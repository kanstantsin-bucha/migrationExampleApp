#
# Be sure to run `pod lib lint DetectaConnectSDK.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'DetectaConnectSDK'
  s.version          = '0.1.0'
  s.summary          = 'Detecta Cloud Connect Moblie SDK.'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
  Contains basic UI and logic to interoperate with Detecta Cloud Server.
                       DESC

  s.homepage         = 'https://detecta.group'
  s.license          = { :type => 'Private License', :file => 'DetectaConnectSDK/LICENSE' }
  s.author           = { 'Kanstantsin Bucha' => 'truebucha@gmail.com' }
  s.source           = { :git => 'https://github.com/truebucha/DetectaConnectSDK.git', :tag => s.version.to_s }

  s.ios.deployment_target = '12.3'
  s.swift_version = '5.3'

  s.source_files = 'DetectaConnectSDK/Classes/**/*'
  s.resources = 'DetectaConnectSDK/Assets/**/*.{png,jpeg,jpg,storyboard,xib,xcassets}'
  # s.ios.resource_bundle = { 'DetectaConnectSDK' => 'Assets/**/*.xcassets' }

  s.frameworks = 'Foundation', 'UIKit', 'CoreBluetooth'
  s.dependency 'BlueSwift'
  s.dependency 'SwiftProtobuf'
  s.dependency 'Charts'
end
