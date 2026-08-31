# chatapp-gitops — Build Roadmap

Platform repo for the `full-stack_chatApp` GitOps project (Project 1 of the resume plan).
This repo is what ArgoCD watches — the app repo (`full-stack_chatApp`) stays separate and owns
its own CI (build/test/scan/push).

## Phase 1 — Helm chart (local, free)
- [x] Repo scaffolded
- [x] Convert raw k8s/*.yml → Helm chart (`helm/chatapp`)
- [x] Fix bugs found in original manifests:
  - [x] mongodb Service targetPort typo (27107 → 27017)
  - [x] add resource requests/limits on all containers
  - [x] add liveness/readiness probes
  - [x] add non-root securityContext (frontend nginx was running as root)
  - [x] replace hostPath PV with a StorageClass-driven PVC (works on EKS via EBS CSI, not just local)
  - [x] parameterize image repo/tag, replica count, env via values.yaml
- [ ] Install Helm (`choco install kubernetes-helm` or via winget) and `helm lint` the chart
- [ ] Smoke-test on a local cluster (Docker Desktop Kubernetes or `kind`)

## Phase 2 — Terraform for AWS infra (write + plan only, free)
- [ ] `terraform/` modules: vpc, eks, ecr, remote state (S3 + DynamoDB lock)
- [ ] `terraform plan` validated — do NOT apply yet

## Phase 3 — CI (GitHub Actions, free)
- [ ] In `full-stack_chatApp`: test → build → Trivy image scan → push to ECR
- [ ] tfsec/checkov scan on this repo's Terraform in CI

## Phase 4 — Real AWS (short-lived, costs money — apply then destroy)
- [ ] Fix AWS CLI creds + set a Budget/billing alarm FIRST
- [ ] `terraform apply`
- [ ] Install ArgoCD, point it at this repo, sync
- [ ] Install kube-prometheus-stack (Prometheus + Grafana), screenshot dashboards
- [ ] `terraform destroy` — do not leave EKS running

## Phase 5 — Security hardening (free)
- [ ] Kyverno or OPA Gatekeeper policies (no-root, resource limits required, no latest tag)
- [ ] Move secrets out of git → External Secrets Operator + AWS Secrets Manager
- [ ] tfsec/checkov gating in CI

## Phase 6 — Docs
- [ ] Architecture diagram
- [ ] README with trade-off write-ups (why ArgoCD, why EKS vs self-managed, cost breakdown)
- [ ] Resume bullet + interview talking points
