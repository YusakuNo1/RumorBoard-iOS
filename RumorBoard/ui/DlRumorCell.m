//
//  DlRumorCell.m
//  RumorBoard
//
//  Created by David Wu on 19/02/2014.
//  Copyright (c) 2014 David Wu. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>

#import "DlRumorCell.h"
#import "DlRumor.h"


@interface DlRumorCell ()

@property (weak, nonatomic) IBOutlet UIView *containerView;
@property (weak, nonatomic) IBOutlet UIImageView *userImageView;
@property (weak, nonatomic) IBOutlet UILabel *userNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *createDateLabel;
@property (weak, nonatomic) IBOutlet UILabel *rumorLabel;
@property (weak, nonatomic) IBOutlet UIButton *relatedButton;
@property (weak, nonatomic) IBOutlet UIButton *commentsButton;
@property (weak, nonatomic) IBOutlet UIImageView *favouriteImageView;

@end


@implementation DlRumorCell

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
    }
    return self;
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)willMoveToSuperview:(UIView *)newSuperview {
    [super willMoveToSuperview:newSuperview];

    self.containerView.layer.cornerRadius = 8;
//    self.containerView.layer.masksToBounds = YES;
    self.containerView.clipsToBounds = YES;
    self.containerView.layer.borderColor = [UIColor darkGrayColor].CGColor;
    self.containerView.layer.borderWidth = 1;
    self.containerView.layer.shadowColor = [UIColor blackColor].CGColor;
    self.containerView.layer.shadowOffset = CGSizeMake(0, 10);
    
    if (self.rumor) {
        self.rumorLabel.text = self.rumor.content;
    }
}

- (void)setRumor:(DlRumor *)rumor {
    _rumor = rumor;
    self.rumorLabel.text = self.rumor.content;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)drawRect:(CGRect)rect
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSaveGState(context);
    CGContextSetShadowWithColor(context, CGSizeMake(0, 0), 10,
                                [UIColor blueColor].CGColor);
    [super drawRect:rect];
    CGContextRestoreGState(context);
}

//- (UIFont *)rumorFont {
//    return self.rumorLabel.font;
//}
//
//- (int)maxRumorLines {
//    return self.rumorLabel.numberOfLines;
//}
//
//- (CGFloat)rumorWidth {
//    return self.rumorLabel.frame.size.width;
//}

@end
