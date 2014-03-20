//
//  TTEditTimeController.h
//  TimeTracker
//
//  Created by Jérémy Morosi on 20/03/2014.
//  Copyright (c) 2014 Jojeredamyn. All rights reserved.
//

#import <UIKit/UIKit.h>

@class TTTime;
@protocol TTEditTimeDelegate;

@interface TTEditTimeController : UIViewController <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, assign) id<TTEditTimeDelegate> delegate;
- (id)initWithTime:(TTTime *)time forTask:(int)task;

@end
