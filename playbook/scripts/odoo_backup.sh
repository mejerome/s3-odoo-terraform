#!/bin/bash

# vars
BACKUP_DIR=~/odoo_backup
ODOO_DATABASE=ssx-base-db
ADMIN_PASSWORD=wxerdXCDFvm2
PROFILE=default
BUCKET=ssx-postgres-backups
BUCKET_DIR=ssx-restore
LATEST_FILE=$ODOO_DATABASE-$(date +%F).zip

# create a backup
curl -X POST -F "master_pwd=$ADMIN_PASSWORD" -F "name=$ODOO_DATABASE" -F "backup_format=zip" -o $BACKUP_DIR/$LATEST_FILE http://localhost:8069/web/database/backup

# sync to s3
aws s3 sync $BACKUP_DIR s3://$BUCKET/$BUCKET_DIR --profile $PROFILE

# overwrite latest restore file
cp $BACKUP_DIR/$LATEST_FILE ~/odoo_restore/restore.zip
aws s3 cp ~/odoo_restore/restore.zip s3://$BUCKET/$BUCKET_DIR/restore.zip --profile $PROFILE 

# delete old backups
find ${BACKUP_DIR} -type f -mtime +7 -name "${ODOO_DATABASE}-*.zip" -delete