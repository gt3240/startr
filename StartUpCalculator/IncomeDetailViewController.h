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

@interface IncomeDetailViewController : UIViewController

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@property (weak, nonatomic) IBOutlet UILabel *fromLabel;
@property (weak, nonatomic) IBOutlet UILabel *amountLabel;
@property (weak, nonatomic) IBOutlet UILabel *recurringAmountLabel;
@property (weak, nonatomic) IBOutlet UIImageView *typeImage;
@property (weak, nonatomic) IBOutlet UILabel *changeByLabel;
@property (weak, nonatomic) IBOutlet UIImageView *nonRepeatImg;

@property (strong, nonatomic)Incomes *incomeToShowDetail;
@property (weak, nonatomic) IBOutlet UITextView *notesTextView;
@property (weak, nonatomic) IBOutlet UILabel *recurUntilLabel;
@property (weak, nonatomic) IBOutlet UIView *noteUIView;
@property (weak, nonatomic) IBOutlet UIView *recurringView;

@property (strong, nonatomic)Projects *projectToAdd;
@property (strong, nonatomic)Periods *periodToAdd;
@end
