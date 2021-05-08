source 'https://github.com/CocoaPods/Specs.git'

workspace 'Client.xcworkspace'

# ================= Client ================

target :'D-Connect' do
    platform :ios, '13'
    use_frameworks!
    project 'Client.xcodeproj'
    pod 'DetectaConnectSDK', :path => "."
end

target :'DetectaConnectTests' do
    platform :ios, '13'
    use_frameworks!
    project 'Client.xcodeproj'
    pod 'DetectaConnectSDK', :path => "."
end

post_install do |installer|
  installer.pods_project.targets.each do |target|
    puts target.name
  end
end

