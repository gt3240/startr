//
//  NewIncomeTableViewController.h
//  StartUpCalculator
//
//  Created by Tom on 3/31/14.
//  Copyright (c) 2014 Tom Liu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Incomes.h"

@protocol editIncomeDelegate <NSObject>


- (void)incomeEdited:(Incomes *)editedIncome;

@end


@interface NewIncomeTableViewController : UITableViewController


@property (strong, nonatomic)NSMutableArray *incomeToEdit;
@property (strong, nonatomic) id<editIncomeDelegate>  editDelegate;
@property (weak, nonatomic) IBOutlet UITextField *titleTextField;
@property (weak, nonatomic) IBOutlet UITextField *amountTextField;
@property (weak, nonatomic) IBOutlet UISwitch *recurringSwitch;
@property (weak, nonatomic) IBOutlet UITextField *recurringAmount;
@property (weak, nonatomic) IBOutlet UISegmentedControl *recurringType;
@property (weak, nonatomic) IBOutlet UILabel *recurringPeriod;
@property (weak, nonatomic) IBOutlet UISlider *recurringPeriodSlider;
@property (weak, nonatomic) IBOutlet UITextView *notes;
@property (weak, nonatomic) IBOutlet UITextField *sourceLabel;

@end
