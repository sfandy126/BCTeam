//
//  BCCollectionViewCell.m
//  BcExamApp
//
//  Created by beichen on 2022/2/7.
//  Copyright © 2022 apple. All rights reserved.
//

#import "BCCollectionViewCell.h"

@implementation BCCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.contentView.backgroundColor = UIColor.whiteColor;
        [self setup];
    }
    return self;
}

- (void)setup{
    
}

@end
