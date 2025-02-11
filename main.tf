locals {
  resource_prefix = "ky-tf"
  ip_range_all    = "0.0.0.0/0"
}

resource "aws_instance" "my_instance" {
  ami                         = data.aws_ami.ami_linux.id
  instance_type               = var.instance_type
  subnet_id                   = data.aws_subnets.public_subnets.ids[0]
  associate_public_ip_address = true
  key_name                    = var.keypair
  vpc_security_group_ids      = [aws_security_group.efs-ec2.id]

  tags = {
    Name = "${local.resource_prefix}-efs-ec2-1"
  }
}

resource "aws_instance" "my_instance2" {
  ami                         = data.aws_ami.ami_linux.id
  instance_type               = var.instance_type
  subnet_id                   = data.aws_subnets.public_subnets.ids[1]
  associate_public_ip_address = true
  key_name                    = var.keypair
  vpc_security_group_ids      = [aws_security_group.efs-ec2.id]

  tags = {
    Name = "${local.resource_prefix}-efs-ec2-2"
  }
}

resource "aws_efs_file_system" "ec2" {
  creation_token = "my-efs-system"
  encrypted = true
  throughput_mode = "elastic"

  lifecycle_policy {
    transition_to_ia = "AFTER_30_DAYS"
  }

  tags = {
    Name = "${local.resource_prefix}-efs"
  }
}

resource "aws_efs_mount_target" "mount1" {
  file_system_id = aws_efs_file_system.ec2.id
  subnet_id      = aws_instance.my_instance.subnet_id
  security_groups = [ aws_security_group.efs-mount.id ]
}

resource "aws_efs_mount_target" "mount2" {
  file_system_id = aws_efs_file_system.ec2.id
  subnet_id      = aws_instance.my_instance2.subnet_id
  security_groups = [ aws_security_group.efs-mount.id ]
}