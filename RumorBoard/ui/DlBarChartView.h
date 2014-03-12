//
//  DlBarChartView.h
//  RumorBoard
//
//  Created by David Wu on 11/03/2014.
//  Copyright (c) 2014 David Wu. All rights reserved.
//

#import <UIKit/UIKit.h>


@protocol DlBarChartViewItem <NSObject>

@end


@interface DlBarChartViewItem : NSObject

@property (nonatomic, strong) NSString *title;
@property (nonatomic) int count;

@end


@interface DlBarChartView : UIView

- (id)initWithFrame:(CGRect)frame items:(NSArray<DlBarChartViewItem> *)items;

@end
