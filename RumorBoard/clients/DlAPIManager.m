//
//  DlAPIManager.m
//  RumorBoard
//
//  Created by David Wu on 19/02/2014.
//  Copyright (c) 2014 David Wu. All rights reserved.
//

#import "DlAPIManager.h"
#import "DlConfig.h"
#import "AFHTTPRequestOperationManager.h"
#import "AFURLSessionManager.h"
#import "JSONHTTPClient.h"
#import "SVProgressHUD.h"


NSString *kKeyServerUrl = @"kKeyServerUrl";
NSString *kJsonQuerySubfix = @"?format=json";


@interface DlAPIManager ()

@property (nonatomic, strong) NSString *serverUrl;
@property (nonatomic, strong) AFHTTPRequestOperationManager *httpManager;

@end


@implementation DlAPIManager

+ (DlAPIManager *)sharedManager {
    static DlAPIManager *sharedManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedManager = [[self alloc] init];
    });
    return sharedManager;
}


- (id)init {
    self = [super init];
    if (self) {
    }
    
    return self;
}


- (NSString *)serverUrl {
    if (!_serverUrl) {
        _serverUrl = [[NSUserDefaults standardUserDefaults] objectForKey:kKeyServerUrl];
        
        if (!_serverUrl) {
//            _serverUrl = @"http://localhost:8000/";
            _serverUrl = @"http://hack-day-rumor-board.herokuapp.com/";
        }
    }
    
    return _serverUrl;
}


- (AFHTTPRequestOperationManager *)httpManager {
    if (!_httpManager) {
        _httpManager = [AFHTTPRequestOperationManager manager];
    }
    return _httpManager;
}


- (void)getRumors:(NetworkCallback)callback {
    [SVProgressHUD show];
    NSString *urlString = [[self serverUrl] stringByAppendingFormat:@"rumors/%@", kJsonQuerySubfix];
    
    [self.httpManager GET:urlString parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [SVProgressHUD dismiss];
        NSArray *resultArray = [responseObject objectForKey:@"results"];
        if (callback) {
            callback(resultArray, nil);
        }
        NSLog(@"JSON: %@", responseObject);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [SVProgressHUD dismiss];
        callback(nil, error);
        NSLog(@"Error: %@", error);
    }];
}


- (void)getRumor:(int)rumorId callback:(NetworkCallback)callback {
    [SVProgressHUD show];
    NSString *urlString = [[self serverUrl] stringByAppendingFormat:@"rumors/%d/%@", rumorId, kJsonQuerySubfix];
    
    [self.httpManager GET:urlString parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [SVProgressHUD dismiss];
        if (callback) {
            callback(responseObject, nil);
        }
        NSLog(@"JSON: %@", responseObject);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [SVProgressHUD dismiss];
        callback(nil, error);
        NSLog(@"Error: %@", error);
    }];
}


- (void)setRumorThumbs:(int)rumorId isUp:(BOOL)isUp callback:(NetworkCallback)callback {
    [SVProgressHUD show];
    NSString *urlString = [[self serverUrl] stringByAppendingFormat:@"rumors/%d/thumbs/%@/", rumorId, (isUp ? @"up" : @"down")];

//    [JSONHTTPClient postJSONFromURLWithString:urlString
//                                       params:nil
//                                   completion:^(id json, JSONModelError *err) {
//                                       int a =0;
//    }];
    NSString *authString = [@"token " stringByAppendingString:[DlConfig sharedConfig].authToken];
    [JSONHTTPClient JSONFromURLWithString:urlString
                                   method:kHTTPMethodPOST
                                   params:nil
                               orBodyData:nil
                                  headers:@{@"Authorization": authString}
                               completion:^(id json, JSONModelError *err) {
                                   [SVProgressHUD dismiss];
                                   if (callback) {
                                       callback(json, err);
                                   }
                               }];
}


- (void)createRumor:(NSDictionary *)data callback:(NetworkCallback)callback {
    [SVProgressHUD show];
    NSString *authString = [@"token " stringByAppendingString:[DlConfig sharedConfig].authToken];
    [JSONHTTPClient JSONFromURLWithString:[[self serverUrl] stringByAppendingString:@"rumors/"]
                                   method:kHTTPMethodPOST
                                   params:data
                               orBodyData:nil
                                  headers:@{@"Authorization": authString}
                               completion:^(id json, JSONModelError *err) {
                                   [SVProgressHUD dismiss];
                                   if (callback) {
                                       callback(json, err);
                                   }
                               }];
}


- (void)loginWithUsername:(NSString *)username
                 password:(NSString *)password
                 callback:(NetworkCallback)callback {
    [SVProgressHUD show];
    NSString *csrfToken = [[DlAPIManager sharedManager] getCookie:kCSRFToken];
    
    NSMutableDictionary *dict = [@{@"email":username, @"password":password} mutableCopy];
    [dict setObject:csrfToken forKey:@"csrfmiddlewaretoken"];
    
    [JSONHTTPClient postJSONFromURLWithString:[[self serverUrl] stringByAppendingString:@"users/login/"]
                                       params:dict
                                   completion:^(id json, JSONModelError *err) {
                                       [SVProgressHUD dismiss];
                                       if (!err && [json isKindOfClass:[NSDictionary class]]) {
                                           NSDictionary *dict = (NSDictionary *)json;
                                           [DlConfig sharedConfig].username = username;
                                           [DlConfig sharedConfig].userId = [json objectForKey:@"id"];
                                           [DlConfig sharedConfig].authToken = [dict objectForKey:@"token"];
                                       }

                                       callback(json, err);
                                   }];
}


- (void)createUserWithUsername:(NSString *)username password:(NSString *)password callback:(NetworkCallback)callback {
    [SVProgressHUD show];
    NSString *csrfToken = [[DlAPIManager sharedManager] getCookie:kCSRFToken];
    
    NSMutableDictionary *dict = [@{@"email":username, @"password":password} mutableCopy];
    [dict setObject:csrfToken forKey:@"csrfmiddlewaretoken"];

    [JSONHTTPClient postJSONFromURLWithString:[[self serverUrl] stringByAppendingString:@"users/"]
                                       params:dict
                                   completion:^(id json, JSONModelError *err) {
                                       [SVProgressHUD dismiss];
                                       if (!err && [json isKindOfClass:[NSDictionary class]]) {
                                           NSDictionary *dict = (NSDictionary *)json;
                                           [DlConfig sharedConfig].username = username;
                                           [DlConfig sharedConfig].userId = [json objectForKey:@"id"];
                                           [DlConfig sharedConfig].authToken = [dict objectForKey:@"token"];
                                       }

                                       callback(json, err);
                                   }];
}


- (void)logoutWithCallback:(NetworkCallback)callback {
    [SVProgressHUD show];
    [JSONHTTPClient getJSONFromURLWithString:[[self serverUrl] stringByAppendingString:@"users/logout/"]
                                  completion:^(id json, JSONModelError *err) {
                                      [SVProgressHUD dismiss];
                                      if (!err) {
                                          [self removeCookie:kCSRFToken];
                                      }
                                      
                                      callback(json, err);
                                  }];
}


- (void)setRumorPoll:(int)rumorId pollColumnId:(int)pollColumnId callback:(NetworkCallback)callback {
    [SVProgressHUD show];
    NSString *urlString = [[self serverUrl] stringByAppendingFormat:@"rumors/%d/poll/%d/", rumorId, pollColumnId];
    
    NSString *authString = [@"token " stringByAppendingString:[DlConfig sharedConfig].authToken];
    [JSONHTTPClient JSONFromURLWithString:urlString
                                   method:kHTTPMethodPOST
                                   params:nil
                               orBodyData:nil
                                  headers:@{@"Authorization": authString}
                               completion:^(id json, JSONModelError *err) {
                                   [SVProgressHUD dismiss];
                                   if (callback) {
                                       callback(json, err);
                                   }
                               }];
}


- (NSString *)getCookie:(NSString *)name {
    NSHTTPCookieStorage *cookieJar = [NSHTTPCookieStorage sharedHTTPCookieStorage];
    for (NSHTTPCookie *cookie in [cookieJar cookies]) {
        if ([cookie.name isEqualToString:name]) {
            return cookie.value;
        }
    }
    return @"";
}

- (void)removeCookie:(NSString *)name {
//    NSMutableArray *deleteCookieList = [NSMutableArray array];
    NSHTTPCookieStorage *cookieJar = [NSHTTPCookieStorage sharedHTTPCookieStorage];
    for (NSHTTPCookie *cookie in [cookieJar cookies]) {
        if ([cookie.name isEqualToString:name]) {
//            [deleteCookieList addObject:cookie];
            [cookieJar deleteCookie:cookie];
        }
    }
}

@end
