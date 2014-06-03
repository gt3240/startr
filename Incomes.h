//
//  Incomes.h
//  StartUpCalculator
//
//  Created by Tom on 6/2/14.
//  Copyright (c) 2014 Tom Liu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Periods;

@interface Incomes : NSManagedObject

@property (nonatomic, retain) NSNumber * amount;
@property (nonatomic, retain) NSString * notes;
@property (nonatomic, retain) NSNumber * recurring;
@property (nonatomic, retain) NSNumber * recurringAmount;
@property (nonatomic, retain) NSDate * recurringDateID;
@property (nonatomic, retain) NSNumber * recurringEndPeriod;
@property (nonatomic, retain) NSNumber * recurringPeriod;
@property (nonatomic, retain) NSString * recurringType;
@property (nonatomic, retain) NSString * source;
@property (nonatomic, retain) NSString * title;
@property (nonatomic, retain) NSString * type;
@property (nonatomic, retain) NSString * recurringPostiveOrNegative;
@property (nonatomic, retain) Periods *period;

@end
