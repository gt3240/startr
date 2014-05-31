//
//  TutorialViewController.m
//  StartUpCalculator
//
//  Created by Tom on 5/29/14.
//  Copyright (c) 2014 Tom Liu. All rights reserved.
//

#import "TutorialViewController.h"

@interface TutorialViewController ()
{
    NSArray *myContainers;
}
@end

@implementation TutorialViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    myContainers = @[self.contain1, self.contain2, self.contain4, self.contain5, self.contain3];
    self.pageControl.numberOfPages = myContainers.count;
    CGRect scrollFrame = self.tutorialScrollView.bounds;
    
    for (int x = 0; x<myContainers.count; x++) {
        CGRect soyFrame = scrollFrame;
        soyFrame.origin.x += soyFrame.size.width*x;
        ((UIView *)myContainers[x]).frame= soyFrame;
        [self.tutorialScrollView addSubview:myContainers[x]];
    }
    
    [self.tutorialScrollView setContentSize:CGSizeMake(self.tutorialScrollView.frame.size.width*myContainers.count, self.tutorialScrollView.frame.size.height)];
    
    [[UIApplication sharedApplication] setStatusBarHidden:YES
                                            withAnimation:UIStatusBarAnimationFade];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    
    //[self performSelector:@selector(scrollTo:) withObject:@1 afterDelay:2.0];
    
}

-(void)scrollTo:(NSNumber *)num
{
    // Aqui va el scrolleo
    //[self.miScrollView scrollRectToVisible:self.container1.frame animated:YES];
    
    [self.tutorialScrollView scrollRectToVisible:((UIView *)myContainers[num.intValue]).frame animated:YES];
    
    //self.pageControl.currentPage = 1;
    
    [self performSelector:@selector(scrollViewDidEndDecelerating:) withObject:self.tutorialScrollView afterDelay:0.4];
    
}

-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    self.pageControl.currentPage = scrollView.contentOffset.x/scrollView.frame.size.width;
}

- (IBAction)updatePageControl:(UIPageControl *)sender {
    [self scrollTo:@(sender.currentPage)];
}
@end
