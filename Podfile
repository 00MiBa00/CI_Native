source 'https://cdn.cocoapods.org/'
platform :ios, '13.0'

use_frameworks! :linkage => :static
use_modular_headers!

target 'ChickCare' do
  pod 'Firebase/Core'
  pod 'Firebase/Messaging'
  pod 'AppsFlyerFramework'

  target 'ImageNotificationServiceExt' do
    inherit! :search_paths
    pod 'Firebase/Core'
    pod 'Firebase/Messaging'
  end
end