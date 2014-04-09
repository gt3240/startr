//
//  Incomes.h
//  StartUpCalculator
//
//  Created by Tom on 4/9/14.
//  Copyright (c) 2014 Tom Liu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Periods;

@interface Incomes : NSManagedObject

@property (nonatomic, retain) NSNumber * amount;
@property (nonatomic, retain) NSString * title;
@property (nonatomic, retain) Periods *period;

@end
