Pod::Spec.new do |spec|

  spec.name         = 'MLSSDK'
  spec.version      = '1.3.9'
  spec.summary      = 'An SDK for MyCujoo Live Services to help build an amazing video experience'
  spec.description  = 'This SDK is intended for customers of MyCujoo Live Services. It offers a video player, overlays, analytics and more. It has an extension for IMA as well.'
  spec.homepage     = 'https://mls.mycujoo.tv'
  spec.license      = { :type => 'MIT', :file => 'LICENSE' }
  spec.author       = { 'Empower Sports B.V.' => '' }
  spec.ios.deployment_target = '11.0'
  spec.tvos.deployment_target = '11.0'

  spec.source        = { :git => 'https://github.com/mycujoo/mls-ios.git', :tag => spec.version }
  spec.default_subspec = 'Core'
  spec.swift_version = '5.0'
  spec.static_framework = true # needed because of Chromecast

  spec.subspec 'Core' do |ss|
    ss.source_files  = 'Sources/Core/App/**/*.swift', 'Sources/Core/Data/**/*.swift', 'Sources/Core/Domain/**/*.swift'
    ss.ios.resource_bundles = {
      'MLSResources' => ['Sources/Core/Resources/**/*.{strings}', 'Sources/Core/Resources/**/ios.xcassets', 'Sources/Core/Resources/fonts/*.ttf']
    }
    ss.tvos.resource_bundles = {
      'MLSResources' => ['Sources/Core/Resources/**/*.{strings}', 'Sources/Core/Resources/**/tvos.xcassets', 'Sources/Core/Resources/fonts/*.ttf']
    }
    ss.frameworks = 'Foundation', 'AVFoundation', 'UIKit'

    ss.dependency 'YouboraLib'
    ss.dependency 'YouboraAVPlayerAdapter'
    ss.dependency 'Alamofire', '~> 5.0'
    ss.dependency 'Moya', '~> 14.0'
  end

  spec.subspec 'IMA' do |ss|
    ss.ios.source_files = 'Sources/IMA/Shared/**/*.swift', 'Sources/IMA/iOS/**/*.swift'
    ss.tvos.source_files = 'Sources/IMA/Shared/**/*.swift', 'Sources/IMA/tvOS/**/*.swift'
    ss.frameworks = 'Foundation', 'AVFoundation', 'UIKit'

    ss.dependency 'MLSSDK/Core'
    ss.ios.dependency 'GoogleAds-IMA-iOS-SDK', '~> 3.14'
    ss.tvos.dependency 'GoogleAds-IMA-tvOS-SDK', '~> 4.2'
  end

  spec.subspec 'Cast' do |ss|
    ss.ios.source_files = 'Sources/Cast/**/*.swift'
    ss.frameworks = 'Foundation', 'AVFoundation', 'UIKit'

    ss.dependency 'MLSSDK/Core'
    ss.ios.dependency 'google-cast-sdk', '~> 4.5'

  end

  spec.subspec 'Annotations' do |ss|
    ss.ios.source_files = 'Sources/Annotations/Shared/**/*.swift', 'Sources/Annotations/iOS/**/*.swift'
    ss.tvos.source_files = 'Sources/Annotations/Shared/**/*.swift', 'Sources/Annotations/tvOS/**/*.swift'
    ss.frameworks = 'Foundation', 'AVFoundation', 'UIKit'

    ss.dependency 'MLSSDK/Core'
  end
end
