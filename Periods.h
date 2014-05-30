//
//  Periods.h
//  StartUpCalculator
//
//  Created by Tom on 5/28/14.
//  Copyright (c) 2014 Tom Liu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Expenses, Incomes, Projects;

@interface Periods : NSManagedObject

@property (nonatomic, retain) NSNumber * expenseTotal;
@property (nonatomic, retain) NSNumber * incomeTotal;
@property (nonatomic, retain) NSNumber * periodNum;
@property (nonatomic, retain) NSString * periodType;
@property (nonatomic, retain) NSSet *expense;
@property (nonatomic, retain) NSSet *income;
@property (nonatomic, retain) Projects *projects;
@end

@interface Periods (CoreDataGeneratedAccessors)

- (void)addExpenseObject:(Expenses *)value;
- (void)removeExpenseObject:(Expenses *)value;
- (void)addExpense:(NSSet *)values;
- (void)removeExpense:(NSSet *)values;

- (void)addIncomeObject:(Incomes *)value;
- (void)removeIncomeObject:(Incomes *)value;
- (void)addIncome:(NSSet *)values;
- (void)removeIncome:(NSSet *)values;

@end
