//
//  XLButtonBarViewCell.m
//  XLPagerTabStrip ( https://github.com/xmartlabs/XLPagerTabStrip )
//
//  Copyright (c) 2015 Xmartlabs ( http://xmartlabs.com )
//
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.

#import "XLButtonBarViewCell.h"
static CGFloat const kLabelLeftEdge = 10.0f;
static CGFloat const kLabelRigthEdge = 10.0f;

@interface XLButtonBarViewCell()


@end

@implementation XLButtonBarViewCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.label = [[UILabel alloc] init];
        self.label.textColor = [UIColor grayColor];
        self.label.textAlignment = NSTextAlignmentCenter;
        self.label.backgroundColor = [UIColor clearColor];
        self.label.font = [UIFont fontWithName:@"Helvetica-Bold" size:14.0f];
        [self.contentView addSubview:self.label];
        
        [self.label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.contentView.mas_left).offset(kLabelLeftEdge);
            make.right.equalTo(self.contentView.mas_right).offset(-kLabelRigthEdge);
            make.centerY.equalTo(self.contentView.mas_centerY);
        }];
    }
    return self;
}

- (void)setSelected:(BOOL)selected
{
    [super setSelected:selected];
    [self setLabelColor:selected];
#ifdef DEBUG_NEED_ANIMATE
    [self animateVerticalLines:selected];
#endif
}

-(void)setLabelColor:(BOOL)selected
{
    if (selected) {
        self.label.textColor = [UIColor blackColor];
    } else {
        self.label.textColor = [UIColor grayColor];
    }
}

- (void)animateVerticalLines:(BOOL)selected
{
    if (!selected) {
        return;
    }
    [UIView animateWithDuration:0.2 animations:^{
        [self.label setTransform:CGAffineTransformMakeScale(1.2, 1.2)];
    } completion:^(BOOL finished){
        if (finished) {
            [UIView animateWithDuration:0.2 animations:^{
                [self.label setTransform:CGAffineTransformMakeScale(1.0, 1.0)];
            }];
        }
    }];
}

@end
