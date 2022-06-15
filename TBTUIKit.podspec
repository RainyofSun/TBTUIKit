#
# Be sure to run `pod lib lint TBTUIKit.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'TBTUIKit'
  s.version          = '0.1.4'
  s.summary          = 'TBTUIKit '

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
TODO: Add long description of the pod here.
                       DESC

  s.homepage         = 'https://github.com/RainyofSun/TBTUIKit'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'RainyofSun' => '807602063@qq.com' }
  s.source           = { :git => 'https://github.com/RainyofSun/TBTUIKit.git', :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.ios.deployment_target = '10.0'

  # ------------------- 文件分级 --------------------- #
  s.subspec 'UITool' do |ss|
    ss.source_files = 'TBTUIKit/Classes/UITool/*.{h,m}'
  end

  s.subspec 'BaseClass' do |ss|
    ss.source_files = 'TBTUIKit/Classes/BaseClass/*.{h,m}'
    ss.dependency 'TBTUIKit/UITool'
    ss.dependency 'TBTUIKit/MacroHeader'
    ss.dependency 'TBTUIKit/Category'
  end
  
  s.subspec 'Category' do |ss|
    ss.source_files = 'TBTUIKit/Classes/Category/*.{h,m}'
    ss.dependency 'TBTUIKit/MacroHeader'
  end
  
  s.subspec 'MacroHeader' do |ss|
    ss.source_files = 'TBTUIKit/Classes/MacroHeader/*.{h}'
  end
  
  s.subspec 'Widget' do |ss|
    ss.source_files = 'TBTUIKit/Classes/Widget/*.{h,m}'
    ss.dependency 'TBTUIKit/MacroHeader'
    ss.dependency 'TBTUIKit/Category'
    ss.dependency 'TBTUIKit/BaseClass'
  end
  
  # s.resource_bundles = {
  #   'TBTUIKit' => ['TBTUIKit/Assets/*.png']
  # }

  # s.public_header_files = 'Pod/Classes/**/*.h'
  # s.frameworks = 'UIKit', 'MapKit'
#   s.dependency 'RegexKitLite', '4.0'
end

