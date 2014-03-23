//
//  Project.h
//  TimeTracker
//
//  Created by Jérémy Morosi on 06/03/2014.
//  Copyright (c) 2014 Jojeredamyn. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 A project.
 
 Is has an unique identifier and a name.
 */
@interface TTProject : NSObject

/**
 Project's identifier.
 */
@property int identifier;

/**
 Project's name.
 */
@property (strong, nonatomic) NSString *name;

/**
 Initialize a new project.
 @param identifier Project's identifier.
 @param name Project's name.
 @return The initialized project.
 */
- (id)initWithIdentifier:(int)identifier name:(NSString *)name;

/**
 Initialize a new project.
 @param name Project's name.
 @return The initialized project.
 */
- (id)initWithName:(NSString *)name;

/**
 Initialize a new project.
 @param project Another project.
 @return The initialized project.
 */
- (id)initWithProject:(TTProject *)project;

@end
