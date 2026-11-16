# Task 2 — Kubernetes Deployment Review

## Identified Issues and Corrections

| # | Issue in original manifest | Why it matters | Correction |
|---|---|---|---|
| 1 | Deployment selector uses `app: auction-api`, but Pod template uses `app: auctions-api`. | The Deployment selector does not match its Pods, so Kubernetes cannot manage the intended replicas correctly. | Standardized the labels to `app: auction-api`. |
| 2 | Service selector uses `app: auction-api`, which does not match the original Pod label. | The Service cannot find matching Pods, resulting in no usable backend endpoints. | Aligned the Service and Pod labels. |
| 3 | Namespace `auctions` is referenced but not created in the provided manifest. | Deployment fails if the namespace does not already exist. | Added a Namespace resource. |
| 4 | Container image uses the mutable `latest` tag. | The same manifest can deploy different image versions, making releases difficult to reproduce and roll back. | Used an example versioned tag, `v1.0.0`. |
| 5 | Database password is hardcoded in the manifest. | Credentials can be exposed through source control and deployment configuration. | Referenced a Kubernetes Secret using `secretKeyRef`. |
| 6 | Readiness probe checks port 80, while the container declares application port 8080. | The probe may fail even when the application is healthy, preventing the Pod from receiving traffic. | Configured the probe to use the named HTTP port, mapped to 8080. |
| 7 | Service `targetPort` is 80, while the application listens on 8080. | Requests are forwarded to the wrong container port. | Set `targetPort` to the named HTTP port. |
| 8 | Only one replica is configured. | A Pod failure or maintenance event can interrupt application availability. | Increased replicas to two. |
| 9 | No CPU or memory requests are defined. | The scheduler has no resource baseline for placing the workload. | Added CPU and memory requests. |
| 10 | No CPU or memory limits are defined. | The container can consume excessive node resources. | Added CPU and memory limits. |
| 11 | No liveness probe is configured. | Kubernetes cannot automatically detect and restart a container that becomes unhealthy. | Added a liveness probe. |
| 12 | No startup probe is configured. | Slow-starting applications may be restarted before they finish initializing. | Added a startup probe. |
| 13 | No container security context is configured. | The container has no explicit restrictions on privilege escalation, filesystem access, or Linux capabilities. | Added non-root execution, disabled privilege escalation, read-only root filesystem, and dropped capabilities. |
| 14 | No Pod-level security context is configured. | The Pod does not explicitly enforce a non-root user and seccomp profile. | Added a non-root user/group and `RuntimeDefault` seccomp profile. |

## Assumptions and Deployment Prerequisites

- The API listens on TCP port `8080`.
- The application exposes an HTTP health endpoint at `/health`.
- `democr.azurecr.io/auction-api:v1.0.0` is an example image reference. A real immutable release tag or digest must be used before deployment.
- The `auction-api-secrets` Kubernetes Secret must exist in the `auctions` namespace and contain the `DB_PASSWORD` key.
- AKS must have permission to pull the image from the Azure Container Registry.
- The application must support non-root execution and a read-only root filesystem. Writable application paths should use explicitly mounted volumes if required.

## Validation

The manifest should be validated before deployment using:

```bash
kubectl apply --dry-run=client -f kubernetes/auction-api.yaml
kubectl get deployments,services -n auctions
kubectl get endpoints -n auctions
```

The dry-run checks manifest structure. A successful cluster deployment and healthy application still require the image, Secret, registry access, and health endpoint to be available.

## Summary

The corrected manifest addresses the original selector and port mismatches and improves availability, resource management, credential handling, and container security. No production deployment is assumed as part of this deliverable.