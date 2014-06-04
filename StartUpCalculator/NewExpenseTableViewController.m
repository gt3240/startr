//
//  NewExpenseTableViewController.m
//  StartUpCalculator
//
//  Created by Tom on 3/31/14.
//  Copyright (c) 2014 Tom Liu. All rights reserved.
//

#import "NewExpenseTableViewController.h"
#import "AppDelegate.h"
#import "ExpenseTypeCollectionViewController.h"
#import "IncomeAndExpenseType.h"
#import "displayTypeImage.h"

@interface NewExpenseTableViewController ()
{
    NSString *ExpenseTypeStr;
    IncomeAndExpenseType *ExpenseTypeObj;
    NSNumber * shouldRecurr;
    Expenses * addExpense;
    float startingAmount;
    float newAmount;
    NSDate * recurringDateID;
    BOOL deleteRecur;
    UIAlertView *recurAlert;
    float keyboardOffset;
    displayTypeImage *img;
    //int posOrNegInt;
}
@property (nonatomic, retain) NSManagedObjectContext *managedObjectContext;
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
    
    img = [[displayTypeImage alloc]init];
    self.notes.tag = 5; // note text view tag for move view up when keyboard show
    self.recurringPeriodTextField.tag = 4;
    self.recurringAmount.tag = 4;
    
    AppDelegate* appDelegate = [UIApplication sharedApplication].delegate;
    self.managedObjectContext = appDelegate.managedObjectContext;
    
    ExpenseTypeObj = [[IncomeAndExpenseType alloc]init];
    
    if (self.expenseToEdit){
        
        self.title = @"Edit";
        self.titleTextField.text = self.expenseToEdit.title;
        self.amountTextField.text = [NSString stringWithFormat:@"$%@", self.expenseToEdit.amount];
        self.sourceLabel.text = self.expenseToEdit.source;
        ExpenseTypeObj.typeTitle = self.expenseToEdit.type;
        self.TypeLabel.text = ExpenseTypeObj.typeTitle;
        self.typeImage.image = [img showImage:ExpenseTypeObj.typeTitle];
        
        
        if ([self.expenseToEdit.notes isEqualToString:@""]) {
            self.notes.text = @"Notes";
            self.notes.textColor = [UIColor colorWithRed:199/255.0f green:199/255.0f blue:205/255.0f alpha:1.0f];
        } else {
            self.notes.text = self.expenseToEdit.notes;
            self.notes.textColor = [UIColor colorWithRed:0/255.0f green:150/255.0f blue:255/255.0f alpha:1.0f];
        }
        
        
        if ([self.expenseToEdit.recurring intValue] == 1){
            keyboardOffset = 276;
            shouldRecurr = @1;
            [self.recurringSwitch setOn:YES];
            deleteRecur = NO;
            //NSLog(@"recurring type %@", self.expenseToEdit.recurringType);
            if ([self.expenseToEdit.recurringType isEqualToString:@"fixedAmount"]){
                self.recurringType.selectedSegmentIndex = 0;
                self.recurringAmount.text = [NSString stringWithFormat:@"$%@", self.expenseToEdit.recurringAmount];
            } else {
                
                self.recurringType.selectedSegmentIndex = 1;
                self.recurringAmount.text = [NSString stringWithFormat:@"%@%%", self.expenseToEdit.recurringAmount];
            }
            
            if ([self.expenseToEdit.recurringPostiveOrNegative isEqualToString:@"positive"]) {
                self.posOrNegSegementControl.selectedSegmentIndex = 0;
            } else {
                self.posOrNegSegementControl.selectedSegmentIndex = 1;
                
            }
            self.recurringPeriodTextField.text = [NSString stringWithFormat:@"Repeat until month %@", self.expenseToEdit.recurringPeriod];
            keyboardOffset = 414;
        } else {
            [self.recurringSwitch setOn:NO];
            shouldRecurr = 0;
            keyboardOffset = 236;
            
        }
    } else {
        keyboardOffset = 276;
        
        addExpense = [NSEntityDescription insertNewObjectForEntityForName:@"Expenses" inManagedObjectContext:self.managedObjectContext];
        
    }
    
    //NSLog(@"period id is %@", self.periodToAdd.periodNum);
    
}

-(void)viewWillAppear:(BOOL)animated
{
    recurringDateID = [NSDate date];
    
    NSLog(@"Expense type is %@", ExpenseTypeObj.typeTitle);
    
    if (ExpenseTypeObj) {
        self.TypeLabel.text = ExpenseTypeObj.typeTitle;
        self.typeImage.image = [img showImage:ExpenseTypeObj.typeTitle];
    } else {
        self.TypeLabel.text = @"";
    }
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIKeyboardWillHideNotification
                                                  object:nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)donePressed:(UIBarButtonItem *)sender {
    
    if (self.expenseToEdit){
        if ([self.amountTextField.text hasPrefix:@"$"]) {
            self.amountTextField.text = [NSString stringWithFormat:@"%@", self.expenseToEdit.amount];
        }
        
        if ([self.expenseToEdit.recurring isEqualToNumber:@1]) {
            if (deleteRecur == YES ) {
                [self deleteFutureRecurs:self.expenseToEdit.recurringDateID];
                NSError *error;
                if (![self.managedObjectContext save:&error]) {
                    NSLog(@"Whoops, couldn't save: %@", [error localizedDescription]);
                } else {
                    NSLog(@"updated");
                }
                
                [self dismissViewControllerAnimated:YES completion:nil];
                
            } else {
                // erase text in repeating amount and period
                if ([self.recurringPeriodTextField.text hasPrefix:@"Repeat"]) {
                    self.recurringPeriodTextField.text = [NSString stringWithFormat:@"%d", self.expenseToEdit.recurringPeriod.intValue];
                }
                
                if ([self.recurringAmount.text hasPrefix:@"$"]) {
                    self.recurringAmount.text = [NSString stringWithFormat:@"%.2f", self.expenseToEdit.recurringAmount.floatValue];
                }
                // update repeat data
                if (self.expenseToEdit.recurringPeriod == 0) {
                    UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"Oops" message:@"Repeating months can't be 0" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil,nil];
                    [alert show];
                    self.recurringPeriodTextField.text = [NSString stringWithFormat:@"%d", self.expenseToEdit.recurringEndPeriod.intValue];
                    
                } else if (self.recurringPeriodTextField.text.floatValue < self.expenseToEdit.recurringEndPeriod.intValue) {
                    UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"Oops" message:@"Repeat until month cannot be less than previous value.  Deselect repeat to erase future repeated items" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil,nil];
                    [alert show];
                    self.recurringPeriodTextField.text = [NSString stringWithFormat:@"%d", self.expenseToEdit.recurringEndPeriod.intValue];
                } else {
                    
                    //[self deleteFutureRecurs:self.expenseToEdit.recurringDateID];
                    
                    [self deleteAllRecurringInfoFor:self.expenseToEdit];
                    
                    startingAmount = self.amountTextField.text.floatValue;
                    newAmount = startingAmount;
                    
                    [self setRecurringInfoFor:self.expenseToEdit];
                    
                    //[self.periodToAdd addExpenseObject:self.expenseToEdit];
                    
                    NSError *error;
                    if (![self.managedObjectContext save:&error]) {
                        NSLog(@"Whoops, couldn't save: %@", [error localizedDescription]);
                    } else {
                        NSLog(@"updated");
                    }
                    
                    [self dismissViewControllerAnimated:YES completion:nil];
                }
            }
            
        } else {
            
            NSNumber * previousTotal = self.expenseToEdit.period.expenseTotal;
            NSNumber * ExpenseBeforeChange = self.expenseToEdit.amount;
            NSNumber * ExpenseAfterChange = [NSNumber numberWithFloat: self.amountTextField.text.floatValue];
            self.expenseToEdit.period.ExpenseTotal = @([previousTotal floatValue] -[ExpenseBeforeChange floatValue] + [ExpenseAfterChange floatValue]);
            
            self.expenseToEdit.title = self.titleTextField.text;
            
            self.expenseToEdit.source = self.sourceLabel.text;
            
            self.expenseToEdit.amount = [NSNumber numberWithFloat: self.amountTextField.text.floatValue];
            
            self.expenseToEdit.type = ExpenseTypeObj.typeTitle;
            self.expenseToEdit.notes = self.notes.text;
            NSError *error;
            if (![self.managedObjectContext save:&error]) {
                NSLog(@"Whoops, couldn't save: %@", [error localizedDescription]);
            }
            
            [self dismissViewControllerAnimated:YES completion:nil];
        }
        
    } else {
        if ([self validateInputs] == YES) {
            //First update period Expense total
            startingAmount = self.amountTextField.text.floatValue;
            
            newAmount = startingAmount;
            
            if ([shouldRecurr isEqualToNumber:@1]) {
                if (self.recurringPeriodTextField.text.floatValue == 0) {
                    UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"Oops" message:@"Repeating months can't be 0" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil,nil];
                    [alert show];
                    [self.recurringPeriodTextField becomeFirstResponder];
                } else {
                    [self setRecurringInfoFor:addExpense];
                    
                    //[self.periodToAdd addExpenseObject:addExpense];
                    
                    NSError *error;
                    if (![self.managedObjectContext save:&error]) {
                        NSLog(@"Whoops, couldn't save: %@", [error localizedDescription]);
                    }
                    
                    [self.addExpenseDelegate expenseAdded];
                    
                    [self dismissViewControllerAnimated:YES completion:nil];
                }
            } else {
                [self createNewExpense:addExpense toPeriod:self.periodToAdd withAmount:self.amountTextField.text.floatValue nextP:0];
                [self.periodToAdd addExpenseObject:addExpense];
                
                NSError *error;
                if (![self.managedObjectContext save:&error]) {
                    NSLog(@"Whoops, couldn't save: %@", [error localizedDescription]);
                };
                
                [self.addExpenseDelegate expenseAdded];
                
                [self dismissViewControllerAnimated:YES completion:nil];
            }
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
        
        NSSortDescriptor *sortExpense = [NSSortDescriptor sortDescriptorWithKey:@"title" ascending:YES];
        NSArray * ExpenseArr = [thisP.expense sortedArrayUsingDescriptors:@[sortExpense]];
        
        for (int x = 0; x < ExpenseArr.count; x++) {
            //NSLog(@"Expense count is %lu", (unsigned long)thisP.Expense.count);
            
            Expenses *thisI = ExpenseArr[x];
            
            if ([thisI.recurringDateID isEqual: thisID]) {
                //NSLog(@" same found");
                [thisP removeExpenseObject:thisI];
                // update total
                NSNumber * previousTotal = thisP.expenseTotal;
                NSNumber * thisAmount = thisI.amount;
                
                thisP.ExpenseTotal = @([previousTotal floatValue] - [thisAmount floatValue]);
            } else {
                //NSLog(@"nada found");
            }
        }
    }
}

- (void)deleteAllRecurringInfoFor: (Expenses *)thisExpense
{
    // delete old Expense first
    NSSortDescriptor *sort = [NSSortDescriptor sortDescriptorWithKey:@"periodNum" ascending:YES];
    NSArray * pInProjectArr = [self.projectToAdd.period sortedArrayUsingDescriptors:@[sort]];
    
    for (int i = thisExpense.period.periodNum.intValue - 1; i < pInProjectArr.count; i++) {
        Periods *thisP = pInProjectArr[i];
        
        NSArray *ExpenseInThisP = [thisP.expense allObjects];
        NSLog(@"this set have %lu Expenses", (unsigned long)ExpenseInThisP.count);
        
        // delete old repeat records
        for (int a = 0; a < ExpenseInThisP.count; a++) {
            Expenses *thisI = ExpenseInThisP[a];
            NSLog(@"\n \n thisI ID is %@, Expense ID is %@", thisI.recurringDateID, thisExpense.recurringDateID);
            if ([thisI.recurringDateID isEqual: thisExpense.recurringDateID]) {
                NSNumber * previousTotal = thisP.expenseTotal;
                NSNumber * ExpenseBeforeChange = thisI.amount;
                thisP.ExpenseTotal = @([previousTotal floatValue] -[ExpenseBeforeChange floatValue]);
                [thisP removeExpenseObject:thisI];
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
    
    if (self.posOrNegSegementControl.selectedSegmentIndex == 0) {
        thisExpense.recurringPostiveOrNegative = @"positive";
    } else {
        thisExpense.recurringPostiveOrNegative = @"negative";
    }
    
    //Get how many periods are in the projects
    
    NSSortDescriptor *sort = [NSSortDescriptor sortDescriptorWithKey:@"periodNum" ascending:YES];
    
    NSArray * pInProjectArr = [self.projectToAdd.period sortedArrayUsingDescriptors:@[sort]];
    
    for (int i = self.periodToAdd.periodNum.intValue; i <= self.recurringPeriodTextField.text.intValue; i++) {
        
        int pNum = self.recurringPeriodTextField.text.intValue; //period terms, number decreases towards the end
        
        if (i <= pInProjectArr.count) {
            // add new Expense to current period
            if (i == self.periodToAdd.periodNum.intValue) {
                //                if (self.expenseToEdit) {
                //                    newAmount = 0;
                //                }
                [self createNewExpense:thisExpense toPeriod:self.periodToAdd withAmount:startingAmount nextP:pNum];
                newAmount = startingAmount;
            } else {
                
                // add Expense to next other periods
                Periods *nextP = pInProjectArr[i - 1];
                Expenses *newExpense = [NSEntityDescription insertNewObjectForEntityForName:@"Expenses" inManagedObjectContext:self.managedObjectContext];
                if (self.recurringType.selectedSegmentIndex == 0) {
                    if (self.posOrNegSegementControl.selectedSegmentIndex == 0) {
                        newAmount = newAmount + self.recurringAmount.text.floatValue;
                    } else {
                        newAmount = newAmount - self.recurringAmount.text.floatValue;
                    }
                } else {
                    if (self.posOrNegSegementControl.selectedSegmentIndex == 0) {
                        newAmount = newAmount + newAmount * self.recurringAmount.text.floatValue / 100;
                    } else {
                        newAmount = newAmount - newAmount * self.recurringAmount.text.floatValue / 100;
                    }
                    
                }
                
                [self createNewExpense:newExpense toPeriod:nextP withAmount:newAmount nextP:pNum];
            }
        } else {
            // add new period then add Expense
            Periods *newPeriod;
            newPeriod = [NSEntityDescription insertNewObjectForEntityForName:@"Periods" inManagedObjectContext:self.managedObjectContext];
            newPeriod.periodNum = [NSNumber numberWithInt:i];
            newPeriod.projects = self.projectToAdd;
            Expenses *newExpense = [NSEntityDescription insertNewObjectForEntityForName:@"Expenses" inManagedObjectContext:self.managedObjectContext];
            if (self.recurringType.selectedSegmentIndex == 0) {
                if (self.posOrNegSegementControl.selectedSegmentIndex == 0) {
                    newAmount = newAmount + self.recurringAmount.text.floatValue;
                } else {
                    newAmount = newAmount - self.recurringAmount.text.floatValue;
                }
            } else {
                if (self.posOrNegSegementControl.selectedSegmentIndex == 0) {
                    newAmount = newAmount + newAmount * self.recurringAmount.text.floatValue / 100;
                } else {
                    newAmount = newAmount - newAmount * self.recurringAmount.text.floatValue / 100;
                }
                
            }
            [self createNewExpense:newExpense toPeriod:newPeriod withAmount:newAmount nextP:pNum];
        }
    }
}

- (void)createNewExpense: (Expenses *)Expense toPeriod: (Periods *)thisPeriod withAmount:(float)ExpenseAmount nextP:(int)pNum
{
    NSNumber * previousTotal = thisPeriod.expenseTotal;
    
    //NSNumber * ExpenseAfterChange = [NSNumber numberWithFloat: self.amountTextField.text.floatValue];
    NSLog(@"\n \n pnum %@ previousTotal is %@, newAmount is %f", thisPeriod.periodNum, thisPeriod.expenseTotal, newAmount);
    
    //    if ([Expense.recurringPostiveOrNegative isEqualToString:@"positive"]) {
    //         thisPeriod.ExpenseTotal = @([previousTotal floatValue] + newAmount);
    //    } else {
    //         thisPeriod.ExpenseTotal = @([previousTotal floatValue] - newAmount);
    //    }
    //
    thisPeriod.ExpenseTotal = @([previousTotal floatValue] + newAmount);
    
    NSLog(@"Expense total now is %@", thisPeriod.expenseTotal);
    
    Expense.amount = [NSNumber numberWithFloat: ExpenseAmount];
    
    Expense.title = self.titleTextField.text;
    
    Expense.source = self.sourceLabel.text;
    
    if (ExpenseTypeObj.typeTitle == NULL) {
        Expense.type = @"Undeclared Expense";
    } else {
        Expense.type = ExpenseTypeObj.typeTitle;
    }
    
    Expense.notes = self.notes.text;
    
    if ([shouldRecurr isEqualToNumber:@1]) {
        Expense.recurring = @1;
        
        if (self.expenseToEdit) {
            Expense.recurringType = self.expenseToEdit.recurringType;
            Expense.recurringDateID = self.expenseToEdit.recurringDateID;
        } else {
            Expense.recurringType = addExpense.recurringType;
            Expense.recurringDateID = recurringDateID;
        }
        
        if (self.posOrNegSegementControl.selectedSegmentIndex == 0) {
            Expense.recurringPostiveOrNegative = @"positive";
        } else {
            Expense.recurringPostiveOrNegative = @"negative";
        }
        
        Expense.recurringPeriod = [NSNumber numberWithInt:pNum];
        
        Expense.recurringAmount = [NSNumber numberWithFloat:self.recurringAmount.text.floatValue];
        
        Expense.recurringEndPeriod = [NSNumber numberWithInt:self.recurringPeriodTextField.text.intValue];
    } else {
        Expense.recurring = 0;
    }
    
    Expense.period = thisPeriod;
    
}

- (IBAction)canclePressed:(UIBarButtonItem *)sender {
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)recurringSwitched:(UISwitch *)sender {
    
    if ([sender isOn]) {
        shouldRecurr = @1;
        keyboardOffset = 414;
    } else {
        shouldRecurr = @0;
        keyboardOffset = 276;
    }
    [self.tableView reloadData];
    
    if ([self.expenseToEdit.recurring isEqual: @1]) {
        if (![sender isOn]) {
            recurAlert = [[UIAlertView alloc] initWithTitle:@"Warning" message:@"All future repeating items will be deleted, are you sure?" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Yes",nil];
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

- (IBAction)posOrNegSwitched:(UISegmentedControl *)sender {
    
    if (self.expenseToEdit){
        
        if (sender.selectedSegmentIndex == 0) {
            self.expenseToEdit.recurringPostiveOrNegative = @"positive";
            
        } else {
            self.expenseToEdit.recurringPostiveOrNegative = @"negative";
        }
    } else {
        if (sender.selectedSegmentIndex == 0) {
            addExpense.recurringPostiveOrNegative = @"positive";
            
        } else {
            addExpense.recurringPostiveOrNegative = @"negative";
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
            if ([shouldRecurr isEqual: @1]) {
                return 4;
                
            } else {
                return 0;
            }
        }
    } else {
        if (section == 1) {
            if ([shouldRecurr isEqual: @1]) {
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
    if ([segue.identifier isEqualToString:@"ExpenseTypeSegue"]) {
        
        ExpenseTypeCollectionViewController * destination = segue.destinationViewController;
        destination.selectExpenseTypeObj = ExpenseTypeObj;
    }
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if ([textField isEqual: self.titleTextField]) {
        [self.sourceLabel becomeFirstResponder];
    } else if ([textField isEqual: self.sourceLabel]){
        [self.amountTextField becomeFirstResponder];
    } else {
        [textField resignFirstResponder];
    }
    return YES;
}

-(void)keyboardWillHide {
    if (self.view.frame.origin.y < 0)
    {
        [self setViewMovedUp:NO];
    }
}

- (void)textFieldDidBeginEditing:(UITextField *)sender
{
    if (self.expenseToEdit) {
        if (sender == self.recurringPeriodTextField) {
            self.recurringPeriodTextField.text =[NSString stringWithFormat:@"%d", self.expenseToEdit.recurringEndPeriod.intValue];
        }
        
        if (sender == self.recurringAmount) {
            self.recurringAmount.text =[NSString stringWithFormat:@"%@", self.expenseToEdit.recurringAmount];
        }
        
        if (sender == self.amountTextField) {
            self.amountTextField.text =[NSString stringWithFormat:@"%@", self.expenseToEdit.amount];
        }
    }
    
    if (sender.tag == 4) {
        keyboardOffset = 146;
        if  (self.view.frame.origin.y >= 0)
        {
            [self setViewMovedUp:YES];
        }
    }
}

-(void)textViewDidBeginEditing:(UITextView *)sender
{
    if (sender.tag == 5)
    {
        if ([shouldRecurr isEqualToNumber: @1]) {
            keyboardOffset = 414;
        } else {
            keyboardOffset = 276;
        }
        
        if ([self.expenseToEdit.notes isEqualToString:@""]) {
            sender.text = @"";
        } else {
            sender.text = self.expenseToEdit.notes;
        }
        sender.textColor = [UIColor colorWithRed:235/255.0f green:92/255.0f blue:104/255.0f alpha:1.0f];
        //move the main view, so that the keyboard does not hide it.
        if  (self.view.frame.origin.y >= 0)
        {
            [self setViewMovedUp:YES];
        }
    }
}

//method to move the view up/down whenever the keyboard is shown/dismissed
-(void)setViewMovedUp:(BOOL)movedUp
{
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.3]; // if you want to slide up the view
    
    CGRect rect = self.view.frame;
    if (movedUp)
    {
        // 1. move the view's origin up so that the text field that will be hidden come above the keyboard
        // 2. increase the size of the view so that the area behind the keyboard is covered up.
        rect.origin.y -= keyboardOffset;
        rect.size.height += keyboardOffset;
    }
    else
    {
        // revert back to the normal state.
        rect.origin.y += keyboardOffset;
        rect.size.height -= keyboardOffset;
    }
    self.view.frame = rect;
    
    [UIView commitAnimations];
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
}
@end