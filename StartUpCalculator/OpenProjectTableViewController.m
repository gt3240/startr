//
//  OpenProjectTableViewController.m
//  StartUpCalculator
//
//  Created by Tom on 4/19/14.
//  Copyright (c) 2014 Tom Liu. All rights reserved.
//

#import "OpenProjectTableViewController.h"
#import "OpenTableTableViewCell.h"
#import "AppDelegate.h"
#import "Projects.h"
#import "ContainerViewController.h"
#import "TBController.h"

@interface OpenProjectTableViewController ()
{
    Projects *savedProjectC;
    NSDateFormatter *dateFormatter;
}
@property (nonatomic,strong)NSArray* fetchedRecordsArray;
@property (nonatomic, retain) NSManagedObjectContext *managedObjectContext;

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

    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"main_menu_bg"] forBarMetrics:UIBarMetricsDefault];
    
    UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"main_menu_bg"]];
    [self.tableView setBackgroundView:imageView];
    self.tableView.backgroundView.layer.zPosition -= 1;
    
    //  1
    AppDelegate* appDelegate = [UIApplication sharedApplication].delegate;
    self.managedObjectContext = appDelegate.managedObjectContext;
    
    // Fetching Records and saving it in "fetchedRecordsArray" object
    //  2
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"date" ascending:NO];
    self.fetchedRecordsArray = [[[appDelegate getAllProjects]mutableCopy] sortedArrayUsingDescriptors:@[sortDescriptor]];
    //  3
    
    // add iCloud observers
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    NSLog(@" icloud sync is %@", [defaults objectForKey:@"enableICloud"]);
    
    if ([defaults objectForKey:@"enableICloud"]) {
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(storesWillChange) name:NSPersistentStoreCoordinatorStoresWillChangeNotification object:self.managedObjectContext.persistentStoreCoordinator];
        
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(storesDidChange:) name:NSPersistentStoreCoordinatorStoresDidChangeNotification object:self.managedObjectContext.persistentStoreCoordinator];
        
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(mergeContent:) name:NSPersistentStoreDidImportUbiquitousContentChangesNotification object:self.managedObjectContext.persistentStoreCoordinator];
    }
    
    
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
    
}

#pragma mark - iCloud Methods

- (void)storesWillChange {
    
    NSLog(@"\n\nStores WILL change notification received\n\n");
    
    // disbale UI
    [[UIApplication sharedApplication]beginIgnoringInteractionEvents];
    
    // save and reset our context
    if (self.managedObjectContext.hasChanges) {
        [self.managedObjectContext save:nil];
    } else {
        [self.managedObjectContext reset];
    }
}

- (void)storesDidChange:(NSNotification *)notification {
    
    NSLog(@"\n\nStores DID change notification received\n\n");
    
    // enable UI
    [[UIApplication sharedApplication]endIgnoringInteractionEvents];
    
    // update UI
    
    [self.tableView reloadData];
}

- (void)mergeContent:(NSNotification *)notification {
    
    NSLog(@"Merge Content here");
    [self.managedObjectContext mergeChangesFromContextDidSaveNotification:notification];
    
    AppDelegate* appDelegate = [UIApplication sharedApplication].delegate;
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"date" ascending:NO];
    self.fetchedRecordsArray = [[[appDelegate getAllProjects]mutableCopy] sortedArrayUsingDescriptors:@[sortDescriptor]];
    
    [self.tableView reloadData];
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
    
    return self.fetchedRecordsArray.count;

}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    OpenTableTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SavedProjectsCell" forIndexPath:indexPath];
    
    // Configure the cell...
    
    savedProjectC = self.fetchedRecordsArray[indexPath.row];
    
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
        [self.tableView beginUpdates];

        // Delete the row from the data source
        [self.managedObjectContext deleteObject:[self.fetchedRecordsArray objectAtIndex:indexPath.row]];
        NSError *error;
        if (![self.managedObjectContext save:&error]) {
            NSLog(@"Whoops, couldn't delete: %@", [error localizedDescription]);
        }
        
        AppDelegate* appDelegate = [UIApplication sharedApplication].delegate;
        self.fetchedRecordsArray = [appDelegate getAllProjects];
        
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
        //[self.tableView reloadData];
        [self.tableView endUpdates];

        
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
        
        vc.projectToOpen = self.fetchedRecordsArray[self.savedProjectTable.indexPathForSelectedRow.row];
        
        // pass project to tabbar
        tbc.projectToOpen = self.fetchedRecordsArray[self.savedProjectTable.indexPathForSelectedRow.row];
    }

}

@end
