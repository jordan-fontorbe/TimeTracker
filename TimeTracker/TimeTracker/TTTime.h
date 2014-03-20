//
//  Time.h
//  TimeTracker
//
//  Created by Jérémy Morosi on 06/03/2014.
//  Copyright (c) 2014 Jojeredamyn. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TTTime : NSObject

@property int identifier;
@property int idTask;
@property (strong, nonatomic) NSDate *start;
@property (strong, nonatomic) NSDate *end;
@property (strong, nonatomic) NSDateComponents *startComponents;
@property (strong, nonatomic) NSDateComponents *endComponents;
@property (strong, nonatomic) NSDateComponents *durationComponents;
- (id)initWithTime:(TTTime *)time;
- (id)initWithIdentifier:(int)identifier start:(NSDate *)start end:(NSDate *)end task:(int)idTask;
- (id)initWithStart:(NSDate *)start end:(NSDate *)end task:(int)idTask;
- (NSString *)formatDay;
- (NSString *)formatInterval;
- (NSString *)formatDuration;

@end
