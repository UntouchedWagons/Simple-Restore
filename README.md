## Simple Restore

Simple Restore is the companion to the Simple Backup container. It's more useful for Kubernetes setups as an initContainer with PersistantVolumeClaims which (usually) get deleted alongside the associated deployment; applying the deployment results in an empty volume for the service which isn't useful.

### Usage

#### Docker

    ---
    services:
        restore:
            image: untouchedwagons/simple-restore:1.1.0
            container_name: restore
            restart: no
            environment:
                - BACKUP_BASE_NAME=Nginx # Required
                - BACKUP_APPEND_DIRECTORY=/some/sub/path # Optional
            volumes:
                - /path/to/data/source:/data
                - /path/to/backup/storage:/backups

#### Kubernetes

    initContainers:
    - name: restore
        image: untouchedwagons/simple-restore:1.1.0
        volumeMounts:
        - mountPath: /data
            name: Nginx-config
        - mountPath: /backups
            name: backups
        env:
        - name: BACKUP_BASE_NAME
            value: Nginx
        - name: BACKUP_APPEND_DIRECTORY
            value: /some/sub/path

When the container is finished restoring the latest backup it'll create a file called RESTORE in `/data` which it looks for on subsequent runs. If this file exists the restore process will abort so that it won't overwrite the volume with slightly old data. The backup container ignores this file so if the volume does get deleted the most recent backup will be restored as expected.
