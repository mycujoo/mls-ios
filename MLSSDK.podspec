Pod::Spec.new do |spec|

  spec.name         = 'MLSSDK'
  spec.version      = '1.1.8'
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
    ss.dependency 'Starscream', '~> 3.1'
  end

  spec.subspec 'IMA-iOS' do |ss|
    ss.source_files  = 'Sources/IMA/iOS/**/*.swift'
    ss.frameworks = 'Foundation', 'AVFoundation', 'UIKit'

    ss.ios.dependency 'MLSSDK/Core'
    ss.ios.dependency 'GoogleAds-IMA-iOS-SDK', '~> 3.13'
  end

  spec.subspec 'IMA-tvOS' do |ss|
    ss.source_files  = 'Sources/IMA/tvOS/**/*.swift'
    ss.frameworks = 'Foundation', 'AVFoundation', 'UIKit'

    ss.tvos.dependency 'MLSSDK/Core'
    ss.tvos.dependency 'GoogleAds-IMA-tvOS-SDK', '~> 4.2'
  end
end
