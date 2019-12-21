//
//  PlayTimeManager.m
//  Technical Test
//
//  Created by Anton Morozov on 23.12.2019.
//  Copyright © 2019 GPG. All rights reserved.
//

#import "PlayTimeManager.h"

@interface PlayTimeManager ()

@property (nonatomic, strong) NSDate *timerStartDate;
@property (nonatomic, strong) NSDate *timerPauseDate;

@end

@implementation PlayTimeManager

- (instancetype)init {
    self = [super init];
    if (self) {
        self.timerStartDate = nil;
        self.timerPauseDate = nil;
    }
    return self;
}

-(void)start {
    self.timerStartDate = [NSDate date];
    self.timerPauseDate = nil;
}

-(void)stop {
    self.timerStartDate = nil;
    self.timerPauseDate = nil;
}

-(NSTimeInterval)playingTime {
    NSTimeInterval timeInterval = 0;
    NSDate *currentDate = [NSDate date];

    if (self.timerPauseDate) {
        currentDate = self.timerPauseDate;
    }    
    
    if (self.timerStartDate) {
        timeInterval = [currentDate timeIntervalSinceDate:self.timerStartDate];
    }
    return timeInterval;
}

-(void)pause {
    self.timerPauseDate = [NSDate date];
}

-(void)resume {
    if (!self.timerPauseDate || !self.timerStartDate) {
        return;
    }
        
    NSDate *currentDate = [NSDate date];
    NSTimeInterval timeInterval = [currentDate timeIntervalSinceDate:self.timerPauseDate];
    self.timerStartDate = [self.timerStartDate dateByAddingTimeInterval:timeInterval];
    self.timerPauseDate = nil;
}

@end
