//
//  NewIncomeTableViewController.h
//  StartUpCalculator
//
//  Created by Tom on 3/31/14.
//  Copyright (c) 2014 Tom Liu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Incomes.h"
#import "Periods.h"
#import "projects.h"

@protocol editOrNewIncomeDelegate <NSObject>

//-(void)incomeEdited:(Incomes *)editedIncome;

-(void)incomeAdded;
@end


@interface NewIncomeTableViewController : UITableViewController


@property (strong, nonatomic)Incomes *incomeToEdit;
@property (strong, nonatomic)Periods *periodToAdd;
@property (strong, nonatomic)Projects *projectToAdd;


@property (weak, nonatomic) IBOutlet UITextField *titleTextField;
@property (weak, nonatomic) IBOutlet UITextField *amountTextField;
@property (weak, nonatomic) IBOutlet UISwitch *recurringSwitch;
@property (weak, nonatomic) IBOutlet UITextField *recurringAmount;
@property (weak, nonatomic) IBOutlet UISegmentedControl *recurringType;
@property (weak, nonatomic) IBOutlet UITextField *recurringPeriodTextField;

@property (weak, nonatomic) IBOutlet UITextView *notes;
@property (weak, nonatomic) IBOutlet UITextField *sourceLabel;
@property (weak, nonatomic) IBOutlet UILabel *IncomeTypeLabel;

//@property (strong, nonatomic) id<editOrNewIncomeDelegate>  editIncomeDelegate;
@property (strong, nonatomic) id<editOrNewIncomeDelegate>  addIncomeDelegate;


@end
