# Vines Cloud iOS API

Vines Cloud exposes pubsub message channels and key/value data storage to mobile applications via a RESTful HTTP API and XMPP. This Objective-C library is a thin wrapper over those protocols to access your cloud account from iPhone and iPad apps.

Additional documentation can be found at [www.getvines.com](http://www.getvines.com/).

## Usage

This is a quick overview of the methods available in the API. See the examples/ directory
for working demos.

## Authenticate

```objectivec
// replace with your account details
NSString *domain = @"wonderland.getvines.com";
NSString *username = @"alice@wonderland.getvines.com";
NSString *password = @"password";

VinesCloud *vines = [[VinesCloud alloc] initWithDomain:domain];
[vines authenticateWithUsername:username password:password callback:^(NSMutableDictionary *user, VCError *error) {
    if (error) {
        NSLog(@"user: authentication failed %@", error);
        return;   
    }
    // user, storage, and channel calls . . .
}];
```

## User Management

```objectivec
[vines.users count:^(NSNumber *count, VCError *error) {
    NSLog(@"user: count %@", count);
}];

NSString *username = [NSString stringWithFormat:@"hatter@%@", vines.domain];
NSMutableDictionary *signup = [NSMutableDictionary dictionaryWithObjectsAndKeys:username, @"id", @"passw0rd", @"password", nil];
[vines.users save:signup callback:^(NSMutableDictionary *result, VCError *error) {
    if (error) {
        NSLog(@"user: save failed %@", error);
    } else {
        NSLog(@"user: save succeeded %@", result);
    }
}];
```

## Dependencies

This library requires Xcode 4.2 and iOS 5.0 or better.

## Contact

* David Graham <david@negativecode.com>

## License

Released under the MIT license. Check the LICENSE file for details.

