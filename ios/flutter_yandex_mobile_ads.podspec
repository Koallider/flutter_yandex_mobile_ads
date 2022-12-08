#
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html.
# Run `pod lib lint flutter_yandex_mobile_ads.podspec' to validate before publishing.
#
Pod::Spec.new do |s|
  s.name             = 'flutter_yandex_mobile_ads'
  s.version          = '0.0.5'
  s.summary          = 'Yandex Mobile Ads SDK for Flutter'
  s.description      = <<-DESC
Yandex Ads & Mediation Plugin for Flutter
                       DESC
  s.homepage         = 'https://github.com/Koallider/flutter_yandex_mobile_ads'
  s.license          = { :file => '../LICENSE' }
  s.author           = { 'Koallider' => 'https://github.com/Koallider/' }
  s.source           = { :path => '.' }
  s.source_files = 'Classes/**/*'
  s.public_header_files = 'Classes/**/*.h'
  s.dependency 'Flutter'
  s.dependency 'YandexMobileAds', '5.2.1'

  s.static_framework = true

  s.platform = :ios, '9.0'
    s.user_target_xcconfig = { 'CLANG_ALLOW_NON_MODULAR_INCLUDES_IN_FRAMEWORK_MODULES' => 'YES' }

  # Flutter.framework does not contain a i386 slice.
  s.pod_target_xcconfig = { 'DEFINES_MODULE' => 'YES', 'VALID_ARCHS[sdk=iphonesimulator*]' => 'x86_64', 'CLANG_ALLOW_NON_MODULAR_INCLUDES_IN_FRAMEWORK_MODULES' => 'YES',}
  s.swift_version = '5.0'
end
