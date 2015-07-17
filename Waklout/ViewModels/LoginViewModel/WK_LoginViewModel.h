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
- (void)signupWithEmail:(NSString *)email username:(NSString *)uname password:(NSString *)pwd completionBlock:(BoolBlock)block;
- (void)loginWithEmail:(NSString *)email password:(NSString *)pwd completionBlock:(UserBlock)block;

//输出-output
- (NSInteger)count;
- (NSString *)labelText:(NSInteger)index;
- (NSString *)textFieldText:(NSInteger)index;

@end
