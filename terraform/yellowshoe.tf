provider "aws" {
  region = "${var.aws_region}"
}

# create a ssh key pair

resource "aws_key_pair" "deployer" {
  key_name   = "deployer-key"
  public_key = "${file(var.public_key_path)}"
}

# create a VPC

resource "aws_vpc" "main" {
  cidr_block            = "10.10.0.0/16" # 10.0.0.0/16
  enable_dns_support    = true
  enable_dns_hostnames  = true
}

# create internet gateway for public subnet internet access

resource "aws_internet_gateway" "public" {
  vpc_id = "${aws_vpc.main.id}"

  tags {
    Name = "Main"
  }
}

# create route table and associate with public subnet internet access

resource "aws_route_table" "public" {
  vpc_id = "${aws_vpc.main.id}"

  route {
      cidr_block = "0.0.0.0/0"
      gateway_id = "${aws_internet_gateway.public.id}"
  }

  tags {
    Name = "Main"
  }
}

resource "aws_route_table_association" "public" {
  subnet_id      = "${aws_subnet.public.id}"
  route_table_id = "${aws_route_table.public.id}"
}

# create a public subnet

resource "aws_subnet" "public" {
  vpc_id     = "${aws_vpc.main.id}"
  cidr_block = "10.10.1.0/24" // 10.0.0.0/24

  tags {
    Name = "Main"
  }
}

# create an eip

resource "aws_eip" "main" {
  vpc   = true
}

# create security group for the ec2 instance

resource "aws_security_group" "main" {
  vpc_id      = "${aws_vpc.main.id}"

  ingress {
    protocol    = "-1"
    from_port   = 0
    to_port     = 0
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port       = 0
    to_port         = 0
    protocol        = "-1"
    cidr_blocks     = ["0.0.0.0/0"]
  }
}

# create ec2 instance in the public subnet

resource "aws_instance" "web" {
  connection {
    user = "ubuntu"
  }

  ami                    = "${lookup(var.aws_amis, var.aws_region)}"
  instance_type          = "t2.micro"
  subnet_id              = "${aws_subnet.public.id}"
  vpc_security_group_ids = ["${aws_security_group.main.id}"]
  key_name               = "${aws_key_pair.deployer.key_name}"
}

# assign eip to ec2 instance

resource "aws_eip_association" "eip_assoc" {
  instance_id   = "${aws_instance.web.id}"
  allocation_id = "${aws_eip.main.id}"
}
