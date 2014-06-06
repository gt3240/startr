//
//  SettingsViewController.m
//  StartUpCalculator
//
//  Created by Tom on 5/26/14.
//  Copyright (c) 2014 Tom Liu. All rights reserved.
//

#import "SettingsViewController.h"

@interface SettingsViewController ()
{
    NSUserDefaults *defaults;
}
@property (weak, nonatomic) IBOutlet UISwitch *icloudSwitch;

@end

@implementation SettingsViewController

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
    
    //self.settingRowBGView.alpha = 0.5;
    
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

    if ([defaults objectForKey:@"enableICloud"]) {
        [self.icloudSwitch setOn:YES];
    }
    // Do any additional setup after loading the view.
    
    
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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
