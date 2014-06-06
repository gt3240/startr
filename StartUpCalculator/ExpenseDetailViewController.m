//
//  ExpenseDetailViewController.m
//  StartUpCalculator
//
//  Created by Tom on 5/8/14.
//  Copyright (c) 2014 Tom Liu. All rights reserved.
//

#import "ExpenseDetailViewController.h"
#import "NewExpenseTableViewController.h"
#import "displayTypeImage.h"

@interface ExpenseDetailViewController ()

@end

@implementation ExpenseDetailViewController
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
    
    self.amountLabel.text = [self formatToCurrency:self.expenseToShowDetail.amount];
    self.titleLabel.text = self.expenseToShowDetail.title;
    self.fromLabel.text = self.expenseToShowDetail.source;
    self.notesTextView.text = self.expenseToShowDetail.notes;
    
    displayTypeImage *img = [[displayTypeImage alloc]init];
    
    self.typeImage.image = [img showImage:self.expenseToShowDetail.type];
    
    //NSLog(@"\n\n pos or neg %@", self.incomeToShowDetail.recurringPostiveOrNegative);
    
    if ([self.expenseToShowDetail.recurring intValue] == 1) {
        
        //self.recurringLabel.text = @"Increased by";
        //        NSDateFormatter * dateFormatter = [[NSDateFormatter alloc] init];
        //        [dateFormatter setDateFormat:@"MM-dd-yyyy HH:mm:ss"];
        //        self.notesTextView.text = [dateFormatter stringFromDate:self.incomeToShowDetail.recurringDateID];
        
        self.changeByLabel.text = @"To change by:";
        
        self.recurUntilLabel.text = [NSString stringWithFormat: @"Repeat until month %@", self.expenseToShowDetail.recurringEndPeriod.stringValue];
        
        //NSLog(@"type is %@", self.incomeToShowDetail.period.periodType);
        self.recurringAmountLabel.text = self.expenseToShowDetail.recurringAmount.stringValue;
        if ([self.expenseToShowDetail.recurringType isEqualToString:@"fixedAmount"]){
            
            if ([self.expenseToShowDetail.recurringPostiveOrNegative isEqualToString:@"negative"]) {
                self.recurringAmountLabel.text = [NSString stringWithFormat:@"-$%@", [NSNumber numberWithFloat:(self.expenseToShowDetail.recurringAmount.floatValue)]];
            } else {
                self.recurringAmountLabel.text = [NSString stringWithFormat:@"$%@", self.expenseToShowDetail.recurringAmount];
                
            }
        } else {
            
            if ([self.expenseToShowDetail.recurringPostiveOrNegative isEqualToString:@"negative"]) {
                self.recurringAmountLabel.text = [NSString stringWithFormat:@"-%@%%", [NSNumber numberWithFloat:(self.expenseToShowDetail.recurringAmount.floatValue)]];
            } else {
                self.recurringAmountLabel.text = [NSString stringWithFormat:@"%@%%", self.expenseToShowDetail.recurringAmount];
            }
        }
    } else {
        [self.recurringAmountLabel setHidden:YES];
        [self.recurUntilLabel setHidden:YES];
        self.changeByLabel.text = @"Non repeat item";
    }
}

-(void)setTabBarItemColor
{
    self.tabBarController.tabBar.barTintColor = [UIColor colorWithRed:235/255.0f green:92/255.0f blue:104/255.0f alpha:1.0f];
    
    self.tabBarController.tabBar.tintColor = [UIColor whiteColor];
    
    NSArray *items = self.tabBarController.tabBar.items;
    UITabBarItem *inBtn = items[0];
    UITabBarItem *outBtn = items[1];
    UITabBarItem *resultBtn = items[2];
    UITabBarItem *infoBtn = items[3];
    
    inBtn.image = [[UIImage imageNamed:@"In_iconRed"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    
    resultBtn.image = [[UIImage imageNamed:@"Results_iconRed"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    infoBtn.image = [[UIImage imageNamed:@"profile_iconRed"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    
    [outBtn setTitleTextAttributes:@{NSFontAttributeName : [UIFont fontWithName:@"HelveticaNeue" size:10.0f],NSForegroundColorAttributeName : [UIColor whiteColor]} forState:UIControlStateHighlighted];
    
    [inBtn setTitleTextAttributes:@{NSFontAttributeName : [UIFont fontWithName:@"HelveticaNeue" size:10.0f],NSForegroundColorAttributeName : [UIColor colorWithRed:168/255.0f green:60/255.0f blue:82/255.0f alpha:1.0f]} forState:UIControlStateNormal];
    [resultBtn setTitleTextAttributes:@{NSFontAttributeName : [UIFont fontWithName:@"HelveticaNeue" size:10.0f],NSForegroundColorAttributeName : [UIColor colorWithRed:168/255.0f green:60/255.0f blue:82/255.0f alpha:1.0f]} forState:UIControlStateNormal];
    [infoBtn setTitleTextAttributes:@{NSFontAttributeName : [UIFont fontWithName:@"HelveticaNeue" size:10.0f],NSForegroundColorAttributeName : [UIColor colorWithRed:168/255.0f green:60/255.0f blue:82/255.0f alpha:1.0f]} forState:UIControlStateNormal];
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
    NewExpenseTableViewController *destination = newNav.viewControllers[0];
    
    destination.expenseToEdit = self.expenseToShowDetail;
    
    destination.projectToAdd = self.projectToAdd;
    destination.periodToAdd = self.periodToAdd;
    
    //destination.addExpenseDelegate = self;
    
    //NSMutableArray * imIncomeArrayToSend = [NSMutableArray array];
    
}
@end
