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
    NSLog(@"new project name is %@", self.projectName);
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    Projects *newProject;
    if ([segue.identifier isEqualToString: @"weeklyType"]) {
        newProject.type = @"week";
    } else {
        newProject.type = @"month";
    }
    
    newProject = [Projects create];
    newProject.name = self.projectName;
    newProject.date = [NSDate date];
    [[IBCoreDataStore mainStore] save];
    
    IncomeViewController *destination = segue.destinationViewController;
    
}

@end
