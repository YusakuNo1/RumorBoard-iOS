//
//  DlConfig.m
//  RumorBoard
//
//  Created by David Wu on 21/02/2014.
//  Copyright (c) 2014 David Wu. All rights reserved.
//

#import "DlConfig.h"

@implementation DlConfig

+ (DlConfig *)sharedConfig {
    static DlConfig *sharedConfig = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedConfig = [[self alloc] init];
    });
    return sharedConfig;
}

@end
