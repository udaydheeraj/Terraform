# VPC
resource "aws_vpc" "base" {
  cidr_block           = "192.168.0.0/16"
  enable_dns_hostnames = true

  tags = {
    Name = "from-tf"
    Env  = "Dev"
  }
}
# Public subnet - web
resource "aws_subnet" "web" {
  vpc_id            = aws_vpc.base.id
  availability_zone = "us-east-1a"
  cidr_block        = "192.168.0.0/24"

  tags = {
    Name = "web"
    Env  = "Dev"
  }

  depends_on = [aws_vpc.base]
}

# private subnet -- application layer
resource "aws_subnet" "app" {
  vpc_id            = aws_vpc.base.id
  availability_zone = "us-east-1b"
  cidr_block        = "192.168.1.0/24"

  tags = {
    Name = "app"
    Env  = "Dev"
  }

  depends_on = [aws_vpc.base]
}
# private subnet - db layer
resource "aws_subnet" "db" {
  vpc_id            = aws_vpc.base.id
  availability_zone = "us-east-1b"
  cidr_block        = "192.168.2.0/24"

  tags = {
    Name = "db"
    Env  = "Dev"
  }

  depends_on = [aws_vpc.base]
}
# internet gateway - to attach to public subnet route table
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.base.id

  tags = {
    Name = "from-tf-igw"
  }
}

# public route table
resource "aws_route_table" "public" {
  vpc_id = aws_vpc.base.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }

  tags = {
    Name = "public"
  }
}

resource "aws_route_table" "private" {
  vpc_id = aws_vpc.base.id

  tags = {
    Name = "private"
  }
}

resource "aws_route_table_association" "web_assoc" {
  subnet_id      = aws_subnet.web.id
  route_table_id = aws_route_table.public.id
}

resource "aws_route_table_association" "app_assoc" {
  subnet_id      = aws_subnet.app.id
  route_table_id = aws_route_table.private.id
}

resource "aws_route_table_association" "db_assoc" {
  subnet_id      = aws_subnet.db.id
  route_table_id = aws_route_table.private.id
}