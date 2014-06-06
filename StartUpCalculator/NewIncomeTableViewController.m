//
//  NewIncomeTableViewController.m
//  StartUpCalculator
//
//  Created by Tom on 3/31/14.
//  Copyright (c) 2014 Tom Liu. All rights reserved.
//

#import "NewIncomeTableViewController.h"
#import "AppDelegate.h"
#import "IncomeTypeCollectionViewController.h"
#import "IncomeAndExpenseType.h"
#import "displayTypeImage.h"

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
    float keyboardOffset;
    displayTypeImage *img;
    //int posOrNegInt;
}
@property (nonatomic, retain) NSManagedObjectContext *managedObjectContext;
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
    
    img = [[displayTypeImage alloc]init];
    self.notes.tag = 5; // note text view tag for move view up when keyboard show
    self.recurringPeriodTextField.tag = 4;
    self.recurringAmount.tag = 4;
    
    AppDelegate* appDelegate = [UIApplication sharedApplication].delegate;
    self.managedObjectContext = appDelegate.managedObjectContext;
    
    incomeTypeObj = [[IncomeAndExpenseType alloc]init];
    
    if (self.incomeToEdit){

        self.title = @"Edit";
        self.titleTextField.text = self.incomeToEdit.title;
        self.amountTextField.text = [NSString stringWithFormat:@"$%@", self.incomeToEdit.amount];
        self.sourceLabel.text = self.incomeToEdit.source;
        incomeTypeObj.typeTitle = self.incomeToEdit.type;
        self.IncomeTypeLabel.text = incomeTypeObj.typeTitle;
        self.typeImage.image = [img showImage:incomeTypeObj.typeTitle];
        
        
        if ([self.incomeToEdit.notes isEqualToString:@""]) {
            self.notes.text = @"Notes";
            self.notes.textColor = [UIColor colorWithRed:199/255.0f green:199/255.0f blue:205/255.0f alpha:1.0f];
        } else {
            self.notes.text = self.incomeToEdit.notes;
            self.notes.textColor = [UIColor colorWithRed:0/255.0f green:150/255.0f blue:255/255.0f alpha:1.0f];
        }

        
        if ([self.incomeToEdit.recurring intValue] == 1){
            keyboardOffset = 276;
            shouldRecurr = @1;
            [self.recurringSwitch setOn:YES];
            deleteRecur = NO;
            //NSLog(@"recurring type %@", self.incomeToEdit.recurringType);
            if ([self.incomeToEdit.recurringType isEqualToString:@"fixedAmount"]){
                self.recurringType.selectedSegmentIndex = 0;
                self.recurringAmount.text = [NSString stringWithFormat:@"$%@", self.incomeToEdit.recurringAmount];
            } else {
                
                self.recurringType.selectedSegmentIndex = 1;
                self.recurringAmount.text = [NSString stringWithFormat:@"%@%%", self.incomeToEdit.recurringAmount];
            }
            
            if ([self.incomeToEdit.recurringPostiveOrNegative isEqualToString:@"positive"]) {
                self.posOrNegSegementControl.selectedSegmentIndex = 0;
            } else {
                self.posOrNegSegementControl.selectedSegmentIndex = 1;

            }
            self.recurringPeriodTextField.text = [NSString stringWithFormat:@"Repeat until month %@", self.incomeToEdit.recurringPeriod];
            keyboardOffset = 414;
        } else {
            [self.recurringSwitch setOn:NO];
            shouldRecurr = 0;
            keyboardOffset = 236;

        }
    } else {
        keyboardOffset = 276;

        addIncome = [NSEntityDescription insertNewObjectForEntityForName:@"Incomes" inManagedObjectContext:self.managedObjectContext];
        
    }
    
    //NSLog(@"period id is %@", self.periodToAdd.periodNum);
    
}

-(void)viewWillAppear:(BOOL)animated
{
    recurringDateID = [NSDate date];
    
    NSLog(@"income type is %@", incomeTypeObj.typeTitle);
    
    if (incomeTypeObj) {
        self.IncomeTypeLabel.text = incomeTypeObj.typeTitle;
        self.typeImage.image = [img showImage:incomeTypeObj.typeTitle];
    } else {
        self.IncomeTypeLabel.text = @"";
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
    
    if (self.incomeToEdit){
        if ([self.amountTextField.text hasPrefix:@"$"]) {
            self.amountTextField.text = [NSString stringWithFormat:@"%@", self.incomeToEdit.amount];
        }
        
        if ([self.incomeToEdit.recurring isEqualToNumber:@1]) {
            if (deleteRecur == YES ) {
                [self deleteFutureRecurs:self.incomeToEdit.recurringDateID];
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
                    self.recurringPeriodTextField.text = [NSString stringWithFormat:@"%d", self.incomeToEdit.recurringPeriod.intValue];
                }
                
                if ([self.recurringAmount.text hasPrefix:@"$"]) {
                    self.recurringAmount.text = [NSString stringWithFormat:@"%.2f", self.incomeToEdit.recurringAmount.floatValue];
                }
                // update repeat data
                if (self.incomeToEdit.recurringPeriod == 0) {
                    UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"Oops" message:@"Repeating months can't be 0" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil,nil];
                    [alert show];
                    self.recurringPeriodTextField.text = [NSString stringWithFormat:@"%d", self.incomeToEdit.recurringEndPeriod.intValue];

                } else if (self.recurringPeriodTextField.text.floatValue < self.incomeToEdit.recurringEndPeriod.intValue) {
                    UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"Oops" message:@"Repeat until month cannot be less than previous value.  Deselect repeat to erase future repeated items" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil,nil];
                    [alert show];
                    self.recurringPeriodTextField.text = [NSString stringWithFormat:@"%d", self.incomeToEdit.recurringEndPeriod.intValue];
                } else {
                    
                    //[self deleteFutureRecurs:self.incomeToEdit.recurringDateID];
                    
                    [self deleteAllRecurringInfoFor:self.incomeToEdit];
                    
                    startingAmount = self.amountTextField.text.floatValue;
                    newAmount = startingAmount;
                    
                    [self setRecurringInfoFor:self.incomeToEdit];
                    
                    //[self.periodToAdd addIncomeObject:self.incomeToEdit];
                    
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
            
            NSNumber * previousTotal = self.incomeToEdit.period.incomeTotal;
            NSNumber * incomeBeforeChange = self.incomeToEdit.amount;
            NSNumber * incomeAfterChange = [NSNumber numberWithFloat: self.amountTextField.text.floatValue];
            self.incomeToEdit.period.incomeTotal = @([previousTotal floatValue] -[incomeBeforeChange floatValue] + [incomeAfterChange floatValue]);
            
            self.incomeToEdit.title = self.titleTextField.text;
            
            self.incomeToEdit.source = self.sourceLabel.text;
            
            self.incomeToEdit.amount = [NSNumber numberWithFloat: self.amountTextField.text.floatValue];
            
            self.incomeToEdit.type = incomeTypeObj.typeTitle;
            self.incomeToEdit.notes = self.notes.text;
            NSError *error;
            if (![self.managedObjectContext save:&error]) {
                NSLog(@"Whoops, couldn't save: %@", [error localizedDescription]);
            }
            
            [self dismissViewControllerAnimated:YES completion:nil];
        }
        
    } else {
        if ([self validateInputs] == YES) {
            //First update period income total
            startingAmount = self.amountTextField.text.floatValue;
            
            newAmount = startingAmount;
            
            if ([shouldRecurr isEqualToNumber:@1]) {
                if (self.recurringPeriodTextField.text.floatValue == 0) {
                    UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"Oops" message:@"Repeating months can't be 0" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil,nil];
                    [alert show];
                    [self.recurringPeriodTextField becomeFirstResponder];
                } else {
                    [self setRecurringInfoFor:addIncome];
                    
                    //[self.periodToAdd addIncomeObject:addIncome];
                    
                    NSError *error;
                    if (![self.managedObjectContext save:&error]) {
                        NSLog(@"Whoops, couldn't save: %@", [error localizedDescription]);
                    }
                    
                    [self.addIncomeDelegate incomeAdded];
                    
                    [self dismissViewControllerAnimated:YES completion:nil];
                }
            } else {
                [self createNewIncome:addIncome toPeriod:self.periodToAdd withAmount:self.amountTextField.text.floatValue nextP:0];
                [self.periodToAdd addIncomeObject:addIncome];
                
                NSError *error;
                if (![self.managedObjectContext save:&error]) {
                    NSLog(@"Whoops, couldn't save: %@", [error localizedDescription]);
                };
                
                [self.addIncomeDelegate incomeAdded];
                
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

- (void)deleteAllRecurringInfoFor: (Incomes *)thisIncome
{
    // delete old income first
    NSSortDescriptor *sort = [NSSortDescriptor sortDescriptorWithKey:@"periodNum" ascending:YES];
    NSArray * pInProjectArr = [self.projectToAdd.period sortedArrayUsingDescriptors:@[sort]];
    
    for (int i = thisIncome.period.periodNum.intValue - 1; i < pInProjectArr.count; i++) {
        Periods *thisP = pInProjectArr[i];
        
        NSArray *incomeInThisP = [thisP.income allObjects];
        NSLog(@"this set have %lu incomes", (unsigned long)incomeInThisP.count);
        
        // delete old repeat records
        for (int a = 0; a < incomeInThisP.count; a++) {
            Incomes *thisI = incomeInThisP[a];
            NSLog(@"\n \n thisI ID is %@, Income ID is %@", thisI.recurringDateID, thisIncome.recurringDateID);
            if ([thisI.recurringDateID isEqual: thisIncome.recurringDateID]) {
                NSNumber * previousTotal = thisP.incomeTotal;
                NSNumber * incomeBeforeChange = thisI.amount;
                thisP.incomeTotal = @([previousTotal floatValue] -[incomeBeforeChange floatValue]);
                [thisP removeIncomeObject:thisI];
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
    
    if (self.posOrNegSegementControl.selectedSegmentIndex == 0) {
        thisIncome.recurringPostiveOrNegative = @"positive";
    } else {
        thisIncome.recurringPostiveOrNegative = @"negative";
    }
    
    //Get how many periods are in the projects
    
    NSSortDescriptor *sort = [NSSortDescriptor sortDescriptorWithKey:@"periodNum" ascending:YES];
    
    NSArray * pInProjectArr = [self.projectToAdd.period sortedArrayUsingDescriptors:@[sort]];
    
    for (int i = self.periodToAdd.periodNum.intValue; i <= self.recurringPeriodTextField.text.intValue; i++) {
        
        int pNum = self.recurringPeriodTextField.text.intValue; //period terms, number decreases towards the end
        
        if (i <= pInProjectArr.count) {
            // add new income to current period
            if (i == self.periodToAdd.periodNum.intValue) {
//                if (self.incomeToEdit) {
//                    newAmount = 0;
//                }
                [self createNewIncome:thisIncome toPeriod:self.periodToAdd withAmount:startingAmount nextP:pNum];
                newAmount = startingAmount;
            } else {
                
                // add income to next other periods
                Periods *nextP = pInProjectArr[i - 1];
                Incomes *newIncome = [NSEntityDescription insertNewObjectForEntityForName:@"Incomes" inManagedObjectContext:self.managedObjectContext];
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
                
                [self createNewIncome:newIncome toPeriod:nextP withAmount:newAmount nextP:pNum];
            }
        } else {
            // add new period then add income
            Periods *newPeriod;
            newPeriod = [NSEntityDescription insertNewObjectForEntityForName:@"Periods" inManagedObjectContext:self.managedObjectContext];
            newPeriod.periodNum = [NSNumber numberWithInt:i];
            newPeriod.projects = self.projectToAdd;
            Incomes *newIncome = [NSEntityDescription insertNewObjectForEntityForName:@"Incomes" inManagedObjectContext:self.managedObjectContext];
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
            [self createNewIncome:newIncome toPeriod:newPeriod withAmount:newAmount nextP:pNum];
        }        
    }
}

- (void)createNewIncome: (Incomes *)income toPeriod: (Periods *)thisPeriod withAmount:(float)incomeAmount nextP:(int)pNum
{
    NSNumber * previousTotal = thisPeriod.incomeTotal;
    
    //NSNumber * incomeAfterChange = [NSNumber numberWithFloat: self.amountTextField.text.floatValue];
   NSLog(@"\n \n pnum %@ previousTotal is %@, newAmount is %f", thisPeriod.periodNum, thisPeriod.incomeTotal, newAmount);
    
//    if ([income.recurringPostiveOrNegative isEqualToString:@"positive"]) {
//         thisPeriod.incomeTotal = @([previousTotal floatValue] + newAmount);
//    } else {
//         thisPeriod.incomeTotal = @([previousTotal floatValue] - newAmount);
//    }
//    
    thisPeriod.incomeTotal = @([previousTotal floatValue] + newAmount);

    NSLog(@"income total now is %@", thisPeriod.incomeTotal);
    
    income.amount = [NSNumber numberWithFloat: incomeAmount];
    
    income.title = self.titleTextField.text;
    
    income.source = self.sourceLabel.text;
    
    if (incomeTypeObj.typeTitle == NULL) {
        income.type = @"Undeclared Income";
    } else {
        income.type = incomeTypeObj.typeTitle;
    }
    
    income.notes = self.notes.text;
    
    if ([shouldRecurr isEqualToNumber:@1]) {
        income.recurring = @1;
        
        if (self.incomeToEdit) {
            income.recurringType = self.incomeToEdit.recurringType;
            income.recurringDateID = self.incomeToEdit.recurringDateID;
        } else {
            income.recurringType = addIncome.recurringType;
            income.recurringDateID = recurringDateID;
        }
        
        if (self.posOrNegSegementControl.selectedSegmentIndex == 0) {
            income.recurringPostiveOrNegative = @"positive";
        } else {
            income.recurringPostiveOrNegative = @"negative";
        }
        
        income.recurringPeriod = [NSNumber numberWithInt:pNum];
        
        income.recurringAmount = [NSNumber numberWithFloat:self.recurringAmount.text.floatValue];
        
        income.recurringEndPeriod = [NSNumber numberWithInt:self.recurringPeriodTextField.text.intValue];
    } else {
        income.recurring = 0;
    }
    
    income.period = thisPeriod;

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
    
    if ([self.incomeToEdit.recurring isEqual: @1]) {
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
            [self deleteFutureRecurs:self.incomeToEdit.recurringDateID];
        }

    }
}

- (IBAction)posOrNegSwitched:(UISegmentedControl *)sender {
    
    if (self.incomeToEdit){
        
        if (sender.selectedSegmentIndex == 0) {
            self.incomeToEdit.recurringPostiveOrNegative = @"positive";
            
        } else {
            self.incomeToEdit.recurringPostiveOrNegative = @"negative";
        }
    } else {
        if (sender.selectedSegmentIndex == 0) {
            addIncome.recurringPostiveOrNegative = @"positive";
            
        } else {
            addIncome.recurringPostiveOrNegative = @"negative";
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
    if ([segue.identifier isEqualToString:@"incomeTypeSegue"]) {
        
        IncomeTypeCollectionViewController * destination = segue.destinationViewController;
        destination.selectIncomeTypeObj = incomeTypeObj;
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
    if (self.incomeToEdit) {
        if (sender == self.recurringPeriodTextField) {
            self.recurringPeriodTextField.text =[NSString stringWithFormat:@"%d", self.incomeToEdit.recurringEndPeriod.intValue];
        }
        
        if (sender == self.recurringAmount) {
            self.recurringAmount.text =[NSString stringWithFormat:@"%@", self.incomeToEdit.recurringAmount];
        }
        
        if (sender == self.amountTextField) {
            self.amountTextField.text =[NSString stringWithFormat:@"%@", self.incomeToEdit.amount];
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

        if ([self.incomeToEdit.notes isEqualToString:@""]) {
            sender.text = @"";
        } else {
            sender.text = self.incomeToEdit.notes;
        }
        sender.textColor = [UIColor colorWithRed:0/255.0f green:150/255.0f blue:255/255.0f alpha:1.0f];
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