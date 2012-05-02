//
//  IGPost.h
//  ObjectiveTumblr
//
//  Created by Francis Chong on 12年4月26日.
//  Copyright (c) 2012年 Ignition Soft Limited. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum {
    IGPostStatePublished,
    IGPostStateDraft,
    IGPostStateQueue
} IGPostState;

@interface IGPost : NSObject

@property (nonatomic, assign) IGPostState state;
@property (nonatomic, strong) NSString* tags;
@property (nonatomic, strong) NSString* tweet;
@property (nonatomic, strong) NSString* date;
@property (nonatomic, assign) BOOL markdown;
@property (nonatomic, copy) NSString* slug;

-(NSMutableDictionary*) params;

@end

@interface IGTextPost : IGPost

@property (nonatomic, strong) NSString* title;
@property (nonatomic, strong) NSString* body;

@end

@interface IGPhotoPost : IGPost

@property (nonatomic, strong) NSString* caption;
@property (nonatomic, strong) NSString* link;
@property (nonatomic, strong) NSString* source;
@property (nonatomic, strong) NSArray* data;

@end

@interface IGLinkPost : IGPost

@property (nonatomic, strong) NSString* title;
@property (nonatomic, strong) NSString* url;
@property (nonatomic, strong) NSString* description;

@end


