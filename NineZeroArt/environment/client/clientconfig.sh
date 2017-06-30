#!/bin/bash

echo "clientConfig: Using ${CONFIGURATION}"

if [ "${CONFIGURATION}" = "Release" ]; then
clientConfig=$SRCROOT/$TARGET_NAME/environment/client/NineZeroClientConfig-Release.plist
elif [ -f $SRCROOT/$TARGET_NAME/environment/client/NineZeroClientConfig-`whoami`.plist ]; then
clientConfig=$SRCROOT/$TARGET_NAME/environment/client/NineZeroClientConfig-`whoami`.plist
else
clientConfig=$SRCROOT/$TARGET_NAME/environment/client/NineeroClientConfig-Debug.plist
fi

echo "clientConfig: file = $clientConfig"

set -e
set -u

# 密码写死，客户端内采用拼接的方式保存
$SRCROOT/$TARGET_NAME/environment/AES256Encrypt "-e" "X6(rhw998,*" $clientConfig $CONFIGURATION_BUILD_DIR/$UNLOCALIZED_RESOURCES_FOLDER_PATH/ClientConfigs.plist
