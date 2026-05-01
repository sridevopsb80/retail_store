# CICD

# Diagram

==================== CI (Continuous Integration) ====================

Developer
   │
   ▼
GitHub Repo (code push)
   │
   ▼
GitHub Actions
   ├─ Checkout code
   ├─ Build Docker image
   ├─ Tag image (commit SHA / version)
   ├─ Push image → AWS ECR
   └─ Update Kubernetes manifests (Helm/YAML)
                 │
                 ▼
        Git Repo (manifests updated)


==================== CD (Continuous Deployment via GitOps) ====================

Git Repo (source of truth)
   │
   ▼
ArgoCD
   ├─ Watches repo for changes
   ├─ Detects new image tag
   └─ Syncs desired state
          │
          ▼
Kubernetes (EKS)
   ├─ Pulls image from ECR
   └─ Deploys new version


## Data Flow

[Source Code]
     │
     ▼
GitHub Repository
     │
     ▼
GitHub Actions (CI Pipeline)
     │
     ├──────────────► Docker Image ───────────────► AWS ECR
     │
     └──────────────► Updated Kubernetes YAML (image tag)
                              │
                              ▼
                    Git Repository (manifests)
                              │
                              ▼
                           ArgoCD
                              │
                              ▼
                        Kubernetes (EKS)
                              │
                              ▼
                       Running Application