//
//  IGBlog.h
//  ObjectiveTumblr
//
//  Created by Chong Francis on 12年4月25日.
//  Copyright (c) 2012年 Ignition Soft Limited. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface IGBlog : NSObject

@property (nonatomic, strong) NSString* title;
@property (nonatomic, strong) NSString* name;
@property (nonatomic, strong) NSString* url;
@property (nonatomic, strong) NSNumber* updated;
@property (nonatomic, strong) NSString* description;
@property (nonatomic, strong) NSNumber* ask;
@property (nonatomic, strong) NSNumber* primary;
@property (nonatomic, strong) NSNumber* publicBlog;
@property (nonatomic, strong) NSNumber* admin;

+(NSDictionary*) mapping;

@end
