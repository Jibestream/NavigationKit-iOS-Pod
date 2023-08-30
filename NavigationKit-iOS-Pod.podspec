Pod::Spec.new do |s|
s.name             = 'NavigationKit-iOS-Pod'
s.version='2.2.0'
s.summary          = 'The NavigationKit-iOS-Pod for the Jibestream iOS SDK.'

s.description      = 'This CocoaPod provides the release version of the NavigationKit for the Jibestream iOS SDK.'

s.homepage         = 'http://www.jibestream.com/'
s.author           = { 'louieyuen' => 'lyuen@jibestream.com' }
s.source           = { :git => 'https://github.com/Jibestream/NavigationKit-iOS-Pod', :tag => "#{s.version}" }
s.dependency "JMapiOSSDK"
s.ios.deployment_target = '10.0'
s.platform = :ios, '9.0'
s.vendored_frameworks = 'NavigationKit-iOS-Pod/Frameworks/*.xcframework'

end
