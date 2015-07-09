//
//  M16TableViewCell.m
//  M16
//

#import "M16TableViewCell.h"

@implementation M16TableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


+ (NSString *)cellIdentifier {
    return NSStringFromClass([self class]);
}

+ (id)cellForTableView:(UITableView *)tableView {
    NSString *cellID = [self cellIdentifier];

    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (cell == nil) {
        cell = [[self alloc] initWithCellIdentifier:cellID];
    }
    return cell;
}

+ (CGFloat)cellHeight:(id)viewModel index:(NSUInteger)index
{
    return 0;
}

+ (NSMutableArray *)allCellsHeight:(id)viewModel
{
    return [NSMutableArray array];
}

- (id)initWithCellIdentifier:(NSString *)cellID {
    return [self initWithStyle:UITableViewCellStyleDefault
               reuseIdentifier:cellID];
}

- (void)bindViewModel:(id)viewModel atIndexPath:(NSIndexPath *)indexPath
{
    
}

- (void)addTextFloatingEffectWithReferenceView:(UIView *)referenceView
{
    
}

@end
