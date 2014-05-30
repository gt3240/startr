//
//  ProfileViewController.h
//  StartUpCalculator
//
//  Created by Tom on 5/28/14.
//  Copyright (c) 2014 Tom Liu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Projects.h"

@interface ProfileViewController : UIViewController<UITextViewDelegate>
@property (weak, nonatomic) IBOutlet UILabel *projectTitle;
@property (weak, nonatomic) IBOutlet UITextView *projectDescription;
@property (weak, nonatomic) IBOutlet UITableView *notesTableView;

@property (strong, nonatomic)Projects *openProject;

@end
