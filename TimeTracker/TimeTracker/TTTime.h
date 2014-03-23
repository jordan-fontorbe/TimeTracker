//
//  Time.h
//  TimeTracker
//
//  Created by Jérémy Morosi on 06/03/2014.
//  Copyright (c) 2014 Jojeredamyn. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 A time.
 
 It has an unique identifier.
 It is linked to an existing task by its identifier.
 */
@interface TTTime : NSObject

/**
 Time's identifier.
 */
@property int identifier;

/**
 Task's identifier.
 */
@property int idTask;

/**
 Starting date.
 */
@property (strong, nonatomic) NSDate *start;

/**
 Ending date.
 */
@property (strong, nonatomic) NSDate *end;

/**
 Starting date components.
 */
@property (strong, nonatomic) NSDateComponents *startComponents;

/**
 Ending date components.
 */
@property (strong, nonatomic) NSDateComponents *endComponents;

/**
 Components of the difference between the ending date and the starting date.
 */
@property (strong, nonatomic) NSDateComponents *durationComponents;

/**
 Initialize a new time.
 @param time Another time.
 @return The initialized time.
 */
- (id)initWithTime:(TTTime *)time;

/**
 Initialize a new time.
 @param identifier Time's identifier.
 @param start Starting date.
 @param end Ending date.
 @param idTask Task's identifier.
 @return The initialized time.
 */
- (id)initWithIdentifier:(int)identifier start:(NSDate *)start end:(NSDate *)end task:(int)idTask;

/**
 Initialize a new time.
 @param start Starting date.
 @param end Ending date.
 @param idTask Task's identifier.
 @return The initialized time.
 */
- (id)initWithStart:(NSDate *)start end:(NSDate *)end task:(int)idTask;

/**
 Get the components of the difference between the current date and the starting date.
 @return the components of the difference between the current date and the starting date.
 */
- (NSDateComponents *)durationComponentsFromStartToNow;

/**
 Get the string representation of the starting date day.
 @return the string representation of the starting date day.
 */
- (NSString *)formatDay;

/**
 Get the string representation of the interval between the two dates.
 @return the string representation of the interval between the two dates.
 */
- (NSString *)formatInterval;

/**
 Get the string representation of the difference between the two dates.
 @return the string representation of the difference between the two dates.
 */
- (NSString *)formatDuration;

/**
 Get the string representation of the ending date hour.
 @return the string representation of the ending date hour.
 */
- (NSString *)formatHourEnd;

/**
 Get the string representation of the starting date.
 @return the string representation of the starting date.
 */
- (NSString *)formatStart;

@end
