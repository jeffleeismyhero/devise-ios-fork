# devise-ios

[![Build Status](https://travis-ci.org/netguru/devise-ios.svg?branch=master)](https://travis-ci.org/netguru/devise-ios)

**devise-ios** is a simple client which automates connection with [Devise](https://github.com/plataformatec/devise). Specially created to work with [devise-ios backend gem](https://github.com/netguru/devise-ios-rails) to make your job easier and faster!

## Features:
**devise-ios** handles:
* user registration
* signing in / out
* password reminder
* form validation
* profile updating
* account deleting

## Requirements

- Xcode 6.0 and iOS 7.0+ SDK
- CocoaPods 0.35.0 (use `gem install cocoapods` to grab it!)

## CocoaPods

[CocoaPods](http://cocoapods.org) is a dependency manager for Objective-C, which automates and simplifies the process of using 3rd-party. To use **devise-ios** via CocoaPods write in your Podfile:

```ruby
pod "Devise", "~> 0.1.0"
```

## Configuration
Use `#import "Devise.h"` whenever you want to use **devise-ios**.

`[DVSConfiguration sharedConfiguration]` is a `sharedInstance` to keep configuration in one place. At the very beginning, somewhere in `application:didFinishLaunchingWithOptions:` in your `AppDelegate` use:
```objective-c
[[DVSConfiguration sharedConfiguration] setServerURL:<#NSURL#>];
```

 **devise-ios** is also able to inform you about encountered problems. Logging is especially useful during debug process. There are 3 designed log levels:
 * `DVSLogLevelNone` - Don't log anything, ignore all messages.
 * `DVSLogLevelWarning` - Print all messages using NSLog.
 * `DVSLogLevelAssert` - Abort the code with the message.

To specify log level use:
 ```objective-c
[[DVSConfiguration sharedConfiguration] setLogLevel:<#DVSLogLevell#>];
```

 **devise-ios** takes care about network problems and is able to automatically retries request in case of connection issues. You can specify number and time between retries using `numberOfRetries` and `retryTresholdDuration` properties of `DVSConfiguration`.

Although **devise-ios** has default paths that fits [devise-ios backend gem](https://github.com/netguru/devise-ios-rails), you can customize them by your own by calling:
 ```objective-c
- (void)setPath:(NSString *)path forRoute:(DVSRoute)route;
```

## User
The main class of **devise-ios** is `DVSUser`. Provided implementation is enough for login, registration, edition and any other feature offered by **devise-ios**. Nevertheless you can subclass `DVSUser` to customize it and change to fit your own purposes in easy way!

Functions are pretty straightforward and self-explanatory. If you wish to provide additional parameters for every request use `WithExtraParams:(DVSExtraParamsBlock)params` function counterpart:
* User registration:
```objective-c
- (void)registerWithSuccess:(DVSVoidBlock)success failure:(DVSErrorBlock)failure;
- (void)registerWithExtraParams:(DVSExtraParamsBlock)params success:(DVSVoidBlock)success failure:(DVSErrorBlock)failure;
```
* Profile update:
```objective-c
- (void)updateWithSuccess:(DVSVoidBlock)success failure:(DVSErrorBlock)failure;
- (void)updateWithExtraParams:(DVSExtraParamsBlock)params success:(DVSVoidBlock)success failure:(DVSErrorBlock)failure;
```
* Signing in:
```objective-c
- (void)loginWithSuccess:(DVSVoidBlock)success failure:(DVSErrorBlock)failure;
- (void)loginWithExtraParams:(DVSExtraParamsBlock)params success:(DVSVoidBlock)success failure:(DVSErrorBlock)failure;
```
* Password reminder:
```objective-c
- (void)remindPasswordWithSuccess:(DVSVoidBlock)success failure:(DVSErrorBlock)failure;
- (void)remindPasswordWithExtraParams:(DVSExtraParamsBlock)params success:(DVSVoidBlock)success failure:(DVSErrorBlock)failure;
```
* Password update:
```objective-c
- (void)changePasswordWithNewPassword:(NSString *)newPassword success:(DVSVoidBlock)success failure:(DVSErrorBlock)failure;
- (void)changePasswordWithNewPassword:(NSString *)newPassword extraParams:(DVSExtraParamsBlock)params success:(DVSVoidBlock)success failure:(DVSErrorBlock)failure;
```
* Account deleting:
```objective-c
- (void)deleteAccountWithSuccess:(DVSVoidBlock)success failure:(DVSErrorBlock)failure;
```

Unless you've fallen in love with blocks yet, you can still pass additional parameters using regular methods:
* Single parameter:
```objective-c
- (void)setObject:(id)object forKey:(NSString *)key action:(DVSActionType)actionType;
```
*  Multiple parameters:
```objective-c
- (void)setObjects:(NSDictionary *)objects forAction:(DVSActionType)actionType;
```
* or via `DVSUserDataSource` protocol you have to conform:
```objective-c
- (NSDictionary *)additionalRequestParametersForAction:(DVSActionType)action;
```
## User customization
Although `DVSUser` implementation is enough for basic usage, you can customize it as well. The best way to adapt `DVSUser` class to own purposes is conform `DVSUserDataSource` protocol.

Changing default keys for built-in JSON fields can be achieved by:
```objective-c
- (NSString *)JSONKeyPathForEmail;
- (NSString *)JSONKeyPathForPassword;
- (NSString *)JSONKeyPathForPasswordConfirmation;
```

Defining own customize validation rules used when performing a specified action:
```objective-c
- (NSArray *)additionalValidationRulesForAction:(DVSActionType)action;
```
And what was mentioned earlier you can inject your own request parameters via method:
```objective-c
- (NSDictionary *)additionalRequestParametersForAction:(DVSActionType)action;
```

## User model validation and messaging
**devise-ios** deliver also simply validation wrapper for your purposes. If you wish to use it, conform `DVSUserDataSource` protocol and implement `additionalValidationRulesForAction:` method.

Lets say subclass of `DVSUser` has additional property `NSString *registrationUsername` you want to validate during registration process to fulfill conditions:
* cannot be nil
* length should be at least 4 signs
* length should be at most 20 signs

and display appropriate messages when validation fail:

* when has less than 4 signs: "should has at least 4 signs"
* when has more than 20 signs: "should has at most 20 signs"

Moreover `registrationUsername` doesn't sound very well for user, so it should be displayed as "Username":
```objective-c
- (NSArray *)additionalValidationRulesForAction:(DVSActionType)action {
    if (action == DVSActionRegistration) {
        return @[DVSValidate(@"registrationUsername").required().minLength(5).maxLength(20).tooShort(@"should has at least 4 signs.").tooLong(@"should has at most 20 signs").localizedPropertyName(@"Username")];
    }
    return nil;
}
```

When user will provide string `foo` for `registrationUsername` property, **devise-ios** will return an `NSError` with localized description:
```objective-c
NSLog(@"%@", error.localizedDescription);
>>> Username should has at least 4 characters.
```
Simple as that! For more conditions and messages take a look into `DVSPropertyValidator.h`

## Demo
Implements full account [lifecycle](#Features). Contains also an example with simple `DVSUser` subclassing and validation. To run demo please follow the instructions below:
```ruby
git clone --recursive git@github.com:netguru/devise-ios.git
pod install
```
or if you already cloned project without `--recursive`:
```ruby
git submodule update --init --recursive
pod install
```

## License
**devise-ios** is available under the [MIT license](https://github.com/netguru/devise-ios/blob/master/LICENSE.md).

## Contribution
First, thank you for contributing!

Here a few guidelines to follow:

- we follow [Ray Wenderlich Style Guide](https://github.com/raywenderlich/objective-c-style-guide).
- write tests
- make sure the entire test suite passes

## More Info

Have a question? Please [open an issue](https://github.com/netguru/devise-ios/issues/new)!

##
Copyright  2014 © [Netguru](https://netguru.co)
