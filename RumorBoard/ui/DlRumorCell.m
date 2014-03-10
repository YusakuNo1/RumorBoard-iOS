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
#import "DlConfig.h"
#import "DlAPIManager.h"


@interface DlRumorCell ()

@property (weak, nonatomic) IBOutlet UIView *containerView;
@property (weak, nonatomic) IBOutlet UIImageView *userImageView;
@property (weak, nonatomic) IBOutlet UILabel *userNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *createDateLabel;
@property (weak, nonatomic) IBOutlet UILabel *rumorLabel;
@property (weak, nonatomic) IBOutlet UIButton *commentsButton;
@property (weak, nonatomic) IBOutlet UIButton *thumbUpButton;
@property (weak, nonatomic) IBOutlet UIButton *thumbDownButton;

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
        [self updateUI];
    }
}

- (void)setRumor:(DlRumor *)rumor {
    _rumor = rumor;
    [self updateUI];
}

- (void)updateUI {
    if (!self.rumor)
        return;
    
    self.rumorLabel.text = self.rumor.content;
    self.createDateLabel.text = [[DlConfig sharedConfig].dateFormatter stringFromDate:self.rumor.updated_at];
    NSString *commentsString = [NSString stringWithFormat:@"%@ Comment%@", self.rumor.commentCount, self.rumor.commentCount.intValue == 1 ? @"" : @"s"];
    [self.commentsButton setTitle:commentsString forState:UIControlStateNormal];
    [self.thumbUpButton setTitle:[self.rumor.thumbsUpCount stringValue] forState:UIControlStateNormal];
    [self.thumbDownButton setTitle:[self.rumor.thumbsDownCount stringValue] forState:UIControlStateNormal];
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

- (IBAction)onTapComments:(id)sender {
}

- (IBAction)onTapThumbsUp:(id)sender {
    [[DlAPIManager sharedManager] setRumorThumbs:self.rumor.id.intValue isUp:YES callback:^(NSObject *payload, NSError *error) {
        NSDictionary *dict = (NSDictionary *)payload;
        self.rumor.thumbsUpCount = [dict objectForKey:@"thumbsUpCount"];
        self.rumor.thumbsDownCount = [dict objectForKey:@"thumbsDownCount"];
        [self updateUI];
    }];
}

- (IBAction)onTapThumbsDown:(id)sender {
    [[DlAPIManager sharedManager] setRumorThumbs:self.rumor.id.intValue isUp:NO callback:^(NSObject *payload, NSError *error) {
        NSDictionary *dict = (NSDictionary *)payload;
        self.rumor.thumbsUpCount = [dict objectForKey:@"thumbsUpCount"];
        self.rumor.thumbsDownCount = [dict objectForKey:@"thumbsDownCount"];
        [self updateUI];
    }];
}

@end
