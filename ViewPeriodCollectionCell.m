//
//  ViewPeriodCollectionCell.m
//  StartUpCalculator
//
//  Created by Tom on 3/28/14.
//  Copyright (c) 2014 Tom Liu. All rights reserved.
//

#import "ViewPeriodCollectionCell.h"

@implementation ViewPeriodCollectionCell


-(void)setButtonSelected:(BOOL)buttonSelected
{
    _buttonSelected = buttonSelected;
    [self setNeedsDisplay];
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)drawRect:(CGRect)rect
{
    if (self.buttonSelected) {
        CGRect box = CGRectInset(self.bounds, self.bounds.size.width * 0.1f, self.bounds.size.height * 0.1f);
        
        UIBezierPath * circleBackGround = [UIBezierPath bezierPathWithOvalInRect:box];
        [[UIColor whiteColor] setFill];
        [circleBackGround fill];
        
        //[self.periodLabel setTextColor:[UIColor colorWithRed:30/255.0f green:156/255.0f blue:227/255.0f alpha:1.0f]];
    } else {
        [self.periodLabel setTextColor:[UIColor whiteColor]];
    }
    
}

@end
