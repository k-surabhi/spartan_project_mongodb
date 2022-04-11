output "webservers_ip_addresses_output" {
  value = aws_instance.devops106_terraform_surabhi_webserver_tf[*].public_ip
}

output "webservers_ip_addresses_output2" {
  value = aws_instance.devops106_terraform_surabhi_webserver2_tf[*].public_ip
}

output "dbservers_ip_addresses_output" {
  value = aws_instance.devops106_terraform_surabhi_database_tf[*].public_ip
}
