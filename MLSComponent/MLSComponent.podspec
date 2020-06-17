Pod::Spec.new do |spec|

  # ―――  Spec Metadata  ―――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
  spec.name         = "MLSComponent"
  spec.version      = "0.0.1"
  spec.summary      = "A short description of MLSComponent."

  # This description is used to generate tags and improve search results.
  spec.description  = "description"
  spec.homepage     = "http://EXAMPLE/MLSComponent"

  # ―――  Spec License  ――――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
  spec.license      = { :type => "MIT", :file => "FILE_LICENSE" }

  # ――― Author Metadata  ――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
  spec.author             = { "Maxim Smirnov" => "" }

  # ――― Platform Specifics ――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
  spec.ios.deployment_target = "11.0"
  spec.tvos.deployment_target = "11.0"


  # ――― Source Location ―――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
  spec.source       = { :git => "git@github.com:mycujoo/mls-ios.git", :tag => "#{spec.name}-#{spec.version}" }

  # ――― Source Code ―――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
  spec.source_files  = "MLSComponent/MLSComponent/Sources/**/*.swift"


  # ――― Project Settings ――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
  spec.dependency "YouboraLib"
  spec.dependency 'YouboraAVPlayerAdapter'

end
