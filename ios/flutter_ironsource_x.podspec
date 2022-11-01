#
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html.
# Run `pod lib lint flutter_ironsource_x.podspec' to validate before publishing.
#
Pod::Spec.new do |s|
  s.name             = 'flutter_ironsource_x'
  s.version          = '0.0.1'
  s.summary          = 'IronSource Ads & Mediation Plugin for Flutter'
  s.description      = <<-DESC
IronSource Ads & Mediation Plugin for Flutter
                       DESC
  s.homepage         = 'http://example.com'
  s.license          = { :file => '../LICENSE' }
  s.author           = { 'Your Company' => 'email@example.com' }
  s.source           = { :path => '.' }
  s.source_files = 'Classes/**/*'
  s.public_header_files = 'Classes/**/*.h'
  s.dependency 'Flutter'
  s.dependency 'IronSourceSDK', '7.2.0.0'
  s.dependency 'IronSourceAdColonyAdapter','4.3.12.3'
  s.dependency 'IronSourceAdMobAdapter','4.3.30.1'
  s.dependency 'IronSourceAppLovinAdapter','4.3.29.3'
  s.dependency 'IronSourceInMobiAdapter','4.3.13.3'
  s.dependency 'IronSourceMyTargetAdapter','4.1.12.1'
  s.dependency 'IronSourcePangleAdapter','4.3.11.1'
  s.dependency 'IronSourceUnityAdsAdapter','4.3.19.1'
  s.dependency 'IronSourceVungleAdapter','4.3.18.1'
  s.dependency 'IronSourceFacebookAdapter','4.3.33.3'

  s.static_framework = true

  s.platform = :ios, '9.0'
    s.user_target_xcconfig = { 'CLANG_ALLOW_NON_MODULAR_INCLUDES_IN_FRAMEWORK_MODULES' => 'YES' }

  # Flutter.framework does not contain a i386 slice.
  s.pod_target_xcconfig = { 'DEFINES_MODULE' => 'YES', 'VALID_ARCHS[sdk=iphonesimulator*]' => 'x86_64', 'CLANG_ALLOW_NON_MODULAR_INCLUDES_IN_FRAMEWORK_MODULES' => 'YES',}
  s.swift_version = '5.0'
end
