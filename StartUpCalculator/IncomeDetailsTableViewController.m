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
    
    self.amountLabel.text = [self formatToCurrency:self.incomeToShowDetail.amount];
    self.titleLabel.text = self.incomeToShowDetail.title;
    
    
    self.fromLabel.text = self.incomeToShowDetail.source;
    
    if ([self.incomeToShowDetail.recurring intValue] == 1) {
        
        self.recurringLabel.text = @"Increased by";
        
        self.recurringAmountLabel.text = self.incomeToShowDetail.recurringAmount.stringValue;
        if ([self.incomeToShowDetail.recurringType isEqualToString:@"fixedAmount"]){
            
            self.recurringAmountLabel.text = [NSString stringWithFormat:@"$%@", self.incomeToShowDetail.recurringAmount];
        } else {
            
            self.recurringAmountLabel.text = [NSString stringWithFormat:@"%@%%", self.incomeToShowDetail.recurringAmount];
            
        }
    } else {
        self.recurringAmountLabel.text = @"";
        self.recurringLabel.text = @"";
    }
}

- (NSString *)formatToCurrency: (NSNumber *)amount{
    NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];
    [numberFormatter setNumberStyle: NSNumberFormatterCurrencyStyle];
    NSString *numberAsString = [numberFormatter stringFromNumber:[NSNumber numberWithFloat:amount.floatValue]];
    return numberAsString;
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    UINavigationController *newNav = segue.destinationViewController;
    NewIncomeTableViewController *destination = newNav.viewControllers[0];
    
    destination.incomeToEdit = self.incomeToShowDetail;
    
    destination.editIncomeDelegate = self;
    
    //NSMutableArray * imIncomeArrayToSend = [NSMutableArray array];
    
}

@end
