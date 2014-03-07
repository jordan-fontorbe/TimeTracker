//
//  TimeTrackerAppDelegate.h
//  TimeTracker
//
//  Created by Lion User on 06/03/14.
//  Copyright (c) 2014 Jojeredamyn. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TTAppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property(nonatomic, retain) UIViewController *controller;

@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;

- (void)saveContext;
- (NSURL *)applicationDocumentsDirectory;

@end
