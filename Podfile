source 'https://cdn.cocoapods.org/'
platform :ios, '14.0'

use_frameworks! :linkage => :static
use_modular_headers!

target 'ChickCare' do
  # Firebase
  pod 'FirebaseAnalytics'
  pod 'FirebaseMessaging'
  pod 'FirebaseCore'
  pod 'GoogleUtilities'

  # AppsFlyer
  pod 'AppsFlyerFramework'

  target 'ImageNotificationServiceExt' do
    inherit! :search_paths
    pod 'FirebaseMessaging'
  end
end
