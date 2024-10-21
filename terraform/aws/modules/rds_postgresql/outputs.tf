output "rds_id" {
    value = aws_db_instance.postgres_single_instance.id
}

output "rds_arn" {
    value = aws_db_instance.postgres_single_instance.arn
}

output "rds_name" {
    value = aws_db_instance.postgres_single_instance.identifier
}

output "rds_endpoint" {
    value = aws_db_instance.postgres_single_instance.endpoint
}