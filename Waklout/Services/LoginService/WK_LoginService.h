//
//  LoginService.h
//  Waklout
//
//  Created by leejan97 on 15-7-19.
//  Copyright (c) 2015年 janlee. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "M16Services.h"

@interface WK_LoginService : M16Services

+ (void)savePassword:(NSString *)password account:(NSString *)account;

+ (void)deletePasswordForAccount:(NSString *)account;

+ (NSString *)passwordForAccount:(NSString *)account;

@end
