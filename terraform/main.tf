provider "aws" {
region = var.region_var
}

data "aws_availability_zones" "available" {
  state = "available"
}
resource "aws_vpc" "devops106_terraform_surabhi_vpc_tf"{
  cidr_block = "10.11.0.0/16"
  enable_dns_support = true
  enable_dns_hostnames = true
  tags = {
    Name = "devops106_terraform_surabhi_vpc"
  }
}


resource "aws_subnet" "devops106_terraform_surabhi_subnet_webserver_tf"{
  vpc_id = local.vpc_id_var
  cidr_block = "10.11.2.0/24"
  availability_zone = data.aws_availability_zones.available.names[0]
  tags = {
    Name = "devops106_terraform_surabhi_subnet_webserver"
  }

}

resource "aws_internet_gateway" "devops106_terraform_surabhi_igw_tf"{

  vpc_id = local.vpc_id_var

  tags = {
    Name = "devops106_terraform_surabhi_igw"
  }
}

resource "aws_route_table" "devops106_terraform_surabhi_rt_public_tf"{
  vpc_id = local.vpc_id_var
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.devops106_terraform_surabhi_igw_tf.id
  }

  tags = {
    Name = "devops106_terraform_surabhi_rt public"
  }


}


resource "aws_route_table_association" "devops106_terraform_surabhi_rt_assoc_public_web_tf"{
  subnet_id = aws_subnet.devops106_terraform_surabhi_subnet_webserver_tf.id

  route_table_id = aws_route_table.devops106_terraform_surabhi_rt_public_tf.id
}

resource "aws_route_table_association" "devops106_terraform_surabhi_rt_assoc_public_web2_tf"{
  subnet_id = aws_subnet.devops106_terraform_surabhi_subnet_webserver2_tf.id

  route_table_id = aws_route_table.devops106_terraform_surabhi_rt_public_tf.id
}


resource "aws_network_acl" "devops106_terraform_surabhi_nacl_public_tf"{
  vpc_id = local.vpc_id_var


  ingress{
    rule_no = 100
    from_port = 22
    to_port =22
    cidr_block = "0.0.0.0/0"
    protocol = "tcp"
    action = "allow"
  }

  ingress{
    rule_no = 200
    from_port = 8080
    to_port = 8080
    cidr_block = "0.0.0.0/0"
    protocol = "tcp"
    action = "allow"
  }

  ingress{
    rule_no = 300
    from_port = 80
    to_port = 80
    cidr_block = "0.0.0.0/0"
    protocol = "tcp"
    action = "allow"
  }

  egress {
    rule_no = 10000
    from_port = 1024
    to_port = 65535
    cidr_block = "0.0.0.0/0"
    protocol = "tcp"
    action = "allow"
  }

}



resource "aws_security_group" "devops106_terraform_surabhi_sg_webserver_tf"{
  name = "devops106_terraform_surabhi_sg_webserver"
  vpc_id = local.vpc_id_var

  ingress {
    from_port =22
    to_port = 22
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port = 8080
    to_port = 8080
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port = 80
    to_port = 80
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }



  egress {
    from_port = 0
    to_port = 0
    protocol = -1
    cidr_blocks = ["0.0.0.0/0"]
  }



  tags = {
    Name = "devops106_terraform_surabhi_sg_webserver"
  }
}

data "template_file" "app_init" {
  template = file("../init-scripts/docker-install.sh")
}



resource "aws_instance" "devops106_terraform_surabhi_webserver_tf"{
  ami = var.ubuntu_20_04_ami_id
  instance_type = "t2.micro"
  key_name = "devops106_skumari"
  vpc_security_group_ids = [aws_security_group.devops106_terraform_surabhi_sg_webserver_tf.id]

  subnet_id = aws_subnet.devops106_terraform_surabhi_subnet_webserver_tf.id
  associate_public_ip_address = true
  #tags = {
  #Name = "devops106_terraform_surabhi_webserver"
  #}

  count = 2
  user_data = data.template_file.app_init.rendered

  tags = {
    Name = "devops106_terraform_surabhi_webserver_${count.index}"
  }



  connection {
  type = "ssh"
  user = "ubuntu"
  host = self.public_ip
  private_key = file(var.privat_key_path_var)
  }


  #provisioner "file" {
    #source = "./docker-install.sh"
    #destination = "/home/ubuntu/docker-install.sh"

  #}

  #provisioner "remote-exec" {
  #inline = [
  #"bash /home/ubuntu/docker-install.sh"

  #]
  #}

  provisioner "local-exec" {
  command = "echo mongodb: ${aws_instance.devops106_terraform_surabhi_database_tf.public_ip}27017 > ../database.config"
  }

  #provisioner "file" {
  #source = "../database.config"
  #destination = "/home/ubuntu/database.config"
  #}

  #provisioner "remote-exec" {
  #inline = [
  #"docker run -d hello-world",
  #"ls -la /home/ubuntu",
  #"cat /home/ubuntu/database.config"
  #]
  #}

}

#data "template_file" "proxy_init" {
  #template = file("../init-scripts/spartan_api.tpl")
  #vars = {
    #IP0 = value = aws_instance.devops106_terraform_surabhi_database_tf[0].public_ip
    #IP1 = value = aws_instance.devops106_terraform_surabhi_database_tf[0].public_ip
    #IP2 = value = aws_instance.devops106_terraform_surabhi_database_tf[0].public_ip
  #}
#}
#'''/
#data "template_file" "app3_init" {
#  template = file("../init-scripts/ngnix.sh")
#}
#
#resource "aws_instance" "devops106_terraform_surabhi_proxy_webserver_tf"{
#  ami = var.ubuntu_20_04_ami_id
#  instance_type = "t2.micro"
#  key_name = "devops106_skumari"
#  vpc_security_group_ids = [aws_security_group.devops106_terraform_surabhi_sg_webserver_tf.id]

#  subnet_id = aws_subnet.devops106_terraform_surabhi_subnet_webserver_tf.id
#  associate_public_ip_address = true
#  user_data = data.template_file.app3_init.rendered
#  tags = {
#  Name = "devops106_terraform_surabhi_proxy"
#  }

#  connection {
#  type = "ssh"
#  user = "ubuntu"
#  host = self.public_ip
#  private_key = file(var.privat_key_path_var)
#  }
#}



######################################################################################

resource "aws_subnet" "devops106_terraform_surabhi_subnet_webserver2_tf"{
  vpc_id = local.vpc_id_var
  cidr_block = "10.11.3.0/24"
  availability_zone = data.aws_availability_zones.available.names[1]
  tags = {
    Name = "devops106_terraform_surabhi_subnet_webserver2"
  }

}

resource "aws_instance" "devops106_terraform_surabhi_webserver2_tf"{
  ami = var.ubuntu_20_04_ami_id
  instance_type = "t2.micro"
  key_name = "devops106_skumari"
  vpc_security_group_ids = [aws_security_group.devops106_terraform_surabhi_sg_webserver_tf.id]

  subnet_id = aws_subnet.devops106_terraform_surabhi_subnet_webserver2_tf.id
  associate_public_ip_address = true
  #tags = {
  #Name = "devops106_terraform_surabhi_webserver"
  #}

  count = 2
  user_data = data.template_file.app_init.rendered

  tags = {
    Name = "devops106_terraform_surabhi_webserver2_${count.index}"
  }



  connection {
  type = "ssh"
  user = "ubuntu"
  host = self.public_ip
  private_key = file(var.privat_key_path_var)
  }


}


#############################instanace for mongo db###########################################################

resource "aws_subnet" "devops106_terraform_surabhi_subnet_database_tf"{
  vpc_id = local.vpc_id_var
  cidr_block = "10.11.1.0/24"

  tags = {
    Name = "devops106_terraform_surabhi_subnet_database"
  }

}

resource "aws_route_table_association" "devops106_terraform_surabhi_rt_assoc_public_database_tf"{
  subnet_id = aws_subnet.devops106_terraform_surabhi_subnet_database_tf.id
  route_table_id = aws_route_table.devops106_terraform_surabhi_rt_public_tf.id
}


resource "aws_network_acl" "devops106_terraform_surabhi_nacl_database_public_tf"{
  vpc_id = local.vpc_id_var


  ingress{
    rule_no = 100
    from_port = 27017
    to_port = 27017
    cidr_block = "0.0.0.0/0"
    protocol = "tcp"
    action = "allow"
  }

  ingress{
    rule_no = 200
    from_port = 22
    to_port = 22
    cidr_block = "0.0.0.0/0"
    protocol = "tcp"
    action = "allow"
  }


  ingress{
    rule_no = 300
    from_port = 1024
    to_port = 65535
    cidr_block = "0.0.0.0/0"
    protocol = "tcp"
    action = "allow"
  }


  egress {
    rule_no = 100
    from_port = 80
    to_port = 80
    cidr_block = "0.0.0.0/0"
    protocol = "tcp"
    action = "allow"
  }

  egress {
    rule_no = 10000
    from_port = 1024
    to_port = 65535
    cidr_block = "0.0.0.0/0"
    protocol = "tcp"
    action = "allow"
  }

  egress {
    rule_no = 10000
    from_port = 1024
    to_port = 65535
    cidr_block = "0.0.0.0/0"
    protocol = "tcp"
    action = "allow"
  }


}


resource "aws_security_group" "devops106_terraform_surabhi_sg_database_tf"{
  name = "devops106_terraform_surabhi_sg_database"
  vpc_id = local.vpc_id_var

  ingress {
    from_port = 27017
    to_port = 27017
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port = 22
    to_port = 22
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }



  egress {
    from_port = 0
    to_port = 0
    protocol = -1
    cidr_blocks = ["0.0.0.0/0"]
  }



  tags = {
    Name = "devops106_terraform_surabhi_sg_database"
  }
}






data "template_file" "app2_init" {
  template = file("../init-scripts/mongodb-install.sh")
}


resource "aws_instance" "devops106_terraform_surabhi_database_tf" {
ami = var.ubuntu_20_04_ami_id
instance_type = "t2.micro"
key_name = var.public_key_name_var
vpc_security_group_ids = [aws_security_group.devops106_terraform_surabhi_sg_database_tf.id]

subnet_id = aws_subnet.devops106_terraform_surabhi_subnet_database_tf.id
associate_public_ip_address = true
user_data = data.template_file.app2_init.rendered
tags = {
Name = "devops106_terraform_surabhi_database"
}


  connection {
  type = "ssh"
  user = "ubuntu"
  host = self.public_ip
  private_key = file(var.privat_key_path_var)
  }



  #provisioner "file"{
    #source = "./mongodb-install.sh"
    #destination = "/home/ubuntu/mongodb-install.sh"
  #}

  #provisioner "remote-exec" {
  #inline = [
  #"bash /home/ubuntu/mongodb-install.sh"

  #]
  #}


  provisioner "local-exec" {
  command = "echo mongodb://${aws_instance.devops106_terraform_surabhi_database_tf.public_ip}:27017 > ../database.config"
  }
}

resource "aws_route53_zone" "devops106_terraform_surabhi_dns_zone_tf"{
  name = "surabhi.devops106"

  vpc {
    vpc_id = local.vpc_id_var
  }
}
resource "aws_route53_record" "devops106_terraform_surabhi_dns_db_tf" {
  zone_id = aws_route53_zone.devops106_terraform_surabhi_dns_zone_tf.zone_id
  name = "db"
  type = "A"
  ttl = "30"
  records = [aws_instance.devops106_terraform_surabhi_database_tf.public_ip]
}



resource "aws_lb" "devops_terraform_surabhi_lb_tf" {
  name = "devops106terraformsurabhi-lb"
  internal = false
  load_balancer_type = "application"
  subnets = [aws_subnet.devops106_terraform_surabhi_subnet_webserver_tf.id, aws_subnet.devops106_terraform_surabhi_subnet_webserver2_tf.id]
  security_groups = [aws_security_group.devops106_terraform_surabhi_sg_webserver_tf.id]

  tags = {
    Name = "devops106_terraform_surabhi_lb"
  }
}


resource "aws_alb_targer_group" "devops106_terraform_surabhi_tg_tf"{
  name = "devops106terraformsurabhi-lb"
  port = 8080
  target_type = "instance"
  protocol = "HTTP"
  vpc_id = local.vpc_id_var
}

resource "aws_alb_target_group_attachment" "devops106_terraform_surabhi_tg_attach_tf" {
  target_group_arn = aws_alb_target_group.devops106_terraform_surabhi_tg_tf.arn
  count = length(aws_instance.devops106_terraform_surabhi_webserver_tf)
  target_id = aws_instance.devops106_terraform_surabhi_webserver_tf[count.index].id
}

resource "aws_alb_listener" "devops106_terraform_surabhi_lb_listener_tf" {
  load_balancer_arn = aws.lb.devops106_terraform_surabhi_lb_tf.arn
  port = 80
  protocol = "HTTP"

  default_action {
    type = "forward"
    target_group_arn = aws_alb_target_group.devops106_terraform_surabhi_tg_tf.arn
  }
}
