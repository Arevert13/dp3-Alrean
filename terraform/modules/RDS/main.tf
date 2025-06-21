resource "aws_db_instance" "default" {
  identifier              = var.db_identifier
  allocated_storage       = 20
  engine                  = "postgres"
  engine_version          = "15.3"
  instance_class          = var.db_instance_class
  username                = var.db_username
  password                = var.db_password
  publicly_accessible     = true
  skip_final_snapshot     = true
  backup_retention_period = 0
}
