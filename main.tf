resource "random_password" "db_password" {
  length  = 16
  special = true
}

module "network" {
  source = "./modules/network"

  network_name = var.network_name
  subnet_cidr  = var.subnet_cidr
  region       = var.region
}

module "firewall" {
  source = "./modules/firewall"

  network_name = module.network.network_name
}

module "compute" {
  source = "./modules/compute"

  instance_name = var.instance_name
  zone          = var.zone
  network       = module.network.network_name
  subnetwork    = module.network.subnet_name
  db_password   = random_password.db_password.result
  project_id    = var.project_id
}

module "iap" {
  source = "./modules/iap"

  project_id = var.project_id
  user_email = var.user_email
}