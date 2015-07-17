//
//  WK_LoginViewModel.h
//  Waklout
//
//  Created by yoho on 15/7/17.
//  Copyright (c) 2015年 janlee. All rights reserved.
//

#import "M16ViewModel.h"

@interface WK_LoginViewModel : M16ViewModel

- (instancetype)initWithUserActionType:(WK_UserActionType)userActionType;

- (void)loadBaseInfoForUI;

//输出-output
- (NSString *)labelText:(NSInteger)index;

- (NSString *)textFieldText:(NSInteger)index;

@end
