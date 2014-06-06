//
//  SideMenuTableViewController.h
//  StartUpCalculator
//
//  Created by Tom on 4/15/14.
//  Copyright (c) 2014 Tom Liu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Projects.h"
#import "TempProject.h"

@protocol SideMenuDelegate <NSObject>

-(void)openSavedProjectAt:(NSNumber *)index;

@end

@interface SideMenuTableViewController : UITableViewController
{
    TempProject * tempPro; // used to get the which savedproject is selected
}

@property (strong, nonatomic)id<SideMenuDelegate> delegate;
@end
