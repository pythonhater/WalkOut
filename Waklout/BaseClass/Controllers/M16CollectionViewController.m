//
//  M16CollectionViewController.m
//  M16
//

#import "M16CollectionViewController.h"

@interface M16CollectionViewController ()

@end

@implementation M16CollectionViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(languageChanged:) name:kNotificationLanguageChanged object:nil];

    self.view.backgroundColor = [UIColor whiteColor];
    
    // collectionView init
	UICollectionViewFlowLayout *collectionViewFlowLayout = [[UICollectionViewFlowLayout alloc] init];
	[collectionViewFlowLayout setScrollDirection:UICollectionViewScrollDirectionVertical];
	self.collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, CONTENT_HEIGHT) collectionViewLayout:collectionViewFlowLayout];
    self.collectionView.height = self.view.height;
    self.collectionView.autoresizingMask = UIViewAutoresizingFlexibleHeight;
    self.collectionView.backgroundColor = [UIColor whiteColor];
    
    //Enable pull to refresh if the scroll view content height is less than the frame height
    self.collectionView.alwaysBounceVertical = YES;
    self.collectionView.dataSource = self;
    self.collectionView.delegate = self;
    
    [self.view addSubview:self.collectionView];
    
    __weak typeof(self) weakSelf = self;
    if ([self isNeedPullToRefresh]){
        // setup pull-to-refresh
        [self.collectionView addPullToRefreshWithActionHandler:^{
            __strong typeof(self) strongSelf = weakSelf;
            [strongSelf requestRefreshData];
        }];
        
    }
    
    if ([self isNeedInfiniteScrolling]){
        // setup infinite scrolling
        [self.collectionView addInfiniteScrollingWithActionHandler:^{
            __strong typeof(self) strongSelf = weakSelf;
            [strongSelf requestInfiniteData];
        }];
    }
    
    // Just call this line to enable the scrolling navbar
    [self followScrollView:nil];
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)requestRefreshData
{
    [self loadRefreshData];
}

- (void)requestInfiniteData
{
    [self loadInfiniteData];
}

//刷新tableView，获取最新数据
- (void)loadRefreshData
{
    
}

//刷新tableView，获取历史数据
- (void)loadInfiniteData
{
    
}

//停止刷新动画
- (void)stopAnimating
{
    [self.collectionView.pullToRefreshView stopAnimating];
    [self.collectionView.infiniteScrollingView stopAnimating];
}

//禁用下拉刷新
- (void)stopPullToRefresh
{
    self.collectionView.showsPullToRefresh = NO;
}

//禁用上拉加载
- (void)stopInfiniteScrolling
{
    self.collectionView.showsInfiniteScrolling = NO;
}

//允许下拉刷新
- (void)startPullToRefresh
{
    self.collectionView.showsPullToRefresh = YES;
}

//允许上拉加载
- (void)startInfiniteScrolling
{
    self.collectionView.showsInfiniteScrolling = YES;
}


- (BOOL)isNeedPullToRefresh
{
    return YES;
}

- (BOOL)isNeedInfiniteScrolling
{
    return YES;
}
#pragma mark - 语言切换
- (void)languageChanged:(NSNotification *)notification
{
    [self refreshPullView];
}

- (void)refreshPullView
{
    if (self.collectionView.showsPullToRefresh == false) {
        return;
    }
    self.linkStateLabel.text = NSLocalizedString(@"LOSTINTERNET", nil);
    [self.collectionView.pullToRefreshView setTitle:NSLocalizedString(@"LOADING", nil) forState:SVPullToRefreshStateLoading];
    [self.collectionView.pullToRefreshView setTitle:NSLocalizedString(@"RELEASETOREFRESH", nil) forState:SVPullToRefreshStateTriggered];
    [self.collectionView.pullToRefreshView setTitle:NSLocalizedString(@"PULLTOREFRESH", nil) forState:SVPullToRefreshStateStopped];
    if (self.lastRefreshTime > 1) {
        NSDate *date= [NSDate dateWithTimeIntervalSince1970:self.lastRefreshTime];
        NSString *refreshtip =[NSString stringWithFormat:@"%@: %@",NSLocalizedString(@"UPDATETO", nil),[NSString stringWithDate:date dateFormat:@"yyyy-MM-dd HH:mm"]];
        [self.collectionView.pullToRefreshView setTitle:refreshtip forState:SVPullToRefreshStateStopped];
        [self.collectionView.pullToRefreshView setTitle:refreshtip forState:SVPullToRefreshStateTriggered];
        [self.collectionView.pullToRefreshView setTitle:refreshtip forState:SVPullToRefreshStateLoading];

    }
}

- (void)setLastRefreshTime:(NSTimeInterval)lastRefreshTime
{
    _lastRefreshTime = lastRefreshTime;
    [self refreshPullView];
}

#pragma mark - UICollectionView stuff

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return 0;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return nil;
}

#pragma mark - UICollectionViewDelegateFlowLayout


- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeZero;
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsZero;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    return 0;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    return 0;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section
{
    return CGSizeZero;
}


@end
