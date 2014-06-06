//
//  TutorialViewController.h
//  StartUpCalculator
//
//  Created by Tom on 5/29/14.
//  Copyright (c) 2014 Tom Liu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TutorialViewController : UIViewController
@property (weak, nonatomic) IBOutlet UIScrollView *tutorialScrollView;
@property (weak, nonatomic) IBOutlet UIPageControl *pageControl;

@property (strong, nonatomic) IBOutlet UIView *contain1;
@property (strong, nonatomic) IBOutlet UIView *contain2;
@property (strong, nonatomic) IBOutlet UIView *contain3;
@property (strong, nonatomic) IBOutlet UIView *contain4;
@property (strong, nonatomic) IBOutlet UIView *contain5;

@end
