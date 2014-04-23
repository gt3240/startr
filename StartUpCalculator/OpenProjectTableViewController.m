//
//  OpenProjectTableViewController.m
//  StartUpCalculator
//
//  Created by Tom on 4/19/14.
//  Copyright (c) 2014 Tom Liu. All rights reserved.
//

#import "OpenProjectTableViewController.h"
#import "OpenTableTableViewCell.h"
#import "InnerBand.h"
#import "Projects.h"
#import "ContainerViewController.h"

@interface OpenProjectTableViewController ()
{
    NSArray *savedProjectsArr;
    Projects *savedProjectC;
}
@end

@implementation OpenProjectTableViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    savedProjectsArr = [NSArray array];}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillAppear:(BOOL)animated
{
    savedProjectsArr = [Projects allOrderedBy:@"date" ascending:NO];
    
    //NSLog(@"%lu", (unsigned long)savedProjectsArr.count);
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
    
    return savedProjectsArr.count;

}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    OpenTableTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SavedProjectsCell" forIndexPath:indexPath];
    
    // Configure the cell...
    
    savedProjectC = savedProjectsArr[indexPath.row];
    
    cell.nameLabel.text = savedProjectC.name;
    //cell.dateLabel.text = savedProjectC.date;
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
}


// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        Projects *projectToDelete = savedProjectsArr[indexPath.row];
        [projectToDelete destroy];
        [[IBCoreDataStore mainStore] save];
        
        savedProjectsArr = [Projects allOrderedBy:@"date" ascending:YES];
        
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    
    if ([segue.identifier isEqualToString:@"OpenProjectsSegue"]) {
        
        UITabBarController *tbc = segue.destinationViewController;
        UINavigationController *nav = tbc.viewControllers[0];
        IncomeViewController *vc = nav.viewControllers[0];
        
        vc.projectToOpen = savedProjectsArr[self.savedProjectTable.indexPathForSelectedRow.row];
    }

}

@end