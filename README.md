# Secure Azure Infrastructure and DevOps Assessment

## Project Overview

This repository contains three assessment tasks focused on secure Azure infrastructure, Kubernetes deployment best practices, and incident response.

The infrastructure is defined using Terraform with reusable modules. The project also includes a GitHub Actions validation workflow, corrected Kubernetes manifests, and incident response procedures.

## Repository Structure

```text
secure-azure-platform/
│
├── .github/
│   └── workflows/
│       └── terraform.yml
│
├── bootstrap/
│   └── backend/
│       ├── main.tf
│       ├── outputs.tf
│       └── versions.tf
│
├── environments/
│   ├── dev/
│   │   ├── backend.hcl
│   │   └── terraform.tfvars
│   └── prod/
│       ├── backend.hcl
│       └── terraform.tfvars
│
├── modules/
│   ├── key-vault/
│   ├── managed-identity/
│   ├── networking/
│   ├── private-dns/
│   └── storage/
│
├── kubernetes/
│   ├── auction-api.yaml
│   └── issues.md
│
├── incident-response.md
├── main.tf
├── variables.tf
├── outputs.tf
├── versions.tf
├── .gitignore
└── README.md
```

## Task 1 – Secure Azure Infrastructure with Terraform

### Architecture

The infrastructure is organized into reusable Terraform modules.

- **Resource Group:** Provides logical separation for infrastructure resources.
- **Virtual Network:** Uses the `10.20.0.0/16` address space.
- **Subnets:** Separate workload resources and private endpoints.
- **Network Security Groups:** Apply network security rules to the subnets.
- **Azure Storage Account:** Uses private network access, HTTPS, TLS 1.2, and encryption.
- **Private Endpoints:** Provide private connectivity to Storage and Key Vault.
- **Private DNS:** Resolves private endpoint names within the virtual network.
- **Azure Key Vault:** Uses RBAC authorization, soft delete, and purge protection.
- **Managed Identity:** Uses a user-assigned identity with Storage Blob Data Reader access.

### Terraform Modules

| Module | Responsibility |
|---|---|
| Networking | Virtual network, subnets, and NSGs |
| Storage | Secure Azure Storage and Blob private endpoint |
| Private DNS | Private DNS zones and VNet links |
| Key Vault | Secure Key Vault and private endpoint |
| Managed Identity | User-assigned identity and storage access |

### Environment Separation

Separate configuration files are maintained for development and production:

- `environments/dev/terraform.tfvars`
- `environments/prod/terraform.tfvars`

Each environment also has its own remote backend configuration.

### Remote Terraform State

Terraform state is stored in an Azure Storage Account.

The backend uses a private container, Azure AD authentication, blob versioning, and state locking through Azure Blob leases.

The backend infrastructure is provisioned separately under `bootstrap/backend`.

### Security Considerations

- No Azure client secret is stored in GitHub.
- GitHub Actions authentication uses OpenID Connect (OIDC).
- Storage public access is disabled for application storage.
- Key Vault public access is disabled.
- Private endpoints are used for application Storage and Key Vault.
- Managed identity is used instead of embedding application credentials.
- Terraform state files and local provider directories are excluded from Git.

### Terraform Commands

Initialize the development environment:

```powershell
terraform init -backend-config=environments/dev/backend.hcl
```

Format Terraform files:

```powershell
terraform fmt -recursive
```

Validate Terraform configuration:

```powershell
terraform validate
```

Review the development plan:

```powershell
terraform plan -var-file=environments/dev/terraform.tfvars
```

For production, initialize using its backend configuration and use its variable file:

```powershell
terraform init -reconfigure -backend-config=environments/prod/backend.hcl
terraform plan -var-file=environments/prod/terraform.tfvars
```

Review all plans before considering any infrastructure deployment. Do not apply without explicit deployment approval.

### GitHub Actions

The current GitHub Actions workflow runs on pull requests targeting `main`.

It performs:

1. Terraform formatting checks.
2. Terraform initialization without connecting to the remote backend.
3. Terraform validation.
4. Checkov security scanning.

Checkov findings are reported but configured as non-blocking. A successful workflow therefore does not mean every security policy has passed.

The current workflow does not yet implement the Azure-authenticated remote Terraform plan and gated apply stages.

### Production Improvements

Potential future improvements include:

- Add an Azure-authenticated Terraform plan to pull requests.
- Publish the plan summary for reviewer visibility.
- Add a protected production deployment environment.
- Require manual approval before production apply.
- Restrict deployment permissions to the required resource scopes.
- Establish private connectivity for the Terraform backend and CI runners.

## Task 2 – Kubernetes Deployment Corrections

The `kubernetes/auction-api.yaml` file contains the corrected Namespace, Deployment, and Service manifests.

The corrections include:

- Standardized Deployment and Service selectors.
- Added the missing namespace.
- Replaced the mutable `latest` image tag with a versioned example tag.
- Moved the database password reference to a Kubernetes Secret.
- Corrected application port mappings to use port 8080.
- Increased replicas to two.
- Added CPU and memory requests and limits.
- Added startup, readiness, and liveness probes.
- Added non-root execution and container security restrictions.
- Added a read-only root filesystem and dropped Linux capabilities.

The assumptions and identified issues are documented in `kubernetes/issues.md`.

### Deployment Prerequisites

Before deploying, ensure that:

- The actual application image exists in the configured registry.
- The Kubernetes Secret `auction-api-secrets` exists in the `auctions` namespace.
- The application listens on port 8080.
- The `/health` endpoint is available.
- The container supports non-root execution and a read-only filesystem.
- AKS has permission to pull the container image.

### Validation

```bash
kubectl apply --dry-run=client -f kubernetes/auction-api.yaml
```

No production Kubernetes deployment is assumed as part of this assessment.

## Task 3 – Incident Response

The `incident-response.md` document covers four operational scenarios:

1. HTTP 500 errors after an application release.
2. Terraform state corruption while Azure resources still exist.
3. An AKS cluster several minor versions behind its supported upgrade target.
4. Private endpoint connectivity timeouts from a self-hosted runner.

Each scenario includes investigation steps, recovery actions, and preventive measures.

A common incident response process is also documented:

1. Detect and assess.
2. Investigate the root cause.
3. Contain the impact.
4. Fix or roll back.
5. Verify recovery.
6. Document the incident and prevention measures.

## Validation Status and Deployment Scope

Terraform formatting and validation have been completed successfully.

The GitHub Actions Terraform checks and Checkov scan have completed successfully with non-blocking security findings.

The Kubernetes manifest and incident response document have been prepared.

The application infrastructure has not been deployed through the root Terraform configuration. Validation and planning must not be represented as successful production deployment.

## Repository

GitHub: https://github.com/shaheer155/secure-azure-platform