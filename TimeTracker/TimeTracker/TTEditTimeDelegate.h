//
//  TTEditTimeDelegate.h
//  TimeTracker
//
//  Created by Jérémy Morosi on 20/03/2014.
//  Copyright (c) 2014 Jojeredamyn. All rights reserved.
//

#import <Foundation/Foundation.h>

@class TTTime;

@protocol TTEditTimeDelegate <NSObject>

- (void)onCancel;
- (void)onSave:(TTTime *)original :(TTTime *)modified;

@end
