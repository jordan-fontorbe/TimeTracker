//
//  TTImageManager.h
//  TimeTracker
//
//  Created by Jérémy Morosi on 07/03/2014.
//  Copyright (c) 2014 Jojeredamyn. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum {
    Pause,
    Play,
    Project,
    QuickStart,
    Task,
    Tasks,
    Mail
} Icon;

@interface TTImageManager : NSObject

+ (void)init;
+ (UIImage *)getIcon:(Icon)icon;
+ (UIImageView *)getIconView:(Icon)icon;

@end
