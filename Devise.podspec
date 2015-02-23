#
#  Devise.podspec
#
#  Copyright (c) 2014 Netguru Sp. z o.o. All rights reserved.
#

Pod::Spec.new do |spec|

  spec.name          = 'Devise'
  spec.summary       = 'Simple Devise client for iOS'

  spec.homepage      = 'https://github.com/netguru/devise-ios'
  spec.license       = { :type => 'MIT', :file => 'LICENSE.md' }

  spec.authors       = { 'Patryk Kaczmarek' => 'patryk.kaczmarek@netguru.pl',
                         'Adrian Kashivskyy' => 'adrian.kashivskyy@netguru.pl',
                         'Wojciech Trzasko' => 'wojciech.trzasko@netguru.pl'}

  spec.version       = '0.1.2'
  spec.source        = { :git => 'https://github.com/netguru/devise-ios.git', :tag => spec.version.to_s }
  spec.platform      = :ios, '7.0'

  spec.source_files  = 'Devise/**/*.{h,m}'
  spec.requires_arc  = true

  spec.dependency      'AFNetworking', '~> 2.5.0'
  spec.dependency      'UICKeyChainStore', '~> 1.1'
  spec.dependency      'ngrvalidator', '~> 0.3.0'
  spec.dependency      'XLForm', '~> 2.1'

  spec.private_header_files = 'Devise/**/*Private.h'

end
