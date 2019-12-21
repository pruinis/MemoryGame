//
//  CardCollectionViewCell.m
//  Technical Test
//
//  Created by Anton Morozov on 22.12.2019.
//  Copyright © 2019 GPG. All rights reserved.
//

#import "CardCollectionViewCell.h"

@implementation CardCollectionViewCell

-(void)updateWithModel:(CardModel *)model {
    model.cell = self;
    self.model = model;
    
    if (model.isFlipped) {
        [self.model showTitle];
    }
    else {
        [self.model showBack];
    }
}

@end
