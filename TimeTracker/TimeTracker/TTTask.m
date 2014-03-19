//
//  Task.m
//  TimeTracker
//
//  Created by Jérémy Morosi on 06/03/2014.
//  Copyright (c) 2014 Jojeredamyn. All rights reserved.
//

#import "TTTask.h"

@implementation TTTask

@synthesize identifier = _identifier;
@synthesize idProject = _idProject;
@synthesize name = _name;

- (id)initWithIdentifier:(int)identifier name:(NSString *)name project:(int)idProject
{
    self = [super init];
    if(self) {
        _identifier = identifier;
        _name = name;
        _idProject = idProject;
    }
    return self;
}

- (id)initWithName:(NSString *)name project:(int)idProject
{
    return [self initWithIdentifier:0 name:name project:idProject];
}

- (id)initWithTask:(TTTask *)task
{
    return [self initWithIdentifier:[task identifier] name:[task name] project:[task idProject]];
}

@end
