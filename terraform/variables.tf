variable "privat_key_path_var" {
  default = "/home/vagrant/host/devops106_skumari.pem"

}


variable "devops106_surabhi_example_image_AMI" {
  default = "ami-08ca3fed11864d6bb"
}

variable "" {
  default = "ami-034f3e47a4b4cc26a"
}




variable "public_key_name_var" {
  default = "devops106_skumari"
}

variable "region_var" {
  default = "eu-west-1"
}

locals {
vpc_id_var = aws_vpc.devops106_terraform_surabhi_vpc_tf.id

}
