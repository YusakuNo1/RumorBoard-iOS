//
//  DlRumorComment.h
//  RumorBoard
//
//  Created by David Wu on 24/02/2014.
//  Copyright (c) 2014 David Wu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JSONModel.h"


@protocol DlRumorComment
@end

@interface DlRumorComment : JSONModel

@property (nonatomic, strong) NSNumber *id;
@property (nonatomic, strong) NSNumber *owner;
@property (nonatomic, strong) NSNumber *rumor;
@property (nonatomic, strong) NSString *content;
@property (nonatomic, strong) NSNumber *rating;

@end
