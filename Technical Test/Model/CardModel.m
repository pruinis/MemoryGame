//
//  CardModel.m
//  Technical Test
//
//  Created by Anton Morozov on 22.12.2019.
//  Copyright © 2019 GPG. All rights reserved.
//

#import "CardModel.h"
#import "CardCollectionViewCell.h"

@implementation CardModel 

- (instancetype)init {
    self = [super init];
    if (self) {
        self.isFlipped = NO;
        self.isLocked = NO;
        self.number = 0;
    }
    return self;
}

- (void)showTitle {
    self.cell.label.text = [NSString stringWithFormat:@"%d", self.number];
}

-(void)showBack {
    self.cell.label.text = @"X";
}

- (BOOL)isEqual:(id)other
{
    if (other == self) {
        return YES;
    } else if (![super isEqual:other]) {
        return NO;
    } else {
        CardModel *second = (CardModel*)other;        
        return self.number == second.number;
    }
}

// MARK: - NSCopying

- (nonnull id)copyWithZone:(nullable NSZone *)zone {
    CardModel *copy = [[CardModel allocWithZone: zone] init];
    copy.cell = self.cell;
    copy.isFlipped = copy.isFlipped;
    copy.isLocked = self.isLocked;
    copy.number = self.number;
    return copy;
}

@end
