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

> ansible-playbook odoo-setup.yml

Deploy a specific version: checkout code, generate bin files and start services, or pull code from git and restart service

> ansible-playbook odoo-deploy-version.yml --extra-var version=14.0

The next step is to create a new odoo instance. We can do that  by specifying the domain and the version. A postgres database and a static nginx file will be created and enabled.

> ansible-playbook odoo-create-db.yml -e "domain=perso.jejemaes.net version=14.0"

To create the backup of an Odoo Instance (database and filestore). This will create a backup in `/root/backups/` (as `root` user).

> ansible-playbook odoo-backup --extra-var dbname=my_database


## Wordpress

Later ....
