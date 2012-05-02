//
//  IGBlog.m
//  ObjectiveTumblr
//
//  Created by Chong Francis on 12年4月25日.
//  Copyright (c) 2012年 Ignition Soft Limited. All rights reserved.
//

#import "IGBlog.h"

@implementation IGBlog

@synthesize title, name, url, updated, description, ask, primary;
@synthesize admin, publicBlog;

+(NSDictionary*) mapping {
    NSDictionary *mapping = [NSDictionary dictionaryWithObjectsAndKeys:
                             @"title", @"title",
                             @"name", @"name",
                             @"url", @"url",
                             @"updated", @"updated",
                             @"description", @"description",
                             @"ask", @"ask",
                             @"primary", @"primary",
                             @"admin", @"admin",
                             @"publicBlog", @"type",
                             nil];
    return mapping;
}

-(NSString*) description {
    return [NSString stringWithFormat:@"<IGBlog title=%@, name=%@, url=%@, updated=%@, description=%@, ask=%@, public=%@, primary=%@, admin=%@>",
            title, 
            name, 
            url, 
            updated, 
            description, 
            [ask boolValue] ? @"Y" : @"N", 
            [admin boolValue] ? @"Y" : @"N", 
            [publicBlog boolValue] ? @"Y" : @"N",
            [primary boolValue] ? @"Y" : @"N"];
}

@end
