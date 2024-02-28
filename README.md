# Ansible Collection - deployables.ocp

Documentation for the collection.

## Setup
Ensure you have the following Ansible collections downloaded to your working directory:
  - ansible-posix-1.5.4.tar.gz
  - ansible-utils-3.1.0.tar.gz
  - community-general-8.3.0.tar.gz
  - redhat-satellite_operations-2.1.0.tar.gz
  - redhat-satellite-4.0.0.tar.gz
  - redhat-rhel_system_roles-1.22.0.tar.gz

Install the required collections:
```bash
ansible-galaxy install -r requirements.yaml
```

## Configure the `witness` node

### Prerequisites

1. Ensure that you have the `oc-mirror` archive available
1. Ensure you have the `openshift-baremetal-install` binary available
  1. It should be placed in your working directory
  1. This isn't kept in the repository to save space

### Run the playbook

> **Note**
>
> You will need to have valid SSH credentials to access the witness node.
> These credentials would have been created during the build of the ISO,
> which was used to deployed the witness node.
>
> You will also need the `vault` credential, which the secrets were
> encrypted with.

```bash
ansible-playbook deployables.ocp.configure_witness_node -vbKk --vault-id @prompt
```
