//
//  WK_LoginCell.m
//  Waklout
//
//  Created by leejan97 on 15-7-16.
//  Copyright (c) 2015年 janlee. All rights reserved.
//

#import "WK_LoginTableViewCell.h"

@interface WK_LoginTableViewCell ()
@property (strong, nonatomic) UILabel *label;
@property (strong, nonatomic) UITextField *textField;

@end

@implementation WK_LoginTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.label = [[UILabel alloc] init];
        self.label.textAlignment = NSTextAlignmentCenter;
        [self.contentView addSubview:self.label];
        
        self.textField = [[UITextField alloc] init];
        [self.contentView addSubview:self.textField];
        
        [self.label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.contentView.mas_left).offset(10);
            make.width.equalTo(@(80));
            make.centerY.equalTo(self.contentView.mas_centerY);
            make.height.equalTo(self.contentView.mas_height).multipliedBy(3.0 / 4);
        }];
        
        [self.textField mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.label.mas_right).offset(10);
            make.right.equalTo(self.contentView.mas_right).offset(-10);
            make.centerY.equalTo(self.contentView.mas_centerY);
            make.height.equalTo(self.contentView.mas_height).multipliedBy(3.0 / 4);
        }];
    }
    return self;
}

- (void)bindViewModel:(id)viewModel atIndexPath:(NSIndexPath *)indexPath
{
    NSUInteger index = indexPath.row;
    if (index == 0) {
        self.label.text = NSLocalizedString(@"WK_Email", nil);
        self.textField.placeholder = NSLocalizedString(@"WK_Email", nil);
    } else {
        self.label.text = NSLocalizedString(@"WK_Password", nil);
        self.textField.placeholder = NSLocalizedString(@"WK_Password", nil);
    }
}

@end
