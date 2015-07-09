//
//  M16TableViewController.m
//  M16
//

#import "M16TableViewController.h"
#import "M16TableViewCell.h"

@interface M16TableViewController ()

@end

@implementation M16TableViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    // tableView init
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, CONTENT_HEIGHT) style:UITableViewStylePlain];
    self.tableView.height = self.view.height;
    self.tableView.autoresizingMask = UIViewAutoresizingFlexibleHeight;
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:self.tableView];

    __weak typeof(self) weakSelf = self;
    if ([self isNeedPullToRefresh]){
        // setup pull-to-refresh
        [self.tableView addPullToRefreshWithActionHandler:^{
            __strong typeof(self) strongSelf = weakSelf;
            [strongSelf requestRefreshData];
        }];
    }
    
    if ([self isNeedInfiniteScrolling]){
        // setup infinite scrolling
        [self.tableView addInfiniteScrollingWithActionHandler:^{
            __strong typeof(self) strongSelf = weakSelf;
            [strongSelf requestInfiniteData];
        }];
    }
    
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
    [self.tableView.pullToRefreshView stopAnimating];
    [self.tableView.infiniteScrollingView stopAnimating];
}

//禁用下拉刷新
- (void)stopPullToRefresh
{
    self.tableView.showsPullToRefresh = NO;
}

//禁用上拉加载
- (void)stopInfiniteScrolling
{
    self.tableView.showsInfiniteScrolling = NO;
}

//允许下拉刷新
- (void)startPullToRefresh
{
    self.tableView.showsPullToRefresh = YES;
}

//允许上拉加载
- (void)startInfiniteScrolling
{
    self.tableView.showsInfiniteScrolling = YES;
}

- (BOOL)isNeedPullToRefresh
{
    return YES;
}

- (BOOL)isNeedInfiniteScrolling
{
    return YES;
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return nil;
}

@end
