//
//  DlRumor.h
//  RumorBoard
//
//  Created by David Wu on 19/02/2014.
//  Copyright (c) 2014 David Wu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JSONModel.h"


@interface DlRumor : JSONModel

@property (nonatomic, strong) NSNumber *id;
@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *content;
@property (nonatomic, strong) NSNumber *owner;
@property (nonatomic, strong) NSNumber *anonymous;

//@property (nonatomic) float cellHeight;
- (float)cellHeight;

@end
