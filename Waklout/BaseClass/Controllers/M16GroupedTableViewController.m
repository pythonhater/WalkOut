//
//  M16GroupedTableViewController.m
//  Waklout
//
//  Created by yoho on 15/7/17.
//  Copyright (c) 2015年 janlee. All rights reserved.
//

#import "M16GroupedTableViewController.h"

static CGFloat const kFooterContentViewHeight = 40.0f;
static CGFloat const kLoginTableViewCellHeight = 44.0f;

@interface M16GroupedTableViewController ()

@end

@implementation M16GroupedTableViewController

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.push = YES;
    }
    return self;
}

- (instancetype)initWithViewModel:(WK_LoginViewModel *)viewModel
{
    self = [super init];
    if (self) {
        self.push = YES;
        self.loginViewModel = viewModel;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.frame), CGRectGetHeight(self.view.frame)) style:UITableViewStyleGrouped];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.view addSubview:self.tableView];
    
    self.footerContentView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.frame), kFooterContentViewHeight)];
    self.tableView.tableFooterView = self.footerContentView;
    
    [self.loginViewModel loadBaseInfoForUI];
}

#pragma mark - UITableViewDelegate
#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return kLoginTableViewCellHeight;
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.loginViewModel cellsCount];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    WK_LoginTableViewCell *cell = [WK_LoginTableViewCell cellForTableView:tableView];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    [cell bindViewModel:self.loginViewModel atIndexPath:indexPath];
    return cell;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
