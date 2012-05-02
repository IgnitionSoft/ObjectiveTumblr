//
//  IGObjectiveTumblr.m
//  ObjectiveTumblr
//
//  Created by Chong Francis on 12年4月25日.
//  Copyright (c) 2012年 Ignition Soft Limited. All rights reserved.
//

#import "IGObjectiveTumblr.h"
#import "IGUser.h"

#import "JTObjectMapping/NSObject+JTObjectMapping.h"
#import "JTObjectMapping/JTMappings.h"
#import "JSONKit/JSONKit.h"

NSString* const IGObjectiveTumblrApiBaseUrl = @"http://api.tumblr.com/v2";

@interface IGObjectiveTumblr (Private)
+(NSString*) urlWithPath:(NSString*)path;
@end

@implementation IGObjectiveTumblr

@synthesize delegate = _delegate;

-(id) initWithConsumerKey:(NSString*)consumerKey secret:(NSString*)secret {
    self = [super initWithHostName:@"www.tumblr.com"
                customHeaderFields:nil
                   signatureMethod:RSOAuthHMAC_SHA1
                       consumerKey:consumerKey
                    consumerSecret:secret];
    return self;
}

#pragma mark - Public

-(void) userInfo {
    MKNetworkOperation* op = [self operationWithURLString:[IGObjectiveTumblr urlWithPath:@"/user/info"]];
    
    [op onCompletion:^(MKNetworkOperation *completedOperation) {
        NSData* data = [completedOperation responseData];
        NSDictionary* dictionary = [[JSONDecoder decoder] objectWithData:data];
        NSDictionary* userMap = [[dictionary objectForKey:@"response"] objectForKey:@"user"];
        IGUser* user = [IGUser objectFromJSONObject:userMap
                                            mapping:[IGUser mapping]];
        if (self.delegate && [self.delegate respondsToSelector:@selector(tumblr:didFinishUserInfo:)]) {
            [self.delegate tumblr:self didFinishUserInfo:user];
        }
    } onError:^(NSError *error) {
        if (self.delegate && [self.delegate respondsToSelector:@selector(tumblr:didFailUserInfoWithError:)]) {
            [self.delegate tumblr:self didFailUserInfoWithError:error];
        }
    }];
    [self enqueueSignedOperation:op];
}

-(void) createPostWithHostName:(NSString*)hostName post:(IGPost*)post {
    NSString* url = [IGObjectiveTumblr urlWithPath:[NSString stringWithFormat:@"/blog/%@/post", hostName]];
    NSMutableDictionary* params = [post params];
    MKNetworkOperation* op = [self operationWithURLString:url params:params httpMethod:@"POST"];
    [op onCompletion:^(MKNetworkOperation *completedOperation) {
        if (self.delegate && [self.delegate respondsToSelector:@selector(tumblr:didFinishCreatePostWithHostname:)]) {
            [self.delegate tumblr:self didFinishCreatePostWithHostname:hostName];
        }
    } onError:^(NSError *error) {
        if (self.delegate && [self.delegate respondsToSelector:@selector(tumblr:didFailCreatePostWithError:)]) {
            [self.delegate tumblr:self didFailCreatePostWithError:error];
        }
    }];
    [self enqueueSignedOperation:op];
}

#pragma mark - OAuth Access Token store/retrieve

- (void)removeOAuthTokenFromKeychain
{
    // Build the keychain query
    NSMutableDictionary *keychainQuery = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                          (__bridge_transfer NSString *)kSecClassGenericPassword, (__bridge_transfer NSString *)kSecClass,
                                          self.consumerKey, kSecAttrService,
                                          self.consumerKey, kSecAttrAccount,
                                          kCFBooleanTrue, kSecReturnAttributes,
                                          nil];
    
    // If there's a token stored for this user, delete it
    SecItemDelete((__bridge_retained CFDictionaryRef) keychainQuery);
}

- (void)storeOAuthTokenInKeychain
{
    // Build the keychain query
    NSMutableDictionary *keychainQuery = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                          (__bridge_transfer NSString *)kSecClassGenericPassword, (__bridge_transfer NSString *)kSecClass,
                                          self.consumerKey, kSecAttrService,
                                          self.consumerKey, kSecAttrAccount,
                                          kCFBooleanTrue, kSecReturnAttributes,
                                          nil];
    
    CFTypeRef resData = NULL;
    
    // If there's a token stored for this user, delete it first
    SecItemDelete((__bridge_retained CFDictionaryRef) keychainQuery);
    
    // Build the token dictionary
    NSMutableDictionary *tokenDictionary = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                            self.token, @"oauth_token",
                                            self.tokenSecret, @"oauth_token_secret",
                                            nil];
    
    // Add the token dictionary to the query
    [keychainQuery setObject:[NSKeyedArchiver archivedDataWithRootObject:tokenDictionary] 
                      forKey:(__bridge_transfer NSString *)kSecValueData];
    
    // Add the token data to the keychain
    // Even if we never use resData, replacing with NULL in the call throws EXC_BAD_ACCESS
    SecItemAdd((__bridge_retained CFDictionaryRef)keychainQuery, (CFTypeRef *) &resData);
}

- (void)retrieveOAuthTokenFromKeychain
{
    // Build the keychain query
    NSMutableDictionary *keychainQuery = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                          (__bridge_transfer NSString *)kSecClassGenericPassword, (__bridge_transfer NSString *)kSecClass,
                                          self.consumerKey, kSecAttrService,
                                          self.consumerKey, kSecAttrAccount,
                                          kCFBooleanTrue, kSecReturnData,
                                          kSecMatchLimitOne, kSecMatchLimit,
                                          nil];
    
    // Get the token data from the keychain
    CFTypeRef resData = NULL;
    
    // Get the token dictionary from the keychain
    if (SecItemCopyMatching((__bridge_retained CFDictionaryRef) keychainQuery, (CFTypeRef *) &resData) == noErr)
    {
        NSData *resultData = (__bridge_transfer NSData *)resData;
        
        if (resultData)
        {
            NSMutableDictionary *tokenDictionary = [NSKeyedUnarchiver unarchiveObjectWithData:resultData];
            
            if (tokenDictionary) {
                [self setAccessToken:[tokenDictionary objectForKey:@"oauth_token"]
                              secret:[tokenDictionary objectForKey:@"oauth_token_secret"]];
            }
        }
    }
}

#pragma mark - OAuth Authentication

- (void)authenticateWithUsername:(NSString *)username password:(NSString *)password
{
    // Fill the post body with the xAuth parameters
    NSMutableDictionary *postParams = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                       username, @"x_auth_username",
                                       password, @"x_auth_password",
                                       @"client_auth", @"x_auth_mode",
                                       nil];
    
    // Get the access token using xAuth
    MKNetworkOperation *op = [self operationWithPath:@"oauth/access_token"
                                              params:postParams
                                          httpMethod:@"POST"
                                                 ssl:YES];
    
    [op onCompletion:^(MKNetworkOperation *completedOperation)
     {
         // Fill the access token with the returned data
         [self fillTokenWithResponseBody:[completedOperation responseString] type:RSOAuthAccessToken];

         // Store the OAuth access token
         [self storeOAuthTokenInKeychain];
         
         if (self.delegate && [self.delegate respondsToSelector:@selector(tumblr:didFinishAuthenticationWithToken:secret:)]) {
             [self.delegate tumblr:self didFinishAuthenticationWithToken:self.token secret:self.tokenSecret];
         }
     } 
             onError:^(NSError *error)
     {
         if (self.delegate && [self.delegate respondsToSelector:@selector(tumblr:didFailAuthenticationWithError:)]) {
             [self.delegate tumblr:self didFailAuthenticationWithError:error];
         }
     }];
    [self enqueueSignedOperation:op];
}

- (void)cancelAuthentication
{
    NSDictionary *ui = [NSDictionary dictionaryWithObjectsAndKeys:@"Authentication cancelled.", NSLocalizedDescriptionKey, nil];
    NSError *error = [NSError errorWithDomain:@"hk.ignition.ObjectiveTumblr.ErrorDomain" code:401 userInfo:ui];

    if (self.delegate && [self.delegate respondsToSelector:@selector(tumblr:didFailAuthenticationWithError:)]) {
        [self.delegate tumblr:self didFailAuthenticationWithError:error];
    }
}

- (void)forgetStoredToken
{
    [self removeOAuthTokenFromKeychain];
    [self resetOAuthToken];
}

#pragma mark - Private

+(NSString*) urlWithPath:(NSString*)path {
    return [IGObjectiveTumblrApiBaseUrl stringByAppendingString:path];
}

@end