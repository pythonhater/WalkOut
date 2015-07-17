//
//  WK_LoginViewModel.m
//  Waklout
//
//  Created by yoho on 15/7/17.
//  Copyright (c) 2015年 janlee. All rights reserved.
//

#import "WK_LoginViewModel.h"
#import "WK_LoginUIModel.h"

@interface WK_LoginViewModel ()
@property (assign, nonatomic) WK_UserActionType userActionType;
@property (strong, nonatomic) NSArray *uiInfos;
@property (strong, nonatomic) WK_LoginUIModel *emailUIModel;
@property (strong, nonatomic) WK_LoginUIModel *passwordUIModel;
@property (strong, nonatomic) WK_LoginUIModel *confirmPwdUIModel;

@end

@implementation WK_LoginViewModel

- (instancetype)initWithUserActionType:(WK_UserActionType)userActionType
{
    self = [super init];
    if (self) {
        self.userActionType = userActionType;
        self.emailUIModel = [[WK_LoginUIModel alloc] initWithLabelText:NSLocalizedString(@"WK_Email", nil) textFieldText:NSLocalizedString(@"WK_InputEmail", nil)];
        self.passwordUIModel = [[WK_LoginUIModel alloc] initWithLabelText:NSLocalizedString(@"WK_Password", nil) textFieldText:NSLocalizedString(@"WK_InputPassword", nil)];
        self.confirmPwdUIModel = [[WK_LoginUIModel alloc] initWithLabelText:NSLocalizedString(@"WK_Confirm", nil) textFieldText:NSLocalizedString(@"WK_ConfirmPassword", nil)];
        
    }
    return self;
}

- (void)loadBaseInfoForUI
{
    if (self.userActionType == WK_UserActionTypeRegister) {
        
        self.uiInfos = @[self.emailUIModel, self.passwordUIModel, self.confirmPwdUIModel];
        
    } else if (self.userActionType == WK_UserActionTypeLogin) {
        
        self.uiInfos = @[self.emailUIModel, self.passwordUIModel];
        
    }
}

- (void)signupWithEmail:(NSString *)email username:(NSString *)uname password:(NSString *)pwd completionBlock:(BoolBlock)block
{
    AVUser *user = [AVUser user];
    user.email = email;
    user.password = pwd;
    [user setObject:uname forKey:@"username"];
    [user signUpInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (block) {
            block(succeeded, error);
        }
    }];
}

- (void)loginWithEmail:(NSString *)email password:(NSString *)pwd completionBlock:(UserBlock)block
{
    [AVUser logInWithUsernameInBackground:email password:pwd block:^(AVUser *user, NSError *error) {
        if (block) {
            block(user, error);
        }
    }];
}

//--output
- (NSInteger)count
{
    return [self.uiInfos count];
}

- (NSString *)labelText:(NSInteger)index
{
    return [(WK_LoginUIModel *)[self.uiInfos objectAtIndex:index] labelText];
}

- (NSString *)textFieldText:(NSInteger)index
{
    return [(WK_LoginUIModel *)[self.uiInfos objectAtIndex:index] textFieldText];
}

@end
