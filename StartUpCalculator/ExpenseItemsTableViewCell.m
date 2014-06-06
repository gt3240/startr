//
//  ExpenseItemsTableViewCell.m
//  StartUpCalculator
//
//  Created by Tom on 5/8/14.
//  Copyright (c) 2014 Tom Liu. All rights reserved.
//

#import "ExpenseItemsTableViewCell.h"

@implementation ExpenseItemsTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)awakeFromNib
{
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
