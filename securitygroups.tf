resource "aws_security_group" "efs-ec2" {
  name        = "${local.resource_prefix}-efs-ec2-SG"
  description = "Security Group created for EC2 to attach EFS"
  vpc_id      = data.aws_vpc.vpc.id
}

resource "aws_vpc_security_group_ingress_rule" "allowssh" {
  security_group_id = aws_security_group.efs-ec2.id

  cidr_ipv4   = local.ip_range_all
  from_port   = 22
  ip_protocol = "tcp"
  to_port     = 22
}

resource "aws_vpc_security_group_egress_rule" "outgoing" {
  security_group_id = aws_security_group.efs-ec2.id

  cidr_ipv4   = local.ip_range_all
  from_port   = -1
  ip_protocol = "-1"
  to_port     = -1
}

resource "aws_security_group" "efs-mount" {
  name        = "${local.resource_prefix}-efs-mountpoint-SG"
  description = "Security Group created for EFS mountpoint"
  vpc_id      = data.aws_vpc.vpc.id
}

resource "aws_vpc_security_group_ingress_rule" "allowec2" {
  security_group_id = aws_security_group.efs-mount.id

  referenced_security_group_id = aws_security_group.efs-ec2.id
  from_port   = 2049
  ip_protocol = "tcp"
  to_port     = 2049
}

resource "aws_vpc_security_group_egress_rule" "outgoing2" {
  security_group_id = aws_security_group.efs-mount.id

  cidr_ipv4   = local.ip_range_all
  from_port   = -1
  ip_protocol = "-1"
  to_port     = -1
}