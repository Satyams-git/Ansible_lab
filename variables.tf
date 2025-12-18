// Variables used by the Ansible lab Terraform configuration

variable "public_key_path" {
  description = "Path to the public key file used for the AWS key pair (e.g. ./ansible-terraform-key.pub or absolute path)"
  type        = string
}

variable "ami_ubuntu" {
  description = "AMI ID for the Ubuntu image to use for EC2 instances"
  type        = string
}
