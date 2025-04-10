resource "aws_db_subnet_group" "rds" {
  name       = "rds-subnet-group-${var.tag_env}"
  subnet_ids = var.private_subnet_ids

  tags = {
    Name = "rds-subnet-group-${var.tag_env}"
  }
}

resource "aws_security_group" "rds_sg" {
  name        = "rds-sg-${var.tag_env}"
  description = "Allow PostgreSQL inbound traffic"
  vpc_id      = var.vpc_id

  ingress {
    from_port   = 5432
    to_port     = 5432
    protocol    = "tcp"
    cidr_blocks = var.allowed_cidr_blocks
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "rds-sg-${var.tag_env}"
  }
}

resource "aws_db_instance" "rds" {
  identifier              = "photo-db-${var.tag_env}"
  engine                  = "postgres"
  instance_class          = "db.t3.micro"
  allocated_storage       = 20
  username                = var.db_username
  password                = var.db_password
  db_name                 = var.db_name
  port                    = 5432
  vpc_security_group_ids  = [aws_security_group.rds_sg.id]
  db_subnet_group_name    = aws_db_subnet_group.rds.name
  skip_final_snapshot     = true
  publicly_accessible     = false
  multi_az                = false
  storage_encrypted       = false

  tags = {
    Name = "photo-db-${var.tag_env}"
  }
}
