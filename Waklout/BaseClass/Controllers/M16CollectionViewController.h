//
//  M16CollectionViewController.h
//  M16
//

#import "M16ViewController.h"
#import "SVPullToRefresh.h"

@interface M16CollectionViewController : M16ViewController <UICollectionViewDataSource, UICollectionViewDelegate>

@property (strong, nonatomic) UICollectionView *collectionView;
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
