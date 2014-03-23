//
//  Project.m
//  TimeTracker
//
//  Created by Jérémy Morosi on 06/03/2014.
//  Copyright (c) 2014 Jojeredamyn. All rights reserved.
//

#import "TTProject.h"

@implementation TTProject

@synthesize identifier = _identifier;
@synthesize name = _name;

- (id)initWithIdentifier:(int)identifier name:(NSString *)name
{
    self = [super init];
    if(self) {
        _identifier = identifier;
        _name = name;
    }
    return self;
}

- (id)initWithName:(NSString *)name
{
    return [self initWithIdentifier:0 name:name];
}

- (id)initWithProject:(TTProject *)project
{
    return [self initWithIdentifier:[project identifier] name:[project name]];
}

@end
