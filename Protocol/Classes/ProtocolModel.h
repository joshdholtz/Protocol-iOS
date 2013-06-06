//
//  ProtocolModel.h
//  Gigabites
//
//  Created by Josh Holtz on 2/5/13.
//  Copyright (c) 2013 RokkinCat. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ProtocolModel : NSObject

+ (void)registerFormatBlock:(id(^)(NSString *jsonValue))block forKey:(NSString*)key;

+ (NSArray*)protocolModelWithArray:(NSArray*)array;
+ (id)protocolModelWithDictionary:(NSDictionary*)dict;
+ (id)protocolModelWithString:(NSString*)string;

- (id)initWithDictionary:(NSDictionary*)dict;

- (void)setWithString:(NSString*)string;
- (void)setWithDictionary:(NSDictionary*)dict;

@end
