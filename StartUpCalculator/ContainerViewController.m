//
//  ContainerViewController.m
//  StartUpCalculator
//
//  Created by Tom on 3/29/14.
//  Copyright (c) 2014 Tom Liu. All rights reserved.
//

#import "ContainerViewController.h"
#import "SavedProjectsTableViewController.h"
#import "SideMenuTableViewController.h"


@interface ContainerViewController ()
{
    UINavigationController *incomeNav;
}
@end

@implementation ContainerViewController

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
    // Do any additional setup after loading the view.
    
    superX =self.view.layer.position.x;
    
    topeDerecha = superX+self.leftMenu.frame.size.width;
    
    leftPanelOrigin = self.leftMenu.layer.position;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)isPaningToCloseMenu:(UIPanGestureRecognizer *)sender {
    
    CGPoint translation = [sender translationInView:self.view];
    
    CALayer *centerLayer =self.mainMenu.layer;
    CGPoint nuevoPoint = centerLayer.position;
    CGPoint transPoint = centerLayer.position;
    
    if (translation.x < centerLayer.frame.size.width) {
        
        transPoint.x += translation.x;
        
        if (translation.x <= 0) {
            centerLayer.position = transPoint;
        
            [sender setTranslation:CGPointZero inView:self.view];
    
            if (sender.state == UIGestureRecognizerStateEnded) {
            
                nuevoPoint.x = superX;
                [UIView animateWithDuration:0.4 delay:0 usingSpringWithDamping:0.7 initialSpringVelocity:1 options:UIViewAnimationOptionCurveEaseOut animations:^{
                
                    centerLayer.position = nuevoPoint;
                
                }completion:nil];
            }
        }
        else
        {
            if (sender.state == UIGestureRecognizerStateEnded) {
                
                nuevoPoint.x = topeDerecha;
                [UIView animateWithDuration:0.4 delay:0 usingSpringWithDamping:0.7 initialSpringVelocity:1 options:UIViewAnimationOptionCurveEaseOut animations:^{
                    
                    centerLayer.position = nuevoPoint;
                    
                }completion:nil];
            }
        }
        
    }
}

-(void)openSavedProjectAt:(NSNumber *)index
{
    
    UITabBarController *tbc = self.childViewControllers[1];
    UINavigationController *nav = tbc.viewControllers[0];
    IncomeViewController *tvc = (IncomeViewController *)nav.topViewController;
    
    
    tvc.projectIndexToOpen = index;
    [tvc.periodCollectionView reloadData];
    [tvc.mainTableView reloadData];
    
    [self menuButtonPushed]; // close side menu
}

-(void)menuButtonPushed
{
    CALayer *centerLayer =self.mainMenu.layer;
    CGPoint nuevoPoint = centerLayer.position;
    
    if (centerLayer.position.x == topeDerecha) {
        
        nuevoPoint.x = superX;
    }
    else
    {
        
        nuevoPoint.x = topeDerecha;
    }
    
    [UIView animateWithDuration:0.4 delay:0 usingSpringWithDamping:0.7 initialSpringVelocity:1 options:UIViewAnimationOptionCurveEaseOut animations:^{
        
        centerLayer.position = nuevoPoint;
        
    }completion:nil];
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    
    if ([segue.identifier isEqualToString:@"incomeSegue"]) {
        
        UITabBarController *miTab = segue.destinationViewController;
        
        incomeNav = miTab.viewControllers[0];
        
        IncomeViewController *destino = incomeNav.viewControllers[0];
        
        destino.myDelegate = self;
        
        //in delegate
        //UIViewController *nuevaEscena = [self.storyboard instantiateViewControllerWithIdentifier:@"nuevaEscena"];
        //[incomeNav pushViewController:nuevaEscena animated:YES];
        
    }
    
    if ([segue.identifier isEqualToString:@"sideMenuSegue"]) {
        
        UINavigationController *nav = segue.destinationViewController;
        
        SideMenuTableViewController *vc = nav.viewControllers[0];
        vc.delegate = self;
        
    }
}


@end

