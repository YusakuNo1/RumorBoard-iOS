//
//  DlAPIManager.h
//  RumorBoard
//
//  Created by David Wu on 19/02/2014.
//  Copyright (c) 2014 David Wu. All rights reserved.
//

#import <Foundation/Foundation.h>


//typedef void (^GetRumorsCallback)(NSArray *jsonArray, NSError *error);

@interface DlAPIManager : NSObject

+ (DlAPIManager *)sharedManager;

@property (nonatomic, readonly) NSString *serverUrl;


// User APIs
- (void)loginWithUsername:(NSString *)username password:(NSString *)password callback:(NetworkCallback)callback;
- (void)createUserWithUsername:(NSString *)username password:(NSString *)password callback:(NetworkCallback)callback;
- (void)logoutWithCallback:(NetworkCallback)callback;

// Rumor APIs
- (void)getRumors:(NetworkCallback)callback;
- (void)setRumorThumbs:(int)rumorId isUp:(BOOL)isUp callback:(NetworkCallback)callback;
- (void)createRumor:(NSDictionary *)data callback:(NetworkCallback)callback;

@end
