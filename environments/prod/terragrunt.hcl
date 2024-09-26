include {
  path = find_in_parent_folders()
}

terraform {
  source = "../../modules/"
}

inputs = {
  environment                = "prod"
  vpc_address_space          = ["10.30.0.0/16"]
  dns_servers                = ["10.30.0.4", "10.30.0.5"]
  public_subnet              = ["10.30.1.0/24"]
  private_subnet             = ["10.30.2.0/24"]
  destination_address_prefix = "10.30.2.0/24"
  aks_service_cidr           = "10.30.3.0/24"
  aks_dns_service_ip         = "10.30.3.10"
}

