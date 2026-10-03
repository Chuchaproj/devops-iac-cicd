# Delivery decisions

Terraform owns container/network lifecycle. Ansible is an alternative separately named deployment, with Docker, Nginx, monitoring and application roles. They deliberately do not compete for the same resources. Local Docker compute is an explicit cloud-free implementation, not a claim of AWS/GCP experience.

The private network prevents direct ingress and external routing from the backend; the edge network connects Nginx. Firewall assumptions are documented in README. Container images are pinned by release tag in this lab; a registry production workflow should use digests and signed provenance. Version changes need an immutable tag, not a reused mutable tag.

The backend is stateless so release smoke tests can assert commit identity. Nginx resolves backend DNS periodically, avoiding stale container IPs across replacement. Terraform replace can cause downtime; use a load balancer and two generations when availability requirements demand it.

The custom runtime image scan blocks HIGH/CRITICAL findings without hiding unfixed vulnerabilities. A successful scan is not a security certificate. The release gate blocks leaked secrets, broken lint/tests and failed smoke checks. Further vulnerability policy needs severity, reachability, exceptions and expiry decisions.

[Docker provider](https://registry.terraform.io/providers/kreuzwerker/docker/3.6.2/docs) and [GitHub deployment environments](https://docs.github.com/en/actions/reference/workflows-and-actions/deployments-and-environments) are primary references.

`make secrets` scans Git history, staged changes and the current tracked and nonignored source files. Generated ignored local credentials are not publication content, but a forced/staged secret file is still inspected. There is no allowlist for credential-bearing .env paths.

The runtime uses a digest-pinned Python 3.11 / Alpine 3.24 base. The API dependency stage installs binary musllinux wheels into a virtual environment; only that environment and application source enter the runtime. No compiler or pip/setuptools/wheel is retained. This removes unused Debian system utilities instead of suppressing their findings. The trade-off is musl compatibility: new dependencies must provide matching wheels or require an explicitly reviewed build stage. Native arm64 execution is checked locally; amd64 execution belongs to the first hosted CI run.

Release smoke optionally checks EXPECTED_RELEASE, and CI supplies the exact promoted commit image. Ansible derives release identity from app_image by default. Separate environment roots intentionally repeat only environment-specific inputs while lifecycle behavior remains in modules.
