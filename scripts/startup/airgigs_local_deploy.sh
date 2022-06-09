#!/bin/bash
# Variables
AIRGIGS_LOCAL_VAGRANT_DIR='/Volumes/Files/Airgigs/Vagrant'
AIRGIGS_API_LOCAL_VAGRANT_DIR='/Volumes/Files/Airgigs/VagrantApi/Homestead'
AIRGIGS_API_SERVER_WEB_DIR='/home/vagrant/Airgigs-APi'


echo "---------------------------------"
echo "Starting Airgigs Web server..."
echo "---------------------------------"
cd $AIRGIGS_LOCAL_VAGRANT_DIR
vagrant up
echo "---------------------------------"
echo "Airgigs Web server is running..."
echo "---------------------------------"

echo "---------------------------------"
echo "Starting Airgigs API server..."
echo "---------------------------------"
cd $AIRGIGS_API_LOCAL_VAGRANT_DIR
vagrant up
echo "---------------------------------"
echo "Airgigs API server is running..."
echo "---------------------------------"

#cd $AIRGIGS_LOCAL_VAGRANT_DIR
#vagrant ssh
exit 1;