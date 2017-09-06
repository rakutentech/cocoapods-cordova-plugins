# copy cordova and plugins JS files
mkdir -p $TARGET_BUILD_DIR/$TARGET_NAME.app/www
cp -r $TARGET_BUILD_DIR/$TARGET_NAME.app/Frameworks/CordovaPlugins.framework/js/* $TARGET_BUILD_DIR/$TARGET_NAME.app/www
rm -rf $TARGET_BUILD_DIR/$TARGET_NAME.app/Frameworks/CordovaPlugins.framework/js

# copy plugins resources
mkdir -p $TARGET_BUILD_DIR/$TARGET_NAME.app/plugins_resources
cp -r $TARGET_BUILD_DIR/$TARGET_NAME.app/Frameworks/CordovaPlugins.framework/res/* $TARGET_BUILD_DIR/$TARGET_NAME.app
rm -rf $TARGET_BUILD_DIR/$TARGET_NAME.app/Frameworks/CordovaPlugins.framework/res
