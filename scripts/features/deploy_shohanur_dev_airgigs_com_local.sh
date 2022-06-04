#!/usr/bin/env bash
echo "Hello $USER"
echo "Today is $(date)"
echo "--------------------------------------Start deployment-------------------------------------------"
echo "All the changes file will be deployed under this commit no. $1"

#Delearation and initialization
#DATE_FOLDER="20190928210105"
DATE_FOLDER=$(date +%Y%m%d%H%M%S)
DEV3_AIRGIGS_COM_TAR="dev3_airgigs_com_$DATE_FOLDER.tar"
DEV3_AIRGIGS_COM_TEXT="dev3_airgigs_com_$DATE_FOLDER.txt"
REMOTE_BACKUP_PATH="/home/shohanur.dev.airgigs.com_backup"
FOLDER_RELEASE="release"
FOLDER_BACKUP="backup"


echo "Making tar using all changes by commit..."
mkdir ../../shohanur.dev.airgigs.com/$DATE_FOLDER
git show --pretty="" --name-only $1  > ../../shohanur.dev.airgigs.com/$DATE_FOLDER/$DEV3_AIRGIGS_COM_TEXT
tar -cvf ../../shohanur.dev.airgigs.com/$DATE_FOLDER/$DEV3_AIRGIGS_COM_TAR -T ../../shohanur.dev.airgigs.com/$DATE_FOLDER/$DEV3_AIRGIGS_COM_TEXT

echo "Remote server file upload..."
ssh ubuntu@shohanur.dev.airgigs.com "mkdir -p $REMOTE_BACKUP_PATH/$DATE_FOLDER/$FOLDER_RELEASE"
ssh ubuntu@shohanur.dev.airgigs.com "mkdir -p $REMOTE_BACKUP_PATH/$DATE_FOLDER/$FOLDER_BACKUP"

scp -i ../../shohanur.dev.airgigs.com/shohan_id_rsa  ../../shohanur.dev.airgigs.com/$DATE_FOLDER/$DEV3_AIRGIGS_COM_TEXT ubuntu@shohanur.dev.airgigs.com:/home/shohanur.dev.airgigs.com_backup/$DATE_FOLDER/
scp -i ../../shohanur.dev.airgigs.com/shohan_id_rsa  ../../shohanur.dev.airgigs.com/$DATE_FOLDER/$DEV3_AIRGIGS_COM_TAR ubuntu@shohanur.dev.airgigs.com:/home/shohanur.dev.airgigs.com_backup/$DATE_FOLDER/$FOLDER_RELEASE/

echo "execute bash in remote server..."
ssh ubuntu@shohanur.dev.airgigs.com  'bash -s' < ./deploy_shohanur_dev_airgigs_com_remote.sh $DATE_FOLDER


echo "--------------------------------------End deployment-------------------------------------------"


# for running this file. Please use the below command
#./deploy_shohanur_dev_airgigs_com_local.sh  commit no.