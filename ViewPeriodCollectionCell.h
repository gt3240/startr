//
//  ViewPeriodCollectionCell.h
//  StartUpCalculator
//
//  Created by Tom on 3/28/14.
//  Copyright (c) 2014 Tom Liu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewPeriodCollectionCell : UICollectionViewCell

@property (weak, nonatomic) IBOutlet UILabel *periodLabel;

@property (nonatomic) BOOL buttonSelected;

-(void)setButtonSelected:(BOOL)buttonSelected;


@end
