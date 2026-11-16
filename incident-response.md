# Task 3 – Incident Response

## 1. HTTP 500 Errors After Release

**Problem:** Application returns HTTP 500 errors after deployment, although the code appears unchanged.

**Key Fixes:**
- Check application logs, deployment history, configuration, environment variables, and secrets.
- Compare the current image version with the last working release.
- Check database connectivity and external dependencies.
- Roll back to the last known stable version if the release caused the issue.
- Verify application health after rollback.

**Prevention:** Use immutable image tags, automated health checks, and staged deployments.

## 2. Terraform State Corruption

**Problem:** Terraform state is corrupted, but Azure resources still exist.

**Key Fixes:**
- Stop Terraform apply and destroy operations.
- Back up the current state file.
- Restore the last healthy state version from Azure Storage blob versions if available.
- Import existing resources missing from the state using `terraform import`.
- Run `terraform plan` and review all proposed changes before applying.

**Prevention:** Enable remote state versioning, soft delete, access control, and state locking.

## 3. AKS Cluster Four Versions Behind

**Problem:** The required Kubernetes upgrade version is not available.

**Key Fixes:**
- Run `az aks get-upgrades` to check supported upgrade versions.
- Check AKS version availability and deprecated Kubernetes APIs.
- Upgrade through supported minor versions sequentially.
- Test workloads and compatibility before each production upgrade.
- Validate node pools and application health after upgrading.

**Prevention:** Maintain a regular Kubernetes upgrade schedule and monitor version support.

## 4. Private Endpoint Timeout

**Problem:** A self-hosted runner cannot connect to an Azure service through its private endpoint.

**Key Fixes:**
- Verify private endpoint connection status.
- Check private DNS resolution and confirm it returns the private IP.
- Verify VNet connectivity, peering, routing, NSGs, and firewall rules.
- Test DNS using `nslookup`.
- Test port 443 using `Test-NetConnection`.
- Ensure the runner has a valid private network path to the endpoint.

**Prevention:** Host runners within the appropriate VNet and maintain correct private DNS configuration.

## 5. Common Incident Response Process

1. Detect and assess the issue.
2. Identify the root cause using logs and monitoring.
3. Contain the impact.
4. Apply the safest fix or rollback.
5. Verify service recovery.
6. Document the root cause and preventive actions.