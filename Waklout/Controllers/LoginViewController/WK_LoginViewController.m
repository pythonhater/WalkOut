//
//  WK_LoginViewController.m
//  Waklout
//
//  Created by yoho on 15/7/16.
//  Copyright (c) 2015年 janlee. All rights reserved.
//

#import "WK_LoginViewController.h"
#import "WK_RegisterViewController.h"

static CGFloat const kLoginButtonLeftEdge = 10.0f;
static CGFloat const kLoginButtonWidth = 100.0f;
static CGFloat const kLoginButtonHeight = 38.0f;

static CGFloat const kWechatButtonLeftEdge = 10.0f;
static CGFloat const kWechatButtonRightEdge = 10.0f;
static CGFloat const kWechatButtonHeight = 38.0f;

@interface WK_LoginViewController ()
@property (strong, nonatomic) UIButton *closeButton;
@property (strong, nonatomic) UIButton *registerButton;

@property (strong, nonatomic) UIButton *loginButton;
@property (strong, nonatomic) UIButton *wechatButton;

@property (strong, nonatomic) WK_RegisterViewController *registerViewController;
@end

@interface WK_LoginViewController ()
/*以下两个TextField是为了获取用户输入的登陆信息*/
@property (strong, nonatomic) UITextField *emailTextField;
@property (strong, nonatomic) UITextField *passwordTextField;

@end

@implementation WK_LoginViewController

- (void)setupLeftButton
{
    self.closeButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.closeButton.exclusiveTouch = YES;
    self.closeButton.frame = CGRectMake(0, 0, NAVIGATION_BAR_HEIGHT, NAVIGATION_BAR_HEIGHT);
    [self.closeButton setImage:[UIImage imageNamed:@"close"] forState:UIControlStateNormal];
    [self.closeButton setImage:[UIImage imageNamed:@"close"] forState:UIControlStateHighlighted];
    [self.closeButton addTarget:self action:@selector(closeButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *negativeSeperatorItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    negativeSeperatorItem.width = iOS7_OR_LATER? -10:0;
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithCustomView:self.closeButton];
    
    self.navigationItem.leftBarButtonItems = @[negativeSeperatorItem, leftItem];
}

- (void)closeButtonClicked:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)setupNaviBarTitleView
{
    
}

- (void)setupRightButton
{
    self.registerButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.registerButton.exclusiveTouch = YES;
    self.registerButton.frame = CGRectMake(0, 0, NAVIGATION_BAR_HEIGHT, NAVIGATION_BAR_HEIGHT);
    [self.registerButton setImage:[UIImage imageNamed:@"adduser"] forState:UIControlStateNormal];
    [self.registerButton setImage:[UIImage imageNamed:@"adduser"] forState:UIControlStateHighlighted];
    [self.registerButton addTarget:self action:@selector(registerButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:self.registerButton];
}

- (void)registerButtonClicked
{
    if (!self.registerViewController) {
        WK_LoginViewModel *loginViewModel = [[WK_LoginViewModel alloc] initWithUserActionType:WK_UserActionTypeRegister];
        self.registerViewController = [[WK_RegisterViewController alloc] initWithViewModel:loginViewModel];
    }
    [self.navigationController pushViewController:self.registerViewController animated:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.loginButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.loginButton setTitle:NSLocalizedString(@"WK_Login", nil) forState:UIControlStateNormal];
    [self.loginButton addTarget:self action:@selector(loginButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    self.loginButton.backgroundColor = [UIColor lightGrayColor];
    [self.footerContentView addSubview:self.loginButton];
    
    self.wechatButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.wechatButton setTitle:NSLocalizedString(@"WK_WechatLogin", nil) forState:UIControlStateNormal];
    self.wechatButton.backgroundColor = [UIColor lightGrayColor];
    [self.footerContentView addSubview:self.wechatButton];
    
    [self.loginButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.footerContentView.mas_left).offset(kLoginButtonLeftEdge);
        make.width.equalTo(@(kLoginButtonWidth));
        make.centerY.equalTo(self.footerContentView.mas_centerY);
        make.height.equalTo(@(kLoginButtonHeight));
    }];
    
    [self.wechatButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.loginButton.mas_right).offset(kWechatButtonLeftEdge);
        make.right.equalTo(self.footerContentView.mas_right).offset(-kWechatButtonRightEdge);
        make.centerY.equalTo(self.footerContentView.mas_centerY);
        make.height.equalTo(@(kWechatButtonHeight));
    }];
}

- (void)loginButtonClicked
{
    NSString *email = self.emailTextField.text;
    NSString *password = self.passwordTextField.text;
    __weak typeof(self) weakSelf = self;
    [self.loginViewModel loginWithEmail:email password:password completionBlock:^(AVUser *user, NSError *error) {
        __strong typeof(weakSelf) strongSelf = weakSelf;
        if (user) {
            [strongSelf dismissViewControllerAnimated:YES completion:nil];
        }
        
        if (error) {
            NSLog(@"login error %@",error);
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
    }
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
