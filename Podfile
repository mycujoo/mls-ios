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
end

target 'MLSComponent-tvOS' do
  platform :tvos, '11.0'
  project 'MLSComponent/MLSComponent.xcodeproj'
  pod 'YouboraLib'
  pod 'YouboraAVPlayerAdapter'
end

# // MARK: - Example projects

target 'MLS' do
  platform :ios, '11.0'
  #  pod 'YouboraLib'
  #  pod 'YouboraAVPlayerAdapter'
  pod 'MLSComponent', :path => 'MLSComponent'
end

target 'MLS-tvOS' do
  platform :tvos, '11.0'
#  pod 'YouboraLib'
#  pod 'YouboraAVPlayerAdapter'
  pod 'MLSComponent', :path => 'MLSComponent'
end
