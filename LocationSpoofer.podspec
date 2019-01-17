#
# Be sure to run `pod lib lint LocationSpoofer.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'LocationSpoofer'
  s.version          = '0.1.0'
  s.summary          = 'Easy location mocking.'
  s.description      = 'LocationSpoofer is an iOS library for spoofing / mocking location, without changing any of your existing CoreLocation code.'
  s.homepage         = 'https://buglife.com'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'buglife' => 'support@buglife.com' }
  s.source           = { :git => 'https://github.com/buglife/LocationSpoofer.git', :tag => s.version.to_s }
  s.ios.deployment_target = '10.0'
  s.source_files = 'LocationSpoofer/Classes/**/*'
  s.public_header_files = 'LocationSpoofer/Classes/Public/**/*.h'
  s.frameworks = 'UIKit', 'MapKit', 'CoreLocation'
end
