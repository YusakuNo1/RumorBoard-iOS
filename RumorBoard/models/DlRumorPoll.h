//
//  DlRumorPoll.h
//  RumorBoard
//
//  Created by David Wu on 11/03/2014.
//  Copyright (c) 2014 David Wu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JSONModel.h"


@protocol DlRumorPoll
@end

@interface DlRumorPoll : JSONModel

@property (nonatomic, strong) NSNumber *id;
@property (nonatomic, strong) NSNumber *rumor;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSNumber *columnIndex;
@property (nonatomic, strong) NSNumber *rumorPollUserCount;
@property (nonatomic, strong) NSDate *created_at;
@property (nonatomic, strong) NSDate *updated_at;

@end
