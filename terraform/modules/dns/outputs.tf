output "zone_id" {
  value = aws_route53_zone.main.zone_id
}

output "zone_arn" {
  value = aws_route53_zone.main.arn
}

output "name_servers" {
  value       = aws_route53_zone.main.name_servers
  description = "Add these NS records to your domain registrar"
}
