//
//  SideMenuTableViewController.m
//  StartUpCalculator
//
//  Created by Tom on 4/15/14.
//  Copyright (c) 2014 Tom Liu. All rights reserved.
//

#import "SideMenuTableViewController.h"
#import "NewProjectViewController.h"
#import "SavedProjectsTableViewController.h"
#import "innerBand.h"

@interface SideMenuTableViewController ()

@end

@implementation SideMenuTableViewController

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
    
    tempPro = [[TempProject alloc]init];
}

-(void)viewWillAppear:(BOOL)animated
{
    //NSLog(@"index is %@", tempPro.proIndex);
    
    if (tempPro.proIndex) {
        [self.delegate openSavedProjectAt:tempPro.proIndex];
    }
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)NewProjectPressed:(UIButton *)sender {
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main_iPhone" bundle:nil];
    
    UINavigationController *vc = [storyboard instantiateViewControllerWithIdentifier:@"NewProjectNav"];
    
    [self presentViewController:vc animated:YES completion:NULL];
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"SavedProjectSegue"]) {
        
        SavedProjectsTableViewController * destination = segue.destinationViewController;
        
        destination.indexOfSavedProject = tempPro;
    }
}

@end
