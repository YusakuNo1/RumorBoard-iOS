//
//  DlRumorCell.h
//  RumorBoard
//
//  Created by David Wu on 19/02/2014.
//  Copyright (c) 2014 David Wu. All rights reserved.
//

#import <UIKit/UIKit.h>


@class DlRumor;


@interface DlRumorCell : UITableViewCell

@property (nonatomic, strong) DlRumor *rumor;

@property (weak, nonatomic) IBOutlet UIButton *commentsButton;
@property (weak, nonatomic) IBOutlet UIButton *thumbUpButton;
@property (weak, nonatomic) IBOutlet UIButton *thumbDownButton;

@end
