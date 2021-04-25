source 'https://github.com/CocoaPods/Specs.git'

workspace 'Client.xcworkspace'

# ================= Client ================

def shared_pods
    platform :ios, '13'
    use_frameworks!
    
    pod 'DetectaConnectSDK', :path => "."
end

target :'D-Connect' do
    project 'Client.xcodeproj'
    shared_pods
end

target :'DetectaConnectTests' do
    project 'Client.xcodeproj'
    shared_pods
end

post_install do |installer|
  installer.pods_project.targets.each do |target|
    puts target.name
  end
end

