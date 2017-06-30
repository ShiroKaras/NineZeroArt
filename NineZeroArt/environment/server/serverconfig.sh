#!/bin/bash

echo "serverConfig: Using ${CONFIGURATION}"

if [ "${CONFIGURATION}" = "Release" ]; then
serverConfig=$SRCROOT/$TARGET_NAME/environment/server/NineZeroServerConfig-Release.plist
elif [ -f $SRCROOT/$TARGET_NAME/environment/server/NineZeroServerConfig-`whoami`.plist ]; then
serverConfig=$SRCROOT/$TARGET_NAME/environment/server/NineZeroServerConfig-`whoami`.plist
else
serverConfig=$SRCROOT/$TARGET_NAME/environment/client/NineeroServerConfig-Debug.plist
fi

echo "serverConfig: file = $serverConfig"

set -e
set -u

# 密码写死，客户端内采用拼接的方式保存
$SRCROOT/$TARGET_NAME/environment/AES256Encrypt "-e" "X6(rhw998,*" $serverConfig $CONFIGURATION_BUILD_DIR/$UNLOCALIZED_RESOURCES_FOLDER_PATH/ServerConfigs.plist
