#!/usr/bin/env bash
echo "Starting server deployment"

#Delearation and initialization
DATE_FOLDER=$1
DEV3_AIRGIGS_COM_TAR="dev3_airgigs_com_$1.tar"
DEV3_AIRGIGS_COM_TEXT="dev3_airgigs_com_$1.txt"
REMOTE_BACKUP_PATH="/home/shohanur.dev.airgigs.com_backup"
FOLDER_RELEASE="release"
FOLDER_BACKUP="backup"
DEPLOY_FOLDER="/var/www/dev3.airgigs.com"

cd /home/shohanur.dev.airgigs.com_backup/$DATE_FOLDER

echo "Severing making backup file before deploying new changes..."
tar -cvf ./$FOLDER_BACKUP/$DEV3_AIRGIGS_COM_TAR -T ./$DEV3_AIRGIGS_COM_TEXT

echo "Server deploying the changes..."
tar -C $DEPLOY_FOLDER/ -xvf  ./$FOLDER_RELEASE/$DEV3_AIRGIGS_COM_TAR
chmod -R 777 $DEPLOY_FOLDER/

# for testing purpose...
#mkdir test
#chmod -R 777 ./test
#tar -C ./test/ -xvf  ./$FOLDER_RELEASE/$DEV3_AIRGIGS_COM_TAR
#chmod -R 777 ./test