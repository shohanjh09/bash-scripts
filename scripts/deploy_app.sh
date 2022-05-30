#!/bin/bash
# Terminate execution if any command fails
set -e

# Functions
ok() { echo -e '\e[32m'$1'\e[m'; } # Green
die() { echo -e '\e[1;31m'$1'\e[m'; exit 1; }

# Set basic setting for deployment
BASE_DIR=/home/airgigsapp
RELEASE_DIR=/vagrant/airgigsapp/

cd $BASE_DIR

echo "---------------------------------"
echo "Cleaning the exising app dependencies..."
echo "---------------------------------"

rm -rf $BASE_DIR/node_modules/
rm -rf $BASE_DIR/dist/

rm -rf $RELEASE_DIR/dist/
rm -rf $RELEASE_DIR/node_modules/

ok "Dependencies are cleared";

echo "---------------------------------"
echo "Installing app dependencies..."
echo "---------------------------------"

npm install

ok "Dependencies are added";

echo "---------------------------------"
echo "Buliding production build..."
echo "---------------------------------"

npm run build

ok "Build completed";

echo "---------------------------------"
echo "Syn ionic cap..."
echo "---------------------------------"

ionic cap sync

ok "Syn ionic app done";

echo "---------------------------------"
echo "Moving the dependencies and build to release..."
echo "---------------------------------"

cp -r $BASE_DIR/node_modules/ $RELEASE_DIR/
cp -r $BASE_DIR/dist/ $RELEASE_DIR/

echo "Deployment completed"