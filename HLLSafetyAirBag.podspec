#
# Be sure to run `pod lib lint HLLSafetyAirBag.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'HLLSafetyAirBag'
  s.version          = '0.3.13'
  s.summary          = '安全气囊，iOS系统下的Crash安全防护组件'
  s.description      = <<-DESC
  iOS系统下的Crash安全防护组件, 对项目工程的代码进行主动、被动的crash安全防护，以保证APP稳定性,增强用户的体验.
                       DESC

  s.homepage         = 'https://github.com/HuolalaTech/hll-safetyairbag-ios'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'chensheng12330' => '' }
  s.source           = { :git => 'git@github.com:HuolalaTech/hll-safetyairbag-ios.git', :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.ios.deployment_target = '9.0'
  s.pod_target_xcconfig = {
      'ENABLE_BITCODE' => 'NO',
      'EXCLUDED_ARCHS[sdk=iphonesimulator*]' => 'arm64',
      'VALID_ARCHS' => 'arm64 x86_64'
  }

  s.user_target_xcconfig = {
    'EXCLUDED_ARCHS[sdk=iphonesimulator*]' => 'arm64',
    'VALID_ARCHS' => 'arm64 x86_64'
  }
  
  s.static_framework = true

  #子库组件,按需依赖.
  s.subspec 'HLLSafeCode' do |sp|
    sp.source_files = 'HLLSafetyAirBag/Classes/HLLSafeCode/*.{h,m}'
    sp.public_header_files = 'HLLSafetyAirBag/Classes/HLLSafeCode/*.h'
  end

  s.subspec 'HLLSafeCrash' do |sp|
      sp.source_files = 'HLLSafetyAirBag/Classes/HLLSafeCrash/*.{h,m}'
      sp.public_header_files = 'HLLSafetyAirBag/Classes/HLLSafeCrash/HLLUSafeCrashManager.h'
  end

  s.frameworks = 'Foundation'
  
end
