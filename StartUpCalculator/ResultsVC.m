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
    NSMutableArray *groupedPeriods;
    NSMutableDictionary * incomeDic;
    NSMutableDictionary *expenseDic;
    NSArray *incomeArr;
    NSArray *expenseArr;
    NSString * displayType; // 1 for monthly, 2 for quarterly, 3 for yearly
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
    incomeDic = [NSMutableDictionary dictionary];
    expenseDic = [NSMutableDictionary dictionary];
    incomeArr = [NSArray array];
    expenseArr = [NSArray array];
    displayType = @"monthly"; // 1 for monthly, 2 for quarterly, 3 for yearly
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
    
    //[self groupPeriodArr:periodsArr intoGroupsof:1];
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

- (IBAction)displayTypeChanged:(UISegmentedControl *)sender {
    if (sender.selectedSegmentIndex == 1) {
        [self groupPeriodArr:periodsArr intoGroupsof:3];
        NSLog(@" Quarterly selected");
        NSLog(@"in count is %lu", (unsigned long)incomeArr.count);
        displayType = @"quarterly";
        [self.resultTBV reloadData];
        
    } else if (sender.selectedSegmentIndex == 2) {
        NSLog(@" Yearly selected");
        [self groupPeriodArr:periodsArr intoGroupsof:12];
        NSLog(@"in count is %lu", (unsigned long)incomeArr.count);
        NSLog(@" ceil is %f", ceil(((double)incomeArr.count) / 12));
        displayType = @"yearly";
        [self.resultTBV reloadData];

    } else {
        NSLog(@" Monthly selected");
        [self groupPeriodArr:periodsArr intoGroupsof:1];
        NSLog(@"in count is %lu", (unsigned long)incomeArr.count);
        displayType = @"monthly";
        [self.resultTBV reloadData];
    }
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if ([displayType isEqualToString:@"monthly"]) {
        return 1;
    } else if ([displayType isEqualToString:@"quarterly"]){
        return ceil(((double)incomeArr.count) / 3);
    } else {
        return incomeArr.count;
        
    }
    
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    
    NSString *sectionName = [NSString stringWithFormat:@"Year %ld", (long)section + 1];
    return sectionName;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if ([displayType isEqualToString:@"monthly"]) {
        return incomeArr.count;
    } else if ([displayType isEqualToString:@"quarterly"]){
        return 4;
    } else {
        return 1;
    }
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ResultsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"resultsItemCell" forIndexPath:indexPath];
    /*
    Periods *imPeriod = periodsArr[indexPath.row];
    
    cell.periodLabel.text = imPeriod.periodNum.stringValue;
    cell.incomeAmountLabel.text = [self formatToCurrency:imPeriod.incomeTotal];
    cell.expenseAmountLabel.text = [self formatToCurrency:imPeriod.expenseTotal];
    
    NSNumber *pResult = [NSNumber numberWithFloat:([imPeriod.incomeTotal floatValue] - [imPeriod.expenseTotal floatValue])];
    
    cell.totalAmountLabel.text = [self formatToCurrency:pResult];
     */
    
    NSMutableDictionary *inDic = [incomeArr objectAtIndex:indexPath.row];
    //cell.periodLabel.text = [inDic objectForKey:@"dicKey"];
    
    return cell;
}

- (void)groupPeriodArr: (NSArray *)periodArr intoGroupsof:(int)groupSize
{
    [incomeDic removeAllObjects];
    [expenseDic removeAllObjects];
   
    int arrSize = (int)periodsArr.count;
    double numOfGroups = ceil(((double)arrSize) / groupSize);
    groupedPeriods = [NSMutableArray array];
    int currentP = 0;
    float groupIncomeTotal = 0;
    float groupExpenseTotal = 0;
    NSString *dicKey = @"";
    NSString *incomeDicVal = @"";
    NSString *expenseDicVal = @"";
    for (int g = 0; g < numOfGroups; g++) {
        //NSLog(@"g is %d", g);
        groupIncomeTotal = 0;
        groupExpenseTotal = 0;
        for (int p = 0; p < groupSize; p++) {
            if (currentP < periodsArr.count) {
                Periods * thisP = periodsArr[currentP];
                groupIncomeTotal = groupIncomeTotal + thisP.incomeTotal.floatValue;
                groupExpenseTotal = groupExpenseTotal + thisP.expenseTotal.floatValue;

                currentP++;
            }
            dicKey = [NSString stringWithFormat:@"%d", g+1];
            incomeDicVal = [NSString stringWithFormat:@"%.2f", groupIncomeTotal];
            expenseDicVal = [NSString stringWithFormat:@"%.2f", groupExpenseTotal];
        }
        [incomeDic setValue:incomeDicVal forKey:dicKey];
        [expenseDic setValue:expenseDicVal forKey:dicKey];
        //NSLog(@"incomeDic is %@", incomeDic);
        //NSLog(@"expense Dic is %@", expenseDic);
        incomeArr = [incomeDic allKeys];
        expenseArr = [expenseDic allKeys];

    }
}


@end
