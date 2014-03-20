//
//  TTDataManager.h
//  TimeTracker
//
//  Created by Lion User on 12/03/14.
//  Copyright (c) 2014 Jojeredamyn. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TTDataManager : NSObject

+(TTDataManager*)instance;

-(void)initRunningTasks;

-(NSMutableArray *)getRunningTasks;

-(void)setRunningTasks:(NSMutableArray*)newRunningTasks;

-(NSInteger)getNumberOfQuickRunningTasks;

@end
