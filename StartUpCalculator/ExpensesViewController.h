//
//  ExpensesViewController.h
//  StartUpCalculator
//
//  Created by Tom on 4/24/14.
//  Copyright (c) 2014 Tom Liu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "projects.h"
#import "NewExpenseTableViewController.h"

@interface ExpensesViewController : UIViewController<UICollectionViewDelegate, UICollectionViewDataSource, editOrNewExpenseDelegate>
{
    NSMutableArray * expense; // change to nsarray when connect to core data
    NSArray * projectsArr;
    NSArray *periodsArr;
    NSArray *expenseArr;
    
    int previousSelected;

}
@property (weak, nonatomic) IBOutlet UITableView *mainTableView;

@property (weak, nonatomic) IBOutlet UICollectionView *periodCollectionView;
@property (weak, nonatomic) IBOutlet UILabel *termsTypeLabel;

@property (strong,nonatomic)NSNumber *projectIndexToOpen;
@property (strong, nonatomic)Projects *projectToOpen;

@end
