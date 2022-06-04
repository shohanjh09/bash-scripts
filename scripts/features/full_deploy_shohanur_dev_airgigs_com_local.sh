#!/usr/bin/env bash
echo "Hello $USER"
echo "Today is $(date)"
echo "--------------------------------------Start deployment-------------------------------------------"
echo "All the changes file will be deployed under this commit no. $1"

#Delearation and initialization
#DATE_FOLDER="20190928210105"
DATE_FOLDER=$(date +%Y%m%d%H%M%S)
DEV3_AIRGIGS_COM_TAR="dev3_airgigs_com_$DATE_FOLDER.tar"
REMOTE_BACKUP_PATH="/home/shohanur.dev.airgigs.com_backup"

echo "Making tar using all changes by commit..."
mkdir ../../shohanur.dev.airgigs.com/$DATE_FOLDER
tar -cvf ../../shohanur.dev.airgigs.com/$DATE_FOLDER/$DEV3_AIRGIGS_COM_TAR ./src

echo "Uploading tar in the remote server..."
scp -i ../../shohanur.dev.airgigs.com/shohan_id_rsa  ../../shohanur.dev.airgigs.com/$DATE_FOLDER/$DEV3_AIRGIGS_COM_TAR ubuntu@shohanur.dev.airgigs.com:/home/shohanur.dev.airgigs.com_backup

echo "execute bash in remote server..."
ssh ubuntu@shohanur.dev.airgigs.com  'bash -s' < ./full_deploy_shohanur_dev_airgigs_com_remote.sh $DATE_FOLDER


echo "--------------------------------------End deployment-------------------------------------------"


# for running this file. Please use the below command
#./deploy_shohanur_dev_airgigs_com_local.sh  commit no.