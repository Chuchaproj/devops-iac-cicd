ENV ?= dev
IMAGE ?= iac-backend:local
.PHONY: install test lint build up down smoke fmt validate deploy rollback ansible
install:
	python3 -m venv .venv
	.venv/bin/pip install -r requirements-dev.txt
test:
	.venv/bin/python -m pytest -q
lint:
	.venv/bin/ruff check app tests scripts
	shellcheck scripts/*.sh
	yamllint -c .yamllint compose.yaml ansible .github
	hadolint Dockerfile
	.venv/bin/ansible-lint ansible/site.yml
	terraform fmt -check -recursive terraform
build:
	docker build --provenance=false -t $(IMAGE) .
up:
	docker compose up -d --build --wait
down:
	docker compose down
smoke:
	python3 scripts/smoke.py
fmt:
	terraform fmt -recursive terraform
validate:
	for env in dev stage prod; do terraform -chdir=terraform/environments/$$env init -backend=false -input=false && terraform -chdir=terraform/environments/$$env validate || exit 1; done
deploy:
	bash scripts/deploy.sh $(ENV) $(IMAGE)
rollback:
	bash scripts/rollback.sh $(ENV) $(IMAGE)
ansible:
	cd ansible && ../.venv/bin/ansible-playbook site.yml

.PHONY: secrets
secrets:
	bash scripts/check-secrets.sh
