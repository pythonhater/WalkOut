//
//  YH_NavigationController.h
//  Yohoboys
//
//  Created by Zhou Rongjun on 14-9-25.
//  Copyright (c) 2014年 YOHO. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WK_NavigationController : UINavigationController

@property (nonatomic, strong) UIView *overlayView;

- (UIViewController *)rootViewController;

@end
