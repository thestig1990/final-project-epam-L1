# --- compute/outputs.tf ---

output "elb_url" {
  value = aws_elb.web.dns_name
}