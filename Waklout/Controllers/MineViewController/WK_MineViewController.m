//
//  MineViewController.m
//  Waklout
//
//  Created by yoho on 15/7/8.
//  Copyright (c) 2015年 janlee. All rights reserved.
//

#import "WK_MineViewController.h"
#import "WK_FollowView.h"

@interface WK_MineViewController ()
@property (strong, nonatomic) UIView *topContentView;
@property (strong, nonatomic) WK_FollowView *focusView;
@property (strong, nonatomic) UIImageView *userIconImageView;
@property (strong, nonatomic) WK_FollowView *fansView;

@end

@implementation WK_MineViewController

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.title = NSLocalizedString(@"MINE", nil);
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor blueColor];
    [self setupTopContentView];
    
}

- (void)setupTopContentView
{
    self.topContentView = [[UIView alloc] init];
    self.topContentView.backgroundColor = [UIColor redColor];
    [self.view addSubview:self.topContentView];
    [self.view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left).offset(0);
        make.right.equalTo(self.view.mas_right).offset(0);
        make.top.equalTo(self.view.mas_top).offset(100);
        make.height.equalTo(@(60));
    }];
    
    self.focusView = [[WK_FollowView alloc] init];
    self.focusView.backgroundColor = [UIColor purpleColor];
    [self.topContentView addSubview:self.focusView];
    
    self.userIconImageView = [[UIImageView alloc] init];
    self.userIconImageView.backgroundColor = [UIColor cyanColor];
    [self.topContentView addSubview:self.userIconImageView];
    
    self.fansView = [[WK_FollowView alloc] init];
    self.fansView.backgroundColor = [UIColor brownColor];
    [self.topContentView addSubview:self.fansView];
    
    [self.userIconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view.mas_centerX);
        make.width.equalTo(@(45));
        make.centerY.equalTo(self.view.mas_centerY);
        make.height.equalTo(@(45));
    }];
    
    [self.focusView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.userIconImageView.mas_left).offset(-10);
        make.width.equalTo(@(30));
        make.centerY.equalTo(self.view.mas_centerY);
        make.height.equalTo(@(30));
    }];
    
    [self.fansView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.userIconImageView.mas_right).offset(10);
        make.width.equalTo(@(30));
        make.centerY.equalTo(self.view.mas_centerY);
        make.height.equalTo(@(30));
    }];
}

- (void)didReceiveMemoryWarning
{
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
