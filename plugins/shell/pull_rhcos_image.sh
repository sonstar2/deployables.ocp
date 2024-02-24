#!/usr/bin/env bash
set -euo pipefail

export RHCOS_QEMU_URI=$(/usr/local/bin/openshift-baremetal-install coreos print-stream-json | jq -r --arg ARCH "$(arch)" '.architectures[$ARCH].artifacts.qemu.formats["qcow2.gz"].disk.location')
export RHCOS_QEMU_NAME=${RHCOS_QEMU_URI##*/}
export RHCOS_QEMU_UNCOMPRESSED_SHA256=$(/usr/local/bin/openshift-baremetal-install coreos print-stream-json | jq -r --arg ARCH "$(arch)" '.architectures[$ARCH].artifacts.qemu.formats["qcow2.gz"].disk["uncompressed-sha256"]')
curl -L ${RHCOS_QEMU_URI} -o ./rhcos.gcow2.gz

echo "Please update the 'rhcos_sha' variable with ${RHCOS_QEMU_UNCOMPRESSED_SHA256}"
echo "You will also need to copy 'rhcos.qcow2.gz' to /home/ansible/rhcos_image_cache on \
on the witness node"
