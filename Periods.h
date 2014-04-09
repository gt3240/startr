//
//  Periods.h
//  StartUpCalculator
//
//  Created by Tom on 4/9/14.
//  Copyright (c) 2014 Tom Liu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Incomes, Projects;

@interface Periods : NSManagedObject

@property (nonatomic, retain) NSNumber * periodNum;
@property (nonatomic, retain) NSSet *income;
@property (nonatomic, retain) Projects *projects;
@end

@interface Periods (CoreDataGeneratedAccessors)

- (void)addIncomeObject:(Incomes *)value;
- (void)removeIncomeObject:(Incomes *)value;
- (void)addIncome:(NSSet *)values;
- (void)removeIncome:(NSSet *)values;

@end
