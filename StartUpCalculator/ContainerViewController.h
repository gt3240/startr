//
//  ContainerViewController.h
//  StartUpCalculator
//
//  Created by Tom on 3/29/14.
//  Copyright (c) 2014 Tom Liu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "IncomeViewController.h"

@interface ContainerViewController : UIViewController<IncomeViewDelegate>
{
    int topeDerecha;
    int superX;
    CGPoint leftPanelOrigin;
}
@property (weak, nonatomic) IBOutlet UIView *leftMenu;
@property (weak, nonatomic) IBOutlet UIView *mainMenu;

@end
