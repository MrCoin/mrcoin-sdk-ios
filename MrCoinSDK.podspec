Pod::Spec.new do |s|
  s.name     = ‘MrCoinSDK’
  s.version  = ‘0.1.0’
  s.license  = ‘…’
  s.summary  = 'An open source iOS framework for …’
  s.homepage = 'https://github.com/MrCoin/mrcoin-ios-sdk'
  s.author   = { ‘Gabor Nagy’ => ‘gabor.nagy@shellshaper.com’ }
  s.source   = { :git => 'https://github.com/MrCoin/mrcoin-ios-sdk.git', :tag => "#{s.version}" }
  
  s.source_files = 'framework/Source/**/*.{h,m}'
  s.resources = 'framework/Resources/*.png'
  s.requires_arc = true
  s.xcconfig = { 'CLANG_MODULES_AUTOLINK' => 'YES' }
  
  s.ios.deployment_target = ‘7.0’
end
