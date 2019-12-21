//
//  PlayTimeManager.h
//  Technical Test
//
//  Created by Anton Morozov on 23.12.2019.
//  Copyright © 2019 GPG. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface PlayTimeManager : NSObject

@property (nonatomic, readonly) NSTimeInterval playingTime;

-(void)start;
-(void)stop;
-(void)pause;
-(void)resume;

@end

NS_ASSUME_NONNULL_END
