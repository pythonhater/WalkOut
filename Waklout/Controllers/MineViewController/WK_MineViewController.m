//
//  MineViewController.m
//  Waklout
//
//  Created by yoho on 15/7/8.
//  Copyright (c) 2015年 janlee. All rights reserved.
//

#import "WK_MineViewController.h"
#import "WK_FollowView.h"
#import "WK_LocalNotesViewController.h"
#import "WK_PublishedNotesViewController.h"
#import "WK_CollectedNotesViewController.h"

static CGFloat const kTopContentViewHeight = 60.0f;
static CGFloat const kUserIconImageViewWidth = 45.0f;
static CGFloat const kUserIconImageViewHeight = 45.0f;
static CGFloat const kFocusViewRightEdge = 10.0f;
static CGFloat const kFocusViewWidth = 30.0f;
static CGFloat const kFocusViewHeight = 30.0f;
static CGFloat const kFansViewLeftEdge = 10.0f;
static CGFloat const kFansViewWidth = 30.0f;
static CGFloat const kFansViewHeight = 30.0f;

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
    [self setupTopContentView];
    

}

- (void)setupTopContentView
{
    self.topContentView = [[UIView alloc] init];
    self.topContentView.backgroundColor = [UIColor redColor];
    [self.view addSubview:self.topContentView];
    [self.topContentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left).offset(0);
        make.right.equalTo(self.view.mas_right).offset(0);
        make.top.equalTo(self.view.mas_top).offset(0);
        make.height.equalTo(@(kTopContentViewHeight));
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
        make.centerX.equalTo(self.topContentView.mas_centerX);
        make.width.equalTo(@(kUserIconImageViewWidth));
        make.centerY.equalTo(self.topContentView.mas_centerY);
        make.height.equalTo(@(kUserIconImageViewHeight));
    }];
    
    [self.focusView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.userIconImageView.mas_left).offset(-kFocusViewRightEdge);
        make.width.equalTo(@(kFocusViewWidth));
        make.centerY.equalTo(self.topContentView.mas_centerY);
        make.height.equalTo(@(kFocusViewHeight));
    }];
    
    [self.fansView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.userIconImageView.mas_right).offset(kFansViewLeftEdge);
        make.width.equalTo(@(kFansViewWidth));
        make.centerY.equalTo(self.topContentView.mas_centerY);
        make.height.equalTo(@(kFansViewHeight));
    }];
}

#pragma mark - PageContainerViewControllerDataSource
-(NSArray *)childViewControllersForPagerTabStripViewController:(XLPagerTabStripViewController *)pagerTabStripViewController
{
    WK_LocalNotesViewController *localNotesViewController = [[WK_LocalNotesViewController alloc] init];
    WK_PublishedNotesViewController *publishedNotesViewController = [[WK_PublishedNotesViewController alloc] init];
    WK_CollectedNotesViewController *collectedNotesViewController = [[WK_CollectedNotesViewController alloc] init];
    return @[localNotesViewController, publishedNotesViewController, collectedNotesViewController];
}

- (void)moveToViewControllerAtIndex:(NSUInteger)index
{
    //点击频道名称切换
    [super moveToViewControllerAtIndex:index];
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
