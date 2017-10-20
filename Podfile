# Uncomment the next line to define a global platform for your project
# platform :ios, '9.0'

target 'NineZeroArt' do
  # Uncomment the next line if you're using Swift or would like to use dynamic frameworks
  # use_frameworks!
  
  pod 'AFNetworking', '~> 3.0'
  pod 'SDWebImage', '~> 3.7.3'
  pod 'YTKKeyValueStore'
  pod 'Qiniu', "~> 7.0"
  pod 'MBProgressHUD+BWMExtension', '~> 1.0.0'
  pod 'Masonry'
  pod 'UIImage+animatedGif', '~> 0.1.0'
  pod 'TTTAttributedLabel'
  pod 'YLGIFImage'
  pod 'SSZipArchive'
  
  target 'NineZeroArtTests' do
    inherit! :search_paths
    # Pods for testing
  end

  target 'NineZeroArtUITests' do
    inherit! :search_paths
    # Pods for testing
  end
  
end

post_install do |installer|
    copy_pods_resources_path = "Pods/Target Support Files/Pods-NineZeroArt/Pods-NineZeroArt-resources.sh"
    string_to_replace = '--compile "${BUILT_PRODUCTS_DIR}/${UNLOCALIZED_RESOURCES_FOLDER_PATH}"'
    assets_compile_with_app_icon_arguments = '--compile "${BUILT_PRODUCTS_DIR}/${UNLOCALIZED_RESOURCES_FOLDER_PATH}" --app-icon "${ASSETCATALOG_COMPILER_APPICON_NAME}" --output-partial-info-plist "${BUILD_DIR}/assetcatalog_generated_info.plist"'
    text = File.read(copy_pods_resources_path)
    new_contents = text.gsub(string_to_replace, assets_compile_with_app_icon_arguments)
    File.open(copy_pods_resources_path, "w") {|file| file.puts new_contents }
end
