Pod::Spec.new do |spec|

  spec.name         = "MLSSDK"
  spec.version      = "0.0.1"
  spec.summary      = "An SDK for MLS (MyCujoo Live Services) to help build an amazing video experience"
  spec.description  = "An SDK for MLS (MyCujoo Live Services) to help build an amazing video experience"
  spec.homepage     = "https://mls.mycujoo.tv"
  spec.license      = { :type => "MIT", :file => "LICENSE" }
  spec.author       = { "Maxim Smirnov" => "" }
  spec.ios.deployment_target = "11.0"
  spec.tvos.deployment_target = "11.0"
  spec.source       = { :git => "git@github.com:mycujoo/mls-ios.git", :tag => "#{spec.name}-#{spec.version}" }
  spec.source_files  = "Sources/**/*.swift"
  spec.ios.resource_bundles = {
    'MLSResources' => ["Resources/**/*.{xcassets,strings}"]
  }
  spec.tvos.resource_bundles = {
    'MLSResources' => ["Resources/**/*.{strings}"]
  }
  spec.frameworks = "Foundation", "AVFoundation", "UIKit"

  spec.dependency 'YouboraLib'
  spec.dependency 'YouboraAVPlayerAdapter'
  spec.dependency 'Alamofire', '~> 5.0'
  spec.dependency 'Moya', '~> 14.0'
  spec.dependency 'Starscream', '~> 4.0'

end
