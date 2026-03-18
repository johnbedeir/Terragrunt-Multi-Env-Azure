# Terragrunt Multi-Env Infrastructure on Azure

<img src=imgs/cover.png>

## About

This project provisions **multi-environment Azure infrastructure** using **Terraform** and **Terragrunt**. Each environment (e.g. `dev`, `prod`) gets its own copy of the same stack: a VNet with public/private subnets, **AKS** (Kubernetes), **Azure Container Registry (ACR)**, **Azure SQL Database** with Private Endpoint, **Key Vault** for DB credentials, **NAT Gateway**, **NSGs**, **Argo CD** and a **monitoring stack** (Helm). Terragrunt keeps the Terraform module DRY and passes per-env inputs (CIDRs, environment name, etc.) from the root config and environment-specific `terragrunt.hcl` files.

## Project structure

```
├── terragrunt.hcl        # Shared inputs (subscription, location, client_id, etc.)
├── run_me_first.sh      # One-time: service principal + GitHub OIDC
├── environments/
│   ├── dev/terragrunt.hcl
│   └── prod/terragrunt.hcl
└── modules/
   # Terraform: VNet, NAT, NSG, AKS, ACR, Key Vault,
   SQL, Argo CD, monitoring
```

Run Terragrunt from `environments/` or `environments/<env>/`; each env has its own state and uses the shared `modules/`.

## Usage

### Run first (one-time setup)

Create a `subscription.txt` file in the repo root containing your Azure subscription ID, then run:

```bash
./run_me_first.sh
```

This creates an Azure service principal and federated credentials for GitHub Actions OIDC (used for CI/CD). You’ll need the Client ID (and Client Secret if created) for your Terraform/Terragrunt variables.

### Running Terragrunt Commands

For Terragrunt v0.50+ (CLI redesign), run from the `environments` directory:

```bash
# Plan all environments
cd environments && terragrunt run --all plan

# Apply all environments
cd environments && terragrunt run --all apply

# Plan specific environment
cd environments/dev && terragrunt plan
cd environments/prod && terragrunt plan

# Apply specific environment
cd environments/dev && terragrunt apply
cd environments/prod && terragrunt apply
```

**Note:** The old `run-all` command has been replaced with `run --all` in newer Terragrunt versions. The root directory contains only a parent configuration file, so run commands from the `environments` directory.

### Getting AKS Credentials

```bash
az aks get-credentials --resource-group cluster-1-dev-rg --name dev-cluster-1-aks --overwrite-existing

az aks get-credentials --resource-group cluster-1-prod-rg --name prod-cluster-1-aks --overwrite-existing
```

### Getting DB Credentials from Key Vault

Run **all** of the following from the repo root. Replace `dev` with `prod` for production.

```bash
# 1. Set variables from Terragrunt outputs (use -raw and trim whitespace)
cd environments/dev
KV_NAME=$(terragrunt output -raw key_vault_name | tr -d '\n')
USER_SECRET=$(terragrunt output -raw key_vault_db_username_secret_name | tr -d '\n')
PASS_SECRET=$(terragrunt output -raw key_vault_db_password_secret_name | tr -d '\n')
cd ../..

# 2. Fetch secrets (requires az login and access to the vault)
DB_USER=$(az keyvault secret show --vault-name "$KV_NAME" -n "$USER_SECRET" --query value -o tsv)
DB_PASS=$(az keyvault secret show --vault-name "$KV_NAME" -n "$PASS_SECRET" --query value -o tsv)

echo "DB_USER=$DB_USER"
echo "DB_PASS=$DB_PASS"
```
