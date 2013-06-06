//
//  UserModel.m
//  Protocol
//
//  Created by Josh Holtz on 6/6/13.
//  Copyright (c) 2013 Josh Holtz. All rights reserved.
//

#import "UserModel.h"

@implementation UserModel

- (NSDictionary *)mapKeysToProperties {
    return [[NSDictionary alloc] initWithObjectsAndKeys:
            @"userId",@"id",
            @"firstName",@"first_name",
            @"lastName",@"last_name",
            @"Date:birthday",@"birthday",
            @"UserModel.bestFriend",@"best_friend",
            @"UserModel.friends",@"friends",
            
            nil];
}

@end
