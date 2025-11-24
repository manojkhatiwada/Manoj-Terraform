# Deploy HTML Page on Azure VM with Terraform

## Prerequisites

1. Install Azure CLI and login:

```bash
az login
```

2. Get your subscription ID:

```bash
az account show --query id -o tsv
```

3. Update `main.tf`:
   - Line 13: Add your subscription ID
   - Line 23: Change the admin password (optional)

## Commands to Run

### 1. Initialize Terraform
```bash
terraform init
```

### 2. Preview what will be created
```bash
terraform plan
```

### 3. Deploy the infrastructure
```bash
terraform apply
```
Type `yes` when prompted.

### 4. Get the website URL
After deployment, Terraform will show the public IP. Open the URL in your browser:
```
http://PUBLIC_IP_ADDRESS
```

### 5. Destroy resources when done
```bash
terraform destroy
```
Type `yes` when prompted.

## What Gets Created

- Resource Group: `manoj-web-rg`
- Virtual Machine running Ubuntu 22.04
- Nginx web server
- Your custom HTML page from `manoj.html`
- All networking (VNet, Subnet, Public IP, NSG)

## Files

- `main.tf` - Terraform configuration (includes VM setup script)
- `manoj.html` - Your HTML page
- `README.md` - This file
