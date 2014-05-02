//
//  ProjectTypeViewController.m
//  StartUpCalculator
//
//  Created by Tom on 4/7/14.
//  Copyright (c) 2014 Tom Liu. All rights reserved.
//

#import "ProjectTypeViewController.h"
#import "InnerBand.h"
#import "Projects.h"
#import "Periods.h"
#import "IncomeViewController.h"

@interface ProjectTypeViewController ()

@end

@implementation ProjectTypeViewController

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
    // Do any additional setup after loading the view.
    [self.termsTextField.layer setCornerRadius:5.0f];
    //NSLog(@"new project name is %@", self.projectName);
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(BOOL)shouldPerformSegueWithIdentifier:(NSString *)identifier sender:(id)sender
{
    if ([self.termsTextField.text isEqualToString:@""]) {
        
        self.termsTextField.layer.borderColor=[[UIColor colorWithRed:232/255.0f green:91/255.0f blue:103/255.0f alpha:0.8f]CGColor];
        
        self.termsTextField.layer.borderWidth=2.0;
        return NO;
    } else {
        return YES;
    }
}
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    
    Projects *newProject;
    
    newProject = [Projects create];
    newProject.name = self.projectName;
    newProject.date = [NSDate date];
    
    if (self.typeSelector.selectedSegmentIndex == 0) {
        newProject.type = @"Week";
    } else {
        newProject.type = @"Month";
    }
    
    for (int i = 1; i <= self.termsTextField.text.intValue; i++) {
        Periods *newPeriod;
        newPeriod = [Periods create];
        newPeriod.periodNum = [NSNumber numberWithInt:i];
        newPeriod.projects = newProject;
    }
    
    [[IBCoreDataStore mainStore] save];
    
    UITabBarController *tbc = segue.destinationViewController;
    UINavigationController *nav = tbc.viewControllers[0];
    IncomeViewController *vc = nav.viewControllers[0];
    
    vc.projectIndexToOpen = @1;
    vc.projectToOpen = newProject;
    
    
}

@end
