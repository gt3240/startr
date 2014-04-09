//
//  IncomeDetailsTableViewController.m
//  StartUpCalculator
//
//  Created by Tom on 3/31/14.
//  Copyright (c) 2014 Tom Liu. All rights reserved.
//

#import "IncomeDetailsTableViewController.h"
#import "Incomes.h"
#import "NewIncomeTableViewController.h"

@interface IncomeDetailsTableViewController ()
{
    Incomes * imIncome;
}
@end

@implementation IncomeDetailsTableViewController

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
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
}

-(void)viewWillAppear:(BOOL)animated
{
    /*
    imIncome = self.incomeToShowDetail[0];
    
    //NSLog(@"%lu", (unsigned long)self.incomeToShowDetail.count);
    
    self.amountLabel.text = [NSString stringWithFormat:@"$%@", imIncome.amount];
    
    self.titleLabel.text = imIncome.title;
    
    self.fromLabel.text = imIncome.source;
    
    if (imIncome.recurring) {
        self.recurringAmountLabel.text = imIncome.recurring_amount.stringValue;
        if ([imIncome.recurring_type isEqualToString:@"fixedAmount"]){
            
            self.recurringAmountLabel.text = [NSString stringWithFormat:@"$%@", imIncome.recurring_amount];
        } else {
            
            self.recurringAmountLabel.text = [NSString stringWithFormat:@"%@%%", imIncome.recurring_amount];
            
        }
    } else {
        self.recurringAmountLabel.text = @"";
        self.recurringLabel.text = @"";
    }
     */
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    UINavigationController *newNav = segue.destinationViewController;
    NewIncomeTableViewController *destination = newNav.viewControllers[0];
    
    destination.incomeToEdit = self.incomeToShowDetail;
    
    destination.editDelegate = self;
    
    //NSMutableArray * imIncomeArrayToSend = [NSMutableArray array];
    
    //[imIncomeArrayToSend addObject:imIncome];
    
    //destination.incomeToEdit = imIncomeArrayToSend;
    
    //NSLog(@"%lu", (unsigned long)self.incomeToShowDetail.count);
}

@end
