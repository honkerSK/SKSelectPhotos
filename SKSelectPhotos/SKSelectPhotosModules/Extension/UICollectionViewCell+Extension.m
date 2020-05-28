//
//  UICollectionViewCell+Extension.m
//  xiangwan
//
//  Created by mac on 2019/8/17.
//  Copyright © 2019 mac. All rights reserved.
//

#import "UICollectionViewCell+Extension.h"

@implementation UICollectionViewCell (Extension)

+ (void)registerClassForCollectionView:(UICollectionView *)collectionView {
    [collectionView registerClass:self forCellWithReuseIdentifier:[self identifier]];
}
+ (void)registerNibForCollectionView:(UICollectionView *)collectionView {
    [collectionView registerNib:[UINib nibWithNibName:[self className]
                                               bundle:[NSBundle mainBundle]] forCellWithReuseIdentifier:[self identifier]];
}
+ (NSString *)identifier {
    return [NSString stringWithFormat:@"%@Id",[self className]];
}

@end
