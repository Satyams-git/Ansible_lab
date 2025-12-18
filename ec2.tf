resource "aws_instance" "my_instance" {

  for_each = tomap({
    Ansible-Master  = var.ami_ubuntu,
    Ansible-Worker1 = var.ami_ubuntu,
    Ansible-Worker2 = var.ami_ubuntu
  })

  depends_on = [
    aws_security_group.my_security_group,
    aws_key_pair.my_key_new
  ]

  ami           = each.value
  instance_type = "t2.micro"
  key_name      = aws_key_pair.my_key_new.key_name
  vpc_security_group_ids = [aws_security_group.my_security_group.id]

  root_block_device {
    volume_size = 10
    volume_type = "gp3"
  }

  tags = {
    Name = each.key
  }
}
