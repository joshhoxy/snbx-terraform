
# 반복되거나 전체적으로 적용되는 내용 혹은 전처리가 필욯나 내용을 local block에 정의합니다.

locals {
    name_tag_middle = "an2-mytf-prod"
}

# VPC를 생성하는 Module을 호출하면서 입력값들을 넘깁니다.

module "create_vpc" {
    # Source 필드는 Module이 존재하는 경로이다. 절대, 상대 경로 혹은 Git등.
    source              = "./create-vpc/"
    # 다음은 해당 Module에서 variable block으로 요구하는 값들 입니다.
    vpc_cidr            = "10.0.0.0/16"
    create_igw          = true
    name_tag_middle = local.name_tag_middle
}

locals {
    # create_vpc Module에서 output block으로 vpc_id 값을 id로 출력해주고 있고 이를 vpc_id로 저장
    vpc_id = module.create_vpc.vpc_id
    
    # create_vpc Module에서 output block으로 igw_id 값을 id로 출력해주고 있고 이를 igw_id로 저장
    igw_id = module.create_vpc.igw_id
}

# Subnet을 생성하는 Module을 호출하면서 입력값을 넘깁니다.
module "create_subnet" {
    source              = "./create-subnet/"

    vpc_id              = local.vpc_id
    igw_id              = local.igw_id
    subnets             = [
        {
            identifier          = "public-a"
            name_tag_postfix    = "pub-a"
            availability_zone   = "ap-northeast-2a"
            cidr_block          = "10.0.0.0/24"
            enable_route_with_igw = true
            enable_route_with_nat = flase
            create_nat          = true
        },
        {
            identifier = "public-c"
            name_tag_postfix = "pub-c"
            availability_zone = "ap-northeast-2c"
            cidr_block = "10.0.64.0/24"
            enable_route_with_igw = true # Public Subnet 이므로 Internet-gateway를 사용합니다.
            enable_route_with_nat = false
            create_nat = false
        },
        {
            identifier = "private-a"
            name_tag_postfix = "pri-a"
            availability_zone = "ap-northeast-2a"
            cidr_block = "10.0.128.0/24"
            enable_route_with_igw = false
            enable_route_with_nat = true # Privaate Subnet 이므로 NAT-gateway를 사용합니다.
            create_nat = false
        },
        {
            identifier = "private-c"
            name_tag_postfix = "pri-c"
            availability_zone = "ap-northeast-2c"
            cidr_block = "10.0.192.0/24"
            enable_route_with_igw = false
            enable_route_with_nat = true # Privaate Subnet 이므로 NAT-gateway를 사용합니다.
            create_nat = false
        }    
    ]
    name_tag_middle = local.name_tag_middle
}