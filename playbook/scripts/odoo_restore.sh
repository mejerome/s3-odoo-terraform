#!/bin/bash

# vars
RESTORE_DIR=~/odoo_restore
ODOO_DATABASE=ssx-base-db
ADMIN_PASSWORD=wxerdXCDFvm2
PROFILE=default
BUCKET=ssx-postgres-backups
BUCKET_DIR=ssx-restore

# download latest backup from s3
aws s3 cp s3://$BUCKET/$BUCKET_DIR/restore.zip /home/bitnami/odoo_restore

# create a backup
curl -F 'master_pwd=$ADMIN_PASSWORD' -F backup_file=@/home/bitnami/odoo_restore/restore.zip -F 'copy=true' -F 'name=${ODOO_DATABASE}' http://localhost:8069/web/database/restore