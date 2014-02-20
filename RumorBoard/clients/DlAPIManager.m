//
//  DlAPIManager.m
//  RumorBoard
//
//  Created by David Wu on 19/02/2014.
//  Copyright (c) 2014 David Wu. All rights reserved.
//

#import "DlAPIManager.h"
#import "AFHTTPRequestOperationManager.h"


NSString *kKeyServerUrl = @"kKeyServerUrl";
NSString *kJsonQuerySubfix = @"?format=json";


@interface DlAPIManager () {
    NSString *_serverUrl;
}

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
            _serverUrl = @"http://localhost:8000/";
        }
    }
    
    return _serverUrl;
}

- (void)getRumors:(GetRumorsCallback)callback {
    NSString *urlString = [[self serverUrl] stringByAppendingFormat:@"rumors/%@", kJsonQuerySubfix];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager GET:urlString parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSArray *resultArray = [responseObject objectForKey:@"results"];
        if (callback) {
            callback(resultArray, nil);
        }
        NSLog(@"JSON: %@", responseObject);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        callback(nil, error);
        NSLog(@"Error: %@", error);
    }];
}

@end
