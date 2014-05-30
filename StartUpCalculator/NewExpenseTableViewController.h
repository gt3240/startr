//
//  NewExpenseTableViewController.h
//  StartUpCalculator
//
//  Created by Tom on 5/8/14.
//  Copyright (c) 2014 Tom Liu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Expenses.h"
#import "Periods.h"
#import "projects.h"

@protocol editOrNewExpenseDelegate <NSObject>

-(void)expenseAdded;

@end

@interface NewExpenseTableViewController : UITableViewController

@property (strong, nonatomic)Expenses *expenseToEdit;
@property (strong, nonatomic)Periods *periodToAdd;
@property (strong, nonatomic)Projects *projectToAdd;


@property (weak, nonatomic) IBOutlet UITextField *titleTextField;
@property (weak, nonatomic) IBOutlet UITextField *amountTextField;
@property (weak, nonatomic) IBOutlet UISwitch *recurringSwitch;
@property (weak, nonatomic) IBOutlet UITextField *recurringAmount;
@property (weak, nonatomic) IBOutlet UISegmentedControl *recurringType;
@property (weak, nonatomic) IBOutlet UISegmentedControl *negOrPosSwitch;
@property (weak, nonatomic) IBOutlet UITextField *recurringPeriodTextField;

@property (weak, nonatomic) IBOutlet UITextView *notes;
@property (weak, nonatomic) IBOutlet UITextField *sourceLabel;
@property (weak, nonatomic) IBOutlet UILabel *TypeLabel;
@property (weak, nonatomic) IBOutlet UIImageView *typeImage;

@property (strong, nonatomic) id<editOrNewExpenseDelegate>  addExpenseDelegate;

@end
