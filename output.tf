output "instance_name" {
  value = module.compute.instance_name
}

output "wordpress_url" {
  value = module.compute.external_ip
}