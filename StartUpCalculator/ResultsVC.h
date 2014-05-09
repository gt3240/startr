//
//  ResultsVC.h
//  StartUpCalculator
//
//  Created by Tom on 5/9/14.
//  Copyright (c) 2014 Tom Liu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Projects.h"

@interface ResultsVC : UIViewController

@property (weak, nonatomic) IBOutlet UITableView *resultTBV;
@property (strong, nonatomic)Projects *openProject;
@end
