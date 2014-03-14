//
//  DlRumorCell.m
//  RumorBoard
//
//  Created by David Wu on 19/02/2014.
//  Copyright (c) 2014 David Wu. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>

#import <Block.h>

#import "DlRumorCell.h"
#import "DlRumor.h"
#import "DlRumorPoll.h"
#import "DlConfig.h"
#import "DlAPIManager.h"
#import "DSBarChart.h"
#import "DlBarChartView.h"
#import "DlAPIManager.h"


@interface DlRumorCell ()

@property (weak, nonatomic) IBOutlet UIView *containerView;
@property (weak, nonatomic) IBOutlet UIImageView *userImageView;
@property (weak, nonatomic) IBOutlet UILabel *userNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *createDateLabel;
@property (weak, nonatomic) IBOutlet UILabel *rumorContent;
@property (weak, nonatomic) IBOutlet UILabel *rumorTitle;
@property (weak, nonatomic) IBOutlet UIButton *commentsButton;
@property (weak, nonatomic) IBOutlet UIButton *thumbUpButton;
@property (weak, nonatomic) IBOutlet UIButton *thumbDownButton;
@property (weak, nonatomic) IBOutlet UIView *footerView;
@property (weak, nonatomic) IBOutlet UIImageView *rumorImageView;

@property (nonatomic, strong) DSBarChart *bartChart;

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

    self.containerView.layer.cornerRadius = 4;
//    self.containerView.layer.masksToBounds = YES;
    self.containerView.clipsToBounds = YES;
    self.containerView.layer.borderColor = [UIColor darkGrayColor].CGColor;
    self.containerView.layer.borderWidth = 1;
    self.containerView.layer.shadowColor = [UIColor blackColor].CGColor;
    self.containerView.layer.shadowOffset = CGSizeMake(0, 10);
    
    if (self.rumor) {
        self.rumorContent.text = self.rumor.content;
        [self updateUI];
    }

    if (self.rumor.poll.count > 0) {
        int a = 0;
    }
}

- (void)setRumor:(DlRumor *)rumor {
    _rumor = rumor;
    [self updateUI];
}

- (void)updateUI {
    if (!self.rumor)
        return;
    
    [self.bartChart removeFromSuperview];
    
    self.rumorContent.text = self.rumor.content;
    self.rumorTitle.text = self.rumor.title;
    self.createDateLabel.text = [[DlConfig sharedConfig].dateFormatter stringFromDate:self.rumor.updated_at];
    NSString *commentsString = [self.rumor.commentCount description];
    [self.commentsButton setTitle:commentsString forState:UIControlStateNormal];
    [self.thumbUpButton setTitle:[self.rumor.thumbsUpCount stringValue] forState:UIControlStateNormal];
    [self.thumbDownButton setTitle:[self.rumor.thumbsDownCount stringValue] forState:UIControlStateNormal];
    
    self.rumorImageView.hidden = self.rumor.poll.count > 0;

    if (self.rumor.poll.count > 0) {
//        self.rumorContent.height -= kPollSize + kPollMargin*2;

//        CGRect frame = CGRectMake((self.width - kPollSize)/2, self.height - self.footerView.height - kPollSize - kPollMargin, kPollSize, kPollSize);
        CGRect frame = self.rumorImageView.frame;
        
        NSMutableArray *vals = [NSMutableArray array];
        NSMutableArray *refs = [NSMutableArray array];
        
        for (DlRumorPoll *poll in self.rumor.poll) {
//            poll.rumorPollUserCount = [NSNumber numberWithInt:(rand() % 40) + 10];                       // TESTING
            [vals addObject:poll.rumorPollUserCount];
            [refs addObject:poll.name];
        }
        
        DSBarChart *bartChart = [[DSBarChart alloc] initWithFrame:frame
                                                       color:[UIColor greenColor]
                                                  references:refs
                                                   andValues:vals];
//        bartChart.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        frame.origin.x = 0;
        frame.origin.y = 0;
//        bartChart.bounds = frame;
        [self.containerView addSubview:bartChart];
        
        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] bk_initWithHandler:^(UIGestureRecognizer *sender, UIGestureRecognizerState state, CGPoint location) {
            UIAlertView *alert = [UIAlertView bk_alertViewWithTitle:@"Please Vote:"];
            [alert bk_setCancelButtonWithTitle:@"Cancel" handler:^{
            }];
            
            for (DlRumorPoll *poll in self.rumor.poll) {
                [alert bk_addButtonWithTitle:poll.name handler:^{
                    [[DlAPIManager sharedManager] setRumorPoll:self.rumor.id.intValue
                                                  pollColumnId:poll.id.intValue
                                                      callback:^(NSObject *payload, NSError *error) {
                                                          [self updateRumor];
                    }];
                }];
            }
            
            [alert show];
        }];
        [bartChart addGestureRecognizer:tapGesture];
        self.bartChart = bartChart;
    }
}

- (void)updateRumor {
    [[DlAPIManager sharedManager] getRumor:self.rumor.id.intValue callback:^(NSObject *payload, NSError *error) {
        if (![payload isKindOfClass:[NSDictionary class]]) {
            return;
        }
        
        NSData *jsonData = [NSJSONSerialization dataWithJSONObject:(NSDictionary *)payload
                                                           options:NSJSONWritingPrettyPrinted
                                                             error:nil];
        
        NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
        
        DlRumor *rumor = [[DlRumor alloc] initWithString:jsonString error:nil];
        if (rumor != nil) {
            self.rumor = rumor;
        }
    }];
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
