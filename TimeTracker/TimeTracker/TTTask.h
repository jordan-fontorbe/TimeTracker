//
//  Task.h
//  TimeTracker
//
//  Created by Jérémy Morosi on 06/03/2014.
//  Copyright (c) 2014 Jojeredamyn. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TTTask : NSObject

@property int identifier;
@property int idProject;
@property (strong, nonatomic) NSString *name;
- (id)initWithIdentifier:(int)identifier name:(NSString *)name project:(int)idProject;
- (id)initWithName:(NSString *)name project:(int)idProject;
- (id)initWithTask:(TTTask *)task;

@end
