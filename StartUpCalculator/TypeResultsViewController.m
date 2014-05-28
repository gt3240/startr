//
//  TypeResultsViewController.m
//  StartUpCalculator
//
//  Created by Tom on 5/14/14.
//  Copyright (c) 2014 Tom Liu. All rights reserved.
//

#import "TypeResultsViewController.h"
#import "TypeResultsTableViewCell.h"
#import "InnerBand.h"
#import "Incomes.h"
#import "Expenses.h"
#import "Periods.h"

@interface TypeResultsViewController ()
{
    NSMutableArray *selectedPeriodsArr;
    NSArray *periodsArr;
    //income type nums
    NSNumber * othersTotal;
    NSNumber * investmentTotal;
    NSNumber * loanTotal;
    NSNumber * salesTotal;
    //expense type nums
    NSNumber *electricity;
    NSNumber *employee;
    NSNumber *cogs;
    NSNumber *rent;
    NSNumber *finance;
    NSNumber *automobile;
    NSNumber *marketing;
    NSNumber *expenses;
    NSNumber *telephone;
    NSNumber *hardware;
    NSNumber *water;
    
    NSNumber * undeclaredTotal;
    NSNumber * total;
    NSString * displayType;
    NSDictionary *displayItemDic;
    NSArray * keyArr;
    NSArray *valArr;
}
@end

@implementation TypeResultsViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    periodsArr = [NSArray array];

    [self loadPeriodFromProject:self.openProject];
    // Do any additional setup after loading the view.
}

- (void)viewWillAppear:(BOOL)animated
{
    NSArray *periodStrSplit = [self.periodStr componentsSeparatedByString:@"-"];
    selectedPeriodsArr = [NSMutableArray arrayWithCapacity:[periodStrSplit count]];
    [selectedPeriodsArr addObjectsFromArray:periodStrSplit];
    
    NSString *titleText = [[self.displayTitle substringToIndex:[self.displayTitle length]-2]capitalizedString];
    int titleNumber;
    if ([self.displayTitle isEqualToString:@"monthly"]) {
        titleNumber = (self.displayTitleNumber + 1) + ((self.displayTitleSectionNumber + 1) * 12 - 12);
    } else if ([self.displayTitle isEqualToString:@"quarterly"]) {
        titleNumber = (self.displayTitleNumber + 1) + ((self.displayTitleSectionNumber + 1) * 4 - 4);
    } else {
        titleNumber = self.displayTitleNumber + 1;
    }
    
    self.title = [NSString stringWithFormat:@"%@ %d", titleText, titleNumber];
    
    //NSLog(@"periodArr count is %lu", (unsigned long)selectedPeriodsArr.count);
    //NSLog(@"selectedPeriodArr count is %lu",(unsigned long)selectedPeriodsArr.count);
    
    [self calculateTotalForEachType:selectedPeriodsArr forType:@"income" forPeriod:periodsArr];
    
    displayType = @"income";
    self.typeSwitch.selectedSegmentIndex = 0;
    
    [self.mainTable reloadData];
//    NSLog(@"keyArr is %@", keyArr);
//    NSLog(@"valArr is %@", valArr);
}
- (IBAction)typeSwitched:(UISegmentedControl *)sender {
    
    if (sender.selectedSegmentIndex == 0) {
        [self calculateTotalForEachType:selectedPeriodsArr forType:@"income" forPeriod:periodsArr];
        displayType = @"income";
        //NSLog(@"income key count is %lu", (unsigned long)keyArr.count);
    } else {
        [self calculateTotalForEachType:selectedPeriodsArr forType:@"expense" forPeriod:periodsArr];
        displayType = @"expense";
        //NSLog(@"expense key count is %lu", (unsigned long)keyArr.count);
        NSLog(@"total is %@", total);

    }
    [self.mainTable reloadData];
}

- (void)calculateTotalForEachType: (NSMutableArray *)selectePeriodsArr forType:(NSString *)type forPeriod:(NSArray *)periodArr
{
    total = [NSNumber numberWithFloat:0.0];
    investmentTotal = [NSNumber numberWithFloat:0.0];
    loanTotal = [NSNumber numberWithFloat:0.0];
    salesTotal = [NSNumber numberWithFloat:0.0];
    
    finance = [NSNumber numberWithFloat:0.0];
    electricity = [NSNumber numberWithFloat:0.0];
    rent = [NSNumber numberWithFloat:0.0];
    telephone = [NSNumber numberWithFloat:0.0];
    expenses = [NSNumber numberWithFloat:0.0];
    hardware = [NSNumber numberWithFloat:0.0];
    water = [NSNumber numberWithFloat:0.0];
    automobile = [NSNumber numberWithFloat:0.0];
    employee = [NSNumber numberWithFloat:0.0];
    cogs = [NSNumber numberWithFloat:0.0];
    marketing = [NSNumber numberWithFloat:0.0];
    
    undeclaredTotal = [NSNumber numberWithFloat:0.0];
    othersTotal = [NSNumber numberWithFloat:0.0];
    
    for (int i = 0; i < selectePeriodsArr.count; i++) {
        NSString * selectIndex = selectePeriodsArr[i];
        NSLog(@"selectedIndex is %@",selectIndex);
        Periods * thisP = periodsArr[selectIndex.integerValue - 1];
        //NSLog(@"thisP is %@",thisP);
        
        if ([type isEqualToString:@"income"]) {
            NSArray *thisIncomeArr = [thisP.income allObjects];
            //NSLog(@"thisIncome has %lu",(unsigned long)thisIncomeArr.count);
            for (int incomeIndex = 0; incomeIndex < thisIncomeArr.count; incomeIndex++) {
                Incomes *thisIncome = thisIncomeArr[incomeIndex];
                //NSLog(@"income type is %@", thisIncome.type);
                if ([thisIncome.type isEqualToString:@"Investment"])
                {
                    investmentTotal = [NSNumber numberWithFloat:([investmentTotal floatValue] + [thisIncome.amount floatValue])];
                } else if ([thisIncome.type isEqualToString:@"Loan"]){
                    loanTotal = [NSNumber numberWithFloat:([loanTotal floatValue] + [thisIncome.amount floatValue])];
                } else if ([thisIncome.type isEqualToString:@"Sales"])
                {
                    salesTotal = [NSNumber numberWithFloat:([salesTotal floatValue] + [thisIncome.amount floatValue])];
                } else if ([thisIncome.type isEqualToString:@"Others"])
                {
                    othersTotal = [NSNumber numberWithFloat:([othersTotal floatValue] + [thisIncome.amount floatValue])];
                } else if ([thisIncome.type isEqualToString:@"Undeclared"])
                {
                    undeclaredTotal = [NSNumber numberWithFloat:([undeclaredTotal floatValue] + [thisIncome.amount floatValue])];
                }
            }
            displayItemDic = [NSDictionary dictionaryWithObjectsAndKeys:
                              investmentTotal, @"investment",
                              loanTotal, @"loan",
                              salesTotal, @"sales",
                              othersTotal, @"others",
                              undeclaredTotal, @"undeclared", nil];
             total = [NSNumber numberWithFloat:([loanTotal floatValue] + [salesTotal floatValue] + [undeclaredTotal floatValue] + [investmentTotal floatValue] + [othersTotal floatValue])];
            
        } else {
            NSArray *thisExpenseArr = [thisP.expense allObjects];
            
            NSLog(@"this expense has %lu",(unsigned long)thisExpenseArr.count);

            for (int i = 0; i < thisExpenseArr.count; i++) {
                
                //NSLog(@"thisIncome has %lu",(unsigned long)thisIncomeArr.count);
                Expenses *thisExpense = thisExpenseArr[i];
                NSLog(@"expense type is %@", thisExpense.type);
                if ([thisExpense.type isEqualToString:@"Electricity"])
                {
                    electricity = [NSNumber numberWithFloat:([electricity floatValue] + [thisExpense.amount floatValue])];
                } else if ([thisExpense.type isEqualToString:@"Employee"]){
                    employee = [NSNumber numberWithFloat:([employee floatValue] + [thisExpense.amount floatValue])];
                } else if ([thisExpense.type isEqualToString:@"COGS"])
                {
                    cogs = [NSNumber numberWithFloat:([cogs floatValue] + [thisExpense.amount floatValue])];
                } else if ([thisExpense.type isEqualToString:@"Rent"])
                {
                    rent = [NSNumber numberWithFloat:([rent floatValue] + [thisExpense.amount floatValue])];
                } else if ([thisExpense.type isEqualToString:@"Finance"])
                {
                    finance = [NSNumber numberWithFloat:([finance floatValue] + [thisExpense.amount floatValue])];
                } else if ([thisExpense.type isEqualToString:@"Automobile"])
                {
                    automobile = [NSNumber numberWithFloat:([automobile floatValue] + [thisExpense.amount floatValue])];
                } else if ([thisExpense.type isEqualToString:@"Marketing"])
                {
                    marketing = [NSNumber numberWithFloat:([marketing floatValue] + [thisExpense.amount floatValue])];
                } else if ([thisExpense.type isEqualToString:@"Telephone"])
                {
                    telephone = [NSNumber numberWithFloat:([telephone floatValue] + [thisExpense.amount floatValue])];
                } else if ([thisExpense.type isEqualToString:@"Expenses"])
                {
                    expenses = [NSNumber numberWithFloat:([expenses floatValue] + [thisExpense.amount floatValue])];
                } else if ([thisExpense.type isEqualToString:@"Hardware"])
                {
                    hardware = [NSNumber numberWithFloat:([hardware floatValue] + [thisExpense.amount floatValue])];
                } else if ([thisExpense.type isEqualToString:@"Water"])
                {
                    water = [NSNumber numberWithFloat:([water floatValue] + [thisExpense.amount floatValue])];
                }else if ([thisExpense.type isEqualToString:@"Others"])
                {
                    othersTotal = [NSNumber numberWithFloat:([othersTotal floatValue] + [thisExpense.amount floatValue])];
                } else if ([thisExpense.type isEqualToString:@"Undeclared"])
                {
                    undeclaredTotal = [NSNumber numberWithFloat:([undeclaredTotal floatValue] + [thisExpense.amount floatValue])];
                }
            }
            displayItemDic = [NSDictionary dictionaryWithObjectsAndKeys:
                              electricity, @"electricity",
                              employee, @"employee",
                              hardware, @"hardware",
                              rent, @"rent",
                              expenses, @"expenses",
                              telephone, @"telephone",
                              water, @"water",
                              marketing, @"marketing",
                              automobile, @"automobile",
                              finance, @"finance",
                              cogs, @"cogs",
                              othersTotal, @"others",
                              undeclaredTotal, @"undeclared", nil];
             total = [NSNumber numberWithFloat:([electricity floatValue] + [employee floatValue] + [hardware floatValue] + [expenses floatValue] + [telephone floatValue] + [water floatValue] + [marketing floatValue] + [automobile floatValue] + [finance floatValue] + [cogs floatValue] + [rent floatValue] + [othersTotal floatValue] + [undeclaredTotal floatValue])];
        }
    }
    
    //sort the dic into arr
    keyArr = [displayItemDic keysSortedByValueUsingComparator: ^(id obj1, id obj2) {
        if ([obj1 floatValue] > [obj2 floatValue]) {
            return (NSComparisonResult)NSOrderedAscending;
        }
        if ([obj1 floatValue] < [obj2 floatValue]) {
            return (NSComparisonResult)NSOrderedDescending;
        }
        return (NSComparisonResult)NSOrderedSame;
    }];

    valArr = [[displayItemDic allValues] sortedArrayUsingComparator:^(id obj1, id obj2) {
        if ([obj1 floatValue] > [obj2 floatValue]) {
            return (NSComparisonResult)NSOrderedAscending;
        }
        if ([obj1 floatValue] < [obj2 floatValue]) {
            return (NSComparisonResult)NSOrderedDescending;
        }
        return (NSComparisonResult)NSOrderedSame;
    }];
    // get total for percentage
   
}

-(void)loadPeriodFromProject:(Projects *)project
{
    NSSortDescriptor *sort = [NSSortDescriptor sortDescriptorWithKey:@"periodNum" ascending:YES];
    
    periodsArr = [project.period sortedArrayUsingDescriptors:@[sort]];
}

- (NSString *)formatToCurrency: (NSNumber *)amount{
    NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];
    [numberFormatter setNumberStyle: NSNumberFormatterCurrencyStyle];
    NSString *numberAsString = [numberFormatter stringFromNumber:[NSNumber numberWithFloat:amount.floatValue]];
    return numberAsString;
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    //NSLog(@"%lu", (unsigned long)self.periodArr.count);
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return displayItemDic.count;
}


 - (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
 {
 TypeResultsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"typeResultCell" forIndexPath:indexPath];
 
 // Configure the cell...
     cell.amountLabel.text = [self formatToCurrency:valArr[indexPath.row]];
     NSNumber * totalNum = [NSNumber numberWithFloat:([valArr[indexPath.row] floatValue] / [total floatValue])];
     if (totalNum.floatValue != totalNum.floatValue) {
         totalNum = [NSNumber numberWithFloat:0.0];
     }
     NSString *totalStr = [NSString stringWithFormat:@"%.2f%%", totalNum.floatValue * 100];
     cell.percentLabel.text =totalStr;

     if ([displayType isEqualToString:@"income"]) {
         cell.typeNameLabel.text = [[NSString stringWithFormat:@"%@", keyArr[indexPath.row]]capitalizedString];
         if ([keyArr[indexPath.row] isEqualToString:@"undeclared"]) {
             cell.typeImage.image = [UIImage imageNamed:@"PlaceHolderBlue"];
         } else {
             cell.typeImage.image = [UIImage imageNamed:keyArr[indexPath.row]];
         }
     } else {
         cell.typeNameLabel.text = [[NSString stringWithFormat:@"%@", keyArr[indexPath.row]]capitalizedString];

         if ([keyArr[indexPath.row] isEqualToString:@"undeclared"]) {
             cell.typeImage.image = [UIImage imageNamed:@"PlaceHolderRed"];
         } else {
             NSString *imgName = [NSString stringWithFormat:@"%@", keyArr[indexPath.row]];
             if ([imgName isEqualToString:@"cogs"]) {
                 imgName = @"COGS";
             } else if ([imgName isEqualToString:@"marketing"]) {
                 imgName = @"marketing";
             } else {
                 imgName = imgName.capitalizedString;
             }
             cell.typeImage.image = [UIImage imageNamed:imgName];
         }
     }
     
 return cell;
 }
 

@end
