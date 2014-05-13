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
    NSString * displayType;
    int sectionCount;
    int currentSection;
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
    displayType = @"monthly";
    //[self groupPeriodArr:periodsArr intoGroupsof:1];
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [self setTabBarItemColor];
    //NSLog(@"project is %@", self.openProject);
    
    [self loadPeriodFromProject:self.openProject];
    
    [self groupPeriodArr:periodsArr intoGroupsof:displayType];
    
    if ([displayType isEqualToString:@"monthly"]) {
        sectionCount = ceil(((double)incomeArr.count) / 12);
    } else if ([displayType isEqualToString:@"quarterly"]) {
        sectionCount = ceil(((double)incomeArr.count) / 4);
    } if ([displayType isEqualToString:@"yearly"]) {
        sectionCount = 1;
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

- (IBAction)displayTypeChanged:(UISegmentedControl *)sender {
    if (sender.selectedSegmentIndex == 1) {
        displayType = @"quarterly";
        [self groupPeriodArr:periodsArr intoGroupsof:displayType];
        sectionCount = ceil(((double)incomeArr.count) / 4);
        
        [self.resultTBV reloadData];
        
    } else if (sender.selectedSegmentIndex == 2) {
        displayType = @"yearly";
        [self groupPeriodArr:periodsArr intoGroupsof:displayType];
        sectionCount = 1;
        [self.resultTBV reloadData];

    } else {
        displayType = @"monthly";
        [self groupPeriodArr:periodsArr intoGroupsof:displayType];
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
    if ([displayType isEqualToString:@"monthly"] || [displayType isEqualToString:@"quarterly"]) {
        NSString *sectionName = [NSString stringWithFormat:@"Year %ld", (long)section + 1];
        
        return sectionName;
    } else {
        return @"";
    }
}

- (int)getNumOfLeftOverRows: (int)displayTypeCount
{
    int difference = (int)incomeArr.count - (int)incomeArr.count / displayTypeCount * displayTypeCount;
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
        return incomeArr.count;
    }
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ResultsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"resultsItemCell" forIndexPath:indexPath];
    NSString * incomeStr;
    NSString *expenseStr;
    NSString * z = [[incomeArr objectAtIndex:indexPath.row]  objectForKey:@"period"];
    if ([displayType isEqualToString:@"monthly"]) {
        currentSection = (int)indexPath.section * 12;
        int sec = z.intValue + currentSection;
        cell.periodLabel.text =[[incomeArr objectAtIndex:indexPath.row]  objectForKey:@"period"];
        cell.incomeAmountLabel.text = [self formatToCurrency:[[incomeArr objectAtIndex:sec - 1]  objectForKey:@"incomeTotal"]];
        cell.expenseAmountLabel.text = [self formatToCurrency:[[incomeArr objectAtIndex:sec -1]  objectForKey:@"expenseTotal"]];
        incomeStr = [[incomeArr objectAtIndex:sec - 1]  objectForKey:@"incomeTotal"];
        expenseStr = [[incomeArr objectAtIndex:sec - 1]  objectForKey:@"expenseTotal"];
        //cell.periodLabel.text =[NSString stringWithFormat:@"%d", sec];
        
    } else if ([displayType isEqualToString:@"quarterly"]) {
        currentSection = (int)indexPath.section * 4;
        int sec = z.intValue + currentSection;
        cell.periodLabel.text =[[incomeArr objectAtIndex:indexPath.row]  objectForKey:@"period"];
        cell.incomeAmountLabel.text = [self formatToCurrency:[[incomeArr objectAtIndex:sec - 1]  objectForKey:@"incomeTotal"]];
        cell.expenseAmountLabel.text = [self formatToCurrency:[[incomeArr objectAtIndex:sec - 1]  objectForKey:@"expenseTotal"]];
        incomeStr = [[incomeArr objectAtIndex:sec - 1]  objectForKey:@"incomeTotal"];
        expenseStr = [[incomeArr objectAtIndex:sec - 1]  objectForKey:@"expenseTotal"];
    } else if ([displayType isEqualToString:@"yearly"]) {
        cell.periodLabel.text =[[incomeArr objectAtIndex:indexPath.row]  objectForKey:@"period"];
        cell.incomeAmountLabel.text = [self formatToCurrency:[[incomeArr objectAtIndex:indexPath.row]  objectForKey:@"incomeTotal"]];
        cell.expenseAmountLabel.text = [self formatToCurrency:[[incomeArr objectAtIndex:indexPath.row]  objectForKey:@"expenseTotal"]];
        incomeStr = [[incomeArr objectAtIndex:indexPath.row]  objectForKey:@"incomeTotal"];
        expenseStr = [[incomeArr objectAtIndex:indexPath.row]  objectForKey:@"expenseTotal"];
        //NSLog(@"z is %@",z);
    }
    
    NSString *str = displayType;
    NSString *truncatedDisplayTypeString = [str substringToIndex:[str length]-2];
    
    cell.typeLabel.text = [truncatedDisplayTypeString capitalizedString];

    float income = incomeStr.floatValue;
    
    float expense = expenseStr.floatValue;
    
    float total = income - expense;
    
    cell.totalAmountLabel.text = [self formatToCurrency:[NSNumber numberWithFloat:total]];
    //NSLog(@"total is %f", total);
    return cell;
}

- (void)groupPeriodArr: (NSArray *)periodArr intoGroupsof:(NSString *)groupType
{
    [incomeDic removeAllObjects];
    [expenseDic removeAllObjects];
    [incomeArr removeAllObjects];
    int groupSize;
    if ([groupType isEqualToString:@"monthly"]) {
        groupSize = 1;
    } else if ([groupType isEqualToString:@"quarterly"]) {
        groupSize = 3;
    } else if ([groupType isEqualToString:@"yearly"]) {
        groupSize = 12;
    }
    
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
         }
}


@end
