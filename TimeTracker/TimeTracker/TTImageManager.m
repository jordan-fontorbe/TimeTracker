//
//  TTImageManager.m
//  TimeTracker
//
//  Created by Jérémy Morosi on 07/03/2014.
//  Copyright (c) 2014 Jojeredamyn. All rights reserved.
//

#import "TTImageManager.h"

@interface TTImageManager ()

+ (NSDictionary *)loadIcons;
+ (void)loadIcon:(Icon)icon from:(NSString *)file to:(NSMutableDictionary *)dictionary;

@end

@implementation TTImageManager

static NSDictionary *_icons;

+ (void)init
{
    _icons = [self loadIcons];
}

+ (NSDictionary *)loadIcons
{
    NSMutableDictionary *d = [[NSMutableDictionary alloc] init];
    [self loadIcon:Pause from:@"pause" to:d];
    [self loadIcon:Play from:@"play" to:d];
    [self loadIcon:Project from:@"project" to:d];
    [self loadIcon:QuickStart from:@"quickstart" to:d];
    [self loadIcon:Task from:@"task" to:d];
    [self loadIcon:Tasks from:@"tasks" to:d];
    return d;
}

+ (void)loadIcon:(Icon)icon from:(NSString *)file to:(NSMutableDictionary *)dictionary
{
    NSString *s = [[NSBundle mainBundle] pathForResource:file ofType:@"png"];
    NSData *d = [NSData dataWithContentsOfFile:s];
    UIImage *img = [[UIImage alloc] initWithData:d];
    [dictionary setObject:img forKey:[NSNumber numberWithInt:icon]];
}

+ (UIImage *)getIcon:(Icon)icon
{
    return [_icons objectForKey:[NSNumber numberWithInt:icon]];
}

+ (UIImageView *)getIconView:(Icon)icon
{
    return [[UIImageView alloc] initWithImage:[self getIcon:icon]];
}

@end
