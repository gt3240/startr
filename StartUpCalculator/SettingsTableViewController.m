//
//  SettingsTableViewController.m
//  StartUpCalculator
//
//  Created by Tom on 5/27/14.
//  Copyright (c) 2014 Tom Liu. All rights reserved.
//

#import "SettingsTableViewController.h"

@interface SettingsTableViewController ()
{
    NSUserDefaults *defaults;
}
@property (weak, nonatomic) IBOutlet UISwitch *icloudSwitch;
@end

@implementation SettingsTableViewController

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
    
    UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"main_menu_bg"]];
    [self.tableView setBackgroundView:imageView];
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSURL *iCloudURL = [fileManager URLForUbiquityContainerIdentifier:nil];
    NSLog(@"%@", [iCloudURL absoluteString]);
    
    if(iCloudURL){
        NSUbiquitousKeyValueStore *iCloudStore = [NSUbiquitousKeyValueStore defaultStore];
        [iCloudStore setString:@"Success" forKey:@"iCloudStatus"];
        [iCloudStore synchronize]; // For Synchronizing with iCloud Server
        NSLog(@"iCloud status : %@", [iCloudStore stringForKey:@"iCloudStatus"]);
    }
    
    defaults = [NSUserDefaults standardUserDefaults];
    
    if ([defaults boolForKey:@"enableICloud"] == YES) {
        [self.icloudSwitch setOn:YES];
    }


    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)enableIcloudSwtiched:(UISwitch *)sender {
    
    defaults = [NSUserDefaults standardUserDefaults];
    if ([sender isOn]) {
        [defaults setBool:YES forKey:@"enableICloud"];
    } else {
        [defaults setBool:NO forKey:@"enableICloud"];
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
}

@end
