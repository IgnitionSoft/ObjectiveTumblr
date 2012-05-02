//
//  ObjectiveTumblrTest.m
//  ObjectiveTumblrTest
//
//  Created by Francis Chong on 12年4月26日.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "Constants.h"
#import "IGObjectiveTumblr.h"
#import "OCMock/OCMock.h"
#import "IGBlog.h"
#import "ConciseKit/ConciseKit.h"

SpecBegin(IGObjectiveTumblrSpecs)
describe(@"Thing", ^{
    __block IGObjectiveTumblr* tumblr = [[IGObjectiveTumblr alloc] initWithConsumerKey:kTumblrConsumerKey
                                                                                secret:kTumblrConsumerSecret];

    beforeAll(^{
        [Expecta setAsynchronousTestTimeout:5];
    });

    it(@"should have defined settings in Constant.h", ^{
        expect(kTumblrConsumerKey).Not.toEqual(@"");
        expect(kTumblrConsumerSecret).Not.toEqual(@"");
        expect(kTumblrPassword).Not.toEqual(@"");
        expect(kTumblrUsername).Not.toEqual(@"");
        expect(kTumblrTestingBlogHost).Not.toEqual(@"");
    });
    
    describe(@"authenticated requested", ^{
        beforeAll(^{
            [tumblr authenticateWithUsername:kTumblrUsername 
                                    password:kTumblrPassword];            
        });
    
        
        it(@"should authenticate user", ^{
            expect([tumblr isAuthenticated]).isGoing.toBeTruthy();
        });
        
        it(@"should retrieve user info", ^{
            __block IGUser* user = nil;
            OCMockObject<IGObjectiveTumblrDelegate>* mockDelegate = [OCMockObject mockForProtocol:@protocol(IGObjectiveTumblrDelegate)];
            expect([tumblr isAuthenticated]).isGoing.toBeTruthy();
            [[mockDelegate expect] tumblr:tumblr didFinishUserInfo:[OCMArg checkWithBlock:^(id userId){
                user = (IGUser*) userId;
                return YES;
            }]];
            [[mockDelegate reject] tumblr:tumblr didFailUserInfoWithError:[OCMArg isNotNil]];
            tumblr.delegate = mockDelegate;
            [tumblr userInfo];
            
            // wait for the requests to complete
            [$ waitUntil:^{ return (BOOL)(user != nil); }];
            [mockDelegate verify];
            
            expect(user).toBeKindOf([IGUser class]);
            expect(user).Not.toBeNil();
            expect(user.name).Not.toBeNil();            
            expect(user.blogs).Not.toBeNil();

            IGBlog* blog = [user.blogs objectAtIndex:0];
            expect(blog.url).Not.toBeNil();
            expect(blog.name).Not.toBeNil();
        });
        
        it(@"should post text post", ^{
            __block BOOL loaded = NO;
            expect([tumblr isAuthenticated]).isGoing.toBeTruthy();
            OCMockObject<IGObjectiveTumblrDelegate>* mockDelegate = [OCMockObject mockForProtocol:@protocol(IGObjectiveTumblrDelegate)];
            [[mockDelegate expect] tumblr:tumblr didFinishCreatePostWithHostname:[OCMArg checkWithBlock:^(NSString* hostname){
                loaded = YES;
                return [hostname isEqualToString:kTumblrTestingBlogHost];
            }]];
            [[mockDelegate reject] tumblr:tumblr didFailCreatePostWithError:[OCMArg any]];
            tumblr.delegate = mockDelegate;
            
            IGTextPost* post = [[IGTextPost alloc] init];
            post.markdown = YES;
            post.title = @"Automated Test";
            post.body = [@"Test post content at " stringByAppendingFormat:@"_%@_", [NSDate date]];
            [tumblr createPostWithHostName:kTumblrTestingBlogHost post:post];
            
            // wait for the requests to complete
            [$ waitUntil:^{ return (BOOL)(loaded == YES); }];
            [mockDelegate verify];                        
        });
        
        it(@"should post photo post", ^{
            __block BOOL loaded = NO;
            expect([tumblr isAuthenticated]).isGoing.toBeTruthy();
            OCMockObject<IGObjectiveTumblrDelegate>* mockDelegate = [OCMockObject mockForProtocol:@protocol(IGObjectiveTumblrDelegate)];
            [[mockDelegate expect] tumblr:tumblr didFinishCreatePostWithHostname:[OCMArg checkWithBlock:^(NSString* hostname){
                loaded = YES;
                return [hostname isEqualToString:kTumblrTestingBlogHost];
            }]];
            [[mockDelegate reject] tumblr:tumblr didFailCreatePostWithError:[OCMArg any]];
            tumblr.delegate = mockDelegate;

            IGPhotoPost* post = [[IGPhotoPost alloc] init];
            post.markdown = YES;
            post.caption = [@"Testing Photo at " stringByAppendingFormat:@"_%@_", [NSDate date]];
            post.source = @"http://cp.ignt.hk/m/gcD72vPLXoq?open=true";
            post.link = @"http://campl.us/gcD72vPLXoq";
            [tumblr createPostWithHostName:kTumblrTestingBlogHost post:post];
            
            // wait for the requests to complete
            [$ waitUntil:^{ return (BOOL)(loaded == YES); }];
            [mockDelegate verify];
        });
        
        it(@"should post link post", ^{
            __block BOOL loaded = NO;
            expect([tumblr isAuthenticated]).isGoing.toBeTruthy();
            OCMockObject<IGObjectiveTumblrDelegate>* mockDelegate = [OCMockObject mockForProtocol:@protocol(IGObjectiveTumblrDelegate)];
            [[mockDelegate expect] tumblr:tumblr didFinishCreatePostWithHostname:[OCMArg checkWithBlock:^(NSString* hostname){
                loaded = YES;
                return [hostname isEqualToString:kTumblrTestingBlogHost];
            }]];
            [[mockDelegate reject] tumblr:tumblr didFailCreatePostWithError:[OCMArg any]];
            tumblr.delegate = mockDelegate;
            
            IGLinkPost* post = [[IGLinkPost alloc] init];
            post.markdown = YES;
            post.title = @"Automated Test Link";
            post.url = @"http://hk.apple.nextmedia.com/template/apple/art_main.php?iss_id=20120427&sec_id=4104&art_id=16286643";
            post.description = @"特首選舉雖已結束，但廉政公署針對唐英年的調查卻未有停止。據了解廉署懷疑唐觸犯《選舉（舞弊及非法行為）條例》，在選舉期間作出虛假陳述，並且與選委聚會時提供紅酒款待，廉署早前更主動接觸多名挺唐選委，要求他們提供相關資料，但暫時仍未正式立案進行全面調查。記者：羅偉光、莫劍弦";
            [tumblr createPostWithHostName:kTumblrTestingBlogHost post:post];
            
            // wait for the requests to complete
            [$ waitUntil:^{ return (BOOL)(loaded == YES); }];
            [mockDelegate verify];
        });
        
    });
});

SpecEnd
