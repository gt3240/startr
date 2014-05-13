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
    NSMutableArray *incomeArr;
    NSArray *expenseArr;
    NSMutableArray *dicArr;
    NSString * displayType; // 1 for monthly, 2 for quarterly, 3 for yearly
    int sectionCount;
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
    incomeArr = [NSMutableArray array];
    expenseArr = [NSArray array];
    dicArr = [NSMutableArray array];
    [self loadPeriodFromProject:self.openProject];
    [self groupPeriodArr:periodsArr intoGroupsof:1];
    sectionCount = ceil(((double)incomeArr.count) / 12);
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
        sectionCount = ceil(((double)incomeArr.count) / 4);
        
        [self.resultTBV reloadData];
        
    } else if (sender.selectedSegmentIndex == 2) {
        NSLog(@" Yearly selected");
        [self groupPeriodArr:periodsArr intoGroupsof:12];
        NSLog(@"in count is %lu", (unsigned long)incomeArr.count);
        displayType = @"yearly";
        sectionCount = incomeArr.count;
        [self.resultTBV reloadData];

    } else {
        NSLog(@" Monthly selected");
        [self groupPeriodArr:periodsArr intoGroupsof:1];
        NSLog(@"in count is %lu", (unsigned long)incomeArr.count);
        displayType = @"monthly";
        sectionCount = ceil(((double)incomeArr.count) / 12);
        [self.resultTBV reloadData];
    }
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return sectionCount;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    
    NSString *sectionName = [NSString stringWithFormat:@"Year %ld", (long)section + 1];
    
    return sectionName;

}

- (int)getNumOfLeftOverRows: (int)displayTypeCount
{
    int difference = incomeArr.count - incomeArr.count / displayTypeCount * displayTypeCount;
    if (difference == 0) {
        return displayTypeCount;
    } else {
        return difference;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if ([displayType isEqualToString:@"monthly"]) {
        if (section == sectionCount - 1) {
            return [self getNumOfLeftOverRows:12];
        } else {
            return 12;
            
        }
    } else if ([displayType isEqualToString:@"quarterly"]){
        
        if (section == sectionCount - 1) {
            return [self getNumOfLeftOverRows:4];
        } else {
            return 4;
        }
        
    } else {
        // yearly
        return 1;
    }
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ResultsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"resultsItemCell" forIndexPath:indexPath];
 
    cell.periodLabel.text = [[incomeArr objectAtIndex:indexPath.row]  objectForKey:@"period"];
    NSString * incomeStr = [[incomeArr objectAtIndex:indexPath.row]  objectForKey:@"incomeTotal"];
    float income = incomeStr.floatValue;
    
    NSString *expenseStr = [[incomeArr objectAtIndex:indexPath.row]  objectForKey:@"expenseTotal"];
    float expense = expenseStr.floatValue;
    
    cell.incomeAmountLabel.text = [self formatToCurrency:[[incomeArr objectAtIndex:indexPath.row]  objectForKey:@"incomeTotal"]];
    cell.expenseAmountLabel.text = [self formatToCurrency:[[incomeArr objectAtIndex:indexPath.row]  objectForKey:@"expenseTotal"]];
    
    float total = income - expense;
    
    cell.totalAmountLabel.text = [self formatToCurrency:[NSNumber numberWithFloat:total]];
    NSLog(@"total is %f", total);
    return cell;
}

- (void)groupPeriodArr: (NSArray *)periodArr intoGroupsof:(int)groupSize
{
    [incomeDic removeAllObjects];
    [expenseDic removeAllObjects];
    [incomeArr removeAllObjects];
   
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
      
        NSDictionary *dic1 = [NSDictionary dictionaryWithObjectsAndKeys:
                                        dicKey, @"period",
                                        incomeDicVal, @"incomeTotal",
                                        expenseDicVal, @"expenseTotal", nil];
        
        [incomeArr addObject:dic1];
        
        //[incomeDic setValue:incomeDicVal forKey:dicKey];
        //[expenseDic setValue:expenseDicVal forKey:dicKey];
        //NSLog(@"incomeDic is %@", incomeDic);
        //NSLog(@"expense Dic is %@", expenseDic);
        //incomeArr = [incomeDic allKeys];
        //expenseArr = [expenseDic allKeys];

    }
}


@end
