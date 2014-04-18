//
//  SavedProjectsTableViewController.m
//  StartUpCalculator
//
//  Created by Tom on 4/16/14.
//  Copyright (c) 2014 Tom Liu. All rights reserved.
//

#import "SavedProjectsTableViewController.h"
#import "Projects.h"
#import "InnerBand.h"
#import "SavedProjectsTableViewCell.h"
#import "IncomeViewController.h"

@interface SavedProjectsTableViewController ()
{
    NSArray *savedProjectsArr;
    Projects *savedProjectC;
}
@end

@implementation SavedProjectsTableViewController

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
    
    self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    savedProjectsArr = [NSArray array];
    
    //NSLog(@"%@", self.indexOfSavedProject);
}

-(void)viewWillAppear:(BOOL)animated
{
    savedProjectsArr = [Projects allOrderedBy:@"date" ascending:NO];
    
    //NSLog(@"%lu", (unsigned long)savedProjectsArr.count);
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
    SavedProjectsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"projectNameCell" forIndexPath:indexPath];
    savedProjectC = savedProjectsArr[indexPath.row];
    
    cell.ProjectNameLabel.text = savedProjectC.name;
    
    return cell;
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

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    self.indexOfSavedProject.proIndex =[NSNumber numberWithFloat:indexPath.row];
    
    //NSLog(@"%@", self.indexOfSavedProject);
    
    //self.savedProjects = savedProjectsArr[indexPath.row];
    
    [self.navigationController popViewControllerAnimated:NO];
    
}

@end
