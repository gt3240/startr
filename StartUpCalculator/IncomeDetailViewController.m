//
//  IncomeDetailViewController.m
//  StartUpCalculator
//
//  Created by Tom on 4/28/14.
//  Copyright (c) 2014 Tom Liu. All rights reserved.
//

#import "IncomeDetailViewController.h"
#import "NewIncomeTableViewController.h"
#import "displayTypeImage.h"

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
    self.notesTextView.text = self.incomeToShowDetail.notes;
    
    displayTypeImage *img = [[displayTypeImage alloc]init];
    
    self.typeImage.image = [img showImage:self.incomeToShowDetail.type];
    
    if ([self.incomeToShowDetail.recurring intValue] == 1) {
        
        //self.recurringLabel.text = @"Increased by";
//        NSDateFormatter * dateFormatter = [[NSDateFormatter alloc] init];
//        [dateFormatter setDateFormat:@"MM-dd-yyyy HH:mm:ss"];
//        self.notesTextView.text = [dateFormatter stringFromDate:self.incomeToShowDetail.recurringDateID];
        
        self.recurUntilLabel.text = [NSString stringWithFormat: @"Repeat until month %@", self.incomeToShowDetail.recurringEndPeriod.stringValue];
        
        //NSLog(@"type is %@", self.incomeToShowDetail.period.periodType);
        self.recurringAmountLabel.text = self.incomeToShowDetail.recurringAmount.stringValue;
        if ([self.incomeToShowDetail.recurringType isEqualToString:@"fixedAmount"]){
            
            if (self.incomeToShowDetail.recurringAmount.intValue < 0) {
                self.recurringAmountLabel.text = [NSString stringWithFormat:@"-$%@", [NSNumber numberWithFloat:(self.incomeToShowDetail.recurringAmount.floatValue * -1)]];
            } else {
                self.recurringAmountLabel.text = [NSString stringWithFormat:@"$%@", self.incomeToShowDetail.recurringAmount];
                
            }
        } else {
            
            if (self.incomeToShowDetail.recurringAmount.intValue < 0) {
                self.recurringAmountLabel.text = [NSString stringWithFormat:@"-%@%%", [NSNumber numberWithFloat:(self.incomeToShowDetail.recurringAmount.floatValue * -1)]];
            } else {
                self.recurringAmountLabel.text = [NSString stringWithFormat:@"%@%%", self.incomeToShowDetail.recurringAmount];
            }
        }
    } else {
        self.recurringAmountLabel.text = @"---";
        //self.recurringLabel.text = @"";
    }
}

- (void)setTabBarItemColor
{
    self.tabBarController.tabBar.barTintColor = [UIColor colorWithRed:0/255.0f green:150/255.0f blue:255/255.0f alpha:1.0f];
    
    self.tabBarController.tabBar.tintColor = [UIColor whiteColor];
    
    NSArray *items = self.tabBarController.tabBar.items;
    UITabBarItem *inBtn = items[0];
    UITabBarItem *outBtn = items[1];
    UITabBarItem *resultBtn = items[2];
    UITabBarItem *infoBtn = items[3];
    
    
    outBtn.image = [[UIImage imageNamed:@"Out_iconBlue"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    
    resultBtn.image = [[UIImage imageNamed:@"Results_iconBlue"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    infoBtn.image = [[UIImage imageNamed:@"profile_iconBlue"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    
    [inBtn setTitleTextAttributes:@{NSFontAttributeName : [UIFont fontWithName:@"HelveticaNeue" size:10.0f],NSForegroundColorAttributeName : [UIColor whiteColor]} forState:UIControlStateHighlighted];
    
    [outBtn setTitleTextAttributes:@{NSFontAttributeName : [UIFont fontWithName:@"HelveticaNeue" size:10.0f],NSForegroundColorAttributeName : [UIColor colorWithRed:0/255.0f green:93/255.0f blue:188/255.0f alpha:1.0f]} forState:UIControlStateNormal];
    [resultBtn setTitleTextAttributes:@{NSFontAttributeName : [UIFont fontWithName:@"HelveticaNeue" size:10.0f],NSForegroundColorAttributeName : [UIColor colorWithRed:0/255.0f green:93/255.0f blue:188/255.0f alpha:1.0f]} forState:UIControlStateNormal];
    [infoBtn setTitleTextAttributes:@{NSFontAttributeName : [UIFont fontWithName:@"HelveticaNeue" size:10.0f],NSForegroundColorAttributeName : [UIColor colorWithRed:0/255.0f green:93/255.0f blue:188/255.0f alpha:1.0f]} forState:UIControlStateNormal];
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

    //destination.addIncomeDelegate = self;
    
    //NSMutableArray * imIncomeArrayToSend = [NSMutableArray array];
    
}
@end
