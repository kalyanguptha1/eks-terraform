output "server_id" {
  description = "The private IP address assigned to the instance."
  value = "${element(aws_instance.bastion-server-stage.*.id, 0)}"
}


output "instance_public_ip" {
  description = "Public IP address of the EC2 instance"
  value       = aws_instance.bastion-server-stage.public_ip
}


output "instance_private_ip" {
  description = "Private IP address of the EC2 instance"
  value       = aws_instance.bastion-server-stage.private_ip
}
