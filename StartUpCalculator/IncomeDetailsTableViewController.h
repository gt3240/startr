//
//  IncomeDetailsTableViewController.h
//  StartUpCalculator
//
//  Created by Tom on 3/31/14.
//  Copyright (c) 2014 Tom Liu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Incomes.h"
#import "NewIncomeTableViewController.h"



@interface IncomeDetailsTableViewController : UITableViewController<editIncomeDelegate>

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *fromLabel;
@property (weak, nonatomic) IBOutlet UILabel *amountLabel;
@property (weak, nonatomic) IBOutlet UILabel *recurringAmountLabel;
@property (weak, nonatomic) IBOutlet UILabel *recurringLabel;


@property (strong, nonatomic)NSMutableArray *incomeToShowDetail;


@end
