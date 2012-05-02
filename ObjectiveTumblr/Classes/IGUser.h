//
//  IGUser.h
//  ObjectiveTumblr
//
//  Created by Chong Francis on 12年4月25日.
//  Copyright (c) 2012年 Ignition Soft Limited. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface IGUser : NSObject

@property (nonatomic, strong) NSString* name;
@property (nonatomic, strong) NSString* defaultPostFormat;
@property (nonatomic, strong) NSNumber* following;
@property (nonatomic, strong) NSNumber* likes;
@property (nonatomic, strong) NSArray* blogs;

+(NSDictionary*) mapping;

@end
