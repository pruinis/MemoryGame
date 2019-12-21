//
//  CardModel.h
//  Technical Test
//
//  Created by Anton Morozov on 22.12.2019.
//  Copyright © 2019 GPG. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@class CardCollectionViewCell;

NS_ASSUME_NONNULL_BEGIN

@interface CardModel : NSObject <NSCopying>

@property (nonatomic, assign) int number;
@property (nonatomic, assign) BOOL isFlipped;
@property (nonatomic, assign) BOOL isLocked;
@property (nonatomic, weak) CardCollectionViewCell *cell;

-(void)showTitle;
-(void)showBack;

@end

NS_ASSUME_NONNULL_END
