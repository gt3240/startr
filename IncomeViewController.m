//
//  IncomeViewController.m
//  StartUpCalculator
//
//  Created by Tom on 3/28/14.
//  Copyright (c) 2014 Tom Liu. All rights reserved.
//

#import "IncomeViewController.h"
#import "IncomeItemsTableViewCell.h"
#import "ViewPeriodCollectionCell.h"
#import "Incomes.h"
#import "Projects.h"
#import "AppDelegate.h"
#import "Periods.h"
#import "OpenProjectTableViewController.h"
#import "ProjectTypeViewController.h"
#import "IncomeDetailViewController.h"


@interface IncomeViewController ()
{
    BOOL buttonIsSelected;
    ViewPeriodCollectionCell * selectedCell;
    ViewPeriodCollectionCell *previousCell;
    int incomeRowCount;
    int periodCount;
    float monthlyTotal;
    Periods *periodToShow;
    Projects *currentProject;
    AppDelegate* appDelegate;
}
@property (nonatomic, retain) NSManagedObjectContext *managedObjectContext;

@end

@implementation IncomeViewController

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
        
    NSLog(@"project id is %@",self.projectIndexToOpen);
    
    periodsArr = [NSArray array];
    
    appDelegate = [UIApplication sharedApplication].delegate;
    self.managedObjectContext = appDelegate.managedObjectContext;
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
        
        periodToShow = periodsArr[appDelegate.peroidToShow];
        
        [self loadIncome];
        
        incomeRowCount = (int)incomeArr.count;
    }
    
    self.termsTypeLabel.text = self.projectToOpen.type;
    
    [self.periodCollectionView reloadData];
    [self.mainTableView reloadData];

}

- (void)viewDidAppear:(BOOL)animated
{
    if (previousSelected >=0) {
        previousCell = (ViewPeriodCollectionCell *)[self.periodCollectionView cellForItemAtIndexPath:[NSIndexPath indexPathForRow:previousSelected inSection:0]];
        [previousCell setButtonSelected:NO];
    }
    [self.periodCollectionView selectItemAtIndexPath:[NSIndexPath indexPathForRow:appDelegate.peroidToShow inSection:0] animated:YES scrollPosition:UICollectionViewScrollPositionCenteredHorizontally];
    selectedCell  = (ViewPeriodCollectionCell *)[self.periodCollectionView cellForItemAtIndexPath:[NSIndexPath indexPathForItem:appDelegate.peroidToShow inSection:0]];
    [selectedCell setButtonSelected:YES];
    [selectedCell.periodLabel setTextColor:[UIColor colorWithRed:30/255.0f green:156/255.0f blue:227/255.0f alpha:1.0f]];
    previousSelected = (int)selectedCell.tag;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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

#pragma mark - Buttons or action

-(void)loadPeriodFromProject:(Projects *)project
{
    NSSortDescriptor *sort = [NSSortDescriptor sortDescriptorWithKey:@"periodNum" ascending:YES];
    
    periodsArr = [project.period sortedArrayUsingDescriptors:@[sort]];
}

-(void)loadIncome
{
    NSSortDescriptor *incomeSort = [NSSortDescriptor sortDescriptorWithKey:@"title" ascending:YES];
    incomeArr = [periodToShow.income sortedArrayUsingDescriptors:@[incomeSort]];
}

-(void)incomeAdded
{
    //periodToShow = periodsArr[previousSelected];
    
    [self loadIncome];
    
    incomeRowCount = (int)incomeArr.count;
    
    [self.mainTableView reloadData];
    
    NSLog(@"selected period tag is %ld", (long)selectedCell.tag);
}

- (IBAction)menuPressed:(UIBarButtonItem *)sender {
    
    [self.myDelegate menuButtonPushed];

}

- (IBAction)AddPeriodButtonPressed:(UIButton *)sender {
    Periods *newPeriod = [NSEntityDescription insertNewObjectForEntityForName:@"Periods" inManagedObjectContext:self.managedObjectContext];
    NSNumber *currentCount = [NSNumber numberWithInt:periodCount];
    NSNumber *addCount = @1;
    NSNumber *newCount = @([currentCount intValue] + [addCount intValue]);
    newPeriod.periodNum = newCount;
    [currentProject addPeriodObject:newPeriod];
    
    NSError *error;
    if (![self.managedObjectContext save:&error]) {
        NSLog(@"Whoops, couldn't save: %@", [error localizedDescription]);
    }
    periodCount = newCount.intValue;
    
    appDelegate.peroidToShow = newCount.intValue - 1;
    
    selectedCell  = (ViewPeriodCollectionCell *)[self.periodCollectionView cellForItemAtIndexPath:[NSIndexPath indexPathForItem:appDelegate.peroidToShow inSection:0]];
    [selectedCell setButtonSelected:YES];
    [selectedCell.periodLabel setTextColor:[UIColor colorWithRed:30/255.0f green:156/255.0f blue:227/255.0f alpha:1.0f]];
    previousSelected = newCount.intValue - 1;
    
    [self loadPeriodFromProject:currentProject];
    NSSortDescriptor *incomeSort = [NSSortDescriptor sortDescriptorWithKey:@"title" ascending:YES];
    
    periodToShow = periodsArr[newCount.intValue - 1];
    
    incomeArr = [periodToShow.income sortedArrayUsingDescriptors:@[incomeSort]];
    
    incomeRowCount = (int)incomeArr.count;

    [self.periodCollectionView reloadData];
    [self.mainTableView reloadData];
    
    NSLog(@"period count is %d, current count is %d", periodCount, newCount.intValue);
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
        }
        
        if (indexPath.row == appDelegate.peroidToShow) {
            [cell.periodLabel setTextColor:[UIColor colorWithRed:30/255.0f green:156/255.0f blue:227/255.0f alpha:1.0f]];
            [cell setButtonSelected:YES];
        }
    
    }
        return cell;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (previousSelected >=0) {
        previousCell = (ViewPeriodCollectionCell *)[collectionView cellForItemAtIndexPath:[NSIndexPath indexPathForRow:previousSelected inSection:0]];
        [previousCell setButtonSelected:NO];
    }
    
    selectedCell = (ViewPeriodCollectionCell*)[collectionView cellForItemAtIndexPath:indexPath];
    
    [selectedCell.periodLabel setTextColor:[UIColor colorWithRed:30/255.0f green:156/255.0f blue:227/255.0f alpha:1.0f]];
    [selectedCell setButtonSelected:YES];
    
    previousSelected = (int)selectedCell.tag;
    
    //send periodnum to tabbar so other tabs can have it
    appDelegate.peroidToShow = (int)selectedCell.tag;
    
    //refresh table when selected
    NSSortDescriptor *incomeSort = [NSSortDescriptor sortDescriptorWithKey:@"title" ascending:YES];
    
    periodToShow = periodsArr[selectedCell.tag];
    
    //NSLog(@"selected tag is %ld", (long)selectedCell.tag);
    
    incomeArr = [periodToShow.income sortedArrayUsingDescriptors:@[incomeSort]];
    
    incomeRowCount = (int)incomeArr.count;
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
        return incomeRowCount;
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
    
    NSString *cellType = @"IncomeItemCell";
    
    if (indexPath.section == 0) {
        cellType = @"IncomeTotal";
    }
    
    IncomeItemsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellType forIndexPath:indexPath];
    
    // Configure the cell...
    
    if (indexPath.section == 0) {
       
        cell.totalLabel.text = [self formatToCurrency:periodToShow.incomeTotal];
        cell.totalLabel.adjustsFontSizeToFitWidth = YES;
        
    } else {
        
        Incomes * imIncome = incomeArr [indexPath.row];
        
        cell.titleLabel.text = imIncome.title;
        cell.amountLabel.text = [self formatToCurrency:imIncome.amount];
        cell.amountLabel.adjustsFontSizeToFitWidth = YES;
        
        if ([imIncome.type isEqualToString:@"Investment"])
        {
            cell.image.image = [UIImage imageNamed:@"investment"];
        } else if ([imIncome.type isEqualToString:@"Loan"]){
            cell.image.image = [UIImage imageNamed:@"loan"];
        } else if ([imIncome.type isEqualToString:@"Sales"])
        {
            cell.image.image = [UIImage imageNamed:@"sales"];
        } else if ([imIncome.type isEqualToString:@"Others"])
        {
            cell.image.image = [UIImage imageNamed:@"others"];
        } else         {
            cell.image.image = [UIImage imageNamed:@"PlaceHolderBlue"];
        }
        
        cell.customerLabel.text = imIncome.source;
        
        if ([imIncome.recurring  isEqual: @1]){
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
        Incomes *incomeToDelete = incomeArr[indexPath.row];
         
        incomeRowCount = incomeRowCount - 1;
         
        periodToDelete.incomeTotal = @([periodToDelete.incomeTotal floatValue] - [incomeToDelete.amount floatValue]);
        [periodToDelete removeIncomeObject:incomeToDelete];
         
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
        
        NSError *error;
        if (![self.managedObjectContext save:&error]) {
            NSLog(@"Whoops, couldn't save: %@", [error localizedDescription]);
        }
                  
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
        
        IncomeDetailViewController * destination = segue.destinationViewController;
    
        Incomes *incomeToSend = incomeArr[self.mainTableView.indexPathForSelectedRow.row];
        Periods *periodToSend = periodsArr[previousSelected];
        
        destination.incomeToShowDetail = incomeToSend; // send the class over
        destination.projectToAdd = currentProject;
        destination.periodToAdd = periodToSend;

    }
    
    if ([segue.identifier isEqualToString:@"newIncomeSegue"]){
        UINavigationController * nav = segue.destinationViewController;
        
        NewIncomeTableViewController * destination = nav.viewControllers[0];
        
        Periods *periodToSend = periodsArr[previousSelected];
        
        destination.periodToAdd = periodToSend;
        destination.projectToAdd = currentProject;
        
        destination.addIncomeDelegate = self;
        
        NSLog(@"%@", periodToSend.periodNum);
    }
}

@end
