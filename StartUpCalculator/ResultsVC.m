//
//  ResultsVC.m
//  StartUpCalculator
//
//  Created by Tom on 5/9/14.
//  Copyright (c) 2014 Tom Liu. All rights reserved.
//

#import "ResultsVC.h"
#import "ResultsTableViewCell.h"
#import "Periods.h"

@interface ResultsVC ()
{
    NSArray *periodsArr;
}
@end

@implementation ResultsVC

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
    periodsArr = [NSArray array];
}

- (void)viewWillAppear:(BOOL)animated
{
    [self setTabBarItemColor];
    //NSLog(@"project is %@", self.openProject);
    
    if (!self.openProject) {
        //alert
    } else {
    
        [self loadPeriodFromProject:self.openProject];
      
    }
    
    [self.resultTBV reloadData];
}

- (void)setTabBarItemColor
{
    self.tabBarController.tabBar.barTintColor = [UIColor colorWithRed:27/255.0f green:172/255.0f blue:167/255.0f alpha:1.0f];
    
    NSArray *items = self.tabBarController.tabBar.items;
    UITabBarItem *inBtn = items[0];
    UITabBarItem *outBtn = items[1];
    UITabBarItem *resultBtn = items[2];
    UITabBarItem *infoBtn = items[3];
    
    
    inBtn.image = [[UIImage imageNamed:@"In_iconGreen"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    
    outBtn.image = [[UIImage imageNamed:@"Out_iconGreen"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    infoBtn.image = [[UIImage imageNamed:@"profile_iconGreen"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    
    [resultBtn setTitleTextAttributes:@{NSFontAttributeName : [UIFont fontWithName:@"HelveticaNeue" size:10.0f],NSForegroundColorAttributeName : [UIColor whiteColor]} forState:UIControlStateHighlighted];
    
    [inBtn setTitleTextAttributes:@{NSFontAttributeName : [UIFont fontWithName:@"HelveticaNeue" size:10.0f],NSForegroundColorAttributeName : [UIColor colorWithRed:0/255.0f green:133/255.0f blue:142/255.0f alpha:1.0f]} forState:UIControlStateNormal];
    [outBtn setTitleTextAttributes:@{NSFontAttributeName : [UIFont fontWithName:@"HelveticaNeue" size:10.0f],NSForegroundColorAttributeName : [UIColor colorWithRed:0/255.0f green:133/255.0f blue:142/255.0f alpha:1.0f]} forState:UIControlStateNormal];
    [infoBtn setTitleTextAttributes:@{NSFontAttributeName : [UIFont fontWithName:@"HelveticaNeue" size:10.0f],NSForegroundColorAttributeName : [UIColor colorWithRed:0/255.0f green:133/255.0f blue:142/255.0f alpha:1.0f]} forState:UIControlStateNormal];
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
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return periodsArr.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ResultsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"resultsItemCell" forIndexPath:indexPath];
    Periods *imPeriod = periodsArr[indexPath.row];
    
    cell.periodLabel.text = imPeriod.periodNum.stringValue;
    cell.incomeAmountLabel.text = [self formatToCurrency:imPeriod.incomeTotal];
    cell.expenseAmountLabel.text = [self formatToCurrency:imPeriod.expenseTotal];
    
    NSNumber *pResult = [NSNumber numberWithFloat:([imPeriod.incomeTotal floatValue] - [imPeriod.expenseTotal floatValue])];
    
    cell.totalAmountLabel.text = [self formatToCurrency:pResult];

    return cell;
}

@end
