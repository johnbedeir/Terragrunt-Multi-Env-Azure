# This is a parent configuration file used by child environments
# Common inputs shared across all environments.
# Set these env vars (e.g. in CI or locally): ARM_SUBSCRIPTION_ID, ARM_CLIENT_ID, ARM_CLIENT_SECRET, ARM_TENANT_ID
inputs = {
  subscription_id = get_env("ARM_SUBSCRIPTION_ID", "")
  location        = "westus2"  # Using westus2 which reliably supports SQL Server provisioning
  client_id       = get_env("ARM_CLIENT_ID", "")
  client_secret   = get_env("ARM_CLIENT_SECRET", "")
  tenant_id       = get_env("ARM_TENANT_ID", "")
  db_username     = "sqladmin"
  name_prefix     = "cluster-1"
}
