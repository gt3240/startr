//
//  Projects.h
//  StartUpCalculator
//
//  Created by Tom on 6/2/14.
//  Copyright (c) 2014 Tom Liu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Notes, Periods;

@interface Projects : NSManagedObject

@property (nonatomic, retain) NSDate * date;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSString * projectDescription;
@property (nonatomic, retain) NSString * type;
@property (nonatomic, retain) NSSet *notes;
@property (nonatomic, retain) NSSet *period;
@end

@interface Projects (CoreDataGeneratedAccessors)

- (void)addNotesObject:(Notes *)value;
- (void)removeNotesObject:(Notes *)value;
- (void)addNotes:(NSSet *)values;
- (void)removeNotes:(NSSet *)values;

- (void)addPeriodObject:(Periods *)value;
- (void)removePeriodObject:(Periods *)value;
- (void)addPeriod:(NSSet *)values;
- (void)removePeriod:(NSSet *)values;

@end
