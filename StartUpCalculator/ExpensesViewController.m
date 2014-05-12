//
//  ExpensesViewController.m
//  StartUpCalculator
//
//  Created by Tom on 4/24/14.
//  Copyright (c) 2014 Tom Liu. All rights reserved.
//

#import "ExpensesViewController.h"
#import "ExpenseItemsTableViewCell.h"
#import "Expenses.h"
#import "ViewPeriodCollectionCell.h"
#import "Projects.h"
#import "InnerBand.h"
#import "Periods.h"
#import "ExpenseDetailViewController.h"

@interface ExpensesViewController ()
{
    BOOL buttonIsSelected;
    ViewPeriodCollectionCell * selectedCell;
    int expenseRowCount;
    int periodCount;
    float monthlyTotal;
    Periods *periodToShow;
    Projects *currentProject;
}
@end

@implementation ExpensesViewController

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
}

-(void)viewWillAppear:(BOOL)animated
{
    [self setTabBarItemColor];
    
    if (!self.projectToOpen) {
        NSLog(@"Please create a project or open a saved project");
        //self.projectIndexToOpen = @1;
    } else {
        
        //[self loadPeriodFromProject:self.projectIndexToOpen.intValue];
        currentProject = self.projectToOpen;
        
        [self loadPeriodFromProject:currentProject];
        
        //NSLog(@"projectIndexToOpen is %@", self.projectIndexToOpen);
        //NSLog(@"project is %@", self.projectToOpen);
        
        
        if (!periodToShow) {
            periodToShow = periodsArr[0];
        } else {
            periodToShow = periodsArr[previousSelected];
        }
        
        [self loadIncome];
        
        expenseRowCount = (int)expenseArr.count;
    }
    
    self.termsTypeLabel.text = self.projectToOpen.type;
    
    [self.periodCollectionView reloadData];
    [self.mainTableView reloadData];

}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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

#pragma mark - Buttons or action

-(void)loadPeriodFromProject:(Projects *)project
{
    NSSortDescriptor *sort = [NSSortDescriptor sortDescriptorWithKey:@"periodNum" ascending:YES];
    
    periodsArr = [project.period sortedArrayUsingDescriptors:@[sort]];
}

-(void)loadIncome
{
    NSSortDescriptor *expenseSort = [NSSortDescriptor sortDescriptorWithKey:@"title" ascending:YES];
    expenseArr = [periodToShow.expense sortedArrayUsingDescriptors:@[expenseSort]];
}

- (NSString *)formatToCurrency: (NSNumber *)amount{
    NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];
    [numberFormatter setNumberStyle: NSNumberFormatterCurrencyStyle];
    NSString *numberAsString = [numberFormatter stringFromNumber:[NSNumber numberWithFloat:amount.floatValue]];
    return numberAsString;
}

-(void)expenseAdded
{
    //periodToShow = periodsArr[previousSelected];
    
    [self loadIncome];
    
    expenseRowCount = (int)expenseArr.count;
    
    [self.mainTableView reloadData];
    
    NSLog(@"selected period tag is %ld", (long)selectedCell.tag);
}

- (IBAction)AddPeriodButtonPressed:(UIButton *)sender {
    Periods *newPeriod = [Periods create];
    NSNumber *currentCount = [NSNumber numberWithInt:periodCount];
    NSNumber *addCount = @1;
    NSNumber *newCount = @([currentCount intValue] + [addCount intValue]);
    newPeriod.periodNum = newCount;
    [currentProject addPeriodObject:newPeriod];
    [[IBCoreDataStore mainStore] save];
    
    periodCount = newCount.intValue;
    
    [self loadPeriodFromProject:currentProject];
    
    [self.periodCollectionView reloadData];
}

#pragma mark - CollectionView
-(long)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 2;
}

-(long)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    if (section == 1){
        return 1;
    } else {
        periodCount = (int)periodsArr.count;
        //NSLog(@"periodCount is %d", periodCount);
        return periodCount;
    }
}


-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *cellType = @"PeriodCollectionCell";
    
    if (indexPath.section == 1) {
        cellType = @"AddPeriodCell";
    }
    
    ViewPeriodCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellType forIndexPath:indexPath];
    
    //int buttonTitle = indexPath.row + 1;
    Periods *pToShow = periodsArr[indexPath.row];
    
    //NSLog(@"project id is %@", self.projectIndexToOpen);
    
    if(indexPath.section == 0){
        cell.periodLabel.text = [NSString stringWithFormat:@"%@", pToShow.periodNum];
        cell.tag = indexPath.row;
        //NSLog(@"button is %@", buttonTitle);
        //NSLog(@"cell is %ld and selected is %ld", (long)cell.tag, (long)selectedCell.tag);
        
        if (cell.tag != previousSelected){
            
            [cell setButtonSelected:NO];
        } else {
            [cell.periodLabel setTextColor:[UIColor colorWithRed:235/255.0f green:92/255.0f blue:104/255.0f alpha:1.0f]];
            [cell setButtonSelected:YES];
        }
    }
    return cell;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (previousSelected >=0) {
        ViewPeriodCollectionCell *previousCell = [collectionView cellForItemAtIndexPath:[NSIndexPath indexPathForRow:previousSelected inSection:0]];
        [previousCell setButtonSelected:NO];
    }
    
    selectedCell = [collectionView cellForItemAtIndexPath:indexPath];
    
    [selectedCell.periodLabel setTextColor:[UIColor colorWithRed:235/255.0f green:92/255.0f blue:104/255.0f alpha:1.0f]];
    [selectedCell setButtonSelected:YES];
    previousSelected = (int)selectedCell.tag;
    
    //refresh table when selected
    NSSortDescriptor *mySort = [NSSortDescriptor sortDescriptorWithKey:@"title" ascending:YES];
    
    periodToShow = periodsArr[selectedCell.tag];
    
    //NSLog(@"selected tag is %ld", (long)selectedCell.tag);
    
    expenseArr = [periodToShow.expense sortedArrayUsingDescriptors:@[mySort]];
    
    expenseRowCount = (int)expenseArr.count;
    //NSLog(@"income count is %lu", (unsigned long)incomeArr.count);
    
    [self.mainTableView reloadData];
}



#pragma mark - Table view

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    if (section == 0){
        return 1;
    } else {
        return expenseRowCount;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    // check here, if it is one of the cells, that needs to be resized
    // to the size of the contained UITextView
    
    if (indexPath.section < 1)
        return 55.0;
    else {
        return 65.0;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    NSString *cellType = @"ExpenseItemCell";
    
    if (indexPath.section == 0) {
        cellType = @"ExpenseTotal";
    }
    
    ExpenseItemsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellType forIndexPath:indexPath];
    
    // Configure the cell...
    
    if (indexPath.section == 0) {
        
        cell.totalLabel.text = [self formatToCurrency:periodToShow.expenseTotal];
        
    } else {
        
        Expenses *imExpense = expenseArr [indexPath.row];
       
        cell.titleLabel.text = imExpense.title;
        cell.amountLabel.text = [self formatToCurrency:imExpense.amount];
        
        if ([imExpense.type isEqualToString:@"Rent"])
        {
            cell.image.image = [UIImage imageNamed:@"Rent"];
        } else if ([imExpense.type isEqualToString:@"Electricity"]){
            cell.image.image = [UIImage imageNamed:@"Electricity"];
        } else if ([imExpense.type isEqualToString:@"Employee"])
        {
            cell.image.image = [UIImage imageNamed:@"Employee"];
        } else if ([imExpense.type isEqualToString:@"Others"])
        {
            cell.image.image = [UIImage imageNamed:@"Others"];
        } else if ([imExpense.type isEqualToString:@"Finance"])
        {
            cell.image.image = [UIImage imageNamed:@"Finance"];
        } else if ([imExpense.type isEqualToString:@"Marketing"])
        {
            cell.image.image = [UIImage imageNamed:@"marketing"];
        } else if ([imExpense.type isEqualToString:@"Telephone"])
        {
            cell.image.image = [UIImage imageNamed:@"Telephone"];
        } else if ([imExpense.type isEqualToString:@"COGS"])
        {
            cell.image.image = [UIImage imageNamed:@"COGS"];
        } else if ([imExpense.type isEqualToString:@"Water"])
        {
            cell.image.image = [UIImage imageNamed:@"Water"];
        } else if ([imExpense.type isEqualToString:@"Automobile"])
        {
            cell.image.image = [UIImage imageNamed:@"Automobile"];
        } else if ([imExpense.type isEqualToString:@"Hardware"])
        {
            cell.image.image = [UIImage imageNamed:@"Hardware"];
        } else if ([imExpense.type isEqualToString:@"Expenses"])
        {
            cell.image.image = [UIImage imageNamed:@"Expenses"];
        }        
        else         {
            cell.image.image = [UIImage imageNamed:@"PlaceHolderRed"];
        }
        
        cell.customerLabel.text = imExpense.source;
        
        if ([imExpense.recurring  isEqual: @1]){
            cell.recurringIcon.image = [UIImage imageNamed:@"recurring"];
        } else {
            cell.recurringIcon.image = [UIImage imageNamed:@""];
            
        }
    }
    
    //cell.totalLabel.text = @"hola";
    return cell;
}

// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}

// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        
        [self.mainTableView beginUpdates];
        
        Periods *periodToDelete = periodsArr[previousSelected];
        Expenses *expenseToDelete = expenseArr[indexPath.row];
        
        expenseRowCount = expenseRowCount - 1;
        
        periodToDelete.expenseTotal = @([periodToDelete.expenseTotal floatValue] - [expenseToDelete.amount floatValue]);
        [periodToDelete removeExpenseObject:expenseToDelete];
        
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
        
        [[IBCoreDataStore mainStore] save];
        
        [self loadIncome];
        
        [self.mainTableView endUpdates];
        
        [self.mainTableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationFade];
        
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    //self.artistaEligida = artistas[indexPath.row]; // this points the artistaEligida to another place.
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES]; // deselect the row
    
}

#pragma mark - Segue

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    
    if([segue.identifier isEqualToString:@"detailsSegue"]){
        
        ExpenseDetailViewController * destination = segue.destinationViewController;
        
        Expenses *expenseToSend = expenseArr[self.mainTableView.indexPathForSelectedRow.row];
        Periods *periodToSend = periodsArr[previousSelected];
        
        destination.expenseToShowDetail = expenseToSend; // send the class over
        destination.projectToAdd = currentProject;
        destination.periodToAdd = periodToSend;
        
    }
    
    
    if ([segue.identifier isEqualToString:@"newExpenseSegue"]){
        UINavigationController * nav = segue.destinationViewController;
        
        NewExpenseTableViewController * destination = nav.viewControllers[0];
        
        Periods *periodToSend = periodsArr[previousSelected];
        
        destination.periodToAdd = periodToSend;
        destination.projectToAdd = currentProject;
        
        destination.addExpenseDelegate = self;
        
        //NSLog(@"%@", periodToSend.periodNum);
    }
}

@end
