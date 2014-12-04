#
#  SaasKit.podspec
#
#  Copyright (c) 2014 Netguru Sp. z o.o. All rights reserved.
#

Pod::Spec.new do |spec|

  spec.name          = 'Devise'
  spec.summary       = 'Simple Devise client for iOS'

  spec.homepage      = 'https://github.com/netguru/saaskit'
  spec.license       = { :type => 'MIT', :file => 'LICENSE.md' }

  spec.authors       = { 'Patryk Kaczmarek' => 'patryk.kaczmarek@netguru.pl' }

  spec.version       = '0.1.0'
  spec.source        = { :git => 'https://github.com/netguru/saaskit.git', :tag => spec.version.to_s }
  spec.platform      = :ios, '7.1'

  spec.source_files  = 'Devise/**/*.{h,m}'
  spec.requires_arc  = true

  spec.dependency      'AFNetworking', '~> 2.5.0'
  spec.dependency      'SSKeychain', '~> 1.2.2'

  spec.framework     = 'Security'

end
