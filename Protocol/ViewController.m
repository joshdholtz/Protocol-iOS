//
//  ViewController.m
//  Protocol
//
//  Created by Josh Holtz on 5/20/13.
//  Copyright (c) 2013 Josh Holtz. All rights reserved.
//

#import "ViewController.h"

#import "ProtocolModel.h"
#import "UserModel.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Creates custom formatting function to convert a string date to a NSDate object
    [ProtocolModel registerFormatBlock:^id(NSString *jsonValue) {
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"en_US_POSIX"]];
        [dateFormatter setDateFormat:@"yyyy-MM-dd"];
        
        NSDate *date = nil;
        NSError *error = nil;
        if (![dateFormatter getObjectValue:&date forString:jsonValue range:nil error:&error]) {
            NSLog(@"Date '%@' could not be parsed: %@", jsonValue, error);
        }
        
        return date;
    } forKey:@"Date"];
    
    // Maps a dictionary to a UserModel
    // UserModel has an NSDate for birthday that gets formatted with a custom function
    // UserModel has a best friend property and friends property that get mapped to more user models
    UserModel *user = [UserModel protocolModelWithDictionary:[self generateMockResponse1]];
    NSLog(@"----------------------------------------------------------");
    NSLog(@"Maps dictionary to UserModel");
    NSLog(@"----------------------------------------------------------");
    NSLog(@"User.userId - %@", user.userId);
    NSLog(@"User.firstName - %@", user.firstName);
    NSLog(@"User.lastName - %@", user.lastName);
    NSLog(@"User.birthday - %@", user.birthday);
    NSLog(@"User.bestFriend - %@", user.bestFriend.firstName);
    NSLog(@"User.friends.count - %d", [user.friends count]);
    
    NSLog(@"\n");
    NSLog(@"\n");
    NSLog(@"----------------------------------------------------------");
    NSLog(@"Maps array of dictionaries to an NSArray of UserModel");
    NSLog(@"----------------------------------------------------------");
    NSArray *users = [UserModel protocolModelWithArray:[self generateMockResponse3]];
    for (UserModel *user in users) {
        NSLog(@"User.userId - %@", user.userId);
        NSLog(@"User.firstName - %@", user.firstName);
        NSLog(@"User.lastName - %@", user.lastName);
        NSLog(@"User.birthday - %@", user.birthday);
        NSLog(@"User.bestFriend - %@", user.bestFriend.firstName);
        NSLog(@"User.friends.count - %d", [user.friends count]);
        NSLog(@"\n");
    }
	
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    
}

#pragma mark - Generates examples response

- (NSDictionary*)generateMockResponse1 {
    return @{
             @"id" : @1,
             @"first_name" : @"Josh",
             @"last_name" : @"Holtz",
             @"birthday" : @"1989-01-01",
             @"best_friend" : [self generateMockResponse2],
             @"friends":[self generateMockResponse3]
             };
}

- (NSDictionary*)generateMockResponse2 {
    return @{
             @"id" : @5,
             @"first_name" : @"Josh5",
             @"last_name" : @"Holtz5",
             @"birthday" : @"1989-01-01",
             };
}

- (NSArray*)generateMockResponse3 {
    return @[
             @{
                 @"id" : @2,
                 @"first_name" : @"Josh2",
                 @"last_name" : @"Holtz2",
                 @"birthday" : @"1989-01-01",
                 @"friends":@[]
                 },
             @{
                 @"id" : @3,
                 @"first_name" : @"Josh3",
                 @"last_name" : @"Holtz3",
                 @"birthday" : @"1989-01-01",
                 @"friends":@[]
                 },
             @{
                 @"id" : @4,
                 @"first_name" : @"Josh4",
                 @"last_name" : @"Holtz4",
                 @"birthday" : @"1989-01-01",
                 @"friends":@[]
                 }
             ];
}

@end
