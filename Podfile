# Uncomment the next line to define a global platform for your project
# platform :ios, '9.0'

target 'menomotasel' do
  # Comment the next line if you don't want to use dynamic frameworks
  use_frameworks!

  # Pods for menomotasel
pod 'Firebase/Core'
pod 'Firebase/Messaging'
pod 'Google-Mobile-Ads-SDK'
pod 'Firebase/Storage'
pod 'FirebaseFirestore'
pod 'Firebase/Auth'
pod 'Firebase'
pod 'Firebase/InAppMessaging'
pod 'Firebase/Analytics'
pod 'Firebase/RemoteConfig'
pod 'KSToastView', '0.5.7'
pod 'SwiftyGif'


post_install do |installer|
  installer.generated_projects.each do |project|
    project.targets.each do |target|
      target.build_configurations.each do |config|
        config.build_settings["DEVELOPMENT_TEAM"] = "RPA494Z5LZ"
      end
    end
  end
end

end
