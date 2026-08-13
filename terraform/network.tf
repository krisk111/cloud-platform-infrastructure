resource "aws_vpc" "cloud_platform" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = {
    Name      = "cloud-platform-vpc"
    Project   = "cloud-platform"
    ManagedBy = "terraform"
  }
}

resource "aws_subnet" "public_a" {
  vpc_id            = aws_vpc.cloud_platform.id
  cidr_block        = "10.0.1.0/24"
  availability_zone = "us-east-1a"

  tags = {
    Name                     = "cloud-platform-public-a"
    Project                  = "cloud-platform"
    ManagedBy                = "terraform"
    "kubernetes.io/role/elb" = "1"
  }
}

resource "aws_subnet" "public_b" {
  vpc_id            = aws_vpc.cloud_platform.id
  cidr_block        = "10.0.2.0/24"
  availability_zone = "us-east-1b"

  tags = {
    Name                     = "cloud-platform-public-b"
    Project                  = "cloud-platform"
    ManagedBy                = "terraform"
    "kubernetes.io/role/elb" = "1"
  }
}

resource "aws_subnet" "private_a" {
  vpc_id            = aws_vpc.cloud_platform.id
  cidr_block        = "10.0.11.0/24"
  availability_zone = "us-east-1a"

  tags = {
    Name                              = "cloud-platform-private-a"
    Project                           = "cloud-platform"
    ManagedBy                         = "terraform"
    "kubernetes.io/role/internal-elb" = "1"
  }
}

resource "aws_subnet" "private_b" {
  vpc_id            = aws_vpc.cloud_platform.id
  cidr_block        = "10.0.12.0/24"
  availability_zone = "us-east-1b"

  tags = {
    Name                              = "cloud-platform-private-b"
    Project                           = "cloud-platform"
    ManagedBy                         = "terraform"
    "kubernetes.io/role/internal-elb" = "1"
  }
}

resource "aws_internet_gateway" "cloud_platform_internet_gateway" {
  vpc_id = aws_vpc.cloud_platform.id

  tags = {
    Name      = "cloud-platform-internet-gateway"
    Project   = "cloud-platform"
    ManagedBy = "terraform"
  }
}

resource "aws_route_table" "cloud_platform_public_route_table" {
  vpc_id = aws_vpc.cloud_platform.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.cloud_platform_internet_gateway.id
  }

  tags = {
    Name      = "cloud-platform-public-route-table"
    Project   = "cloud-platform"
    ManagedBy = "terraform"
  }
}

resource "aws_route_table_association" "cloud_platform_public_subnet_a_route_table_association" {
  subnet_id      = aws_subnet.public_a.id
  route_table_id = aws_route_table.cloud_platform_public_route_table.id
}

resource "aws_route_table_association" "cloud_platform_public_subnet_b_route_table_association" {
  subnet_id      = aws_subnet.public_b.id
  route_table_id = aws_route_table.cloud_platform_public_route_table.id
}

resource "aws_eip" "cloud_platform_nat_gateway_elastic_ip" {
  domain = "vpc"

  tags = {
    Name      = "cloud-platform-nat-gateway-elastic-ip"
    Project   = "cloud-platform"
    ManagedBy = "terraform"
  }
}

resource "aws_nat_gateway" "cloud_platform_nat_gateway" {
  allocation_id = aws_eip.cloud_platform_nat_gateway_elastic_ip.id
  subnet_id     = aws_subnet.public_a.id

  tags = {
    Name      = "cloud-platform-nat-gateway"
    Project   = "cloud-platform"
    ManagedBy = "terraform"
  }

  depends_on = [aws_internet_gateway.cloud_platform_internet_gateway]
}

resource "aws_route_table" "cloud_platform_private_route_table" {
  vpc_id = aws_vpc.cloud_platform.id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.cloud_platform_nat_gateway.id
  }

  tags = {
    Name      = "cloud-platform-private-route-table"
    Project   = "cloud-platform"
    ManagedBy = "terraform"
  }
}

resource "aws_route_table_association" "cloud_platform_private_subnet_a_route_table_association" {
  subnet_id      = aws_subnet.private_a.id
  route_table_id = aws_route_table.cloud_platform_private_route_table.id
}

resource "aws_route_table_association" "cloud_platform_private_subnet_b_route_table_association" {
  subnet_id      = aws_subnet.private_b.id
  route_table_id = aws_route_table.cloud_platform_private_route_table.id
}