//
//  GameDirector.h
//  Technical Test
//
//  Created by Anton Morozov on 22.12.2019.
//  Copyright © 2019 GPG. All rights reserved.
//

@import Foundation;
@class CardModel;

typedef void (^CompletionBlock)(void);
typedef void (^CompletionTimeBlock)(NSTimeInterval);

NS_ASSUME_NONNULL_BEGIN

@interface GameDirector : NSObject

@property (nonatomic, readonly) int pairNumber;
@property (nonatomic, readonly) NSArray *cards;
@property (nonatomic, readonly) NSTimeInterval playingTime;
@property (nonatomic, assign) BOOL undoButtonIsHidden;

@property (nonatomic, copy, nullable) CompletionTimeBlock gameFinishedHandler;
@property (nonatomic, copy, nullable) CompletionBlock startGameHandler;
@property (nonatomic, copy, nullable) CompletionBlock stopGameHandler;

-(void)startNewGame;

-(int)boardSizeMin;
-(int)boardSizeMax;
-(void)setBoardSize:(int)boardSize;

-(void)cardWasTapped:(CardModel *)card;

-(void)pause;
-(void)resume;
-(void)stop;

-(void)undoLastStep;

@end

NS_ASSUME_NONNULL_END
