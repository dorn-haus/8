## Ansible Module

Sets the `ANSIBLE_INVENTORY` value to an auto-generated (YAML) inventory file.

The inventory contains all nodes, so plays need to select the right group in the `hosts` field.

The inventory also contains group vars that are generated based on the cluster config, so Ansible roles would not need
to hard-code such values.
