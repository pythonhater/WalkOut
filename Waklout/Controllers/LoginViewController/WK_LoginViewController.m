//
//  WK_LoginViewController.m
//  Waklout
//
//  Created by yoho on 15/7/16.
//  Copyright (c) 2015年 janlee. All rights reserved.
//

#import "WK_LoginViewController.h"

@interface WK_LoginViewController ()
@property (strong, nonatomic) UIButton *closeButton;

@end

@implementation WK_LoginViewController

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.push = YES;
    }
    return self;
}

- (void)setupLeftButton
{
    self.closeButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.closeButton.exclusiveTouch = YES;
    self.closeButton.frame = CGRectMake(0, 0, NAVIGATION_BAR_HEIGHT, NAVIGATION_BAR_HEIGHT);
    [self.closeButton setImage:[UIImage imageNamed:@"button_nav_icon_normal"] forState:UIControlStateNormal];
    [self.closeButton setImage:[UIImage imageNamed:@"button_nav_icon_highlighted"] forState:UIControlStateHighlighted];
    [self.closeButton addTarget:self action:@selector(closeButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *negativeSeperatorItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    negativeSeperatorItem.width = iOS7_OR_LATER? -10:0;
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithCustomView:self.closeButton];
    
    self.navigationItem.leftBarButtonItems = @[negativeSeperatorItem, leftItem];
}

- (void)closeButtonClicked:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)setupNaviBarTitleView
{
    
}

- (void)setupRightButton
{

}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
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
