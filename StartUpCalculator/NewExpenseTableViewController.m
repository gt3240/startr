//
//  NewExpenseTableViewController.m
//  StartUpCalculator
//
//  Created by Tom on 5/8/14.
//  Copyright (c) 2014 Tom Liu. All rights reserved.
//

#import "NewExpenseTableViewController.h"
#import "InnerBand.h"
#import "ExpenseTypeCollectionViewController.h"
#import "IncomeAndExpenseType.h"

@interface NewExpenseTableViewController ()
{
    NSString *ExpenseTypeStr;
    IncomeAndExpenseType *expenseTypeObj;
    NSNumber * shouldRecurr;
    Expenses * addExpense;
    float startingAmount;
    float newAmount;
    NSDate * recurringDateID;
    BOOL deleteRecur;
    UIAlertView *recurAlert;
}
@end

@implementation NewExpenseTableViewController

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
    
    expenseTypeObj = [[IncomeAndExpenseType alloc]init];
    
    if (self.expenseToEdit){
        self.title = @"Edit";
        self.titleTextField.text = self.expenseToEdit.title;
        self.amountTextField.text = [NSString stringWithFormat:@"%@", self.expenseToEdit.amount];
        self.sourceLabel.text = self.expenseToEdit.source;
        expenseTypeObj.typeTitle = self.expenseToEdit.type;
        //self.IncomeTypeLabel.text = incomeTypeStr;
        self.TypeLabel.text = expenseTypeObj.typeTitle;
        
        if ([self.expenseToEdit.recurring intValue] == 1){
            shouldRecurr = @1;
            [self.recurringSwitch setOn:YES];
            deleteRecur = NO;
            if ([self.expenseToEdit.recurringType isEqualToString:@"fixedAmount"]){
                self.recurringType.selectedSegmentIndex = 0;
                self.recurringAmount.text = [NSString stringWithFormat:@"%@", self.expenseToEdit.recurringAmount];
            } else {
                self.recurringType.selectedSegmentIndex = 1;
                self.recurringAmount.text = [NSString stringWithFormat:@"%@", self.expenseToEdit.recurringAmount];
            }
            
            //self.recurringPeriodTextfield.text = [NSString stringWithFormat:@"%@", self.expenseToEdit.recurringPeriod];
            
        } else {
            [self.recurringSwitch setOn:NO];
            shouldRecurr = 0;
        }
    } else {
        addExpense = [Expenses create];
        recurringDateID = [NSDate date];
    }
    
    //NSLog(@"period id is %@", self.periodToAdd.periodNum);
    
}

-(void)viewWillAppear:(BOOL)animated
{
    NSLog(@"income type is %@", expenseTypeObj.typeTitle);
    
    if (expenseTypeObj) {
        self.TypeLabel.text = expenseTypeObj.typeTitle;
    } else {
        self.TypeLabel.text = @"";
    }
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)donePressed:(UIBarButtonItem *)sender {
    if (self.expenseToEdit){
        
        //First update period income total
        NSNumber * previousTotal = self.expenseToEdit.period.expenseTotal;
        NSNumber * incomeBeforeChange = self.expenseToEdit.amount;
        NSNumber * incomeAfterChange = [NSNumber numberWithFloat: self.amountTextField.text.floatValue];
        self.expenseToEdit.period.expenseTotal = @([previousTotal floatValue] -[incomeBeforeChange floatValue] + [incomeAfterChange floatValue]);
        
        self.expenseToEdit.title = self.titleTextField.text;
        
        self.expenseToEdit.source = self.sourceLabel.text;
        
        self.expenseToEdit.amount = [NSNumber numberWithFloat: self.amountTextField.text.floatValue];
        
        self.expenseToEdit.type = expenseTypeObj.typeTitle;
        
        if (deleteRecur == YES ) {
            [self deleteFutureRecurs:self.expenseToEdit.recurringDateID];
        } else {
            self.expenseToEdit.recurring = self.expenseToEdit.recurring;
            
            self.expenseToEdit.recurringAmount = [NSNumber numberWithFloat: self.recurringAmount.text.floatValue];
            
            self.expenseToEdit.recurringPeriod = [NSNumber numberWithFloat: self.recurringPeriodTextField.text.floatValue];
        }
        
        [[IBCoreDataStore mainStore] save];
        
        [self dismissViewControllerAnimated:YES completion:nil];
        
    } else {
        if ([self validateInputs] == YES) {
            //First update period income total
            startingAmount = self.amountTextField.text.floatValue;
            
            newAmount = startingAmount;
            
            if ([shouldRecurr isEqualToNumber:@1]) {
                [self setRecurringInfoFor:addExpense];
                
            } else {
                [self createNewExpense:addExpense toPeriod:self.periodToAdd withAmount:self.amountTextField.text.floatValue];
            }
            [self.periodToAdd addExpenseObject:addExpense];
            
            [[IBCoreDataStore mainStore] save];
            
            [self.addExpenseDelegate expenseAdded];
            
            [self dismissViewControllerAnimated:YES completion:nil];
        }
        
    }
    
}

-(BOOL)validateInputs
{
    if ([self.titleTextField.text isEqualToString: @""]) {
        UIAlertView *myAlert = [[UIAlertView alloc] initWithTitle:@"Oops" message:@"Please enter a title" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil,nil];
        [myAlert show];
        return NO;
    }
    else
    {
        return YES;
    }
}

- (void)deleteFutureRecurs: (NSDate *)thisID
{
    //load projects periods
    NSSortDescriptor *sort = [NSSortDescriptor sortDescriptorWithKey:@"periodNum" ascending:YES];
    NSArray * pInProjectArr = [self.projectToAdd.period sortedArrayUsingDescriptors:@[sort]];
    //NSLog(@"pInProjectArr count is %lu", (unsigned long)pInProjectArr.count);
    //NSLog(@"this pInProjectArr count is %lu", (unsigned long)self.projectToAdd.period.count);
    
    for (int i = self.periodToAdd.periodNum.intValue; i < pInProjectArr.count; i++) {
        //NSLog(@"this p is %lu", (unsigned long)self.periodToAdd.periodNum.intValue);
        
        Periods *thisP = pInProjectArr[i];
        
        NSSortDescriptor *sortIncome = [NSSortDescriptor sortDescriptorWithKey:@"title" ascending:YES];
        NSArray * expenseArr = [thisP.income sortedArrayUsingDescriptors:@[sortIncome]];
        
        for (int x = 0; x < expenseArr.count; x++) {
            //NSLog(@"income count is %lu", (unsigned long)thisP.income.count);
            
            Expenses *thisI = expenseArr[x];
            
            if ([thisI.recurringDateID isEqual: thisID]) {
                //NSLog(@" same found");
                [thisP removeExpenseObject:thisI];
                // update total
                NSNumber * previousTotal = thisP.expenseTotal;
                NSNumber * thisAmount = thisI.amount;
                
                thisP.expenseTotal = @([previousTotal floatValue] - [thisAmount floatValue]);
            } else {
                //NSLog(@"nada found");
            }
        }
    }
}

- (void)setRecurringInfoFor:(Expenses *)thisExpense
{
    thisExpense.recurring = shouldRecurr;
    thisExpense.recurringAmount = [NSNumber numberWithFloat:self.recurringAmount.text.floatValue];
    thisExpense.recurringPeriod = [NSNumber numberWithInt:self.recurringPeriodTextField.text.intValue];
    if (self.recurringType.selectedSegmentIndex == 0) {
        thisExpense.recurringType = @"fixedAmount";
    } else {
        thisExpense.recurringType = @"percentage";
    }
    
    //Get how many periods are in the projects
    
    NSSortDescriptor *sort = [NSSortDescriptor sortDescriptorWithKey:@"periodNum" ascending:YES];
    
    NSArray * pInProjectArr = [self.projectToAdd.period sortedArrayUsingDescriptors:@[sort]];
    
    for (int i = self.periodToAdd.periodNum.intValue; i < self.recurringPeriodTextField.text.intValue + self.periodToAdd.periodNum.intValue; i++) {
        
        if (i <= pInProjectArr.count) {
            // add new income to current period
            if (i == self.periodToAdd.periodNum.intValue) {
                [self createNewExpense:thisExpense toPeriod:self.periodToAdd withAmount:startingAmount];
            } else {
                // add income to next other periods
                Periods *nextP = pInProjectArr[i - 1];
                Expenses *newExpense = [Expenses create];
                if (self.recurringType.selectedSegmentIndex == 0) {
                    newAmount += self.recurringAmount.text.floatValue;
                } else {
                    newAmount = newAmount + newAmount * self.recurringAmount.text.floatValue / 100;
                }
                [self createNewExpense:newExpense toPeriod:nextP withAmount:newAmount];
            }
        } else {
            // add new period then add income
            Periods *newPeriod;
            newPeriod = [Periods create];
            newPeriod.periodNum = [NSNumber numberWithInt:i];
            newPeriod.projects = self.projectToAdd;
            Expenses *newExpense = [Expenses create];
            if (self.recurringType.selectedSegmentIndex == 0) {
                newAmount += self.recurringAmount.text.floatValue;
            } else {
                newAmount = newAmount + newAmount * self.recurringAmount.text.floatValue /100;
            }
            [self createNewExpense:newExpense toPeriod:newPeriod withAmount:newAmount];
        }
    }
}

- (void)createNewExpense: (Expenses *)expense toPeriod: (Periods *)thisPeriod withAmount:(float)incomeAmount
{
    NSNumber * previousTotal = thisPeriod.expenseTotal;
    
    //NSNumber * incomeAfterChange = [NSNumber numberWithFloat: self.amountTextField.text.floatValue];
    
    thisPeriod.expenseTotal = @([previousTotal floatValue] + newAmount);
    
    expense.amount = [NSNumber numberWithFloat: incomeAmount];
    
    expense.title = self.titleTextField.text;
    
    expense.source = self.sourceLabel.text;
    
    expense.type = expenseTypeObj.typeTitle;
    
    if ([shouldRecurr isEqualToNumber:@1]) {
        expense.recurring = @1;
        
        expense.recurringType = addExpense.recurringType;
        
        expense.recurringDateID = recurringDateID;
        
        expense.recurringAmount = [NSNumber numberWithFloat:self.recurringAmount.text.floatValue];
        
        expense.recurringEndPeriod = [NSNumber numberWithInt:self.recurringPeriodTextField.text.intValue + self.periodToAdd.periodNum.intValue - 1];
    } else {
        expense.recurring = 0;
    }
    
    expense.period = thisPeriod;
    
}

- (IBAction)canclePressed:(UIBarButtonItem *)sender {
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)recurringSwitched:(UISwitch *)sender {
        
    if ([sender isOn]) {
        shouldRecurr = @1;
    } else {
        shouldRecurr = @0;
    }
    [self.tableView reloadData];
    
    if ([self.expenseToEdit.recurring isEqual: @1]) {
        if (![sender isOn]) {
            recurAlert = [[UIAlertView alloc] initWithTitle:@"Warning" message:@"All future recurring income will be deleted, are you sure?" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Yes",nil];
            [recurAlert show];
        }
    }
    
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView == recurAlert) {
        if (buttonIndex == 0) {
            NSLog(@"cancle clicked");
            [self.recurringSwitch setOn:YES];
            shouldRecurr = @1;
            [self.tableView reloadData];
        } else {
            deleteRecur = YES;
            [self deleteFutureRecurs:self.expenseToEdit.recurringDateID];
        }
        
    }
}

- (IBAction)recurringTypeChanged:(UISegmentedControl *)sender {
    
    if (self.expenseToEdit){
        
        if (sender.selectedSegmentIndex == 0) {
            self.expenseToEdit.recurringType = @"fixedAmount";
            
        } else {
            self.expenseToEdit.recurringType = @"percentage";
        }
    } else {
        if (sender.selectedSegmentIndex == 0) {
            addExpense.recurringType = @"fixedAmount";
            
        } else {
            addExpense.recurringType = @"percentage";
        }
    }
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSInteger count = [super tableView:tableView numberOfRowsInSection:section];
    
    if(self.expenseToEdit){
        if (section == 1) {
            if ([shouldRecurr  isEqual: @1]) {
                return 1;
            } else {
                return 0;
            }
        }
    } else {
        if (section == 1) {
            if ([shouldRecurr  isEqual: @1]) {
                return 4;
            } else {
                return 1;
            }
        }
    }
    
    return count;
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"expenseTypeSegue"]) {
        
        ExpenseTypeCollectionViewController * destination = segue.destinationViewController;
        destination.selectExpenseTypeObj = expenseTypeObj;
    }
}


@end