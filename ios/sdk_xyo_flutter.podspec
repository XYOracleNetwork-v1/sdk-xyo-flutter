#
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#
Pod::Spec.new do |s|
  s.name             = 'sdk_xyo_flutter'
  s.version          = '0.0.1'
  s.swift_version    = '4.2'
  s.summary          = 'XYO Flutter SDK.'
  s.description      = <<-DESC
  XYO Flutter SDK.
                       DESC
  s.homepage         = 'https://xyo.network'
  s.license          = { :file => '../LICENSE' }
  s.author           = { 'Kevin Weiler' => 'kevinw@xyo.network' }
  s.source           = { :path => '.' }
  s.source_files = 'Classes/**/*.{h,m,swift,xcdatamodeld}'
  s.resources = 'Classes/Xyo*.xcdatamodeld'
  s.public_header_files = 'Classes/**/*.h'
  
  s.dependency 'Flutter'
  s.dependency 'SwiftProtobuf', '~> 1.5'
  s.dependency 'sdk-xyo-swift', '~> 1.0.4'

  s.ios.deployment_target = '11.0'
end
