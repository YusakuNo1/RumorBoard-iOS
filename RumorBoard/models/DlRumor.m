//
//  DlRumor.m
//  RumorBoard
//
//  Created by David Wu on 19/02/2014.
//  Copyright (c) 2014 David Wu. All rights reserved.
//

#import "DlRumor.h"

@implementation DlRumor

const int MAX_LINES = 5;
float _heightPerLine = -1;

- (float)cellHeight {
    float height = -1;
    height = (50 + 1 + 10 + 10) * 2;
    
    NSDictionary *stringAttributes = [NSDictionary dictionaryWithObject:[UIFont systemFontOfSize:17]
                                                                 forKey: NSFontAttributeName];
    
    if (_heightPerLine <= 0) {
        CGSize expectedLabelSize = [@"WgL" boundingRectWithSize:CGSizeMake(280, MAXFLOAT)
                                                        options:NSStringDrawingTruncatesLastVisibleLine|NSStringDrawingUsesLineFragmentOrigin
                                                     attributes:stringAttributes
                                                        context:nil].size;

        _heightPerLine = expectedLabelSize.height;
    }
    
    CGSize expectedLabelSize = [self.content boundingRectWithSize:CGSizeMake(280, MAXFLOAT)
                                                          options:NSStringDrawingTruncatesLastVisibleLine|NSStringDrawingUsesLineFragmentOrigin
                                                       attributes:stringAttributes
                                                          context:nil].size;

    height += MIN(expectedLabelSize.height, _heightPerLine * MAX_LINES);

    return height;
}

//- (float)cellHeightWithFont:(UIFont *)font maxLines:(int)maxLines width:(CGFloat)width {
//    float height = -1;
//    height = (50 + 1 + 10 + 10) * 2;
//    
//    NSDictionary *stringAttributes = [NSDictionary dictionaryWithObject:font
//                                                                 forKey: NSFontAttributeName];
//    
//    if (_heightPerLine <= 0) {
//        CGSize expectedLabelSize = [@"WgL" boundingRectWithSize:CGSizeMake(width, MAXFLOAT)
//                                                        options:NSStringDrawingTruncatesLastVisibleLine|NSStringDrawingUsesLineFragmentOrigin
//                                                     attributes:stringAttributes
//                                                        context:nil].size;
//        
//        _heightPerLine = expectedLabelSize.height;
//    }
//    
//    CGSize expectedLabelSize = [self.content boundingRectWithSize:CGSizeMake(width, MAXFLOAT)
//                                                          options:NSStringDrawingTruncatesLastVisibleLine|NSStringDrawingUsesLineFragmentOrigin
//                                                       attributes:stringAttributes
//                                                          context:nil].size;
//    
//    height += MIN(expectedLabelSize.height, _heightPerLine * MAX_LINES);
//    
//    return height;
//}

@end
