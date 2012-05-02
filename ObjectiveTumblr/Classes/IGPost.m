//
//  IGPost.m
//  ObjectiveTumblr
//
//  Created by Francis Chong on 12年4月26日.
//  Copyright (c) 2012年 Ignition Soft Limited. All rights reserved.
//

#import "IGPost.h"

@implementation IGPost

@synthesize state, tags, tweet, date, markdown, slug;

-(id) init {
    self = [super init];
    if (self) {
        self.state = IGPostStatePublished;
        self.tags = nil;
        self.tweet = nil;
        self.date = nil;
        self.markdown = NO;
    }
    return self;
}

-(NSMutableDictionary*) params {
    NSMutableDictionary* params = [NSMutableDictionary dictionary];

    switch (self.state) {
        case IGPostStateDraft:
            [params setObject:@"draft" forKey:@"state"];
            break;
        case IGPostStateQueue:
            [params setObject:@"queue" forKey:@"state"];
            break;
        case IGPostStatePublished:
            [params setObject:@"published" forKey:@"state"];
            break;
    }
    
    if (self.tags) {
        [params setObject:self.tags forKey:@"tags"];
    }
    
    if (self.tweet) {
        [params setObject:self.tweet forKey:@"tweet"];
    }
    
    if (self.date) {
        [params setObject:self.date forKey:@"date"];
    }
    
    // Somehow the document on Tumblr API is wrong (http://www.tumblr.com/docs/en/api/v2#posting)
    // You need specifiy "format" instead of "markdown"!
    if (self.markdown) {
        [params setObject:@"True" forKey:@"markdown"];
        [params setObject:@"markdown" forKey:@"format"];
    } else {
        [params setObject:@"False" forKey:@"markdown"];
        [params setObject:@"html" forKey:@"format"];
    }

    if (self.slug) {
        [params setObject:self.slug forKey:@"slug"];
    }

    return params;
}

@end

@implementation IGTextPost

@synthesize title, body;

-(NSMutableDictionary*) params {
    NSMutableDictionary* params = [super params];
    [params setObject:@"text" forKey:@"type"];
    
    if (self.title) {
        [params setObject:self.title forKey:@"title"];
    }
    
    if (self.body) {
        [params setObject:self.body forKey:@"body"];
    }
    return params;
}

@end

@implementation IGPhotoPost

@synthesize caption, link, source, data;

-(NSMutableDictionary*) params {
    NSMutableDictionary* params = [super params];
    [params setObject:@"photo" forKey:@"type"];
    
    if (self.caption) {
        [params setObject:self.caption forKey:@"caption"];
    }
    
    if (self.link) {
        [params setObject:self.link forKey:@"link"];
    }
    
    if (self.source) {
        [params setObject:self.source forKey:@"source"];
    }
    
    if (self.data) {
        [params setObject:self.data forKey:@"data"];
    }
    return params;
}

@end

@implementation IGLinkPost

@synthesize title, url, description;

-(NSMutableDictionary*) params {
    NSMutableDictionary* params = [super params];
    [params setObject:@"link" forKey:@"type"];
    
    if (self.title) {
        [params setObject:self.title forKey:@"title"];
    }
    
    if (self.url) {
        [params setObject:self.url forKey:@"url"];
    }
    
    if (self.description) {
        [params setObject:self.description forKey:@"description"];
    }
    return params;
}

@end
