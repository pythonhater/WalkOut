//
//  M16CollectionViewCell.m
//  Yohoboys
//
//  Created by Zhou Rongjun on 14-9-24.
//  Copyright (c) 2014年 YOHO. All rights reserved.
//

#import "M16CollectionViewCell.h"

@implementation M16CollectionViewCell

+ (NSString *)cellIdentifier
{
    return NSStringFromClass([self class]);
}

+ (id)cellForCollectionView:(UICollectionView *)collectionView forIndexPath:(NSIndexPath *)indexPath
{
    return [collectionView dequeueReusableCellWithReuseIdentifier:[self cellIdentifier] forIndexPath:indexPath];
}


- (void)bindViewModel:(id)viewModel atIndexPath:(NSIndexPath *)indexPath
{
    
}

@end
