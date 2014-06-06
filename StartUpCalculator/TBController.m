//
//  TBController.m
//  StartUpCalculator
//
//  Created by Tom on 4/23/14.
//  Copyright (c) 2014 Tom Liu. All rights reserved.
//

#import "TBController.h"
#import "ExpensesViewController.h"
#import "ResultsVC.h"
#import "ProfileViewController.h"

@interface TBController ()

@end

@implementation TBController

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
    // send project object to expense
    UINavigationController *nav = self.viewControllers[1];
    ExpensesViewController *vc = nav.viewControllers[0];
    vc.projectToOpen = self.projectToOpen;
    
    // send project to result
    UINavigationController *resultNav = self.viewControllers[2];
    ResultsVC *rvc = resultNav.viewControllers[0];
    rvc.openProject = self.projectToOpen;
    
    // send project to profile
    UINavigationController *profileNav = self.viewControllers[3];
    ProfileViewController *pvc = profileNav.viewControllers[0];
    pvc.openProject = self.projectToOpen;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
