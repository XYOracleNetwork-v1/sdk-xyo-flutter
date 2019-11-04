#
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#
Pod::Spec.new do |s|
  s.name             = 'sdk_xyo_flutter'
  s.version          = '0.1.4'
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
  s.dependency 'XyBleSdk', '~> 3.0.6'
  s.dependency 'SwiftProtobuf', '~> 1.5'
  s.dependency 'sdk-bletcpbridge-swift', '~> 3.0.7'
  s.dependency 'sdk-xyobleinterface-swift', '~> 3.0.7'
  s.dependency 'sdk-core-swift', '~> 3.0.1'
  s.dependency 'sdk-objectmodel-swift', '~> 3.0.1'

  s.ios.deployment_target = '11.0'
end
