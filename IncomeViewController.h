//
//  IncomeViewController.h
//  StartUpCalculator
//
//  Created by Tom on 3/28/14.
//  Copyright (c) 2014 Tom Liu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NewIncomeTableViewController.h"

@protocol IncomeViewDelegate <NSObject>

-(void)menuButtonPushed;

@end

@interface IncomeViewController : UIViewController<UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, editOrNewIncomeDelegate>
{
    NSMutableArray * income; // change to nsarray when connect to core data
    NSArray * projectsArr;
    NSArray *periodsArr;
    NSArray *incomeArr;
    
    int previousSelected;
}

@property (nonatomic,strong) id<IncomeViewDelegate> myDelegate;
@property (weak, nonatomic) IBOutlet UITableView *mainTableView;

@property (weak, nonatomic) IBOutlet UICollectionView *periodCollectionView;

@property (strong,nonatomic)NSNumber *projectIndexToOpen;
@property (strong, nonatomic)Projects *projectToOpen;
@end
