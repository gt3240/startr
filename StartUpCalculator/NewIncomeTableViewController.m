//
//  NewIncomeTableViewController.m
//  StartUpCalculator
//
//  Created by Tom on 3/31/14.
//  Copyright (c) 2014 Tom Liu. All rights reserved.
//

#import "NewIncomeTableViewController.h"
#import "InnerBand.h"
#import "IncomeTypeCollectionViewController.h"
#import "IncomeAndExpenseType.h"

@interface NewIncomeTableViewController ()
{
    NSString *incomeTypeStr;
    IncomeAndExpenseType *incomeTypeObj;
    NSNumber * shouldRecurr;
    Incomes * addIncome;
    float startingAmount;
    float newAmount;
    NSDate * recurringDateID;
    BOOL deleteRecur;
    UIAlertView *recurAlert;
}
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
    
    incomeTypeObj = [[IncomeAndExpenseType alloc]init];
    
    if (self.incomeToEdit){
        
        self.titleTextField.text = self.incomeToEdit.title;
        self.amountTextField.text = [NSString stringWithFormat:@"%@", self.incomeToEdit.amount];
        self.sourceLabel.text = self.incomeToEdit.source;
        incomeTypeObj.typeTitle = self.incomeToEdit.type;
        //self.IncomeTypeLabel.text = incomeTypeStr;
        self.IncomeTypeLabel.text = incomeTypeObj.typeTitle;
        
        if ([self.incomeToEdit.recurring intValue] == 1){
            shouldRecurr = @1;
            [self.recurringSwitch setOn:YES];
            deleteRecur = NO;
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
            shouldRecurr = 0;
        }
    } else {
        addIncome = [Incomes create];
        recurringDateID = [NSDate date];
    }
    
    //NSLog(@"period id is %@", self.periodToAdd.periodNum);
    
}

-(void)viewWillAppear:(BOOL)animated
{
    NSLog(@"income type is %@", incomeTypeObj.typeTitle);
    
    if (incomeTypeObj) {
        self.IncomeTypeLabel.text = incomeTypeObj.typeTitle;
    } else {
        self.IncomeTypeLabel.text = @"";
    }
   
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
        
        self.incomeToEdit.type = incomeTypeObj.typeTitle;
        
        if (deleteRecur == YES ) {
            [self deleteFutureRecurs:self.incomeToEdit.recurringDateID];
        } else {
            self.incomeToEdit.recurring = self.incomeToEdit.recurring;
            
            self.incomeToEdit.recurringAmount = [NSNumber numberWithFloat: self.recurringAmount.text.floatValue];
            
            self.incomeToEdit.recurringPeriod = [NSNumber numberWithFloat: self.recurringPeriodTextField.text.floatValue];
        }
        
        [[IBCoreDataStore mainStore] save];
        
        [self dismissViewControllerAnimated:YES completion:nil];
        
    } else {
        
        //First update period income total
        startingAmount = self.amountTextField.text.floatValue;
        
        newAmount = startingAmount;
        
        if ([shouldRecurr isEqualToNumber:@1]) {
            [self setRecurringInfoFor:addIncome];
            
        } else {
            [self createNewIncome:addIncome toPeriod:self.periodToAdd withAmount:self.amountTextField.text.floatValue];
        }
        
        if ([self validateInputs] == YES) {
            [self.periodToAdd addIncomeObject:addIncome];
            
            [[IBCoreDataStore mainStore] save];
            
            [self.addIncomeDelegate incomeAdded];
            
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
        NSArray * incomeArr = [thisP.income sortedArrayUsingDescriptors:@[sortIncome]];
        
        for (int x = 0; x < incomeArr.count; x++) {
            //NSLog(@"income count is %lu", (unsigned long)thisP.income.count);
            
            Incomes *thisI = incomeArr[x];
            
            if ([thisI.recurringDateID isEqual: thisID]) {
                //NSLog(@" same found");
                [thisP removeIncomeObject:thisI];
                // update total
                NSNumber * previousTotal = thisP.incomeTotal;
                NSNumber * thisAmount = thisI.amount;
                
                thisP.incomeTotal = @([previousTotal floatValue] - [thisAmount floatValue]);
            } else {
                //NSLog(@"nada found");
            }
        }
    }
}

- (void)setRecurringInfoFor:(Incomes *)thisIncome
{
    thisIncome.recurring = shouldRecurr;
    thisIncome.recurringAmount = [NSNumber numberWithFloat:self.recurringAmount.text.floatValue];
    thisIncome.recurringPeriod = [NSNumber numberWithInt:self.recurringPeriodTextField.text.intValue];
    if (self.recurringType.selectedSegmentIndex == 0) {
        thisIncome.recurringType = @"fixedAmount";
    } else {
        thisIncome.recurringType = @"percentage";
    }
    
    //Get how many periods are in the projects
    
    NSSortDescriptor *sort = [NSSortDescriptor sortDescriptorWithKey:@"periodNum" ascending:YES];
    
    NSArray * pInProjectArr = [self.projectToAdd.period sortedArrayUsingDescriptors:@[sort]];
    
    for (int i = self.periodToAdd.periodNum.intValue; i < self.recurringPeriodTextField.text.intValue + self.periodToAdd.periodNum.intValue; i++) {
        
        if (i <= pInProjectArr.count) {
            // add new income to current period
            if (i == self.periodToAdd.periodNum.intValue) {
                [self createNewIncome:thisIncome toPeriod:self.periodToAdd withAmount:startingAmount];
            } else {
                // add income to next other periods
                Periods *nextP = pInProjectArr[i - 1];
                Incomes *newIncome = [Incomes create];
                if (self.recurringType.selectedSegmentIndex == 0) {
                    newAmount += self.recurringAmount.text.floatValue;
                } else {
                    newAmount = newAmount + newAmount * self.recurringAmount.text.floatValue / 100;
                }
                [self createNewIncome:newIncome toPeriod:nextP withAmount:newAmount];
            }
        } else {
            // add new period then add income
            Periods *newPeriod;
            newPeriod = [Periods create];
            newPeriod.periodNum = [NSNumber numberWithInt:i];
            newPeriod.projects = self.projectToAdd;
            Incomes *newIncome = [Incomes create];
            if (self.recurringType.selectedSegmentIndex == 0) {
                newAmount += self.recurringAmount.text.floatValue;
            } else {
                newAmount = newAmount + newAmount * self.recurringAmount.text.floatValue /100;
            }
            [self createNewIncome:newIncome toPeriod:newPeriod withAmount:newAmount];
        }        
    }
}

- (void)createNewIncome: (Incomes *)income toPeriod: (Periods *)thisPeriod withAmount:(float)incomeAmount
{
    NSNumber * previousTotal = thisPeriod.incomeTotal;
    
    //NSNumber * incomeAfterChange = [NSNumber numberWithFloat: self.amountTextField.text.floatValue];
    
    thisPeriod.incomeTotal = @([previousTotal floatValue] + newAmount);
    
    income.amount = [NSNumber numberWithFloat: incomeAmount];
    
    income.title = self.titleTextField.text;
    
    income.source = self.sourceLabel.text;
    
    income.type = incomeTypeObj.typeTitle;
    
    if ([shouldRecurr isEqualToNumber:@1]) {
        income.recurring = @1;
        
        income.recurringType = addIncome.recurringType;
        
        income.recurringDateID = recurringDateID;
        
        income.recurringAmount = [NSNumber numberWithFloat:self.recurringAmount.text.floatValue];
        
        income.recurringEndPeriod = [NSNumber numberWithInt:self.recurringPeriodTextField.text.intValue + self.periodToAdd.periodNum.intValue - 1];
    } else {
        income.recurring = 0;
    }
    
    income.period = thisPeriod;

}

- (IBAction)canclePressed:(UIBarButtonItem *)sender {
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)recurringSwitched:(UISwitch *)sender {
    
   /* if (self.incomeToEdit){
        
        if ([sender isOn]) {
            self.incomeToEdit.recurring = @1;
            shouldRecurr = @1;
            
        } else {
            self.incomeToEdit.recurring = 0;
            shouldRecurr = 0;
        }
    } else {
        if ([sender isOn]) {
            shouldRecurr = @1;
        } else {
            shouldRecurr = @0;
        }
    }
    */
    
    if ([sender isOn]) {
        shouldRecurr = @1;
    } else {
        shouldRecurr = @0;
    }
    [self.tableView reloadData];
    
    if ([self.incomeToEdit.recurring isEqual: @1]) {
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
            [self deleteFutureRecurs:self.incomeToEdit.recurringDateID];
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
    } else {
        if (sender.selectedSegmentIndex == 0) {
            addIncome.recurringType = @"fixedAmount";
            
        } else {
            addIncome.recurringType = @"percentage";
        }
    }
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSInteger count = [super tableView:tableView numberOfRowsInSection:section];
    
    if(self.incomeToEdit){
        if (section == 1) {
            return 1;
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
    if ([segue.identifier isEqualToString:@"incomeTypeSegue"]) {
        
        IncomeTypeCollectionViewController * destination = segue.destinationViewController;
        destination.selectIncomeTypeObj = incomeTypeObj;
    }
}


@end
