//
//  Expense.h
//  StartUpCalculator
//
//  Created by Tom on 4/8/14.
//  Copyright (c) 2014 Tom Liu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Period;

@interface Expense : NSManagedObject

@property (nonatomic, retain) NSNumber * amount;
@property (nonatomic, retain) NSString * expense_type;
@property (nonatomic, retain) NSString * recurring;
@property (nonatomic, retain) NSNumber * recurring_amount;
@property (nonatomic, retain) NSNumber * recurring_periods;
@property (nonatomic, retain) NSString * recurring_type;
@property (nonatomic, retain) NSString * source;
@property (nonatomic, retain) NSString * title;
@property (nonatomic, retain) Period *period;

@end
