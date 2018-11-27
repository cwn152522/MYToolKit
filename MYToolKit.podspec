#
#  Be sure to run `pod spec lint MYToolKit.podspec' to ensure this is a
#  valid spec and to remove all comments including this before submitting the spec.
#
#  To learn more about Podspec attributes see http://docs.cocoapods.org/specification.html
#  To see working Podspecs in the CocoaPods repo see https://github.com/CocoaPods/Specs/
#

Pod::Spec.new do |s|

  s.name         = "MYToolKit"
  s.platform     = :ios
  s.version      = "0.0.2"
  s.summary      = "这是一个工具库，主要放一些经常要用的工具类，比如链式实现的自动布局、xib约束适配、xib字体适配等"

  s.homepage     = "https://github.com/cwn152522/MYToolKit"

  s.license      = "MIT"

  s.author       = { "cwn" => "1014949353@qq.com" }
 
  s.source       = { :git => "https://github.com/cwn152522/MYToolKit.git", :tag => "#{s.version}" }

  s.source_files = "source_files/**/*.{h,m,swift}"
 
  s.frameworks   = "UIKit"

end
