//
//  BlockMacros.h
//  Waklout
//
//  Created by yoho on 15/7/17.
//  Copyright (c) 2015年 janlee. All rights reserved.
//

#import "M16Model.h"

typedef void (^VoidBlock)(void);
typedef void (^StringBlock)(NSString *info, NSError *error);
typedef void (^BoolBlock)(BOOL flag, NSError *error);
typedef void (^ModelBlock)(M16Model *model, NSError *error);
typedef void (^ArrayBlock)(NSMutableArray *models, NSError *error);
typedef void (^DictionaryBlock)(NSMutableDictionary *infoDict, NSError *error);
typedef void (^IntegerBlock)(NSInteger index, NSError *error);
typedef void (^ErrorBlock)(NSError *error);
typedef void (^UserBlock)(AVUser *user, NSError *error);
