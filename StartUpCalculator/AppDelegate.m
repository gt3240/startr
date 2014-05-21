//
//  AppDelegate.m
//  StartUpCalculator
//
//  Created by Tom on 3/26/14.
//  Copyright (c) 2014 Tom Liu. All rights reserved.
//

#import "AppDelegate.h"
#import "Projects.h"
#import "Periods.h"
#import "Incomes.h"

@implementation AppDelegate

@synthesize managedObjectContext = _managedObjectContext;
@synthesize managedObjectModel = _managedObjectModel;
@synthesize persistentStoreCoordinator = _persistentStoreCoordinator;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Override point for customization after application launch
    
    // remove navbar lower border.
    [[UINavigationBar appearance] setBackgroundImage:[[UIImage alloc] init]
                                      forBarPosition:UIBarPositionAny
                                          barMetrics:UIBarMetricsDefault];
    
    [[UINavigationBar appearance] setShadowImage:[[UIImage alloc] init]];
    
    self.window.tintColor = [UIColor whiteColor];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    
    BOOL isRunMoreThanOnce = [[NSUserDefaults standardUserDefaults] boolForKey:@"isRunMoreThanOnce"];
    if(!isRunMoreThanOnce){
        // load the p list
        NSLog(@"oops, not first time");

//        NSString *pathArtist = [[NSBundle mainBundle] pathForResource:@"startup" ofType:@"plist"];
//        NSArray *projectList = [NSArray arrayWithContentsOfFile:pathArtist];
//        
//        for (NSDictionary *imProject in projectList) {
//            Projects *newProject = [Projects create];
//            
//            newProject.name = imProject[@"projectName"];
//            
//            for (NSDictionary *periodList in imProject[@"period"]) {
//                Periods *newPeriod = [Periods create];
//                newPeriod.periodNum = periodList[@"periodNum"];
//                newPeriod.projects = newProject;
//                
//                for (NSDictionary *incomeList in periodList[@"income"]) {
//                    Incomes *newIncome = [Incomes create];
//                    newIncome.title = incomeList[@"title"];
//                    newIncome.amount = incomeList[@"amount"];
//                    newIncome.period = newPeriod;
//                    newIncome.recurring = incomeList[@"recurring"];
//                    newIncome.recurringAmount = incomeList[@"recurringAmount"];
//                    newIncome.recurringType = incomeList[@"recurringType"];
//                    newIncome.recurringPeriod = incomeList[@"recurringPeriod"];
//                    newIncome.notes = incomeList[@"notes"];
//                    newIncome.source = incomeList[@"source"];
//                }
//            }
//            
//            [[IBCoreDataStore mainStore] save];
//           }
        
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"isRunMoreThanOnce"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
    

    return YES;
}
							
- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

// 1
- (NSManagedObjectContext *) managedObjectContext {
    if (_managedObjectContext != nil) {
        return _managedObjectContext;
    }
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (coordinator != nil) {
        _managedObjectContext = [[NSManagedObjectContext alloc] init];
        [_managedObjectContext setPersistentStoreCoordinator: coordinator];
    }
    
    return _managedObjectContext;
}

//2
- (NSManagedObjectModel *)managedObjectModel {
    if (_managedObjectModel != nil) {
        return _managedObjectModel;
    }
    _managedObjectModel = [NSManagedObjectModel mergedModelFromBundles:nil];
    
    return _managedObjectModel;
}

//3
- (NSPersistentStoreCoordinator *)persistentStoreCoordinator {
    if (_persistentStoreCoordinator != nil) {
        return _persistentStoreCoordinator;
    }
    NSURL *storeUrl = [NSURL fileURLWithPath: [[self applicationDocumentsDirectory]
                                               stringByAppendingPathComponent: @"Startr.sqlite"]];
    NSError *error = nil;
    
    _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc]
                                   initWithManagedObjectModel:[self managedObjectModel]];
    
    NSDictionary *options = @{NSPersistentStoreUbiquitousContentNameKey: @"Startr"};
    
    if(![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType
                                                  configuration:nil URL:storeUrl options:options error:&error]) {
        /*Error for store creation should be handled in here*/
    }
    
    return _persistentStoreCoordinator;
}

- (NSString *)applicationDocumentsDirectory {
    return [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
}

#pragma mark - fetch records

-(NSArray*)getAllProjects
{
    // initializing NSFetchRequest
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    
    //Setting Entity to be Queried
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Projects"
                                              inManagedObjectContext:self.managedObjectContext];
    [fetchRequest setEntity:entity];
    NSError* error;
    
    // Query on managedObjectContext With Generated fetchRequest
    NSArray *fetchedRecords = [self.managedObjectContext executeFetchRequest:fetchRequest error:&error];
    
    // Returning Fetched Records
    return fetchedRecords;
}
@end
