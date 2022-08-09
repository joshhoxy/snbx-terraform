resource "aws_vpc" "this" {
    # 동일한 리소스를 여러번 생성하는 경우 count 혹은 for_each를 사용할 수 있다.
    # 아래 코드는 이를 응용한 기법으로, var.create_vpc가 true 인 경우에만 vpc가 생성된다.

    count           = var.create_vpc ? 1 : 0 
    cidr_block      = var.vpc_cidr
    tags            = {
        "Name" = "vpc-${var.name_tage_middle}"
    }        
}

resource "aws_internet_gateway" "this" {
    count           = var.create_vpc && var.create_igw ? 1: 0
    # count로 생성된 리소스들은 리스트의 아이템을 인덱싱 하듯 대괄호를 통해 지정해야 한다.
    vpc_id          = aws_vpc.this[0].id
    tags            = {
        "Name" = "igw-${var.name_tag_middle}"
    }
}