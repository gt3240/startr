//
//  Notes.h
//  StartUpCalculator
//
//  Created by Tom on 5/28/14.
//  Copyright (c) 2014 Tom Liu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Projects;

@interface Notes : NSManagedObject

@property (nonatomic, retain) NSDate * date;
@property (nonatomic, retain) NSString * notes;
@property (nonatomic, retain) Projects *project;

@end
