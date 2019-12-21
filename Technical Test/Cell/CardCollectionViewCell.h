//
//  CardCollectionViewCell.h
//  Technical Test
//
//  Created by Anton Morozov on 22.12.2019.
//  Copyright © 2019 GPG. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CardModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface CardCollectionViewCell : UICollectionViewCell

@property (weak, nonatomic) IBOutlet UILabel *label;
@property (nonatomic, weak) CardModel *model;

-(void)updateWithModel:(CardModel *)model;

@end

NS_ASSUME_NONNULL_END
