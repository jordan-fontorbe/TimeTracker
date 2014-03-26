//
//  TimeTrackerAppDelegate.m
//  TimeTracker
//
//  Created by Lion User on 06/03/14.
//  Copyright (c) 2014 Jojeredamyn. All rights reserved.
//

#import "TTAppDelegate.h"
#import "TTImageManager.h"
#import "TTOverviewController.h"
#import "TTDatabase.h"
#import "TTDataManager.h"
#import "TTProject.h"
#import "TTTask.h"
#import "TTTime.h"


@implementation TTAppDelegate

@synthesize managedObjectContext = _managedObjectContext;
@synthesize managedObjectModel = _managedObjectModel;
@synthesize persistentStoreCoordinator = _persistentStoreCoordinator;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Initialize the ImageManager.
    [TTImageManager init];
    
    // Clear the database. (a retirer ensuite)
    [[TTDatabase instance] clear];
    
    // Initialize singleton
    [[TTDatabase instance] createDatabase];
    [[TTDataManager instance] initRunningTasks];
    
    //**** A RETIRER (SEULEMENT POUR TEST) ****//
    
    TTProject *prj1 = [[TTProject alloc] init];
    [prj1 setName:@"Développement iOS"];
    [[TTDatabase instance] insertProject:prj1];
    
    TTProject *prj2 = [[TTProject alloc] init];
    [prj2 setName:@"Analyse statique"];
    [[TTDatabase instance] insertProject:prj2];
    
    TTProject *prj3 = [[TTProject alloc] init];
    [prj3 setName:@"Sécurité réseau"];
    [[TTDatabase instance] insertProject:prj3];
    
    TTTask *task = [[TTTask alloc] initWithName:@"Projet" project:1];
    [[TTDatabase instance] insertTask:task];
    
    task = [[TTTask alloc] initWithName:@"single task 1" project:0];
    [[TTDatabase instance] insertTask:task];
    
    TTTime *time = [[TTTime alloc] init];
    [time setIdTask:0];
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"dd/MM/yyyy HH:mm:ss"];
    [time setStart:[dateFormat dateFromString:@"16/03/2014 14:00:30"]];
    [time setEnd:[dateFormat dateFromString:@"16/03/2014 15:23:10"]];
    [time setIdTask:2];
    [[TTDatabase instance] insertTime:time];
    time = [[TTTime alloc] init];
    [time setIdTask:1];
    [time setStart:[dateFormat dateFromString:@"16/03/2014 15:00:00"]];
    [time setEnd:[dateFormat dateFromString:@"16/03/2014 17:00:00"]];
    [[TTDatabase instance] insertTime:time];
    TTRunningTask *runningTask = [[TTRunningTask alloc] initWithTask:task start:[dateFormat dateFromString:@"26/03/2014 10:00:30"]];
    [[TTDataManager instance] addRunningTask:runningTask];
    
    //****************************************//
    
    // Set the view.
    self.overviewController = [[TTOverviewController alloc]initWithNibName:@"TTOverviewController" bundle:nil];
    self.navigationController = [[UINavigationController alloc] initWithRootViewController:self.overviewController];
    self.window.rootViewController = self.navigationController;
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];

    
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
    // Saves changes in the application's managed object context before the application terminates.
    [self saveContext];
}

- (void)saveContext
{
    NSError *error = nil;
    NSManagedObjectContext *managedObjectContext = self.managedObjectContext;
    if (managedObjectContext != nil) {
        if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error]) {
             // Replace this implementation with code to handle the error appropriately.
             // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development. 
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        } 
    }
}

#pragma mark - Core Data stack

// Returns the managed object context for the application.
// If the context doesn't already exist, it is created and bound to the persistent store coordinator for the application.
- (NSManagedObjectContext *)managedObjectContext
{
    if (_managedObjectContext != nil) {
        return _managedObjectContext;
    }
    
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (coordinator != nil) {
        _managedObjectContext = [[NSManagedObjectContext alloc] init];
        [_managedObjectContext setPersistentStoreCoordinator:coordinator];
    }
    return _managedObjectContext;
}

// Returns the managed object model for the application.
// If the model doesn't already exist, it is created from the application's model.
- (NSManagedObjectModel *)managedObjectModel
{
    if (_managedObjectModel != nil) {
        return _managedObjectModel;
    }
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"TimeTracker" withExtension:@"momd"];
    _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    return _managedObjectModel;
}

// Returns the persistent store coordinator for the application.
// If the coordinator doesn't already exist, it is created and the application's store added to it.
- (NSPersistentStoreCoordinator *)persistentStoreCoordinator
{
    if (_persistentStoreCoordinator != nil) {
        return _persistentStoreCoordinator;
    }
    
    NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"TimeTracker.sqlite"];
    
    NSError *error = nil;
    _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    if (![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error]) {
        /*
         Replace this implementation with code to handle the error appropriately.
         
         abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development. 
         
         Typical reasons for an error here include:
         * The persistent store is not accessible;
         * The schema for the persistent store is incompatible with current managed object model.
         Check the error message to determine what the actual problem was.
         
         
         If the persistent store is not accessible, there is typically something wrong with the file path. Often, a file URL is pointing into the application's resources directory instead of a writeable directory.
         
         If you encounter schema incompatibility errors during development, you can reduce their frequency by:
         * Simply deleting the existing store:
         [[NSFileManager defaultManager] removeItemAtURL:storeURL error:nil]
         
         * Performing automatic lightweight migration by passing the following dictionary as the options parameter:
         @{NSMigratePersistentStoresAutomaticallyOption:@YES, NSInferMappingModelAutomaticallyOption:@YES}
         
         Lightweight migration will only work for a limited set of schema changes; consult "Core Data Model Versioning and Data Migration Programming Guide" for details.
         
         */
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }    
    
    return _persistentStoreCoordinator;
}

#pragma mark - Application's Documents directory

// Returns the URL to the application's Documents directory.
- (NSURL *)applicationDocumentsDirectory
{
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}

@end
