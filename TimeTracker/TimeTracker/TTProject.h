//
//  Project.h
//  TimeTracker
//
//  Created by Jérémy Morosi on 06/03/2014.
//  Copyright (c) 2014 Jojeredamyn. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TTProject : NSObject

@property int identifier;
@property (strong, nonatomic) NSString *name;
- (id)initWithIdentifier:(int)identifier name:(NSString *)name;
- (id)initWithName:(NSString *)name;
- (id)initWithProject:(TTProject *)project;

@end
