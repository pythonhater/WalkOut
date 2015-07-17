//
//  WK_LoginUIModel.m
//  Waklout
//
//  Created by yoho on 15/7/17.
//  Copyright (c) 2015年 janlee. All rights reserved.
//

#import "WK_LoginUIModel.h"

@implementation WK_LoginUIModel

- (instancetype)initWithLabelText:(NSString *)labelText textFieldText:(NSString *)textFieldText
{
    self = [super init];
    if (self) {
        self.labelText = labelText;
        self.textFieldText = textFieldText;
    }
    return self;
}

@end
