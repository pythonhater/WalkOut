//
//  M16TableViewCell.h
//  M16
//

#import <UIKit/UIKit.h>

@interface M16TableViewCell : UITableViewCell

+ (NSString *)cellIdentifier;

+ (id)cellForTableView:(UITableView *)tableView;

//计算Cell内布局的高度
+ (CGFloat)cellHeight:(id)viewModel index:(NSUInteger)index;

+ (NSMutableArray *)allCellsHeight:(id)viewModel;

- (id)initWithCellIdentifier:(NSString *)cellID;

//绑定ViewModel
- (void)bindViewModel:(id)viewModel atIndexPath:(NSIndexPath *)indexPath;

//滑动时候呼吸效果
- (void)addTextFloatingEffectWithReferenceView:(UIView *)referenceView;

@end
