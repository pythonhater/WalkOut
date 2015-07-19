//
//  ResigerViewController.m
//  Waklout
//
//  Created by leejan97 on 15-7-19.
//  Copyright (c) 2015年 janlee. All rights reserved.
//

#import "WK_RegisterViewController.h"

static CGFloat const kRegisterButtonLeftEdge = 20.0f;
static CGFloat const kRegisterButtonHeight = 38.0f;
static CGFloat const kRegisterButtonRightEdge = 20.0f;

@interface WK_RegisterViewController ()
@property (strong, nonatomic) UIButton *backButton;

@property (strong, nonatomic) UIButton *registerButton;

@property (strong, nonatomic) UITextField *emailTextField;
@property (strong, nonatomic) UITextField *passwordTextField;
@property (strong, nonatomic) UITextField *confirmPwdTextField;

@end

@implementation WK_RegisterViewController

- (void)setupLeftButton
{
    self.backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.backButton.exclusiveTouch = YES;
    self.backButton.frame = CGRectMake(0, 0, NAVIGATION_BAR_HEIGHT, NAVIGATION_BAR_HEIGHT);
    [self.backButton setImage:[UIImage imageNamed:@"back"] forState:UIControlStateNormal];
    [self.backButton setImage:[UIImage imageNamed:@"back"] forState:UIControlStateHighlighted];
    [self.backButton addTarget:self action:@selector(backButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *negativeSeperatorItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    negativeSeperatorItem.width = iOS7_OR_LATER? -10:0;
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithCustomView:self.backButton];
    
    self.navigationItem.leftBarButtonItems = @[negativeSeperatorItem, leftItem];
}

- (void)backButtonClicked
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)setupNaviBarTitleView
{
    
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.registerButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.registerButton setTitle:NSLocalizedString(@"WK_Register", nil) forState:UIControlStateNormal];
    [self.registerButton addTarget:self action:@selector(registerButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    self.registerButton.backgroundColor = [UIColor lightGrayColor];
    [self.footerContentView addSubview:self.registerButton];
    
    [self.registerButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.footerContentView.mas_left).offset(kRegisterButtonLeftEdge);
        make.right.equalTo(self.footerContentView.mas_right).offset(-kRegisterButtonRightEdge);
        make.centerY.equalTo(self.footerContentView.mas_centerY);
        make.height.equalTo(@(kRegisterButtonHeight));
    }];
}

- (void)registerButtonClicked:(id)sender
{
    NSString *email = self.emailTextField.text;
    NSString *username = @"littlelion";
    NSString *password = self.passwordTextField.text;
    [self.loginViewModel signupWithEmail:email username:username password:password completionBlock:^(BOOL flag, NSError *error) {
        if (flag) {
            
        }
    }];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    WK_LoginTableViewCell *cell = (WK_LoginTableViewCell *)[super tableView:tableView cellForRowAtIndexPath:indexPath];
    if (indexPath.row == 0) {
        self.emailTextField = cell.textField;
    } else if (indexPath.row == 1) {
        self.passwordTextField = cell.textField;
    } else if (indexPath.row == 2) {
        self.confirmPwdTextField = cell.textField;
    }
    return cell;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
