//
//  NewIncomeTableViewController.m
//  StartUpCalculator
//
//  Created by Tom on 3/31/14.
//  Copyright (c) 2014 Tom Liu. All rights reserved.
//

#import "NewIncomeTableViewController.h"
#import "Incomes.h"

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
    /*
    //NSLog(@"%lu", (unsigned long)self.incomeToEdit.count);
    Income *income = self.incomeToEdit[0];
    
    self.titleTextField.text = income.title;
    self.amountTextField.text = [NSString stringWithFormat:@"$%@", income.amount];
    self.sourceLabel.text = income.source;
    
    if (income.recurring == YES){
        
        [self.recurringSwitch setOn:YES];
        
        if ([income.recurring_type isEqualToString:@"fixedAmount"]){
            self.recurringType.selectedSegmentIndex = 0;
            self.recurringAmount.text = [NSString stringWithFormat:@"$%@", income.recurring_amount];
        } else {
            self.recurringType.selectedSegmentIndex = 1;
            self.recurringAmount.text = [NSString stringWithFormat:@"%@%%", income.recurring_amount];
        }
        
    } else {
        [self.recurringSwitch setOn:NO];
    }
     */
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)canclePressed:(UIBarButtonItem *)sender {
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
