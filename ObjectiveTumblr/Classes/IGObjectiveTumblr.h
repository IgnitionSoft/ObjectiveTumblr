//
//  IGObjectiveTumblr.h
//  ObjectiveTumblr
//
//  Created by Chong Francis on 12年4月25日.
//  Copyright (c) 2012年 Ignition Soft Limited. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "IGUser.h"
#import "IGPost.h"
#import "IGObjectiveTumblr.h"

#import "MKNetworkKit.h"
#import "RSOAuthEngine.h"

@class IGObjectiveTumblr;

@protocol IGObjectiveTumblrDelegate <NSObject>
@optional
-(void) tumblr:(IGObjectiveTumblr*)tumblr didFinishAuthenticationWithToken:(NSString*)token secret:(NSString*)secret;
-(void) tumblr:(IGObjectiveTumblr*)tumblr didFailAuthenticationWithError:(NSError*)error;

-(void) tumblr:(IGObjectiveTumblr*)tumblr didFinishUserInfo:(IGUser*)user;
-(void) tumblr:(IGObjectiveTumblr*)tumblr didFailUserInfoWithError:(NSError*)error;

-(void) tumblr:(IGObjectiveTumblr*)tumblr didFinishCreatePostWithHostname:(NSString*)hostname;
-(void) tumblr:(IGObjectiveTumblr*)tumblr didFailCreatePostWithError:(NSError*)error;

@end

extern NSString* const IGObjectiveTumblrApiBaseUrl;

@interface IGObjectiveTumblr : RSOAuthEngine

@property (nonatomic, assign) id<IGObjectiveTumblrDelegate> delegate;

-(id) initWithConsumerKey:(NSString*)consumerKey secret:(NSString*)secret;

// authentication
- (void)authenticateWithUsername:(NSString *)username password:(NSString *)password;

// cancel authentication
- (void)cancelAuthentication;

// logout
- (void)forgetStoredToken;

// request user info
// GET api.tumblr.com/v2/user/info
-(void) userInfo;

// post a blog
// POST api.tumblr.com/v2/blog/{base-hostname}/post
-(void) createPostWithHostName:(NSString*)hostName post:(IGPost*)post;


@end
