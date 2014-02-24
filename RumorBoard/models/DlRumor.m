//
//  DlRumor.m
//  RumorBoard
//
//  Created by David Wu on 19/02/2014.
//  Copyright (c) 2014 David Wu. All rights reserved.
//

#import "DlRumor.h"


@implementation DlRumor

static const float FONT_SIZE = 15;
float _heightPerLine = -1;

- (float)heightPerLine {
    NSDictionary *stringAttributes = [NSDictionary dictionaryWithObject:[UIFont systemFontOfSize:FONT_SIZE]
                                                                 forKey: NSFontAttributeName];
    
    if (_heightPerLine <= 0) {
        CGSize expectedLabelSize = [@"WgL" boundingRectWithSize:CGSizeMake(280, MAXFLOAT)
                                                        options:NSStringDrawingTruncatesLastVisibleLine|NSStringDrawingUsesLineFragmentOrigin
                                                     attributes:stringAttributes
                                                        context:nil].size;
        
        _heightPerLine = expectedLabelSize.height;
    }
    
    return _heightPerLine;
}

- (float)cellHeight {
    float height = -1;
    height = (50 + 1 + 10 + 10) * 2;
    
    NSDictionary *stringAttributes = [NSDictionary dictionaryWithObject:[UIFont systemFontOfSize:FONT_SIZE]
                                                                 forKey: NSFontAttributeName];

    CGSize expectedLabelSize = [self.content boundingRectWithSize:CGSizeMake(280, MAXFLOAT)
                                                          options:NSStringDrawingTruncatesLastVisibleLine|NSStringDrawingUsesLineFragmentOrigin
                                                       attributes:stringAttributes
                                                          context:nil].size;

    height += expectedLabelSize.height;
    
    if (self.expended) {
        height += 100;
        
//        for (self.)
    }

    return height;
}


BOOL _expended = FALSE;
- (void)setExpended:(BOOL)expended {
    _expended = expended;
}
- (BOOL)expended {
    return _expended;
}

@end
