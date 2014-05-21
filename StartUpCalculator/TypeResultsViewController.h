//
//  TypeResultsViewController.h
//  StartUpCalculator
//
//  Created by Tom on 5/14/14.
//  Copyright (c) 2014 Tom Liu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Projects.h"

@interface TypeResultsViewController : UIViewController
@property (weak, nonatomic) IBOutlet UITableView *mainTable;

@property (strong, nonatomic)NSString * periodStr;

@property (strong, nonatomic)Projects *openProject;
@property (weak, nonatomic) IBOutlet UISegmentedControl *typeSwitch;

@end
