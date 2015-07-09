//
//  M16TableViewController.h
//  M16
//

#import "M16ViewController.h"

#import "SVPullToRefresh.h"


@interface M16TableViewController : M16ViewController <UITableViewDataSource, UITableViewDelegate>

@property (strong, nonatomic) UITableView *tableView;
@property (assign, nonatomic) NSTimeInterval lastRefreshTime;

- (void)loadRefreshData;
- (void)loadInfiniteData;

- (void)stopAnimating;
- (void)stopPullToRefresh;
- (void)stopInfiniteScrolling;
- (void)startPullToRefresh;
- (void)startInfiniteScrolling;

- (BOOL)isNeedPullToRefresh;
- (BOOL)isNeedInfiniteScrolling;

@end
