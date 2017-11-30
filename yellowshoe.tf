provider "aws" {
  region = "ap-southeast-2"
}

# create a ssh key pair

resource "aws_key_pair" "deployer" {
  key_name   = "deployer-key"
  public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQDGuu+uqfwlA7t9VysleYe+l0soyZ9tPWmipfVhiGUM90pee6M2Meamtp3HKnEjw4vjZS7hXDziu/GCTU/SgUxyrasDSX7twZ1HIhkGebbx1f9wZ8V7PV2KXFNOJudG8rLSoLMMQKDW2TF+aYCSflWv3+QUE8cHCCAlAlANCgkRuYcUtthB2Ibbe1tieXZIW6wuj+w7JNcOt7HArqby3GJtpK9PCWgk5BVJtAvBg04NsShnpEDVC+jl5CrmD4U0w5juG/yRhijV+ceIOwCkLULYqiiZm0QF5ua63hXhmwP5I9oTJBcjS/DTOYdLPjE2dAIMX3xZaZEgurm9JPfLm/gN6PrR5MlcvwMsNq3WpyCMrEqD/6t34I83/AclXWhmFqQH5wh+GBJZyNFSNIAZacerxUwDGE8RN/5mhR9ebF90p/xXnMRNEEa1i7Jj1W6P2euVPUr7OngxrJDkTuDflCyfTIhmQMYEvuXpp9hbuGuh11BOa9/a4g37U6Y7KfaNboy5K4j4n35UC8CQIDb579rWCMp70oDAZdknXo8uo1UFyCqLOOQPbjrSuIBUfRpMF6i03aQsU2QQ45l3QzfTZS8gWD4Qtg8aZXohrMLHtB7PsTvh1Vev9PndVR09X71nFqb0SbU7tfJLQUg17Yu1pY+2QxW+iEMJbfm9xns6J1TpIw== markbrown4@gmail.com"
}

# create a VPC

resource "aws_vpc" "main" {
  cidr_block = "10.10.0.0/16"
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
  cidr_block = "10.10.1.0/24"

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
    protocol    = "tcp"
    from_port   = 22
    to_port     = 22
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
  ami                    = "ami-2de5e74e"
  instance_type          = "t2.micro"
  subnet_id              = "${aws_subnet.public.id}"
  vpc_security_group_ids = ["${aws_security_group.main.id}"]
}

# assign eip to ec2 instance

resource "aws_eip_association" "eip_assoc" {
  instance_id   = "${aws_instance.web.id}"
  allocation_id = "${aws_eip.main.id}"
}
