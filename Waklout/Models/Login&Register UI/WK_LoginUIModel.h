//
//  WK_LoginUIModel.h
//  Waklout
//
//  Created by yoho on 15/7/17.
//  Copyright (c) 2015年 janlee. All rights reserved.
//

#import "M16Model.h"

@interface WK_LoginUIModel : M16Model
@property (strong, nonatomic) NSString *labelText;
@property (strong, nonatomic) NSString *textFieldText;

- (instancetype)initWithLabelText:(NSString *)labelText textFieldText:(NSString *)textFieldText;

@end
