include {
  path = find_in_parent_folders()
}

terraform {
  source = "../../modules/"
}

inputs = {
  environment                = "prod"
  vpc_address_space          = ["10.1.0.0/16"]
  dns_servers                = ["10.1.0.4", "10.1.0.5"]
  public_subnet              = ["10.1.1.0/24"]
  private_subnet             = ["10.1.2.0/24"]
  destination_address_prefix = "10.1.2.0/24"
  aks_service_cidr           = "10.1.3.0/24"
  aks_pod_cidr               = "10.1.4.0/22"
  aks_dns_service_ip         = "10.1.3.10"
}


