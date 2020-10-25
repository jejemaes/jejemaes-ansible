# jejemaes-ansible

Ansible playbooks to setup and manage Odoo Cloud, Wordpress sites, ... on my VPS

Missing files are
 - **hosts**: to set your server IP
  ```
[cloud]
69.69.69.69
 ```
 - **.env**: personal environment variables



## Odoo

Setup Odoo server : this will create user, setup directories and scripts, ...

> ansible-playbook odoo-setup

Deploy a specific version: checkout code, generate bin files and start services, or pull code from git and restart service

> ansible-playbook odoo-deploy-version --extra-var version=14.0

To create the backup of an Odoo Instance (database and filestore). This will create a backup in `/root/backups/` (as `root` user).

> ansible-playbook odoo-backup --extra-var dbname=my_database


## Wordpress

Later ....
