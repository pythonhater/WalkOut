//
//  MineViewController.m
//  Waklout
//
//  Created by yoho on 15/7/8.
//  Copyright (c) 2015年 janlee. All rights reserved.
//

#import "WK_MineViewController.h"
#import "WK_FollowView.h"
#import "XLButtonBarViewCell.h"
#import "WK_RecordlNotesViewController.h"
#import "WK_PublishedNotesViewController.h"
#import "WK_CollectedNotesViewController.h"
#import "WK_LoginViewModel.h"
#import "WK_LoginViewController.h"
#import "WK_NavigationController.h"

static CGFloat const kTopContentViewHeight = 60.0f;
static CGFloat const kUserIconImageViewWidth = 45.0f;
static CGFloat const kUserIconImageViewHeight = 45.0f;
static CGFloat const kFocusViewRightEdge = 10.0f;
static CGFloat const kFocusViewWidth = 30.0f;
static CGFloat const kFocusViewHeight = 30.0f;
static CGFloat const kFansViewLeftEdge = 10.0f;
static CGFloat const kFansViewWidth = 30.0f;
static CGFloat const kFansViewHeight = 30.0f;

@interface WK_MineViewController () <WK_LoginViewControllerDelegate>
@property (strong, nonatomic) UIView *topContentView;
@property (strong, nonatomic) WK_FollowView *focusView;
@property (strong, nonatomic) UIImageView *userIconImageView;
@property (strong, nonatomic) WK_FollowView *fansView;

@property (strong, nonatomic) WK_NavigationController *loginNavigationController;
@end

@implementation WK_MineViewController

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.title = NSLocalizedString(@"LOCAL_MINE", nil);
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setupTopContentView];
    
    self.buttonBarView.frame = CGRectMake(0, CGRectGetMaxY(self.topContentView.frame), SCREEN_WIDTH, kXLBUttonBarViewCellHeight);
    self.buttonBarView.backgroundColor = [UIColor m16_colorwithHexString:@"#F5F5F5"];
    [self.buttonBarView registerClass:[XLButtonBarViewCell class] forCellWithReuseIdentifier:@"Cell"];
    
    CGFloat leftInset = (SCREEN_WIDTH - kXLBUttonBarViewCellWidth * 3) / 2.0;
    CGFloat rightInset = (SCREEN_WIDTH - kXLBUttonBarViewCellWidth * 3) / 2.0;
    UICollectionViewFlowLayout *flowLayout = (UICollectionViewFlowLayout *)self.buttonBarView.collectionViewLayout;
    flowLayout.sectionInset = UIEdgeInsetsMake(0, leftInset, 0, rightInset);
    flowLayout.minimumLineSpacing = 0;
    flowLayout.minimumInteritemSpacing = 0;
    
    self.containerView.bounces = YES;
    self.containerView.frame = CGRectMake(0, CGRectGetMaxY(self.buttonBarView.frame), SCREEN_WIDTH, CGRectGetHeight(self.view.frame) - kTopContentViewHeight - kXLBUttonBarViewCellHeight);
    
    [self reloadPagerTabStripView];
    [self selectFirstItemAutomatically];
}

- (void)setupTopContentView
{
    self.topContentView = [[UIView alloc] init];
    self.topContentView.backgroundColor = [UIColor clearColor];
    self.topContentView.frame = CGRectMake(0, 0, SCREEN_WIDTH, kTopContentViewHeight);
    [self.view addSubview:self.topContentView];
    
    self.focusView = [[WK_FollowView alloc] init];
    self.focusView.backgroundColor = [UIColor purpleColor];
    [self.topContentView addSubview:self.focusView];
    
    self.userIconImageView = [[UIImageView alloc] init];
    self.userIconImageView.backgroundColor = [UIColor cyanColor];
    self.userIconImageView.userInteractionEnabled = YES;
    [self.topContentView addSubview:self.userIconImageView];
    
    UITapGestureRecognizer *userIconTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapUserIconHandler:)];
    [self.userIconImageView addGestureRecognizer:userIconTap];
    
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

- (void)tapUserIconHandler:(UIGestureRecognizer *)gesture
{
    if (!self.loginNavigationController) {
        WK_LoginViewModel *loginViewModel = [[WK_LoginViewModel alloc] initWithUserActionType:WK_UserActionTypeLogin];
        WK_LoginViewController *loginViewController = [[WK_LoginViewController alloc] initWithViewModel:loginViewModel];
        loginViewController.delegate = self;
        self.loginNavigationController = [[WK_NavigationController alloc] initWithRootViewController:loginViewController];
        self.loginNavigationController.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
    }
    [self presentViewController:self.loginNavigationController animated:YES completion:nil];
}

- (void)selectFirstItemAutomatically
{
    NSIndexPath *firstItemIndexPath = [NSIndexPath indexPathForItem:0 inSection:0];
    [self.buttonBarView selectItemAtIndexPath:firstItemIndexPath animated:NO scrollPosition:UICollectionViewScrollPositionNone];
}

#pragma mark - UICollectionViewFlowLayout
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(kXLBUttonBarViewCellWidth, kXLBUttonBarViewCellHeight);
}


#pragma mark - PageContainerViewControllerDataSource
- (NSArray *)childViewControllersForPagerTabStripViewController:(XLPagerTabStripViewController *)pagerTabStripViewController
{
    WK_RecordlNotesViewController *recordNotedViewController = [[WK_RecordlNotesViewController alloc] init];
    WK_PublishedNotesViewController *publishedNotesViewController = [[WK_PublishedNotesViewController alloc] init];
    WK_CollectedNotesViewController *collectedNotesViewController = [[WK_CollectedNotesViewController alloc] init];
    return @[recordNotedViewController, publishedNotesViewController, collectedNotesViewController];
}


- (void)pagerTabStripViewController:(XLPagerTabStripViewController *)pagerTabStripViewController
          updateIndicatorFromIndex:(NSInteger)fromIndex
                           toIndex:(NSInteger)toIndex
{
    
    [super pagerTabStripViewController:pagerTabStripViewController updateIndicatorFromIndex:fromIndex toIndex:toIndex];
    
    //滑动切换
    if (self.shouldUpdateButtonBarView) {
        [self updateBarStatus:toIndex];
    }
}

- (void)moveToViewControllerAtIndex:(NSUInteger)index
{
    //点击频道名称切换
    [super moveToViewControllerAtIndex:index];
}

#pragma mark - WK_LoginViewControllerDelegate
- (void)walkoutAccountDidLoginSucceed
{
    
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
