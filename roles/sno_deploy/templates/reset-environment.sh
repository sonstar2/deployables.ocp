#!/usr/bin/env bash
set -euo pipefail

export IDRAC_PASSWORD='{{ sno_b_idrac_password }}'

echo "Powering off sled2"
# Turn off the sled
curl --insecure \
-u "root:${IDRAC_PASSWORD}" \
-X POST \
-H "Content-Type: application/json" \
-d '{"ResetType": "ForceOff"}' \
"https://{{ sno_b_idrac_ip }}/redfish/v1/Systems/System.Embedded.1/Actions/ComputerSystem.Reset"


echo "Removing sno-b configuration"
rm -rf /home/ansible/sno-b

echo "Creating sno-b configuration"
cd /home/ansible/dependencies/deployables-deploy
sudo ansible-playbook 2-configure-build-node.yaml -vb --vault-password-file ./vault-password --tags "openshift-deploy"