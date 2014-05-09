//
//  ExpenseTypeCollectionCell.h
//  StartUpCalculator
//
//  Created by Tom on 5/8/14.
//  Copyright (c) 2014 Tom Liu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ExpenseTypeCollectionCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UIImageView *TypeImage;
@property (weak, nonatomic) IBOutlet UILabel *TypeTitleLabel;
@end
