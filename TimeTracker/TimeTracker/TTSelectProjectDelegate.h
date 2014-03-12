//
//  TTSelectProjectDelegate.h
//  TimeTracker
//
//  Created by Jérémy Morosi on 12/03/2014.
//  Copyright (c) 2014 Jojeredamyn. All rights reserved.
//

#import <Foundation/Foundation.h>

@class TTSelectProjectController;

@protocol TTSelectProjectDelegate <NSObject>

- (void)onSelected:(int)projectId;

@end
