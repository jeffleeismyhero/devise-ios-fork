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

```rb
pod 'Devise', '~> 0.1.0'
```

## Configuration

Use `#import <Devise/Devise.h>` whenever you want to use **devise-ios**.

`[DVSConfiguration sharedConfiguration]` is a singleton to keep configuration in one place. At the very beginning, somewhere in `application:didFinishLaunchingWithOptions:` in your `AppDelegate` use:

```objc
[[DVSConfiguration sharedConfiguration] setServerURL:<#NSURL#>];
```

 **devise-ios** is also able to inform you about encountered problems. Logging is especially useful during debug process. There are 3 designed log levels:

* `DVSLoggingModeNone` - Don't log anything, ignore all messages.
* `DVSLoggingModeWarning` - Print all messages using NSLog.
* `DVSLoggingModeAssert` - Abort the code with the message.

To specify logging mode use:

 ```objc
[[DVSConfiguration sharedConfiguration] setLoggingMode:<#DVSLoggingMode#>];
```

 **devise-ios** takes care about network problems and is able to automatically retries request in case of connection issues. You can specify number and time between retries using `numberOfRetries` and `retryTresholdDuration` properties of `DVSConfiguration`.

## User
The main class of **devise-ios** is `DVSUser`. Provided implementation is enough for login, registration, edition and any other feature offered by **devise-ios**. Nevertheless you can subclass `DVSUser` to customize it and change to fit your own purposes in easy way!

Functions are pretty straightforward and self-explanatory. If you wish to provide additional parameters for every request use `WithExtraParams:(DVSExtraParamsBlock)params` function counterpart:

* User registration:

    ```objc
    - (void)registerWithSuccess:(DVSVoidBlock)success failure:(DVSErrorBlock)failure;
    - (void)registerWithExtraParams:(DVSExtraParamsBlock)params success:(DVSVoidBlock)success failure:(DVSErrorBlock)failure;
    ```

* Profile update:

    ```objc
    - (void)updateWithSuccess:(DVSVoidBlock)success failure:(DVSErrorBlock)failure;
    - (void)updateWithExtraParams:(DVSExtraParamsBlock)params success:(DVSVoidBlock)success failure:(DVSErrorBlock)failure;
    ```

* Signing in:

    ```objc
    - (void)loginWithSuccess:(DVSVoidBlock)success failure:(DVSErrorBlock)failure;
    - (void)loginWithExtraParams:(DVSExtraParamsBlock)params success:(DVSVoidBlock)success failure:(DVSErrorBlock)failure;
    ```

* Password reminder:

    ```objc
    - (void)remindPasswordWithSuccess:(DVSVoidBlock)success failure:(DVSErrorBlock)failure;
    - (void)remindPasswordWithExtraParams:(DVSExtraParamsBlock)params success:(DVSVoidBlock)success failure:(DVSErrorBlock)failure;
    ```

* Password update:

    ```objc
    - (void)changePasswordWithNewPassword:(NSString *)newPassword success:(DVSVoidBlock)success failure:(DVSErrorBlock)failure;
    - (void)changePasswordWithNewPassword:(NSString *)newPassword extraParams:(DVSExtraParamsBlock)params success:(DVSVoidBlock)success failure:(DVSErrorBlock)failure;
    ```

* Account deleting:

    ```objc
    - (void)deleteAccountWithSuccess:(DVSVoidBlock)success failure:(DVSErrorBlock)failure;
    ```

Unless you've fallen in love with blocks yet, you can still pass additional parameters using regular methods:

* Single parameter:

    ```objc
    - (void)setObject:(id)object forKey:(NSString *)key action:(DVSActionType)actionType;
    ```

* Multiple parameters:

    ```objc
    - (void)setObjects:(NSDictionary *)objects forAction:(DVSActionType)actionType;
    ```

* or via `DVSUserDataSource` protocol you have to conform:

    ```objc
    - (NSDictionary *)additionalRequestParametersForAction:(DVSActionType)action;
    ```

## User customization

Although `DVSUser` implementation is enough for basic usage, you can customize it as well. The best way to adapt `DVSUser` class to own purposes is conform `DVSUserDataSource` protocol.

Changing default keys for built-in JSON fields can be achieved by:

```objc
- (NSString *)JSONKeyPathForEmail;
- (NSString *)JSONKeyPathForPassword;
- (NSString *)JSONKeyPathForPasswordConfirmation;
```

Defining own customize validation rules used when performing a specified action:

```objc
- (NSArray *)additionalValidationRulesForAction:(DVSActionType)action;
```

And what was mentioned earlier you can inject your own request parameters via method:

```objc
- (NSDictionary *)additionalRequestParametersForAction:(DVSActionType)action;
```

If it's needed to store locally more info about `DVSUser` subclass (other than `email`, `sessionToken` and `identifier` - these are stored by default) conform `DVSUserPersisting` protocol. You can choose which properties should be persist by invoking:
```objc
- (NSArray *)propertiesToPersistByName;
```
Just remember to pass property names as `NSString`.

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

```objc
- (NSArray *)additionalValidationRulesForAction:(DVSActionType)action {
    if (action == DVSActionRegistration) {
        return @[DVSValidate(@"registrationUsername").required().minLength(5).maxLength(20).tooShort(@"should has at least 4 signs.").tooLong(@"should has at most 20 signs").localizedPropertyName(@"Username")];
    }
    return nil;
}
```

When user will provide string `foo` for `registrationUsername` property, **devise-ios** will return an `NSError` with localized description:

```objc
NSLog(@"%@", error.localizedDescription);
// Username should has at least 4 characters.
```

Simple as that! For more conditions and messages take a look into `DVSPropertyValidator.h`

## UI Components

<p align="center">
  <img src="http://s7.postimg.org/donvunte3/0_sign_up.jpg" alt="Sign up view example" title="Sign up view example">
</p>

At some point in your app you might want to prepare quick setup for your users and allow them to log in and sign up. **devise-ios** provides a handy view controller, called `DVSAccountRetrieverViewController`, which simplifies that process. Here is simple example of usage:

```objc
DVSAccountRetrieverViewController *logInController = [[DVSAccountRetrieverViewController alloc] initWithType:DVSRetrieverTypeLogIn fields:DVSAccountRetrieverFieldEmailAndPassword | DVSAccountRetrieverFieldProceedButton];
logInController.delegate = self;
[self.navigationController pushViewController:logInController animated:YES];
```

Simple, right? As you can see initializer takes two parameters:`type` and `fields`. First one is defining how your view controller will act and look. If you want to perform log in action, you should pass `DVSRetrieverTypeLogIn`. Using it with `DVSAccountRetrieverViewController` will automatically configure proceed button title and tap event to perform log in request. For sign up action you can use `DVSRetrieverTypeSignUp` type.

`fields` is options parameter that defines which parts of view should be visible. For example, if you want to use simple form with only text fields and proceed button, you should define `fields` like:

```objc
DVSAccountRetrieverFields logInFields = DVSAccountRetrieverFieldEmailAndPassword | DVSAccountRetrieverFieldProceedButton;
```

And the result will be:

<p align="center">
  <img src="http://s7.postimg.org/fhqsizekr/1_log_in.jpg" alt="Log in view example" title="Log in view example">
</p>

If you want to add a password reminder to form, just use following combination:

```objc
DVSAccountRetrieverFields logInFields = DVSAccountRetrieverFieldEmailAndPassword | DVSAccountRetrieverFieldProceedButton | DVSAccountRetrieverFieldPasswordReminder;
```

Result:

<p align="center">
  <img src="http://s7.postimg.org/z9syi9q4r/2_log_in_with_reminder.jpg" alt="Log in view with reminder example" title="Log in view with reminder example">
</p>

In order to handle result of performed action, your class should override two `DVSAccountRetrieverViewControllerDelegate` protocol methods:

```objc
// for success 
- (void)accountRetrieverViewController:(DVSAccountRetrieverViewController *)controller didSuccessForAction:(DVSRetrieverAction)action user:(DVSUser *)user;

// for failure
- (void)accountRetrieverViewController:(DVSAccountRetrieverViewController *)controller didFailWithError:(NSError *)error forAction:(DVSRetrieverAction)action;
```

In both cases view controller will return `action` variable, that defines type of finished action and can have one of values: `DVSRetrieverActionLogIn`, `DVSRetrieverActionSignUp`, `DVSRetrieverActionPasswordRemind`. Success callback additionally will return corresponded user object saved in `user`.

`DVSAccountRetrieverViewController` doesn't implement autoclose feature. Developer is responsible to decide when close view. To help with this task, **devise-ios** provides additional callback in `DVSAccountRetrieverViewControllerDelegate` that is executed when user tapps dismiss button:

```objc
- (void)accountRetrieverViewControllerDidTapDismiss:(DVSAccountRetrieverViewController *)controller; 
```

## Demo
Implements full account [lifecycle](#Features). Contains also an example with simple `DVSUser` subclassing and validation. To run demo please follow the instructions below:

```bash
$ git clone --recursive git@github.com:netguru/devise-ios.git
$ pod install
```

or if you already cloned project without `--recursive`:

```bash
$ git submodule update --init --recursive
$ pod install
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
Copyright © 2014 [Netguru](https://netguru.co)
