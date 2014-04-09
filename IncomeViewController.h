//
//  IncomeViewController.h
//  StartUpCalculator
//
//  Created by Tom on 3/28/14.
//  Copyright (c) 2014 Tom Liu. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol IncomeViewDelegate <NSObject>

-(void)menuButtonPushed;

@end

@interface IncomeViewController : UIViewController<UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>
{
    NSMutableArray * income; // change to nsarray when connect to core data
    NSArray * projectsArr;
    NSMutableArray *periodsArr;
    
    int previousSelected;
}

@property (nonatomic,strong) id<IncomeViewDelegate> myDelegate;
@property (weak, nonatomic) IBOutlet UITableView *mainTableView;

@end
