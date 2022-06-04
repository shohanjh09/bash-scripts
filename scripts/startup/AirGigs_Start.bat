@echo off 
echo "Dev3 server is starting"
cd /d "D:\Airgigs\Vagrant"
start vagrant up

echo "API server is starting"
cd /d "D:\Airgigs\VagrantApi\Homestead"
start vagrant up

echo "AirGigs Local is ready for use!"
rem PAUSE