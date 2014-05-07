//
//  IncomeDetailViewController.m
//  StartUpCalculator
//
//  Created by Tom on 4/28/14.
//  Copyright (c) 2014 Tom Liu. All rights reserved.
//

#import "IncomeDetailViewController.h"
#import "NewIncomeTableViewController.h"

@interface IncomeDetailViewController ()

@end

@implementation IncomeDetailViewController

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
    // Do any additional setup after loading the view.
}

-(void)viewWillAppear:(BOOL)animated
{
    [self setTabBarItemColor];
    
    self.amountLabel.text = [self formatToCurrency:self.incomeToShowDetail.amount];
    self.titleLabel.text = self.incomeToShowDetail.title;
    self.fromLabel.text = self.incomeToShowDetail.source;
    
    if ([self.incomeToShowDetail.type isEqualToString:@"Investment"])
    {
        self.typeImage.image = [UIImage imageNamed:@"investment"];
    } else if ([self.incomeToShowDetail.type isEqualToString:@"Loan"]){
        self.typeImage.image = [UIImage imageNamed:@"loan"];
    } else if ([self.incomeToShowDetail.type isEqualToString:@"Sales"])
    {
        self.typeImage.image = [UIImage imageNamed:@"sales"];
    } else if ([self.incomeToShowDetail.type isEqualToString:@"Others"])
    {
        self.typeImage.image = [UIImage imageNamed:@"others"];
    } else         {
        self.typeImage.image = [UIImage imageNamed:@""];
    }

    
    if ([self.incomeToShowDetail.recurring intValue] == 1) {
        
        //self.recurringLabel.text = @"Increased by";
        NSDateFormatter * dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"MM-dd-yyyy HH:mm:ss"];
        self.notesTextView.text = [dateFormatter stringFromDate:self.incomeToShowDetail.recurringDateID];
        
        self.recurUntilLabel.text = [NSString stringWithFormat: @"Recur until %@ %@", self.incomeToShowDetail.period.projects.type, self.incomeToShowDetail.recurringEndPeriod.stringValue];
        
        NSLog(@"type is %@", self.incomeToShowDetail.period.periodType);
        self.recurringAmountLabel.text = self.incomeToShowDetail.recurringAmount.stringValue;
        if ([self.incomeToShowDetail.recurringType isEqualToString:@"fixedAmount"]){
            
            self.recurringAmountLabel.text = [NSString stringWithFormat:@"$%@", self.incomeToShowDetail.recurringAmount];
        } else {
            
            self.recurringAmountLabel.text = [NSString stringWithFormat:@"%@%%", self.incomeToShowDetail.recurringAmount];
        }
    } else {
        self.recurringAmountLabel.text = @"---";
        //self.recurringLabel.text = @"";
    }
}

- (void)setTabBarItemColor
{
    self.tabBarController.tabBar.barTintColor = [UIColor colorWithRed:0/255.0f green:150/255.0f blue:255/255.0f alpha:1.0f];
    
    NSArray *items = self.tabBarController.tabBar.items;
    UITabBarItem *outBtn = items[1];
    UITabBarItem *resultBtn = items[2];
    
    outBtn.image = [[UIImage imageNamed:@"Out_iconBlue"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    
    resultBtn.image = [[UIImage imageNamed:@"Results_iconBlue"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
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
    
    destination.projectToAdd = self.projectToAdd;
    destination.periodToAdd = self.periodToAdd;


    destination.addIncomeDelegate = self;
    
    //NSMutableArray * imIncomeArrayToSend = [NSMutableArray array];
    
}
@end
