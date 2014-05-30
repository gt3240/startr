//
//  ProfileViewController.m
//  StartUpCalculator
//
//  Created by Tom on 5/28/14.
//  Copyright (c) 2014 Tom Liu. All rights reserved.
//

#import "ProfileViewController.h"
#import "notesTableViewCell.h"
#import "AppDelegate.h"
#import "AddNotesViewController.h"
#import "Notes.h"

@interface ProfileViewController ()
{
    NSArray *notesArr;
    NSDateFormatter *dateFormatter;
}
@property (nonatomic, retain) NSManagedObjectContext *managedObjectContext;

@end

@implementation ProfileViewController

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
    AppDelegate* appDelegate = [UIApplication sharedApplication].delegate;
    self.managedObjectContext = appDelegate.managedObjectContext;
    // Do any additional setup after loading the view.
    notesArr = [NSArray array];
    dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"MM-dd-yyyy HH:mm"];
}

- (void)viewWillAppear:(BOOL)animated
{
    [self setTabBarItemColor];
    self.projectTitle.text = self.openProject.name;
    self.projectDescription.delegate = self;
    self.projectDescription.text = self.openProject.projectDescription;
    // load notes
    NSSortDescriptor *sort = [NSSortDescriptor sortDescriptorWithKey:@"date" ascending:NO];
    
    notesArr = [self.openProject.notes sortedArrayUsingDescriptors:@[sort]];
    
    NSLog(@"notes count %lu", (unsigned long)notesArr.count);
    [self.notesTableView reloadData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
    resultBtn.image = [[UIImage imageNamed:@"Results_iconGreen"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];

    [infoBtn setTitleTextAttributes:@{NSFontAttributeName : [UIFont fontWithName:@"HelveticaNeue" size:10.0f],NSForegroundColorAttributeName : [UIColor whiteColor]} forState:UIControlStateHighlighted];
    
    [inBtn setTitleTextAttributes:@{NSFontAttributeName : [UIFont fontWithName:@"HelveticaNeue" size:10.0f],NSForegroundColorAttributeName : [UIColor colorWithRed:0/255.0f green:133/255.0f blue:142/255.0f alpha:1.0f]} forState:UIControlStateNormal];
    [outBtn setTitleTextAttributes:@{NSFontAttributeName : [UIFont fontWithName:@"HelveticaNeue" size:10.0f],NSForegroundColorAttributeName : [UIColor colorWithRed:0/255.0f green:133/255.0f blue:142/255.0f alpha:1.0f]} forState:UIControlStateNormal];
    [resultBtn setTitleTextAttributes:@{NSFontAttributeName : [UIFont fontWithName:@"HelveticaNeue" size:10.0f],NSForegroundColorAttributeName : [UIColor colorWithRed:0/255.0f green:133/255.0f blue:142/255.0f alpha:1.0f]} forState:UIControlStateNormal];
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    
    if([text isEqualToString:@"\n"]) {
        //[self.openProject setProjectDescription:self.projectDescription.text];
        
        [self.openProject setValue:self.projectDescription.text forKey:@"projectDescription"];
        
        NSError *error;
        if (![self.managedObjectContext save:&error]) {
            NSLog(@"Whoops, couldn't save: %@", [error localizedDescription]);
        } else {
            NSLog(@"description saved");
        }
        
        [textView resignFirstResponder];
        return NO;
    }
    
    return YES;
}
- (IBAction)addPressed:(UIButton *)sender {
    
}

#pragma mark - Table view

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return notesArr.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
   
    
    notesTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"notesCell" forIndexPath:indexPath];
    
    // Configure the cell...
    Notes *imNote = notesArr[indexPath.row];
    
    cell.notesDateLabel.text = [dateFormatter stringFromDate:imNote.date];
    cell.notesContentLabel.text = imNote.notes;

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
//        
//        [self.mainTableView beginUpdates];
//        
//        Periods *periodToDelete = periodsArr[previousSelected];
//        Incomes *incomeToDelete = incomeArr[indexPath.row];
//        
//        incomeRowCount = incomeRowCount - 1;
//        
//        periodToDelete.incomeTotal = @([periodToDelete.incomeTotal floatValue] - [incomeToDelete.amount floatValue]);
//        [periodToDelete removeIncomeObject:incomeToDelete];
//        
//        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
//        
//        NSError *error;
//        if (![self.managedObjectContext save:&error]) {
//            NSLog(@"Whoops, couldn't save: %@", [error localizedDescription]);
//        }
//        
//        [self loadIncome];
//        
//        [self.mainTableView endUpdates];
//        
//        [self.mainTableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationFade];
        
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    //self.artistaEligida = artistas[indexPath.row]; // this points the artistaEligida to another place.
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES]; // deselect the row
    
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"addNotesSegue"]) {
        UINavigationController * nav = segue.destinationViewController;
        AddNotesViewController * destination = nav.viewControllers[0];
        destination.currentProject = self.openProject;
    } else if ([segue.identifier isEqualToString:@"editNotesSegue"]){
        UINavigationController * nav = segue.destinationViewController;
        AddNotesViewController * destination = nav.viewControllers[0];
        Notes *notesToSend = notesArr[self.notesTableView.indexPathForSelectedRow.row];
        destination.currentNotes = notesToSend;
    }
}


@end
