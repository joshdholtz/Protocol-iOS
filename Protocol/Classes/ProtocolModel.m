//
//  ProtocolModel.m
//  Gigabites
//
//  Created by Josh Holtz on 2/5/13.
//  Copyright (c) 2013 RokkinCat. All rights reserved.
//

#import "ProtocolModel.h"

@interface ProtocolModel()

+ (id)sharedInstance;

@property (nonatomic, strong) NSMutableDictionary *formatBlocks;

@end

@implementation ProtocolModel

static ProtocolModel *sharedInstance = nil;

@synthesize formatBlocks = _formatBlocks;

#pragma mark - Public Singleton

+ (ProtocolModel *)sharedInstance {
    if (sharedInstance == nil) {
        sharedInstance = [[super allocWithZone:NULL] init];
        [sharedInstance setFormatBlocks:[NSMutableDictionary dictionary]];
    }
    return sharedInstance;
}

#pragma mark -
#pragma mark Format Block

+ (void)registerFormatBlock:(id (^)(NSString *))block forKey:(NSString *)key {
    [[ProtocolModel sharedInstance] registerFormatBlock:block forKey:key];
}

- (void)registerFormatBlock:(id (^)(NSString *))block forKey:(NSString *)key {
    [_formatBlocks setObject:[block copy] forKey:key];
}

- (id) performFormatBlock:(NSString*)value withKey:(NSString*)key {
    id(^block)(NSString *);
    block = [_formatBlocks objectForKey:key];
    if (block != nil) {
        return block(value);
    } else {
        return nil;
    }
}

+ (NSArray*)protocolModelWithArray:(NSArray*)array {
    return [ProtocolModel protocolModelWithArray:array withClass:[self class]];
}

+ (NSArray*)protocolModelWithArray:(NSArray*)array withClass:(Class)protocolObjectClass {
    NSMutableArray *mutableArray = [[NSMutableArray alloc] init];
    for (NSDictionary *dict in array) {
        [mutableArray addObject:[[protocolObjectClass alloc] initWithDictionary:dict]];
    }
    
    return mutableArray;
}

+ (id)protocolModelWithDictionary:(NSDictionary*)dict {
    NSLog(@"Class  %@",[self class]);
    return [[[self class] alloc] initWithDictionary:dict];
}

+ (id)protocolModelWithString:(NSString*)string {
    NSDictionary *dict = [NSJSONSerialization JSONObjectWithData: [string dataUsingEncoding:NSUTF8StringEncoding]
                                options: NSJSONReadingMutableContainers
                                  error: nil];
    return [[self class] protocolModelWithDictionary:dict];
}
- (id)initWithDictionary:(NSDictionary*)dict {
    self = [self init];
    if (self) {
        [self setWithDictionary:dict];
    }
    return self;
}

- (void)setWithString:(NSString*)string {
    NSDictionary *dict = [NSJSONSerialization JSONObjectWithData: [string dataUsingEncoding:NSUTF8StringEncoding]
                                                         options: NSJSONReadingMutableContainers
                                                           error: nil];
    [self setWithDictionary:dict];
}

- (void)setWithDictionary:(NSDictionary*)dict {

    // Loops through all keys to map to propertiess
    NSDictionary *map = [self mapKeysToProperties];
    for (NSString *key in [map allKeys]) {
        
        // Checks if the key to map is in the dictionary to map
        if ([dict objectForKey:key] != nil && [dict objectForKey:key] != [NSNull null]) {
            
            NSString *property = [map objectForKey:key];
            
            NSRange inflateRange = [property rangeOfString:@"."];
            NSRange formatRange = [property rangeOfString:@":"];
            
            @try {
                if (inflateRange.location != NSNotFound) {
                    NSString *object = [property substringToIndex:inflateRange.location];
                    property = [property substringFromIndex:(inflateRange.location+1)];
                    
                    Class class = NSClassFromString(object);
                    if ([[dict objectForKey:key] isKindOfClass:[NSDictionary class]]) {
                        ProtocolModel *obj = [[class alloc] initWithDictionary:[dict objectForKey:key]];
                        
                        [self setValue:obj forKey:property];
                    } else if ([[dict objectForKey:key] isKindOfClass:[NSArray class]]) {
                        NSArray *array = [ProtocolModel protocolModelWithArray:[dict objectForKey:key] withClass:class];
                        
                        [self setValue:array forKey:property];
                    }
                } else if (formatRange.location != NSNotFound) {
                    NSString *formatFunction = [property substringToIndex:formatRange.location];
                    property = [property substringFromIndex:(formatRange.location+1)];
                    
                    [self setValue:[[ProtocolModel sharedInstance] performFormatBlock:[dict objectForKey:key] withKey:formatFunction] forKey:property ];
                } else {
                    [self setValue:[dict objectForKey:key] forKey:property ];
                }
            }
            @catch (NSException *exception) {
                NSLog(@"ProtocolModel Warning - %@", [exception description]);
            }
            
        } else {
            
        }
        
    }
}

- (NSDictionary *)mapKeysToProperties {
    return [[NSDictionary alloc] init];
}

@end
