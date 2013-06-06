# Protocol - Model Mapping Library for iOS
Protocol is a model mapping library that takes in a JSON string, NSDictionary, or NSArray, and maps it to ProtocolModel objects.

##Benefits
- Map models within models
- Define custom functions for to be performed on values before mapping (ex: parse a NSString into an NSDate)

### How to user a mapping
```objc
// Maps an NSDictionary to a UserModel
UserModel *user = [UserModel protocolModelWithDictionary:@{
             @"id" : @1,
             @"first_name" : @"Josh",
             @"last_name" : @"Holtz"
             }];
             
NSLog(@"User.userId - %@", user.userId);
NSLog(@"User.firstName - %@", user.firstName);
NSLog(@"User.lastName - %@", user.lastName);

```

### Define mapping - UserMode.h
```objc
#import "ProtocolModel.h"

@interface UserModel : ProtocolModel

@property (nonatomic, strong) NSNumber *userId;
@property (nonatomic, strong) NSString *firstName;
@property (nonatomic, strong) NSString *lastName;

@end

```

### Define mapping - UserModel.m
```objc
#import "UserModel.h"

@implementation UserModel

- (NSDictionary *)mapKeysToProperties {
    return [[NSDictionary alloc] initWithObjectsAndKeys:
            @"userId",@"id",
            @"firstName",@"first_name",
            @"lastName",@"last_name"
            nil];
}

@end

```
