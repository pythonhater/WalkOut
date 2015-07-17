//
//  WK_LoginCell.m
//  Waklout
//
//  Created by leejan97 on 15-7-16.
//  Copyright (c) 2015年 janlee. All rights reserved.
//

#import "WK_LoginTableViewCell.h"
#import "WK_LoginViewModel.h"

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
        self.label.textAlignment = NSTextAlignmentLeft;
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
    WK_LoginViewModel *loginViewModel = (WK_LoginViewModel *)viewModel;
    NSString *labelText = [loginViewModel labelText:index];
    NSString *textFieldText = [loginViewModel textFieldText:index];
    self.label.text = labelText;
    self.textField.placeholder = textFieldText;
}

@end
