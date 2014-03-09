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

@end
