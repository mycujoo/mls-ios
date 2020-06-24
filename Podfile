use_frameworks!
inhibit_all_warnings!
source 'https://cdn.cocoapods.org/'
workspace 'MLS'
use_frameworks!

# // MARK: - Frameworks

target 'MLSComponent-iOS' do
  platform :ios, '11.0'
  project 'MLSComponent/MLSComponent.xcodeproj'
  pod 'YouboraLib'
  pod 'YouboraAVPlayerAdapter'
  pod 'Moya', '~> 14.0'
end

target 'MLSComponent-tvOS' do
  platform :tvos, '11.0'
  project 'MLSComponent/MLSComponent.xcodeproj'
  pod 'YouboraLib'
  pod 'YouboraAVPlayerAdapter'
  pod 'Moya', '~> 14.0'
end

# // MARK: - Example projects

target 'MLS' do
  platform :ios, '11.0'
  pod 'MLSComponent', :path => 'MLSComponent'
end

target 'MLS-tvOS' do
  platform :tvos, '11.0'
  pod 'MLSComponent', :path => 'MLSComponent'
end
