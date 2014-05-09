//
//  ExpenseTypeCollectionViewController.h
//  StartUpCalculator
//
//  Created by Tom on 5/8/14.
//  Copyright (c) 2014 Tom Liu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "IncomeAndExpenseType.h"

@interface ExpenseTypeCollectionViewController : UICollectionViewController

@property (strong, nonatomic)IncomeAndExpenseType *selectExpenseTypeObj;

@end
