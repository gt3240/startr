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
    
    periodsArr = [NSMutableArray array];
    
    NSNumber * add = @0;
    
    for (int i = 1; i < 50; i++){
        
        add = @(i);
        [periodsArr addObject:add];
    }
    
    //periodsArr = @[@"1", @"2", @"3", @"4", @"5", @"6", @"7", @"8", @"9", @"10", @"11", @"12", @"13"];
    NSLog(@"%lu", (unsigned long)periodsArr.count);
    
}

-(void)viewWillAppear:(BOOL)animated
{
    /*
    projectsArr = [Projects allOrderedBy:@"name" ascending:YES];
    NSLog(@"%lu", (unsigned long)projectsArr.count);
    
    NSSortDescriptor *miSort = [NSSortDescriptor sortDescriptorWithKey:@"periodNum" ascending:YES];
    
    //int selected = self.tableView.indexPathForSelectedRow.row;
    
    Projects *projectToShow = projectsArr[0];
    
    NSLog(@"%@", projectToShow.name);
    
    periodsArr = [projectToShow.period sortedArrayUsingDescriptors:@[miSort]];
    
    NSLog(@"%lu", (unsigned long)periodsArr.count);
    */
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Buttons or action

- (IBAction)menuPressed:(UIBarButtonItem *)sender {
    
    [self.myDelegate menuButtonPushed];
    
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
}

#pragma mark - CollectionView
-(int)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

-(int)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return periodsArr.count;
    
}


-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    ViewPeriodCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"PeriodCollectionCell" forIndexPath:indexPath];
    NSString * buttonTitle = [NSString stringWithFormat:@"%@", periodsArr[indexPath.row]];
    
    cell.periodLabel.text = buttonTitle;
    cell.tag = indexPath.row;
    
    NSLog(@"cell is %ld and selected is %ld", (long)cell.tag, (long)selectedCell.tag);
    
    if (cell.tag != selectedCell.tag){
        
        [cell setButtonSelected:NO];
    } else {
        [cell setButtonSelected:YES];
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
        return periodsArr.count;
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
    /*
    if (indexPath.section == 0) {
        float sum = 0;
        for (int i = 0; i < income.count; i++)
        {
            Income * imIncome = income [i];
            sum += imIncome.amount.floatValue;
        }
        
        cell.totalLabel.text = [NSString stringWithFormat:@"$%.2f", sum];
    } else {
        Income * imIncome = income [indexPath.row];
        
        cell.titleLabel.text = imIncome.title;
        cell.amountLabel.text = [NSString stringWithFormat:@"$%@", imIncome.amount];
        cell.customerLabel.text = imIncome.source;
        if (imIncome.recurring == YES){
            cell.recurringLabel.text = @"Recurring";
        } else {
            cell.recurringLabel.text = @"";
        }
    
    }
     */
    cell.totalLabel.text = @"hola";
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
         // Delete the row from the data source
         [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
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
    /*
    if([segue.identifier isEqualToString:@"detailsSegue"]){
        
        IncomeDetailsTableViewController * destination = segue.destinationViewController;
    
        Income *incomeToSend = income[self.mainTableView.indexPathForSelectedRow.row];
        
        NSMutableArray * imIncomeArrayToSend = [NSMutableArray array];
        
        [imIncomeArrayToSend addObject:incomeToSend];
    
        
        //NSLog(@"%@", incomeToSend.title);
        
        destination.incomeToShowDetail = imIncomeArrayToSend;
        
        //[destination.incomeToShowDetail addObjectsFromArray:income[self.mainTableView.indexPathForSelectedRow.row]];
        
        //NSLog(@" this is %ld", (long)self.mainTableView.indexPathForSelectedRow.row);
        //NSLog(@"the count is %lu", (unsigned long)destination.incomeToShowDetail.count);
    }
     */
}


@end
