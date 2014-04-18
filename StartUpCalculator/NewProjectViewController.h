//
//  NewProjectViewController.h
//  StartUpCalculator
//
//  Created by Tom on 4/7/14.
//  Copyright (c) 2014 Tom Liu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NewProjectViewController : UIViewController<UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITextField *projectNameTextField;

@end
