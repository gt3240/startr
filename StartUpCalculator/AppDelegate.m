//
//  AppDelegate.m
//  StartUpCalculator
//
//  Created by Tom on 3/26/14.
//  Copyright (c) 2014 Tom Liu. All rights reserved.
//

#import "AppDelegate.h"
#import "InnerBand.h"
#import "Projects.h"
#import "Periods.h"
#import "Incomes.h"

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Override point for customization after application launch
    
    // remove navbar lower border.
    [[UINavigationBar appearance] setBackgroundImage:[[UIImage alloc] init]
                                      forBarPosition:UIBarPositionAny
                                          barMetrics:UIBarMetricsDefault];
    
    [[UINavigationBar appearance] setShadowImage:[[UIImage alloc] init]];
    
    
    NSUserDefaults *miDefaults = [NSUserDefaults standardUserDefaults];
    
    if (![miDefaults objectForKey:@"firstLaunch"]) {
        // load the p list
        /*
        NSString *pathArtist = [[NSBundle mainBundle] pathForResource:@"startup" ofType:@"plist"];
        NSArray *projectList = [NSArray arrayWithContentsOfFile:pathArtist];
        
        for (NSDictionary *imProject in projectList) {
            Projects *newProject = [Projects create];
            
            newProject.name = imProject[@"projectName"];
            
            for (NSDictionary *periodList in imProject[@"period"]) {
                Periods *newPeriod = [Periods create];
                newPeriod.periodNum = periodList[@"periodNum"];
                newPeriod.projects = newProject;
                
                for (NSDictionary *incomeList in periodList[@"canciones"]) {
                    Incomes *newIncome = [Incomes create];
                    newIncome.title = incomeList[@"title"];
                    newIncome.amount = incomeList[@"amount"];
                    newIncome.period = newPeriod;
                }
            }
            
            [[IBCoreDataStore mainStore] save];
        }
        
        */
        [miDefaults setObject:@1 forKey:@"firstLaunch"];
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

@end
