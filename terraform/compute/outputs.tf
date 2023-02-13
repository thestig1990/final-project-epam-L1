# --- compute/outputs.tf ---

output "elb_url" {
  value = aws_elb.web.dns_name
}

output "asg_name" {
  value = aws_autoscaling_group.web.name
}