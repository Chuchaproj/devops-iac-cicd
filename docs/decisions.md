# Delivery decisions

Terraform owns container/network lifecycle. Ansible is an alternative separately named deployment, with Docker, Nginx, monitoring and application roles. They deliberately do not compete for the same resources. Local Docker compute is an explicit cloud-free implementation, not a claim of AWS/GCP experience.

The private network prevents direct ingress and external routing from the backend; the edge network connects Nginx. Firewall assumptions are documented in README. Container images are pinned by release tag in this lab; a registry production workflow should use digests and signed provenance. Version changes need an immutable tag, not a reused mutable tag.

The backend is stateless so release smoke tests can assert commit identity. Nginx resolves backend DNS periodically, avoiding stale container IPs across replacement. Terraform replace can cause downtime; use a load balancer and two generations when availability requirements demand it.

The scan intentionally reports upstream vulnerabilities without hiding them or claiming a clean image. The release gate blocks leaked secrets, broken lint/tests and failed smoke checks. Further vulnerability policy needs severity, reachability, exceptions and expiry decisions.

[Docker provider](https://registry.terraform.io/providers/kreuzwerker/docker/3.6.0/docs) and [GitHub deployment environments](https://docs.github.com/en/actions/reference/workflows-and-actions/deployments-and-environments) are primary references.
