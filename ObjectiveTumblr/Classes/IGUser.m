//
//  IGUser.m
//  ObjectiveTumblr
//
//  Created by Chong Francis on 12年4月25日.
//  Copyright (c) 2012年 Ignition Soft Limited. All rights reserved.
//

#import "IGUser.h"
#import "IGBlog.h"
#import "JTObjectMapping/NSObject+JTObjectMapping.h"

@implementation IGUser

@synthesize name, defaultPostFormat, following, likes, blogs;

+(NSDictionary*) mapping {
    NSDictionary *mapping = [NSDictionary dictionaryWithObjectsAndKeys:
                             @"name", @"name",
                             @"defaultPostFormat", @"default_post_format",
                             @"following", @"following",
                             @"likes", @"likes",
                             [IGBlog mappingWithKey:@"blogs" mapping:[IGBlog mapping]], @"blogs",
                             nil];
    return mapping;
}

-(NSString*) description {
    return [NSString stringWithFormat:@"<IGUser name=%@, defaultPostFormat=%@, following=%@, likes=%@, blogs=%@>", name, defaultPostFormat, following, likes, blogs];
}

@end
