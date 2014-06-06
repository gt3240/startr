//
//  TBController.h
//  StartUpCalculator
//
//  Created by Tom on 4/23/14.
//  Copyright (c) 2014 Tom Liu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Projects.h"

@interface TBController : UITabBarController

@property (strong,nonatomic)NSNumber *projectIndexToOpen;
@property (strong, nonatomic)Projects *projectToOpen;
@end
