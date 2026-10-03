# Local validation — devops-iac-cicd

## Observed results

| Check | Result | Evidence / scope |
|---|---|---|
| Application tests | PASS | 1 test of health and release identity. |
| Static checks | PASS | Ruff, ShellCheck, yamllint, Hadolint and ansible-lint; no lint finding. |
| Pre-commit | PASS | Seven hooks: Python, Shell, YAML, Terraform formatting, Ansible, Dockerfile and staged secret scan. |
| Docker build / Compose | PASS | Patched non-root backend image built; Compose config and deployment, release smoke and Nginx configuration test passed. |
| Terraform formatting | PASS | `terraform fmt -check -recursive terraform`. |
| Terraform initialization / validation | PASS | `make validate`: dev, stage and prod; pinned Docker provider 3.6.2 and lock files. |
| Terraform real deployment | PASS | Actual Docker network/compute applies and HTTP smoke checks in dev/stage/prod. No cloud resources. |
| Terraform drift | PASS | Dev and prod returned `No changes` with the same image input as apply. Docker memory_swap is now explicit to avoid observed perpetual drift. |
| Rollback | PASS | Stage baseline → candidate → baseline image, with release endpoint read-back after each step. |
| Ansible local deployment | PASS | Roles rendered and deployed Nginx/application/exporter using localhost inventory. Health verified through Nginx on 8084. |
| Ansible idempotency | PASS | Final unchanged second run: `ok=7 changed=0 unreachable=0 failed=0 skipped=3`. Linux Docker installation tasks were intentionally skipped. |
| Environment isolation / cleanup | PASS | Distinct names, network/state roots and ports; Terraform and Ansible lab resources destroyed after validation. |
| Kubernetes / Helm | NOT APPLICABLE | No Kubernetes workload is implemented in this repository. |

## Corrections verified during implementation

Docker's effective memory_swap value caused a drift after apply; explicitly declaring it produced empty plans. Native Linux mount propagation was incompatible with Docker Desktop, so local exporter mounting was adjusted. The monitoring configuration now sets a real Go scheduler budget. The final image was rebuilt with patched OS dependency and build tooling removed.

To reproduce an empty plan, pass the SAME image variable that was used during apply, for example `terraform -chdir=terraform/environments/dev plan -var='image=iac-backend:final'` after applying that local tag. Switching inputs intentionally proposes a release change.

## NOT TESTED and remaining limitations

- Ubuntu 24.04 Docker package installation/service role on a real Linux host; skipped locally, not reported as a pass.
- Remote SSH inventory, privilege escalation and remote Docker/TLS delivery.
- HTTP remote state service, migration, encryption/ACLs, locking contention and state restore. The supplied backend block is not a running backend.
- Actual GitHub image artifact transfer, hosted runners, production dispatch and required-reviewer enforcement. Environment reviewers require future GitHub settings.
- Persistent remote production deployment and disaster recovery. CI stage/prod are disposable runner-local environments.
- Host firewall/VPC enforcement: internal networks and loopback publishing were exercised, but they are not an AWS/GCP security-group or UFW deployment.
- The release replacement can interrupt requests; no zero-downtime or blue/green guarantee is made.
- The HTTP service is stdlib-only. OS image findings remain and wider exposure requires security work.

## Validation boundary

Date: 2026-10-03. Host: macOS, 8 GiB physical RAM; Docker Desktop Linux VM approximately 3.8 GiB. Runtime checks were performed sequentially. Docker 29.5.3, Compose 5.1.4, Python 3.11, Trivy 0.75.0 and Gitleaks 8.30.0 were available. No paid resources were created. PASS means the stated check was observed locally, not that every production failure mode is covered.

`make install`, application tests, Docker builds and the documented local deployment/smoke/cleanup paths were exercised. Sources are independently versioned in this repository. Commit dates are real; no history was squashed or backdated. GitHub publication is pending explicit approval.

## Security and publication checks

- PASS: Gitleaks scanned local Git history, staged changes and the tracked publication tree. No finding was reported. This is a detector result, not proof that every possible secret is absent.
- PASS: `.env`, environment variants, virtual environments, generated artifacts and private key files are ignored; `.env.example` is tracked. No local credential file is included in the publication tree.
- EXECUTED WITH FINDINGS: custom runtime image Trivy scan reported 44 HIGH, 60 MEDIUM, 60 LOW and 2 UNKNOWN findings; zero CRITICAL. The HIGH findings have no fixed package version in the scan result. See [security report](docs/security-scan.md). Third-party stack images and exploitability were not audited. The CI vulnerability scan reports findings without blocking; secret scanning blocks.
- PASS: actionlint and YAML lint checked workflow syntax. GitHub Actions execution, environment protection and CI status badges are **NOT TESTED** because the repository has not been published. No badge asserts a successful remote check.

## Recheck

Run `make install test lint secrets` in a clean checkout with the prerequisites from README. Generate local credentials where required; do not copy someone else's `.env`. Follow README deployment and cleanup commands one project at a time. Image findings and dependency versions are a dated snapshot; refresh scans before publication or wider use.
