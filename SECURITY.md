# Image security audit

Audit date: 2026-10-03. Trivy 0.75.0. Scope: the custom application runtime image built from this repository, including detected OS and Python dependencies. No severity suppression, ignore-unfixed flag or vulnerability allowlist was used. The OS package database is retained; the new image has 38 detected OS packages. This is not a full assessment of third-party service images or the host.

## Before and after

| Runtime | HIGH | CRITICAL | Other findings |
|---|---:|---:|---|
| Previous patched Debian runtime | 44 | 0 | 60 MEDIUM, 60 LOW, 2 UNKNOWN |
| New digest-pinned Alpine runtime | 0 | 0 | 0 MEDIUM, 0 LOW, 0 UNKNOWN |

The 44 previous HIGH package/CVE records represent eight unique CVEs, all originating from the Debian base-image OS layer. None came from the application dependency graph. Trivy supplied no fixed Debian stable version for them. That does NOT mean no upstream fix exists: the vendor tracker lists the fixes below, generally in newer/unstable branches. Mixing Debian unstable packages into the old stable image was avoided.

## Every unique previous HIGH vulnerability

| CVE | Affected installed packages | Stable fixed version in scan | Known fix elsewhere | Disposition |
|---|---|---|---|
| [CVE-2025-69720](https://security-tracker.debian.org/tracker/CVE-2025-69720) | libncursesw6 6.5+20250216-2; libtinfo6 6.5+20250216-2; ncurses-base 6.5+20250216-2; ncurses-bin 6.5+20250216-2 | None reported for trixie | ncurses upstream 6.5-20251213 / Debian unstable 6.6+20251231-1 | Old affected Debian packages removed by base replacement; no exception |
| [CVE-2026-16742](https://security-tracker.debian.org/tracker/CVE-2026-16742) | libsystemd0 257.13-1~deb13u1; libudev1 257.13-1~deb13u1 | None reported for trixie | systemd upstream 261.2 (also 258.10 branch fixes) / Debian unstable 261.2-1 | Old affected Debian packages removed by base replacement; no exception |
| [CVE-2026-54369](https://security-tracker.debian.org/tracker/CVE-2026-54369) | libacl1 2.3.2-2+b1 | None reported for trixie | acl upstream 2.4.0 / Debian unstable 2.4.0-1 | Old affected Debian packages removed by base replacement; no exception |
| [CVE-2026-76642](https://security-tracker.debian.org/tracker/CVE-2026-76642) | bsdutils 1:2.41.5-0+deb13u1; libblkid1 2.41.5-0+deb13u1; liblastlog2-2 2.41.5-0+deb13u1; libmount1 2.41.5-0+deb13u1; libsmartcols1 2.41.5-0+deb13u1; libuuid1 2.41.5-0+deb13u1; login 1:4.16.0-2+really2.41.5-0+deb13u1; mount 2.41.5-0+deb13u1; util-linux 2.41.5-0+deb13u1 | None reported for trixie | util-linux upstream 2.42.3 / Debian unstable 2.42.3-1 | Old affected Debian packages removed by base replacement; no exception |
| [CVE-2026-78408](https://security-tracker.debian.org/tracker/CVE-2026-78408) | bsdutils 1:2.41.5-0+deb13u1; libblkid1 2.41.5-0+deb13u1; liblastlog2-2 2.41.5-0+deb13u1; libmount1 2.41.5-0+deb13u1; libsmartcols1 2.41.5-0+deb13u1; libuuid1 2.41.5-0+deb13u1; login 1:4.16.0-2+really2.41.5-0+deb13u1; mount 2.41.5-0+deb13u1; util-linux 2.41.5-0+deb13u1 | None reported for trixie | util-linux upstream 2.42.4 / Debian unstable 2.42.4-1 | Old affected Debian packages removed by base replacement; no exception |
| [CVE-2026-78409](https://security-tracker.debian.org/tracker/CVE-2026-78409) | bsdutils 1:2.41.5-0+deb13u1; libblkid1 2.41.5-0+deb13u1; liblastlog2-2 2.41.5-0+deb13u1; libmount1 2.41.5-0+deb13u1; libsmartcols1 2.41.5-0+deb13u1; libuuid1 2.41.5-0+deb13u1; login 1:4.16.0-2+really2.41.5-0+deb13u1; mount 2.41.5-0+deb13u1; util-linux 2.41.5-0+deb13u1 | None reported for trixie | Debian unstable 2.42.3-1 | Old affected Debian packages removed by base replacement; no exception |
| [CVE-2026-78410](https://security-tracker.debian.org/tracker/CVE-2026-78410) | bsdutils 1:2.41.5-0+deb13u1; libblkid1 2.41.5-0+deb13u1; liblastlog2-2 2.41.5-0+deb13u1; libmount1 2.41.5-0+deb13u1; libsmartcols1 2.41.5-0+deb13u1; libuuid1 2.41.5-0+deb13u1; login 1:4.16.0-2+really2.41.5-0+deb13u1; mount 2.41.5-0+deb13u1; util-linux 2.41.5-0+deb13u1 | None reported for trixie | Debian unstable 2.42.3-1 | Old affected Debian packages removed by base replacement; no exception |
| [CVE-2026-9538](https://security-tracker.debian.org/tracker/CVE-2026-9538) | perl-base 5.40.1-6+deb13u1 | None reported for trixie | Archive::Tar 3.10 / Debian unstable perl 5.42.3-1 | Old affected Debian packages removed by base replacement; no exception |

## Stale local tag found during audit

The reused `iac-backend:local` tag still pointed to an older image with 47 HIGH, despite the previous source-validation image `iac-backend:final` having 44. Rebuilding the documented tag replaces it. The three additional fixed findings in that stale image were:

| CVE | Package/version | Fixed version | Origin | Disposition |
|---|---|---|---|---|
| [CVE-2026-103111](https://security-tracker.debian.org/tracker/CVE-2026-103111) | libpcre2-8-0 10.46-1~deb13u2 | 10.46-1~deb13u3 | Base OS | Old library removed with Debian base |
| [CVE-2026-23949](https://github.com/jaraco/jaraco.context/security/advisories/GHSA-58pv-8j8x-9vj2) | jaraco.context 5.3.0 | 6.1.0 | Base setuptools vendored build dependency | Build tooling absent in final runtime |
| [CVE-2026-24049](https://github.com/pypa/wheel/security/advisories/GHSA-8rrh-rw8j-w5fx) | wheel 0.45.1 | 0.46.2 | Base setuptools vendored build dependency | Build tooling absent in final runtime |

## Changes and trade-offs

The Python base is pinned to `python:3.11-alpine3.24@sha256:f2cdc43fcddbabe870f53750cbdcc01ae4aa75b1959351252457fde88f91d20f`. The container runs UID 10001. Python package installers/build tooling are removed after use. The stdlib-only service does not need a dependency stage. The stale local-tag comparison is 47 HIGH → 0; the source-matching prior release image comparison is 44 HIGH → 0. No compiler or Linux login/mount administration stack was added.

Alpine uses musl rather than glibc. Dependency upgrades must be checked for matching wheels and real DB/network operation. Local builds and runtime checks cover arm64; amd64 hosted CI execution remains NOT TESTED. No claim of universal ABI compatibility is made.

## Remaining HIGH vulnerabilities

None were reported in the scanned new custom runtime image. There are therefore no remaining custom-runtime HIGH exceptions to justify as unfixable. This is a dated detector result, not proof that the image or application is secure. New vulnerabilities can be disclosed later; the pinned digest must be refreshed and rescanned. Do not use absence of a fixed version as a reason to call an affected image secure.

## Security boundaries and unresolved risks

- Docker provider/daemon access is root-equivalent. Use SSH/TLS for remote access and restrict Terraform state; local network isolation does not validate a host firewall or remote-state disaster recovery.
- This is a trusted, loopback/private homelab. Public API authentication, TLS and production authorization are absent. Do not expose it directly.
- The service needs no credential `.env`. State files, backend authentication and remote Docker credentials must remain outside Git; source/history secret checks do not assess remote secret-store configuration.
- Third-party stack images, host/kernel, developer tooling, CI action dependencies and dependency exploitability were not exhaustively audited. Zero findings in the backend image is not a zero-vulnerability result for the whole stack.

## Reproduce and CI

Build the documented local image with `make build`. Run `trivy image --severity HIGH,CRITICAL --exit-code 1 IMAGE_TAG` using the exact image you just built. Use `trivy image --format json IMAGE_TAG` for all-severity evidence. CI now blocks HIGH/CRITICAL custom runtime findings and scans secrets with the default Gitleaks rules; it needs no manually configured credential for basic validation. GitHub supplies its automatic GITHUB_TOKEN. Hosted execution remains NOT TESTED. Production reviewer enforcement requires configuration in GitHub environment settings.

The normalized [scan evidence](docs/security-evidence.json) records image identities, package/CVE/version/fix/origin and all reported severities. Raw scan artifacts were kept locally outside Git.
