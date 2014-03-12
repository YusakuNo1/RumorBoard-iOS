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
    
    if (self.poll.count > 0) {
        height += kPollSize + kPollMargin*2;
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


-(id)initWithString:(NSString*)string error:(JSONModelError**)err
{
    return [super initWithString:string error:err];
}


-(NSDate*)NSDateFromNSString:(NSString*)string
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    string = [string stringByReplacingOccurrencesOfString:@":" withString:@""]; // this is such an ugly code, is this the only way?
    [dateFormatter setDateFormat:@"yyyy-MM-dd'T'HHmmssZZZZ"];
    
    return [dateFormatter dateFromString: string];
}


@end
