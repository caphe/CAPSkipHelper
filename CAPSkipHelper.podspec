#
#  Be sure to run `pod spec lint CAPSkipHelper.podspec' to ensure this is a
#  valid spec and to remove all comments including this before submitting the spec.
#
#  To learn more about Podspec attributes see http://docs.cocoapods.org/specification.html
#  To see working Podspecs in the CocoaPods repo see https://github.com/CocoaPods/Specs/
#

Pod::Spec.new do |s|
  s.name             = 'CAPSkipHelper'
  s.version          = '1.2'
  s.summary          = 'A short description of CAPSkipHelper'
  s.description      = <<-DESC'A long long long long description of CAPSkipHelper'
DESC

  s.homepage     = "https://github.com/yoimhere"
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'Hekaiping' => 'hk631819952@126.com' }
  s.source           = {:git => 'https://github.com/caphe/CAPSkipHelper.git', :tag => s.version.to_s }
  s.ios.deployment_target = '8.0'
  s.source_files = 'SkipHelper/**/*'
#s.resource_bundles = {
# 'SkipHelper' => ['SkipHelper/Resource/*.{storyboard,xib,xcassets,json,imageset,png}']
# }
  s.resources = "SkipHelper/Resource/*.png"

  s.dependency 'SDWebImage'
end

