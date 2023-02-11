# --- root/outputs.tf ---

output "elb_url" {
  description = "Load Balancer DNS Name"
  value       = module.compute.elb_url
}
