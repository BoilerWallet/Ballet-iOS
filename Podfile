# Uncomment the next line to define a global platform for your project
# platform :ios, '9.0'

target 'Ballet' do
  # Comment the next line if you're not using Swift and don't want to use dynamic frameworks
  use_frameworks!

  # Pods for Ballet

  # Hot functional shit
  #pod 'Runes', '~> 4.1'
  #pod 'Curry', '~> 4.0'

  # Material
  #pod 'Material'

  # Official Material components
  pod 'MaterialComponents/Cards', '~> 112.0'
  pod 'MaterialComponents/Buttons', '~> 112.0'
  pod 'MaterialComponents/Snackbar', '~> 112.0'
  pod 'MaterialComponents/Slider', '~> 112.0'
  pod 'MaterialComponents/Dialogs', '~> 112.0'
  pod 'MaterialComponents/Ink', '~> 112.0'
  pod 'MaterialComponents/BottomSheet', '~> 112.0'
  pod 'MaterialComponents/BottomNavigation', '~> 112.0'

  #pod 'Down'

  # Lottie animations
  #pod 'lottie-ios', '~> 2.5'

  # Dropdown
  pod 'DropDown', '~> 2.3'

  # MarqueeLabel
  #pod 'MarqueeLabel', '~> 3.1'

  # Keyboard avoiding
  #pod 'TPKeyboardAvoiding', '~> 1.3'

  # Cartography
  #pod 'Cartography', '~> 3.0'

  # Networking
  #pod 'Alamofire', '~> 4.6'

  # Image
  #pod 'AlamofireImage', '~> 3.3'

  # Database
  #pod 'RealmSwift', '~> 3.0'

  # DateTools
  pod 'DateToolsSwift', '~> 4.0'

  # BlockiesSwift
  pod 'BlockiesSwift', '~> 0.1'

  # Web3
  #pod 'Web3', '~> 0.3'
  #pod 'Web3/PromiseKit', '~> 0.3'
  #pod 'Web3/ContractABI', '~> 0.3'
  #pod 'Keystore', '~> 0.1'

  # PromiseKit
  #pod 'PromiseKit', '~> 6.0'

  # Fabric
  pod 'Fabric'
  pod 'Crashlytics'

  target 'BalletTests' do
    inherit! :search_paths
    # Pods for testing

    pod 'Quick', '~> 1.2'
    pod 'Nimble', '~> 7.0'
  end

  target 'BalletUITests' do
    inherit! :search_paths
    # Pods for testing
  end
end

# Workaround for Cocoapods issue #7606
post_install do |installer|
    installer.pods_project.build_configurations.each do |config|
        config.build_settings.delete('CODE_SIGNING_ALLOWED')
        config.build_settings.delete('CODE_SIGNING_REQUIRED')
    end
end
