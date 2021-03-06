//
//  ExpenseDetailViewController.h
//  StartUpCalculator
//
//  Created by Tom on 5/8/14.
//  Copyright (c) 2014 Tom Liu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Expenses.h"
#import "NewExpenseTableViewController.h"

@interface ExpenseDetailViewController : UIViewController

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *fromLabel;
@property (weak, nonatomic) IBOutlet UILabel *amountLabel;
@property (weak, nonatomic) IBOutlet UILabel *recurringAmountLabel;
@property (weak, nonatomic) IBOutlet UIImageView *typeImage;
@property (weak, nonatomic) IBOutlet UITextView *notesTextView;
@property (weak, nonatomic) IBOutlet UILabel *recurUntilLabel;
@property (weak, nonatomic) IBOutlet UIView *recurringView;
@property (weak, nonatomic) IBOutlet UIView *noteUIView;

@property (strong, nonatomic)Expenses *expenseToShowDetail;
@property (strong, nonatomic)Projects *projectToAdd;
@property (strong, nonatomic)Periods *periodToAdd;
@end
