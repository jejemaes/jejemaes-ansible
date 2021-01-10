# jejemaes-ansible

Ansible playbooks to setup and manage Odoo Cloud, Wordpress sites, ... on my VPS

Missing files are
 - **hosts**: to set your server IP
  ```
[cloud]
69.69.69.69
 ```
 - **.env**: personal environment variables


## Requirements

This playbooks depends on the community collection (https://galaxy.ansible.com/community/general). So, it is needed to install it before running commands.

> ansible-galaxy install -r requirements.yml

## Metabase

The metabase contains the running service catalog. The purpose is to have a global overview of the accounts, services and used ports. From that database, we can recreate all server configurations.

> ansible-playbook common-metabase.yml


## Setup Server

This playbook will setup all different services, packages, utils, ... for our cloud : nginx, postgres server, ... but also specific lib and configuration for odoo, web, ...

> ansible-playbook common-setup.yml


## Odoo

### Version Management

Deploy a specific version: checkout code, generate bin files and start services.

> ansible-playbook odoo-version-deploy.yml --extra-var version=14.0

To update a version: pull code from git and restart service

> ansible-playbook odoo-version-update.yml --extra-var version=14.0


### Database Management

Once a version is added, we can do operations on database.

Create a new one with the following command. No SSL certificate will be created for the domain, as it must be done in 2 times.

> ansible-playbook odoo-db-new.yml -e "dbname=testasbl_wagnelee_be domains=testasbl.wagnelee.be version=14.0"

Link a new domain (no SSL certificate) with

> ansible-playbook odoo-db-add-domain.yml -e "dbname=asblcopy_wagnelee_be domain=asblcopy_wagnelee_be"

Refresh nginx configuration of a given database with

> ansible-playbook odoo-db-refresh-nginx.yml -e "dbname=asbl_wagnelee_be"

Create a duplicate database; this will copy the database, desactivate mails serve, ...

> ansible-playbook odoo-db-duplicate.yml -e "src_dbname=asbl_wagnelee_be dst_dbname=asblcopy_wagnelee_be domains=asblcopy.wagnelee.be"

Create an SSL certificate for a given database

> ansible-playbook odoo-db-certificate.yml -e "domain=perso.jejemaes.net"

Remove a database (drop database, delete nginx files, ...)

> ansible-playbook odoo-db-remove.yml -e "dbname=perso_jejemaes_net"


## Wordpress

Later ....



certbot certonly --noninteractive --nginx -d asbl-copy.wagnelee.be --dry-run

