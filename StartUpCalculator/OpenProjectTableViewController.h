//
//  OpenProjectTableViewController.h
//  StartUpCalculator
//
//  Created by Tom on 4/19/14.
//  Copyright (c) 2014 Tom Liu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TempProject.h"


@interface OpenProjectTableViewController : UITableViewController

@property (nonatomic, strong)TempProject * indexOfSavedProject;

@property (strong,nonatomic)NSNumber *projectIndexToOpen;
@property (strong, nonatomic) IBOutlet UITableView *savedProjectTable;

@end
