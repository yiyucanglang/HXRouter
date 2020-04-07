Pod::Spec.new do |s|
  s.name             = 'TestCommunity'
  s.version          = '1.0.1'
  s.summary          = 'An easy-to-use routing component for iOS'

  s.homepage         = 'https://github.com/yiyucanglang'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'dahuanxiong' => 'xinlixuezyj@163.com' }
  s.source           = { :git => 'https://github.com/yiyucanglang/HXRouter.git', :tag => s.version.to_s }

  s.static_framework = true

  s.ios.deployment_target = '8.0'

  s.public_header_files = '*{h}'
  s.source_files = '*.{h,m}'
 end
