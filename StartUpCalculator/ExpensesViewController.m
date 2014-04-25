//
//  ExpensesViewController.m
//  StartUpCalculator
//
//  Created by Tom on 4/24/14.
//  Copyright (c) 2014 Tom Liu. All rights reserved.
//

#import "ExpensesViewController.h"

@interface ExpensesViewController ()

@end

@implementation ExpensesViewController

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

}

-(void)viewWillAppear:(BOOL)animated
{
    [self setTabBarItemColor];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)setTabBarItemColor
{
    self.tabBarController.tabBar.barTintColor = [UIColor colorWithRed:235/255.0f green:92/255.0f blue:104/255.0f alpha:1.0f];
    
    NSArray *items = self.tabBarController.tabBar.items;
    UITabBarItem *inBtn = items[0];
    UITabBarItem *resultBtn = items[2];
    
    inBtn.image = [[UIImage imageNamed:@"In_iconRed"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    
    resultBtn.image = [[UIImage imageNamed:@"Results_iconRed"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
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
