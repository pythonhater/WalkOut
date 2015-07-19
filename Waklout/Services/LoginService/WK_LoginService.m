//
//  LoginService.m
//  Waklout
//
//  Created by leejan97 on 15-7-19.
//  Copyright (c) 2015年 janlee. All rights reserved.
//

#import "WK_LoginService.h"
#import "SSKeychain.h"

static NSString * const WK_WakloutKeyChainServiceKey = @"WK_WakloutKeyChainServiceKey";

@implementation WK_LoginService

+ (void)savePassword:(NSString *)password account:(NSString *)account
{
    [SSKeychain setPassword:password forService:WK_WakloutKeyChainServiceKey account:account];
}

+ (void)deletePasswordForAccount:(NSString *)account
{
    [SSKeychain deletePasswordForService:WK_WakloutKeyChainServiceKey account:account];
}

+ (NSString *)passwordForAccount:(NSString *)account
{
    return [SSKeychain passwordForService:WK_WakloutKeyChainServiceKey account:account];
}

@end
