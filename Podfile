source 'https://github.com/CocoaPods/Specs.git'

workspace 'Client.xcworkspace'

# ================= Client ================

def shared_pods
    platform :ios, '13'
    use_frameworks!

    pod 'CDBKit', '~> 1.4.1'
    pod 'BuchaSwift', '~> 1.0'
    
    pod 'BlueSwift'
    pod 'SwiftProtobuf'
end

target :'client' do
    project 'Client.xcodeproj'
    shared_pods
end

target :'clientTests' do
    project 'Client.xcodeproj'
    shared_pods
end

post_install do |installer|
  installer.pods_project.targets.each do |target|
    puts target.name
  end
end

