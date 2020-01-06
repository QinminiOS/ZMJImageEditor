#
# Be sure to run `pod lib lint ZMJImageEditor.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'ZMJImageEditor'
  s.version          = '0.1.0'
  s.summary          = 'ZMJImageEditor is a component of image editing like WeChat'
  s.homepage         = 'https://github.com/qinminios/ZMJImageEditor'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'keshiim' => '11gmqin@gmail.com' }
  s.source           = { :git => 'https://github.com/qinminios/ZMJImageEditor.git', :tag => s.version.to_s }

  s.ios.deployment_target = '7.0'

  s.source_files = 'ZMJImageEditor/Classes/**/*'
  
   s.resource = [
     'ZMJImageEditor/Assets/*.png',
     'ZMJImageEditor/Assets/*.{xib,storyboard}',
     'ZMJImageEditor/Assets/*.{pdf,xcassets}',
     'ZMJImageEditor/Assets/*.{lproj}',
     'ZMJImageEditor/Assets/**/*.png',
     'ZMJImageEditor/Assets/**/*.{xib,storyboard}',
     'ZMJImageEditor/Assets/**/*.{pdf,xcassets}',
     'ZMJImageEditor/Assets/**/*.{strings}'
     ]

   s.frameworks = 'UIKit', 'MapKit'
   s.dependency 'YYCategories'
   s.dependency 'Masonry'
   s.dependency 'FrameAccessor'
   s.dependency  'XXNibBridge'
   s.dependency  'YYText'
   s.dependency  'YYWebImage'
   s.dependency  'extobjc'
end
