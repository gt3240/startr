//
//  IncomeDetailViewController.h
//  StartUpCalculator
//
//  Created by Tom on 4/28/14.
//  Copyright (c) 2014 Tom Liu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Incomes.h"
#import "NewIncomeTableViewController.h"

@interface IncomeDetailViewController : UIViewController<editOrNewIncomeDelegate>

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@property (weak, nonatomic) IBOutlet UILabel *fromLabel;
@property (weak, nonatomic) IBOutlet UILabel *amountLabel;
@property (weak, nonatomic) IBOutlet UILabel *recurringAmountLabel;
@property (weak, nonatomic) IBOutlet UIImageView *typeImage;

@property (strong, nonatomic)Incomes *incomeToShowDetail;

@end
