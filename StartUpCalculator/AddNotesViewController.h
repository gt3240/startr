//
//  AddNotesViewController.h
//  StartUpCalculator
//
//  Created by Tom on 5/28/14.
//  Copyright (c) 2014 Tom Liu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Projects.h"
#import "Notes.h"

@interface AddNotesViewController : UIViewController

@property (strong,nonatomic)Projects *currentProject;
@property (strong, nonatomic)Notes *currentNotes;

@end
