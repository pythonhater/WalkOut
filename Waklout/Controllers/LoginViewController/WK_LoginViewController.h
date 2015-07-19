//
//  WK_LoginViewController.h
//  Waklout
//
//  Created by yoho on 15/7/16.
//  Copyright (c) 2015年 janlee. All rights reserved.
//

#import "M16GroupedTableViewController.h"

@protocol WK_LoginViewControllerDelegate <NSObject>

- (void)walkoutAccountDidLoginSucceed;

@end

@interface WK_LoginViewController : M16GroupedTableViewController

@property (assign, nonatomic) id<WK_LoginViewControllerDelegate> delegate;

@end
