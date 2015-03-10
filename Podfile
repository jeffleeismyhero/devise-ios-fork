#
#  Podfile
#
#  Copyright (c) 2014 Netguru Sp. z o.o. All rights reserved.
#

# Pod sources
source 'https://github.com/CocoaPods/Specs.git'

# Initial configuration
platform :ios, '8.0'
inhibit_all_warnings!

# Framework dependencies
pod 'AFNetworking', '~> 2.5'
pod 'UICKeyChainStore', '~> 1.1'
pod 'XLForm', '~> 2.1'
pod 'NGRValidator', '~> 0.4.2'
pod 'googleplus-ios-sdk', '~> 1.7.1'

post_install do |installer_representation|
  installer_representation.project.targets.each do |target|
    if target.name == 'Devise'
      config.build_settings["FRAMEWORK_SEARCH_PATHS"] = ["$(PROJECT_DIR)/", "$(PROJECT_DIR)/Pods/**"]
    end
  end
end

# Exclusive demo dependencies
target 'Demo' do
  link_with 'Devise Demo'
end

# Unit tests exclusive dependencies
target 'Tests' do
  link_with 'Devise Tests', 'Devise Demo Tests'

  pod 'Kiwi', '~> 2.3'
  pod 'OHHTTPStubs', '~> 3.1'
  pod 'KIF-Kiwi', '~> 0.2'
  pod 'OCMockito', '~> 1.4.0'
end
