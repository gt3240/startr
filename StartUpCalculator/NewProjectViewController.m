//
//  NewProjectViewController.m
//  StartUpCalculator
//
//  Created by Tom on 4/7/14.
//  Copyright (c) 2014 Tom Liu. All rights reserved.
//

#import "NewProjectViewController.h"
#import "ProjectTypeViewController.h"
#import <QuartzCore/QuartzCore.h>

@interface NewProjectViewController ()

@end

@implementation NewProjectViewController

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
   
    [self.projectNameTextField.layer setCornerRadius:5.0f];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)projectNameButtonPressed:(UIButton *)sender {
    // save the project name
    
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    
    
    if ([segue.identifier isEqualToString:@"ProjectTypeSegue"]) {
        
        ProjectTypeViewController * destinationSegue = segue.destinationViewController;
        destinationSegue.projectName = self.projectNameTextField.text;
    }
}

-(BOOL)shouldPerformSegueWithIdentifier:(NSString *)identifier sender:(id)sender
{
    if ([self.projectNameTextField.text isEqualToString:@""]) {
        
        self.projectNameTextField.layer.borderColor=[[UIColor colorWithRed:232/255.0f green:91/255.0f blue:103/255.0f alpha:0.8f]CGColor];
        
        self.projectNameTextField.layer.borderWidth=2.0;
        return NO;
    } else {
        return YES;
    }
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}


@end
