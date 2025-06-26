resource "aws_db_instance" "postgres" {
  identifier              = "ordinal-thinker-postgres"
  engine                  = "postgres"
  engine_version          = "15"
  instance_class          = "db.t3.micro"
  allocated_storage       = 20
  db_name                 = "products_db"
  username                = "postgres_user"
  password                = "postgres_pass123!"
  skip_final_snapshot     = true
  db_subnet_group_name    = aws_db_subnet_group.rds_subnets.name
  vpc_security_group_ids  = [aws_security_group.rds_sg.id]
  publicly_accessible     = true
  parameter_group_name    = "default.postgres15"
}
