//
//  UserModel.h
//  Protocol
//
//  Created by Josh Holtz on 6/6/13.
//  Copyright (c) 2013 Josh Holtz. All rights reserved.
//

#import "ProtocolModel.h"

@interface UserModel : ProtocolModel

@property (nonatomic, strong) NSNumber *userId;
@property (nonatomic, strong) NSString *firstName;
@property (nonatomic, strong) NSString *lastName;
@property (nonatomic, strong) NSDate *birthday;
@property (nonatomic, strong) UserModel *bestFriend;
@property (nonatomic, strong) NSArray *friends;


@end
