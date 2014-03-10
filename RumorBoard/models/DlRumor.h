//
//  DlRumor.h
//  RumorBoard
//
//  Created by David Wu on 19/02/2014.
//  Copyright (c) 2014 David Wu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JSONModel.h"


@protocol DlRumorComment;

@interface DlRumor : JSONModel

@property (nonatomic, strong) NSNumber *id;
@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *content;
@property (nonatomic, strong) NSNumber *owner;
@property (nonatomic, strong) NSNumber *anonymous;
@property (nonatomic, strong) NSNumber *commentCount;
@property (nonatomic, strong) NSNumber *thumbsUpCount;
@property (nonatomic, strong) NSNumber *thumbsDownCount;
@property (nonatomic, strong) NSString *thumbsVote;
@property (nonatomic, strong) NSDate *created_at;
@property (nonatomic, strong) NSDate *updated_at;
//@property (nonatomic, strong) NSArray<DlRumorComment> *comments;

//@property (nonatomic) float cellHeight;
- (float)cellHeight;
//- (float)cellHeightWithFont:(UIFont *)font maxLines:(int)maxLines width:(CGFloat)width;


- (void)setExpended:(BOOL)expended;
- (BOOL)expended;

@end
