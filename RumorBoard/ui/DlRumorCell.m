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
@property (weak, nonatomic) IBOutlet UILabel *rumorLabel;
@property (weak, nonatomic) IBOutlet UIButton *commentsButton;
@property (weak, nonatomic) IBOutlet UIButton *thumbUpButton;
@property (weak, nonatomic) IBOutlet UIButton *thumbDownButton;
@property (weak, nonatomic) IBOutlet UIView *footerView;

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
    
    self.rumorLabel.text = self.rumor.content;
//    self.userNameLabel.text = self.rumor.u
    self.createDateLabel.text = [[DlConfig sharedConfig].dateFormatter stringFromDate:self.rumor.updated_at];
    NSString *commentsString = [NSString stringWithFormat:@"%@ Comment%@", self.rumor.commentCount, self.rumor.commentCount.intValue == 1 ? @"" : @"s"];
    [self.commentsButton setTitle:commentsString forState:UIControlStateNormal];
    [self.thumbUpButton setTitle:[self.rumor.thumbsUpCount stringValue] forState:UIControlStateNormal];
    [self.thumbDownButton setTitle:[self.rumor.thumbsDownCount stringValue] forState:UIControlStateNormal];
    
    if (self.rumor.poll.count > 0) {
        self.rumorLabel.height -= kPollSize + kPollMargin*2;

    CGRect frame = CGRectMake((self.width - kPollSize)/2, self.height - self.footerView.height - kPollSize - kPollMargin, kPollSize, kPollSize);
        
//#define USE_CUSTOM_GRAPH
        
#ifdef USE_CUSTOM_GRAPH
        NSMutableArray<DlBarChartViewItem> *items = [@[] mutableCopy];
        
        for (DlRumorPoll *poll in self.rumor.poll) {
            DlBarChartViewItem *item = [[DlBarChartViewItem alloc] init];
            item.count = poll.rumorPollUserCount.integerValue;
//            item.count = (rand() % 40) + 10;                       // TESTING
            item.title = poll.name;
            [items addObject:item];
        }
        
        DlBarChartView *view = [[DlBarChartView alloc] initWithFrame:frame items:items];
        [self addSubview:view];
#else
//        NSArray *vals = [NSArray arrayWithObjects:
//                         [NSNumber numberWithInt:30],
//                         [NSNumber numberWithInt:40],
//                         [NSNumber numberWithInt:20],
//                         [NSNumber numberWithInt:56],
//                         [NSNumber numberWithInt:70],
//                         nil];
//        NSArray *refs = [NSArray arrayWithObjects:@"M", @"Tu", @"W", @"Th", @"F", nil];
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
        bartChart.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        frame.origin.x = 0;
        frame.origin.y = 0;
        bartChart.bounds = frame;
        [self addSubview:bartChart];
        
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
#endif
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
