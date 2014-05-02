//
//  ProjectTypeViewController.h
//  StartUpCalculator
//
//  Created by Tom on 4/7/14.
//  Copyright (c) 2014 Tom Liu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Projects.h"

@interface ProjectTypeViewController : UIViewController

@property (strong, nonatomic)NSString *projectName;

@property (strong,nonatomic)NSNumber *projectIndexToOpen;
@property (weak, nonatomic) IBOutlet UITextField *termsTextField;
@property (weak, nonatomic) IBOutlet UISegmentedControl *typeSelector;

@end
