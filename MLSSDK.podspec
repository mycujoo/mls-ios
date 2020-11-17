Pod::Spec.new do |spec|

  spec.name         = "MLSSDK"
  spec.version      = "1.1.4"
  spec.summary      = "An SDK for MyCujoo Live Services to help build an amazing video experience"
  spec.description  = "This SDK is intended for customers of MyCujoo Live Services. It offers a video player, overlays, analytics and more."
  spec.homepage     = "https://mls.mycujoo.tv"
  spec.license      = { :type => "MIT", :file => "LICENSE" }
  spec.author       = { "Mats ten Bohmer" => "" }
  spec.ios.deployment_target = "11.0"
  spec.tvos.deployment_target = "11.0"

  spec.source        = { :git => 'https://github.com/mycujoo/mls-ios.git', :tag => spec.version }
  spec.source_files  = "Sources/App/**/*.swift", "Sources/Data/**/*.swift", "Sources/Domain/**/*.swift"
  spec.ios.resource_bundles = {
    'MLSResources' => ["Sources/Resources/**/*.{strings}", "Sources/Resources/**/ios.xcassets"]
  }
  spec.tvos.resource_bundles = {
    'MLSResources' => ["Sources/Resources/**/*.{strings}", "Sources/Resources/**/tvos.xcassets"]
  }
  spec.frameworks = "Foundation", "AVFoundation", "UIKit"
  spec.swift_version = '5.0'

  spec.dependency 'YouboraLib'
  spec.dependency 'YouboraAVPlayerAdapter'
  spec.dependency 'Alamofire', '~> 5.0'
  spec.dependency 'Moya', '~> 14.0'
  spec.dependency 'Starscream', '~> 3.1'

end
