//
//  DlConfig.h
//  RumorBoard
//
//  Created by David Wu on 21/02/2014.
//  Copyright (c) 2014 David Wu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DlConfig : NSObject

+ (DlConfig *)sharedConfig;

@property (nonatomic, strong) NSString *username;
@property (nonatomic, strong) NSNumber *userId;
@property (nonatomic, strong) NSString *authToken;

@property (nonatomic, readonly) NSDateFormatter *dateFormatter;

@end
