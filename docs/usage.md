# Usage Guide (Operator + Contributor)

This guide explains **how to run and operate** this repo (Operator flow) and **how to extend it safely** (Contributor flow).

> This repo is intentionally environment-scoped (`envs/dev`, `envs/prod`) with reusable modules under `modules/`.

---

## Quick Start (What you need)

- Terraform installed (version used in this repo: check `.terraform.lock.hcl`)
- AWS credentials configured (recommended: AWS SSO profile or `AWS_PROFILE`)
- Access to the S3 backend bucket + lock mechanism (DynamoDB or lockfile depending on configuration)

---

## Operator Guide

### 1) Bootstrap state (one-time)

Bootstrapping creates the **remote backend storage** for Terraform state.

```bash
cd bootstrap/state
terraform init
terraform apply
```

> Why: Remote state enables a shared source of truth and safe collaboration across multiple contributors.

### 2) Run an environment (dev/prod)

#### Dev

```bash
cd envs/dev
terraform init
terraform fmt
terraform validate
terraform plan
terraform apply
```

#### prod
``` bash
cd envs/prod
terraform init
terraform fmt
terraform validate
terraform plan
terraform apply
```

> Why: Each environment maintains **isolated state** and **isolated blast radius**.

### 3) Promote changes from dev → prod (safe flow)

1. Make changes in `modules/*` or `envs/dev/*`
2. Apply in `envs/dev` first
3. Confirm expected behavior (outputs, AWS resources, no drift)
4. Apply the same change in `envs/prod`

```bash
cd envs/dev
terraform plan
terraform apply

cd ../prod
terraform plan
terraform apply
```

> Why: You prove changes in lower-risk environments before expanding blast radius.

### 4) Useful Terraform commands (day-to-day)

```bash
terraform fmt
terraform validate
terraform plan -out tfplan
terraform apply tfplan
terraform destroy
terraform state list
terraform state show <address>
terraform output
```


## Contributor Guide

### Branching and PR flow (always)

1. Create a branch
2. Make changes
3. Commit + push
4. Open a PR
5. Merge only when checks are green

Suggested naming:
- `docs/...`
- `feat/...`
- `fix/...`
- `ci/...`

Suggested commit style:
- `docs: ...`
- `feat: ...`
- `fix: ...`
- `ci: ...`

### Where to put changes

- **Reusable modules:** `modules/*`
- **Environment wiring:** `envs/dev/*`, `envs/prod/*`
- **Repo docs:** `README.md`, `docs/*`
- **Bootstrap backend:** `bootstrap/state/*`

### Adding a new module (pattern)

1. Create module folder: `modules/<name>/`
2. Define: `main.tf`, `variables.tf`, `outputs.tf`
3. Reference module from envs:
   - `envs/dev/main.tf`
   - `envs/prod/main.tf`

### Environment-specific values

Environment values belong in:
- `envs/<env>/terraform.tfvars`

This repo also supports:
- `terraform.tfvars.example` (safe, checked-in sample)
- real `terraform.tfvars` (should be `.gitignore`d if it contains sensitive values)

---

## CI Notes

Some CI workflows may run Terraform with backend disabled (e.g., `terraform init -backend=false`) to avoid requiring AWS credentials during PR validation.

> Why: PR checks should validate formatting + syntax without requiring cloud access.

---

## Troubleshooting

### “No valid credential sources found”
- Ensure `AWS_PROFILE` is set
- Ensure your profile is logged in (`aws sso login --profile <name>`)
- Ensure region is configured
- Ensure the backend bucket exists and you have access

### “Empty or non-existent state”
- You may be pointing at a new backend key or incorrect workspace
- Verify backend configuration (`bucket`, `key`, `region`)
- Run `terraform init -reconfigure`

---