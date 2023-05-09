resource "aws_vpc" "demo_vpc" {
  cidr_block = var.vpc_cidr_block
  enable_dns_hostnames = var.enable_dns_hostnames
  tags = merge(local.tags, {
    Name = "Demo-${var.env}-vpc"
  })
}

resource "aws_internet_gateway" "demo_igw" {
  vpc_id = aws_vpc.demo_vpc.id


  tags = merge(local.tags, {
    Name = "Demo-${var.env}-igw"
  })
}

#================public subnets==============================
resource "aws_subnet" "pub_sub_1" {
  vpc_id = aws_vpc.demo_vpc.id

  cidr_block = cidrsubnet(var.vpc_cidr_block, 8, 0)
  map_public_ip_on_launch = true

  availability_zone = data.aws_availability_zones.available.names[0]
  tags = merge(local.tags, {
    Name = "Demo-${var.env}-pub-sub-1"
  })
}

resource "aws_subnet" "pub_sub_2" {
  vpc_id = aws_vpc.demo_vpc.id

  cidr_block = cidrsubnet(var.vpc_cidr_block, 8, 1)
  map_public_ip_on_launch = true
  availability_zone = data.aws_availability_zones.available.names[1]
  
  tags = merge(local.tags, {
    Name = "Demo-${var.env}-pub-sub-2"
  })
}

resource "aws_route_table" "pub_rt" {
  vpc_id = aws_vpc.demo_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.demo_igw.id
  }

  tags = merge(local.tags, {
    Name = "Demo-${var.env}-pub-rt"
  })
}

resource "aws_route_table_association" "pub_sub_1_ass" {
  subnet_id      = aws_subnet.pub_sub_1.id
  route_table_id = aws_route_table.pub_rt.id
}
resource "aws_route_table_association" "pub_sub_2_ass" {
  subnet_id      = aws_subnet.pub_sub_2.id
  route_table_id = aws_route_table.pub_rt.id
}

#================private subnets==============================
resource "aws_subnet" "pri_sub_1" {
  vpc_id = aws_vpc.demo_vpc.id

  cidr_block = cidrsubnet(var.vpc_cidr_block, 8, 2)
  availability_zone = data.aws_availability_zones.available.names[0]
  
  tags = merge(local.tags, {
    Name = "Demo-${var.env}-pri-sub-1"
  })
}

resource "aws_subnet" "pri_sub_2" {
  vpc_id = aws_vpc.demo_vpc.id

  cidr_block = cidrsubnet(var.vpc_cidr_block, 8, 3)
  availability_zone = data.aws_availability_zones.available.names[1]
  
  tags = merge(local.tags, {
    Name = "Demo-${var.env}-pri-sub-2"
  })
}


resource "aws_route_table" "pri_rt" {
  vpc_id = aws_vpc.demo_vpc.id


  tags = merge(local.tags, {
    Name = "Demo-${var.env}-pub-rt"
  })
}

resource "aws_route_table_association" "pri_sub_1_ass" {
  subnet_id      = aws_subnet.pri_sub_1.id
  route_table_id = aws_route_table.pri_rt.id
}
resource "aws_route_table_association" "pri_sub_2_ass" {
  subnet_id      = aws_subnet.pri_sub_2.id
  route_table_id = aws_route_table.pri_rt.id
}