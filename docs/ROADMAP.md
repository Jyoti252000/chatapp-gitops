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
- [x] Install Helm and `helm lint` the chart
- [x] Smoke-test on a local `kind` cluster — found and fixed 4 real runtime bugs
      (probe timeoutSeconds, missing MONGODB_URI, Alpine/musl DNS race condition
      in db.js needing retry logic, missing JWT_SECRET wiring)

## Phase 2 — Terraform for AWS infra (free until Phase 4)
- [x] `terraform/` : vpc.tf, eks.tf, ecr.tf, variables.tf, provider.tf, outputs.tf
      (no remote state backend — local state only, known limitation for a solo project)
- [x] IAM user (`terraform-admin`) set up instead of root keys
- [x] `terraform plan` validated
- [x] ECR repos applied early (near-zero cost) to unblock Phase 3 testing

## Phase 3 — CI (GitHub Actions, free)
- [x] In `full-stack_chatApp`: install → build → Trivy scan (fails on CRITICAL) → push to ECR
- [x] Found and fixed 3 real CRITICAL CVEs during first real runs: OpenSSL (base
      image upgrade node:18→22), mongoose (dependency bump), npm-bundled tar
      (explicit npm upgrade in both Docker stages)
- [ ] tfsec/checkov scan on this repo's Terraform in CI (not done — noted gap)

## Phase 4 — Real AWS (done — applied, used, destroyed same session)
- [x] Fix AWS CLI creds (rotated 3x after accidentally pasting keys in chat — lesson learned)
- [x] `terraform apply` — full VPC/EKS/node group (had to bump EKS version 1.30→1.36,
      1.30 was fully deprecated/no AMI available)
- [x] Installed EBS CSI driver + gp3 StorageClass manually (NOT in Terraform yet —
      real gap, see below)
- [x] Install ArgoCD, point it at this repo, sync — reached Synced/Healthy
- [x] Full signup/login flow verified working against real ECR images + real EBS-backed Mongo
- [x] Install kube-prometheus-stack (Prometheus + Grafana), screenshotted live dashboards
- [x] `terraform destroy` — confirmed via AWS CLI that EKS/NAT/EC2 are gone
      (ECR repos intentionally survive — non-empty, force_delete not set, ~free)

### Known gap carried forward from Phase 4
ArgoCD install, the EBS CSI driver + IAM role + Pod Identity setup, and the
Prometheus/Grafana install were all done as one-off `helm`/`aws cli` commands,
**not** written as Terraform resources. Re-running `terraform apply` alone will
NOT restore these — would need to be manually redone, or (better) codified into
Terraform via the Helm provider. Worth doing if there's time before wrapping up.

## Phase 5 — Security hardening (free)
- [ ] Kyverno or OPA Gatekeeper policies (no-root, resource limits required, no latest tag)
- [ ] Move secrets out of git → External Secrets Operator + AWS Secrets Manager
- [ ] tfsec/checkov gating in CI

## Phase 6 — Docs
- [ ] Architecture diagram
- [ ] README with trade-off write-ups (why ArgoCD, why EKS vs self-managed, cost breakdown)
- [ ] Resume bullet + interview talking points
