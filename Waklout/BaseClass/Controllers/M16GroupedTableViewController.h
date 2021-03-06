//
//  M16GroupedTableViewController.h
//  Waklout
//
//  Created by yoho on 15/7/17.
//  Copyright (c) 2015年 janlee. All rights reserved.
//

#import "M16ViewController.h"
#import "WK_LoginViewModel.h"
#import "WK_LoginTableViewCell.h"

@interface M16GroupedTableViewController : M16ViewController <UITableViewDelegate, UITableViewDataSource>
@property (strong, nonatomic) WK_LoginViewModel *loginViewModel;
@property (strong, nonatomic) UITableView *tableView;
@property (strong, nonatomic) UIView *footerContentView;

- (instancetype)initWithViewModel:(WK_LoginViewModel *)viewModel;

@end
