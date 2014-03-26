//
//  TTSelectProjectDelegate.h
//  TimeTracker
//
//  Created by Jérémy Morosi on 12/03/2014.
//  Copyright (c) 2014 Jojeredamyn. All rights reserved.
//

#import <Foundation/Foundation.h>

@class TTSelectProjectController;

/**
 Delegate for the select project view.
 */
@protocol TTSelectProjectDelegate <NSObject>

/**
 Called when a project has been selected.
 @param projectId Selected project identifier.
 */
- (void)onProjectSelected:(int)projectId;

@end
