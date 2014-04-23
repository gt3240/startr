//
//  NewIncomeTableViewController.m
//  StartUpCalculator
//
//  Created by Tom on 3/31/14.
//  Copyright (c) 2014 Tom Liu. All rights reserved.
//

#import "NewIncomeTableViewController.h"
#import "InnerBand.h"

@interface NewIncomeTableViewController ()

@end

@implementation NewIncomeTableViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    if (self.incomeToEdit){
        
        self.titleTextField.text = self.incomeToEdit.title;
        self.amountTextField.text = [NSString stringWithFormat:@"%@", self.incomeToEdit.amount];
        self.sourceLabel.text = self.incomeToEdit.source;
        
        if ([self.incomeToEdit.recurring intValue] == 1){
            
            [self.recurringSwitch setOn:YES];
            
            if ([self.incomeToEdit.recurringType isEqualToString:@"fixedAmount"]){
                self.recurringType.selectedSegmentIndex = 0;
                self.recurringAmount.text = [NSString stringWithFormat:@"%@", self.incomeToEdit.recurringAmount];
            } else {
                self.recurringType.selectedSegmentIndex = 1;
                self.recurringAmount.text = [NSString stringWithFormat:@"%@", self.incomeToEdit.recurringAmount];
            }
            
            //self.recurringPeriodTextfield.text = [NSString stringWithFormat:@"%@", self.incomeToEdit.recurringPeriod];
            
        } else {
            [self.recurringSwitch setOn:NO];
        }
    }
    
    NSLog(@"period id is %@", self.periodToAdd.periodNum);
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)donePressed:(UIBarButtonItem *)sender {
    if (self.incomeToEdit){
        
        //First update period income total
        NSNumber * previousTotal = self.incomeToEdit.period.incomeTotal;
        NSNumber * incomeBeforeChange = self.incomeToEdit.amount;
        NSNumber * incomeAfterChange = [NSNumber numberWithFloat: self.amountTextField.text.floatValue];
        self.incomeToEdit.period.incomeTotal = @([previousTotal floatValue] -[incomeBeforeChange floatValue] + [incomeAfterChange floatValue]);
        
        self.incomeToEdit.title = self.titleTextField.text;
        
        self.incomeToEdit.source = self.sourceLabel.text;
        
        self.incomeToEdit.amount = [NSNumber numberWithFloat: self.amountTextField.text.floatValue];
        
        self.incomeToEdit.recurring = self.incomeToEdit.recurring;
        
        self.incomeToEdit.recurringAmount = [NSNumber numberWithFloat: self.recurringAmount.text.floatValue];
        
        self.incomeToEdit.recurringPeriod = [NSNumber numberWithFloat: self.recurringPeriodTextField.text.floatValue];
        
        [[IBCoreDataStore mainStore] save];
        
        [self dismissViewControllerAnimated:YES completion:nil];
        
    } else {
        
        Incomes * addIncome = [Incomes create];
        
        //First update period income total
        NSNumber * previousTotal = self.periodToAdd.incomeTotal;
    
        NSNumber * incomeAfterChange = [NSNumber numberWithFloat: self.amountTextField.text.floatValue];
        self.periodToAdd.incomeTotal = @([previousTotal floatValue] + [incomeAfterChange floatValue]);
        
        addIncome.amount = [NSNumber numberWithFloat: self.amountTextField.text.floatValue];;
    
        addIncome.title = self.titleTextField.text;
        
        [self.periodToAdd addIncomeObject:addIncome];
        
        [[IBCoreDataStore mainStore] save];
        
        [self.addIncomeDelegate incomeAdded];
        
        [self dismissViewControllerAnimated:YES completion:nil];
    }
    
}

- (IBAction)canclePressed:(UIBarButtonItem *)sender {
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)recurringSwitched:(UISwitch *)sender {
    
    if (self.incomeToEdit){
        
        if ([sender isOn]) {
            self.incomeToEdit.recurring = @1;
        } else {
            self.incomeToEdit.recurring = 0;
        }
    }
    
}

- (IBAction)recurringTypeChanged:(UISegmentedControl *)sender {
    
    if (self.incomeToEdit){
        
        if (sender.selectedSegmentIndex == 0) {
            self.incomeToEdit.recurringType = @"fixedAmount";
            
        } else {
            self.incomeToEdit.recurringType = @"percentage";
            
        }
    }

}

@end
