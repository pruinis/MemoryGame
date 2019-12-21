//
//  GameDirector.m
//  Technical Test
//
//  Created by Anton Morozov on 22.12.2019.
//  Copyright © 2019 GPG. All rights reserved.
//

#import "GameDirector.h"
#import "CardModel.h"
#import "CardCollectionViewCell.h"
#import "PlayTimeManager.h"

@interface GameDirector()

@property (nonatomic, assign) int pairNumber;
@property (nonatomic, strong) NSArray *cards;

// Private
@property (nonatomic, weak) CardModel *card1;
@property (nonatomic, weak) CardModel *card2;
@property (nonatomic, assign) BOOL isSecondCard;
@property (nonatomic, strong) NSMutableArray *stepsArray;
@property (nonatomic, strong) PlayTimeManager *playTimeManager;

@end

@implementation GameDirector

- (instancetype)init {
    self = [super init];
    if (self) {
        self.undoButtonIsHidden = YES;
        self.pairNumber = self.boardSizeMin;
        self.stepsArray = [NSMutableArray array];
        self.playTimeManager = [PlayTimeManager new];
        [self populateCards];
    }
    return self;
}

-(void)startNewGame {
    dispatch_async(dispatch_get_main_queue(), ^{
        [self populateCards];
        [self.playTimeManager start];
        self.startGameHandler ? self.startGameHandler() : nil;
    });
}

-(int)boardSizeMin {
    return 2;
}

-(int)boardSizeMax {
    return 6;
}

-(void)setBoardSize:(int)boardSize {
    if (boardSize <= self.boardSizeMin) {
        boardSize = self.boardSizeMin;
    }
    else if (boardSize >= self.boardSizeMax) {
        boardSize = self.boardSizeMax;
    }
    
    if (boardSize != self.pairNumber) {
        self.pairNumber = boardSize;
        [self populateCards];
    }
}

-(void)cardWasTapped:(CardModel *)card {
    if (!card.isFlipped && !card.isLocked){
        [self showCard:card];
    }    
}

-(void)pause {
    [self.playTimeManager pause];
}

-(void)resume {
    [self.playTimeManager resume];
}

-(void)stop {
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.playTimeManager stop];
        [self populateCards];
        self.stopGameHandler ? self.stopGameHandler() : nil;
    });
}

-(NSTimeInterval)playingTime {
    return self.playTimeManager.playingTime;
}

-(void)undoLastStep {
    if (self.stepsArray.count) {
        NSArray *last = [self.stepsArray lastObject];
        [self.stepsArray removeObject:last];
        for (CardModel *card in last) {
            // do stuff...
            card.isFlipped = NO;
            card.isLocked = YES;
            
            [UIView animateWithDuration:0.8 animations:^{
                [UIView setAnimationTransition:UIViewAnimationTransitionFlipFromLeft forView:card.cell.contentView cache:YES];
                [card showBack];
            }];
        }
    }
}


// MARK: - Private

- (void)showCard:(CardModel *)card {
    [UIView animateWithDuration:0.8 animations:^{
        [UIView setAnimationTransition:UIViewAnimationTransitionFlipFromLeft forView:card.cell.contentView cache:YES];
        [card showTitle];
    } completion:^(BOOL finished) {
        if(finished == YES){
            if(!self.isSecondCard){
                self.card1 = card;
                self.isSecondCard = YES;
            }else{
                self.card2 = card;
                if (self.card1.number == self.card2.number) {
                    self.card1.isLocked = YES;
                    self.card2.isLocked = YES;
                    [self.stepsArray addObject: @[self.card1, self.card2]];
                    if([self didCompleteGame]){
                        [self notifyGameCompleted];
                    }
                }else{
                    [self hideCard:self.card1];
                    [self hideCard:self.card2];
                }
                self.isSecondCard = NO;
            }
        }
    }];
    
    card.isFlipped = !card.isFlipped;
}

- (void)hideCard:(CardModel *)card {
    [UIView animateWithDuration:0.8 animations:^{
        [UIView setAnimationTransition:UIViewAnimationTransitionFlipFromLeft forView:card.cell.contentView cache:YES];
        [card showBack];
    } completion:^(BOOL finished) {
        if(finished == YES){
            // NSLog(@"DONE");
        }
    }];
    
    card.isFlipped = !card.isFlipped;
}

- (BOOL)didCompleteGame {
    for (CardModel *card in self.cards) {
        if(!card.isLocked){
            return NO;
        }
    }
    return YES;
}

-(void)notifyGameCompleted {
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.stepsArray removeAllObjects];
        NSTimeInterval timeInterval = self.playTimeManager.playingTime;
        [self.playTimeManager stop];
        self.gameFinishedHandler ? self.gameFinishedHandler(timeInterval) : nil;
    });
}

-(void)shuffleArray:(NSMutableArray *)array {
    for (NSUInteger i = array.count; i > 1; i--) {
        [array exchangeObjectAtIndex:i - 1 withObjectAtIndex:arc4random_uniform((u_int32_t)i)];
    }
}

-(void)populateCards {
    NSMutableArray *arr = [NSMutableArray array];
    for (int i = 0; i < self.pairNumber * self.pairNumber / 2; i++) {
        CardModel *card = [CardModel new];
        card.number = i;
        [arr addObject:card];
        [arr addObject:card.copy];
    }
    [self shuffleArray:arr];
    self.cards = arr;
}

@end
