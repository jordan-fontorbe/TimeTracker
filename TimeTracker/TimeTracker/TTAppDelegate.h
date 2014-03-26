//
//  TimeTrackerAppDelegate.h
//  TimeTracker
//
//  Created by Lion User on 06/03/14.
//  Copyright (c) 2014 Jojeredamyn. All rights reserved.
//

#import <UIKit/UIKit.h>

@class TTOverviewController;

/**
 Delegate for the application.
 */
@interface TTAppDelegate : UIResponder <UIApplicationDelegate>

/**
 Window.
 */
@property (strong, nonatomic) UIWindow *window;

/**
 Controller for the navigation.
 */
@property (strong, nonatomic) UINavigationController * navigationController;

/**
 Controller for the overview.
 */
@property (strong, nonatomic) TTOverviewController * overviewController;

@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;

- (void)saveContext;
- (NSURL *)applicationDocumentsDirectory;

@end
