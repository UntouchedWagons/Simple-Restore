#! /bin/bash

BACKUP_DIRECTORY="/backups"

if [ ! -d ${BACKUP_DIRECTORY} ]; then
    echo "Folder to restore from does not exist. The backups folder should be available at /backups"
    exit 1
fi

if [ -n $BACKUP_APPEND_DIRECTORY ]; then
    BACKUP_DIRECTORY=${BACKUP_DIRECTORY}${BACKUP_APPEND_DIRECTORY}
fi

if [ ! -d ${BACKUP_DIRECTORY} ]; then
    echo $BACKUP_DIRECTORY" does not exist. This may simply be because no backups have been made yet."
fi

if [ ! -d "/data" ]; then
    echo "Folder to be restored does not exist. The target folder should be available at /data"
    exit 1
fi

if [ -z $BACKUP_BASE_NAME ]; then
    echo "No backup base name has been set; examples are 'nginx', 'vaultwarden' or 'mariadb'"
    exit 1
fi

FILE_TO_RESTORE=$(ls -t $BACKUP_DIRECTORY/$BACKUP_BASE_NAME-* | head -n 1)

if [ -z $FILE_TO_RESTORE ]; then
    echo "No backups are available to restore."
    exit
fi

if [ -e /data/RESTORED ]; then
    echo "/data/RESTORED exists, bailing. If you want to restore the latest backup in place delete the RESTORED file"
    exit
fi

touch /data/test

if [ $? -ne 0 ]; then
    echo "Could not write to /data, please check the permissions"
    exit 1
fi

rm /data/test

tar -xzpf $FILE_TO_RESTORE -C /data
touch /data/RESTORED
