//
//  SavedProjectsTableViewController.h
//  StartUpCalculator
//
//  Created by Tom on 4/16/14.
//  Copyright (c) 2014 Tom Liu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "projects.h"
#import "TempProject.h"

@interface SavedProjectsTableViewController : UITableViewController

@property (nonatomic, strong)TempProject * indexOfSavedProject;

@end

