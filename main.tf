#----------------------------------------------------------------------------
#                      Keypair creation
#----------------------------------------------------------------------------

resource "aws_key_pair" "lakme-key" {
  key_name   = "${var.project_name}-${var.project_env}"
  public_key = file("mykey.pub")
  tags = {
    Name    = "${var.project_name}-${var.project_env}"
    project = var.project_name
    env     = var.project_env
  }
}

#----------------------------------------------------------------------------
#                      SecurityGroup
#----------------------------------------------------------------------------
resource "aws_security_group" "lakme-sg" {
  name        = "${var.project_name}-${var.project_env}-webserver-access"
  description = "${var.project_name}-${var.project_env}-webserver-access"
  ingress {
    description      = "http traffic"
    from_port        = 80
    to_port          = 80
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }
  ingress {
    description      = "https traffic"
    from_port        = 443
    to_port          = 443
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }
ingress {
    description      = "ssh traffic"
    from_port        = 22
    to_port          = 22
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }
ingress {
    description      = "nagios traffic"
    from_port        = 8181
    to_port          = 8181
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }
  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
ipv6_cidr_blocks = ["::/0"]
  }
  tags = {
    Name    = "${var.project_name}-${var.project_env}-weberver-access"
    project = var.project_name
    env     = var.project_env
  }
}

#-------------------------------------------------------------------------------
#                 Creation of ec2 instance
#-------------------------------------------------------------------------------

resource "aws_instance" "lakme" {
ami                    = var.instance_ami
  instance_type          = var.instance_type
  user_data              = file("setup.sh")
  key_name               = aws_key_pair.lakme-key.key_name
  vpc_security_group_ids = [aws_security_group.lakme-sg.id]
  tags = {
    Name    = "${var.project_name}-${var.project_env}-frontend"
    project = var.project_name
    env     = var.project_env
  }
}
