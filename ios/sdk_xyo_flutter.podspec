#
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html.
# Run `pod lib lint sdk_xyo_flutter.podspec' to validate before publishing.
#
Pod::Spec.new do |s|
  s.name             = 'sdk_xyo_flutter'
  s.version          = '0.1.0'
  s.swift_version    = '4.2'
  s.summary          = 'XYO Flutter SDK.'
  s.description      = <<-DESC
  XYO Flutter SDK.
                       DESC
  s.homepage         = 'https://xyo.network'
  s.license          = { :file => '../LICENSE' }
  s.author           = { 'Your Company' => 'support@xyo.network' }
  s.source           = { :path => '.' }
  s.source_files = 'Classes/**/*.{h,m,swift,xcdatamodeld}'
  s.resources = 'Classes/Xyo*.xcdatamodeld'
  s.public_header_files = 'Classes/**/*.h'

  s.dependency 'Flutter'
  s.dependency 'SwiftProtobuf', '~> 1.8'
  s.dependency 'sdk-xyo-swift', '~> 1.0'

  s.ios.deployment_target = '11.0'

  # Flutter.framework does not contain a i386 slice. Only x86_64 simulators are supported.
   s.pod_target_xcconfig = { 'DEFINES_MODULE' => 'YES', 'VALID_ARCHS[sdk=iphonesimulator*]' => 'x86_64' }
  # s.swift_version = '5.0'
end
