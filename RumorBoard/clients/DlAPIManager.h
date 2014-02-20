//
//  DlAPIManager.h
//  RumorBoard
//
//  Created by David Wu on 19/02/2014.
//  Copyright (c) 2014 David Wu. All rights reserved.
//

#import <Foundation/Foundation.h>


typedef void (^GetRumorsCallback)(NSArray *jsonArray, NSError *error);

@interface DlAPIManager : NSObject

+ (DlAPIManager *)sharedManager;

@property (nonatomic, readonly) NSString *serverUrl;

- (void)getRumors:(GetRumorsCallback)callback;

@end
