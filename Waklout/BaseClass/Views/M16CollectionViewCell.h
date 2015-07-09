//
//  M16CollectionViewCell.h
//  Yohoboys
//
//  Created by Zhou Rongjun on 14-9-24.
//  Copyright (c) 2014年 YOHO. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface M16CollectionViewCell : UICollectionViewCell

+ (NSString *)cellIdentifier;

+ (id)cellForCollectionView:(UICollectionView *)collectionView forIndexPath:(NSIndexPath *)indexPath;

//绑定ViewModel
- (void)bindViewModel:(id)viewModel atIndexPath:(NSIndexPath *)indexPath;

@end
