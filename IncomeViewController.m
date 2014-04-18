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
#import "InnerBand.h"
#import "Periods.h"
#import "IncomeDetailsTableViewController.h"


@interface IncomeViewController ()
{
    BOOL buttonIsSelected;
    ViewPeriodCollectionCell * selectedCell;
    int incomeRowCount;
    int periodCount;
    float monthlyTotal;
    Periods *periodToShow;
    Projects *projectToShow;
}
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
    
    periodsArr = [NSArray array];
    
}

-(void)viewWillAppear:(BOOL)animated
{
    NSLog(@"project id is %@", self.projectIndexToOpen);
    
    self.tabBarController.tabBar.barTintColor = [UIColor colorWithRed:27/255.0f green:114/255.0f blue:169/255.0f alpha:1.0f];
    
    projectsArr = [Projects allOrderedBy:@"date" ascending:NO];
    //NSLog(@"%lu", (unsigned long)projectsArr.count);
    
    if (self.projectIndexToOpen){
        [self loadPeriodFromProject:self.projectIndexToOpen.integerValue];
    }else {
        [self loadPeriodFromProject:1];
    }
    
    if (!periodToShow) {
        periodToShow = periodsArr[0];
    } else {
        periodToShow = periodsArr[previousSelected];
    }
    
    [self loadIncome];
    
    incomeRowCount = incomeArr.count;
    
    periodCount = periodsArr.count;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSString *)formatToCurrency: (NSNumber *)amount{
    NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];
    [numberFormatter setNumberStyle: NSNumberFormatterCurrencyStyle];
    NSString *numberAsString = [numberFormatter stringFromNumber:[NSNumber numberWithFloat:amount.floatValue]];
    return numberAsString;
}

#pragma mark - Buttons or action

-(void)loadPeriodFromProject:(int)projectindex
{
    NSSortDescriptor *miSort = [NSSortDescriptor sortDescriptorWithKey:@"periodNum" ascending:YES];
    
    projectToShow = projectsArr[projectindex];
    
    periodsArr = [projectToShow.period sortedArrayUsingDescriptors:@[miSort]];
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
    
    incomeRowCount = incomeArr.count;
    
    [self.mainTableView reloadData];
    
    
    NSLog(@"selected period tag is %ld", (long)selectedCell.tag);
}

- (IBAction)menuPressed:(UIBarButtonItem *)sender {
    
    [self.myDelegate menuButtonPushed];

}

- (IBAction)AddPeriodButtonPressed:(UIButton *)sender {
    Periods *newPeriod = [Periods create];
    NSNumber *currentCount = [NSNumber numberWithInt:periodCount];
    NSNumber *addCount = @1;
    NSNumber *newCount = @([currentCount intValue] + [addCount intValue]);
    newPeriod.periodNum = newCount;
    [projectToShow addPeriodObject:newPeriod];
    [[IBCoreDataStore mainStore] save];
    
    periodCount = newCount.intValue;
    
    [self loadPeriodFromProject:1];
    
    [self.periodCollectionView reloadData];
    
    
    NSLog(@"period count is %d, current count is %d", periodCount, newCount.intValue);
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (previousSelected >=0) {
        ViewPeriodCollectionCell *previousCell = [collectionView cellForItemAtIndexPath:[NSIndexPath indexPathForRow:previousSelected inSection:0]];
        [previousCell setButtonSelected:NO];
    }
        
    selectedCell = [collectionView cellForItemAtIndexPath:indexPath];
    
    [selectedCell setButtonSelected:YES];
    previousSelected = (int)selectedCell.tag;
    
    //refresh table when selected
    NSSortDescriptor *incomeSort = [NSSortDescriptor sortDescriptorWithKey:@"title" ascending:YES];
    
    periodToShow = periodsArr[selectedCell.tag];
    
    //NSLog(@"selected tag is %ld", (long)selectedCell.tag);
    
    incomeArr = [periodToShow.income sortedArrayUsingDescriptors:@[incomeSort]];
    
    incomeRowCount = incomeArr.count;
    //NSLog(@"income count is %lu", (unsigned long)incomeArr.count);
    
    [self.mainTableView reloadData];
    
}

#pragma mark - CollectionView
-(int)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 2;
}

-(int)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    if (section == 1){
        return 1;
    } else {
        NSLog(@"cell periodCount is %d", periodCount);
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
    
    int buttonTitle = indexPath.row + 1;
    
    if(indexPath.section == 0){
        cell.periodLabel.text = [NSString stringWithFormat:@"%d", buttonTitle];
        cell.tag = indexPath.row;
        //NSLog(@"button is %@", buttonTitle);
        //NSLog(@"cell is %ld and selected is %ld", (long)cell.tag, (long)selectedCell.tag);
        
        if (cell.tag != previousSelected){
            
            [cell setButtonSelected:NO];
        } else {
            [cell setButtonSelected:YES];
        }
    }
        return cell;
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
        return 95.0;
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
        
    } else {
        Incomes * imIncome = incomeArr [indexPath.row];
        
        cell.titleLabel.text = imIncome.title;
        cell.amountLabel.text = [self formatToCurrency:imIncome.amount];
        
        cell.customerLabel.text = imIncome.source;
        
        if ([imIncome.recurring intValue] == 1){
            cell.recurringLabel.text = @"Recurring";
        } else {
            cell.recurringLabel.text = @"";
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
        
        IncomeDetailsTableViewController * destination = segue.destinationViewController;
    
        Incomes *incomeToSend = incomeArr[self.mainTableView.indexPathForSelectedRow.row];
        
        destination.incomeToShowDetail = incomeToSend; // send the class over
        
    } else {
        
        UINavigationController * nav = segue.destinationViewController;
    
        NewIncomeTableViewController * destination = nav.viewControllers[0];
        
        Periods *periodToSend = periodsArr[previousSelected];
        
        destination.periodToAdd = periodToSend;
        
        destination.editIncomeDelegate = self;

        NSLog(@"%@", periodToSend.periodNum);
    }
}


@end
