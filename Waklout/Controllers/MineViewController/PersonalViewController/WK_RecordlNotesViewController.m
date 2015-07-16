//
//  WK_LocalNotesViewController.m
//  Waklout
//
//  Created by leejan97 on 15-7-15.
//  Copyright (c) 2015年 janlee. All rights reserved.
//

#import "WK_RecordlNotesViewController.h"

@interface WK_RecordlNotesViewController ()

@end

@implementation WK_RecordlNotesViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    UILabel *tempLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 20, 100, 40)];
    tempLabel.text = @"LocalCached";
    [self.view addSubview:tempLabel];
}

#pragma mark - XLPagerTabStripViewControllerDelegate
- (NSString *)titleForPagerTabStripViewController:(XLPagerTabStripViewController *)pagerTabStripViewController
{
    return NSLocalizedString(@"WK_Record", nil);
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
