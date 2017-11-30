variable "public_key_path" {
  description = "Path to the SSH public key"
  default = "~/.ssh/id_rsa.pub"
}

variable "aws_region" {
  description = "AWS region to launch servers."
  default     = "ap-southeast-2"
}

variable "aws_amis" {
  default = {
    ap-southeast-2 = "ami-2de5e74e"
  }
}
