#!/usr/bin/env bash
set -euo pipefail

cd /home/ansible/dependencies/deployables-deploy
sudo ansible-playbook 4-deploy-and-configure-dcs.yaml -v --vault-password-file ./vault-password
sudo ansible-playbook 5-deploy-rhel-vms.yaml --limit "splunk_servers" -v --vault-password-file ./vault-password