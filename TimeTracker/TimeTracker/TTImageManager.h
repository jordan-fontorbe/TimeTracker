//
//  TTImageManager.h
//  TimeTracker
//
//  Created by Jérémy Morosi on 07/03/2014.
//  Copyright (c) 2014 Jojeredamyn. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 Enum for icons.
 */
typedef enum {
    Pause,
    Play,
    Project,
    QuickStart,
    Task,
    Tasks,
    Mail
} Icon;

/**
 Manager for the icons.
 */
@interface TTImageManager : NSObject

/**
 Initialize a new manager.
 @return The initialized manager.
 */
+ (void)init;

/**
 Get the image for the given icon.
 @param icon Icon to get.
 @return The image.
 */
+ (UIImage *)getIcon:(Icon)icon;

/**
 Get the image view for the given icon.
 @param icon Icon to get.
 @return The image view.
 */
+ (UIImageView *)getIconView:(Icon)icon;

@end
