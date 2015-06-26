workspace 'CAAS'
xcodeproj 'CAAS.xcodeproj'
xcodeproj 'CAASExample.xcodeproj'
use_frameworks!


target :CAASExample do
platform :ios, '8.0'
pod 'Shimmer'
pod "MBProgressHUD"
xcodeproj 'CAASExample.xcodeproj'
end


target :CAASObjC do
platform :ios, '8.0'
xcodeproj 'CAASObjC.xcodeproj'
end

target :CAASObjCTests do
    platform :ios, '8.0'
    pod 'CAASObjC', :path => '.'
    xcodeproj 'CAASObjC.xcodeproj'
end
