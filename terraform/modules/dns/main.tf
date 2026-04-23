resource "aws_route53_zone" "main" {
  name = var.domain_name
  tags = {
    Name        = "${var.project_name}-zone"
    Environment = "production"
  }
}

resource "aws_route53_record" "taskapp" {
  zone_id = aws_route53_zone.main.zone_id
  name    = "taskapp.${var.domain_name}"
  type    = "A"
  ttl     = 60
  records = ["127.0.0.1"]
  lifecycle {
    ignore_changes = [records]
  }
}
