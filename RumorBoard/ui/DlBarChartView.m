//
//  DlBarChartView.m
//  RumorBoard
//
//  Created by David Wu on 11/03/2014.
//  Copyright (c) 2014 David Wu. All rights reserved.
//

#import "DlBarChartView.h"


const CGFloat BAR_GAP = 40;
const int kColorPalette[] = { 0xFFFF0000, 0xFF00FF00, 0xFF0000FF, 0xFFFF00FF, 0xFF00FFFF };
const int kColorPaletteLen = sizeof(kColorPalette) / sizeof(int);


@implementation DlBarChartViewItem

@end


@interface DlBarChartView()

@property (nonatomic, strong) NSArray<DlBarChartViewItem> *items;

@end


@implementation DlBarChartView


- (id)initWithFrame:(CGRect)frame items:(NSArray<DlBarChartViewItem> *)items
{
    self = [super initWithFrame:frame];
    if (self) {
        self.items = items;
        NSAssert(items.count <= kColorPaletteLen, @"Too many items to be added in DlBarChartView");
    }
    return self;
}


- (void)willMoveToSuperview:(UIView *)newSuperview {
    [super willMoveToSuperview:newSuperview];

    [self setupGraph];
}

- (void)setupGraph {
    [self setupCoordinate:self.bounds];
    [self setupBars:self.bounds];
}

- (void)setupBars:(CGRect)frame {
    const int kMaxFactorArray[] = { 2, 3, 5, 10 };
    const int kMaxFactorArrayLen = sizeof(kMaxFactorArray) / sizeof(int);
    CGFloat itemMaxCount = 0;
    for (DlBarChartViewItem *item in self.items) {
        itemMaxCount = MAX(itemMaxCount, item.count);
    }
    
    int maxFactorIndex = 0;
    int maxFactorExp = 1;
    while (kMaxFactorArray[maxFactorIndex] * pow(10, maxFactorExp) < itemMaxCount) {
        maxFactorIndex++;
        if (maxFactorIndex >= kMaxFactorArrayLen) {
            maxFactorIndex = 0;
            maxFactorExp++;
        }
    }
    const CGFloat kMaxBarCount = kMaxFactorArray[maxFactorIndex] * pow(10, maxFactorExp);
    const CGFloat kBarWidth = floor((frame.size.width / self.items.count) - BAR_GAP);
    CGFloat x = BAR_GAP / 2;
    for (int i=0; i<self.items.count; ++i) {
        DlBarChartViewItem *item = [self.items objectAtIndex:i];
        const CGFloat count = (item.count / (CGFloat)kMaxBarCount) * frame.size.height;
        CGRect barFrame = CGRectMake(x, frame.size.height - count, kBarWidth, count);
        UIView *view = [[UIView alloc] initWithFrame:barFrame];
        view.backgroundColor = UIColorFromRGB(kColorPalette[i]);
        [self addSubview:view];
        x += kBarWidth + BAR_GAP;
    }
}

- (void)setupCoordinate:(CGRect)frame {
    
}


//- (void)drawRect:(CGRect)rect {
//    [super drawRect:rect];
//    
//    CGContextRef context = UIGraphicsGetCurrentContext();
//    CGContextSetFillColorWithColor(context, self.barColor.CGColor);
//    CGContextBeginPath(context);
//    CGContextAddRect(context, self.bounds);
//    CGContextFillPath(context);
//}


@end
