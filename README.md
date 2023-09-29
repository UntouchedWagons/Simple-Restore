## Simple Restore

Simple Restore is the companion to the Simple Backup container. It's more useful for Kubernetes setups as an initContainer with PersistantVolumes which (usually) get deleted alongside the associated deployment; applying the deployment results in an empty volume for the service which isn't useful.

### Usage

    ---
    version: "2.1"
        services:
            restore:
                image: UntouchedWagons/Simple-Restore:1.0.0
                container_name: restore
                restart: unless-stopped
                environment:
                    - BACKUP_APPEND_DIRECTORY=/some/sub/path #Optional, DO NOT include quotes
                    - BACKUP_BASE_NAME=Nginx #Required
                volumes:
                    - /path/to/data/source:/data
                    - /path/to/backup/storage:/backups
