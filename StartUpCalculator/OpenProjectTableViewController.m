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
#import "TBController.h"

@interface OpenProjectTableViewController ()
{
    NSArray *savedProjectsArr;
    Projects *savedProjectC;
    NSDateFormatter *dateFormatter;
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
    //self.navigationController.navigationBar.translucent = NO;
    //self.navigationController.navigationBar.barTintColor = [UIColor colorWithRed:0/255.0f green:150/255.0f blue:255/255.0f alpha:1.0f];
    savedProjectsArr = [NSArray array];
    
    dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"MM-dd-yyyy HH:mm"];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillAppear:(BOOL)animated
{
    savedProjectsArr = [Projects allOrderedBy:@"date" ascending:NO];
    UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"main_menu_bg"]];
    [self.tableView setBackgroundView:imageView];

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
    cell.dateLabel.text = [dateFormatter stringFromDate:savedProjectC.date];
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
        
        TBController *tbc = segue.destinationViewController;
        UINavigationController *nav = tbc.viewControllers[0];
        IncomeViewController *vc = nav.viewControllers[0];
        
        vc.projectToOpen = savedProjectsArr[self.savedProjectTable.indexPathForSelectedRow.row];
        
        // pass project to tabbar
        tbc.projectToOpen = savedProjectsArr[self.savedProjectTable.indexPathForSelectedRow.row];
    }

}

@end
