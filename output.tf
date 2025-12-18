output "ec2_public_ips" {
  description = "List of public IP addresses for all EC2 instances"
  value       = [for inst in values(aws_instance.my_instance) : inst.public_ip]
}

output "ec2_public_ip_map" {
  description = "Map of instance key (from for_each) to public IP"
  value       = { for k, inst in aws_instance.my_instance : k => inst.public_ip }
}