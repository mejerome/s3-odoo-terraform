#!/bin/bash
# variables
BACKUP_DIR=/home/bitnami/odoo_backup
ODOO_DB=ssx-base-db
ADMIN_PASSWORD=bitnami

curl -X POST -F 'master_pwd=${ADMIN_PASSWORD}' \
  -F 'name=${ODOO_DB}' \
  -F 'backup_format=zip' \
  -o ${BACKUP_DIR}/${ODOO_DB}-$(date +%Y.%m.%d-%H.%M).zip \
  http://localhost:8069/web/database/backup

cd ${BACKUP_DIR}; cp $(ls -t | head -1) restore.zip
aws s3 sync ${BACKUP_DIR} s3://ssx-postgres-backups/ssx-backups