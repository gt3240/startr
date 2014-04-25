//
//  TBController.m
//  StartUpCalculator
//
//  Created by Tom on 4/23/14.
//  Copyright (c) 2014 Tom Liu. All rights reserved.
//

#import "TBController.h"

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
    // Do any additional setup after loading the view.
    
    /*
    NSArray *items = self.tabBar.items;
    UITabBarItem *inBtn = items[0];
    UITabBarItem *outBtn = items[1];
    UITabBarItem *resultBtn = items[2];
   
    if (self.tabBarController.selectedIndex == 0) {

        UIImage *outImg = outBtn.image;
        outBtn.selectedImage = outImg;
        outBtn.image = [[UIImage imageNamed:@"Out_iconBlue"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        
        UIImage *resImg = resultBtn.image;
        resultBtn.selectedImage = resImg;
        resultBtn.image = [[UIImage imageNamed:@"Results_iconBlue"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        NSLog(@"im %lu", (unsigned long)self.tabBarController.selectedIndex);
    }
    
    if (self.tabBarController.selectedIndex == 1) {
        NSLog(@"im2");
        UIImage *inImg = inBtn.image;
        inBtn.selectedImage = inImg;
        inBtn.image = [[UIImage imageNamed:@"In_iconRed"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        
        UIImage *resImg = resultBtn.image;
        resultBtn.selectedImage = resImg;
        resultBtn.image = [[UIImage imageNamed:@"Results_iconRed"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        NSLog(@"im %lu", (unsigned long)self.tabBarController.selectedIndex);

    }
    */
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
