//
//  DlConfig.m
//  RumorBoard
//
//  Created by David Wu on 21/02/2014.
//  Copyright (c) 2014 David Wu. All rights reserved.
//

#import "DlConfig.h"


@interface DlConfig ()

@property (nonatomic, strong) NSDateFormatter *dateFormatter;

@end


@implementation DlConfig

@synthesize username = _username;
@synthesize userId = _userId;
@synthesize authToken = _authToken;

+ (DlConfig *)sharedConfig {
    static DlConfig *sharedConfig = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedConfig = [[self alloc] init];
    });
    return sharedConfig;
}

- (NSString *)username {
    if (!_username) {
        _username = [[NSUserDefaults standardUserDefaults] stringForKey:kUsername];
    }
    return _username;
}

- (void)setUsername:(NSString *)username {
    _username = username;
    [[NSUserDefaults standardUserDefaults] setObject:username forKey:kUsername];
}

- (NSNumber *)userId {
    if (!_userId) {
        _userId = [NSNumber numberWithInteger:[[NSUserDefaults standardUserDefaults] integerForKey:kUserId]];
    }
    return _userId;
}

- (void)setUserId:(NSNumber *)userId {
    _userId = userId;
    [[NSUserDefaults standardUserDefaults] setObject:userId forKey:kUserId];
}

- (NSString *)authToken {
    if (!_authToken) {
        _authToken = [[NSUserDefaults standardUserDefaults] stringForKey:kAuthToken];
    }
    return _authToken;
}

- (void)setAuthToken:(NSString *)authToken {
    _authToken = authToken;
    [[NSUserDefaults standardUserDefaults] setObject:authToken forKey:kAuthToken];
}


- (NSDateFormatter *)dateFormatter {
    if (!_dateFormatter) {
        _dateFormatter = [[NSDateFormatter alloc] init];
        [_dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm"];
    }
    
    return _dateFormatter;
}

@end
