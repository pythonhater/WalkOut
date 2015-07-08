//
//  ViewController.m
//  Waklout
//
//  Created by yoho on 15/7/7.
//  Copyright (c) 2015年 janlee. All rights reserved.
//

#import "WK_TabbarViewController.h"

@interface WK_TabbarViewController ()

@end

@implementation WK_TabbarViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)tabBar:(RDVTabBar *)tabBar shouldSelectItemAtIndex:(NSInteger)index
{
    return YES;
}

- (void)tabBar:(RDVTabBar *)tabBar didSelectItemAtIndex:(NSInteger)index
{
    
}

@end
