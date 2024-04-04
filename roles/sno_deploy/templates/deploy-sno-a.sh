#!/usr/bin/env bash
set -euo pipefail

export IDRAC_PASSWORD='{{ sno_a_idrac_password }}'
openshift-install --dir /home/ansible/sno-a/ agent create image

sudo cp /home/ansible/sno-a/agent.x86_64.iso /home/ansible/ocp-isos/sno-a.iso
CURRENT_VIRTUAL_MEDIA=$(curl --insecure -u "root:${IDRAC_PASSWORD}" -H "Content-Type: application/json" https://{{ sno_a_idrac_ip }}/redfish/v1/Systems/System.Embedded.1/VirtualMedia/1 | jq '.Image')

# Eject virtual media if required
if [[ ${CURRENT_VIRTUAL_MEDIA} != *'null'* ]]; then
  curl --insecure \
  -u "root:${IDRAC_PASSWORD}" \
  -X POST \
  -H "Content-Type: application/json" \
  https://{{ sno_a_idrac_ip }}/redfish/v1/Systems/System.Embedded.1/VirtualMedia/1/Actions/VirtualMedia.EjectMedia
fi

# Mount the ISO
curl --insecure \
-u "root:${IDRAC_PASSWORD}" \
-X POST \
-H "Content-Type: application/json" \
-d '{"Image": "http://{{ inventory_hostname }}:8888/sno-a.iso", "Inserted": true}' \
https://{{ sno_a_idrac_ip }}/redfish/v1/Systems/System.Embedded.1/VirtualMedia/1/Actions/VirtualMedia.InsertMedia

# Override next boot
curl --insecure \
-u "root:${IDRAC_PASSWORD}" \
-X POST \
-H "Content-Type: application/json" \
-d '{"ShareParameters":{"Target":"ALL"},"ImportBuffer":"<SystemConfiguration><Component FQDD=\"iDRAC.Embedded.1\"><Attribute Name=\"ServerBoot.1#BootOnce\">Enabled</Attribute><Attribute Name=\"ServerBoot.1#FirstBootDevice\">VCD-DVD</Attribute></Component></SystemConfiguration>"}' \
https://{{ sno_a_idrac_ip }}/redfish/v1/Managers/iDRAC.Embedded.1/Actions/Oem/EID_674_Manager.ImportSystemConfiguration

# Turn on the sled
curl --insecure \
-u "root:${IDRAC_PASSWORD}" \
-X POST \
-H "Content-Type: application/json" \
-d '{"ResetType": "On"}' \
https://{{ sno_a_idrac_ip }}/redfish/v1/Systems/System.Embedded.1/Actions/ComputerSystem.Reset

openshift-install --dir /home/ansible/sno-a/ agent wait-for bootstrap-complete --log-level=info
openshift-install --dir /home/ansible/sno-a/ agent wait-for install-complete --log-level=info

echo "OpenShift Deployed. Starting configuration"

cd /home/ansible/dependencies/deployables-deploy
sudo ansible-playbook 3-configure-openshift-clusters.yaml -v --vault-password-file ./vault-password --limit "sled1.*"