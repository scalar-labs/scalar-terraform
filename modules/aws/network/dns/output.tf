output "dns_zone_id" {
  value       = aws_route53_zone.private.zone_id
  description = "DNS Zone id"
}
