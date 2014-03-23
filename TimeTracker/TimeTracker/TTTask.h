//
//  Task.h
//  TimeTracker
//
//  Created by Jérémy Morosi on 06/03/2014.
//  Copyright (c) 2014 Jojeredamyn. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 A task.
 
 It has an unique identifier and a name.
 It is linked to an existing project with the project's identifier.
 */
@interface TTTask : NSObject

/**
 Task's identifier.
 */
@property int identifier;

/**
 Project's identifier.
 */
@property int idProject;

/**
 Task's name.
 */
@property (strong, nonatomic) NSString *name;

/**
 Initialize a new Task.
 @param identifier Task's identifier.
 @param name Task's name.
 @param idProject Project's identifier.
 @return The initialized task.
 */
- (id)initWithIdentifier:(int)identifier name:(NSString *)name project:(int)idProject;

/**
 Initialize a new Task.
 @param name Task's name.
 @param idProject Project's identifier.
 @return The initialized task.
 */
- (id)initWithName:(NSString *)name project:(int)idProject;

/**
 Initialize a new Task.
 @param task Another task.
 @return The initialized task.
 */
- (id)initWithTask:(TTTask *)task;

@end
