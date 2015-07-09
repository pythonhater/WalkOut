//
//  YH_NavigationController.m
//  Yohoboys
//
//  Created by Zhou Rongjun on 14-9-25.
//  Copyright (c) 2014年 YOHO. All rights reserved.
//

#import "WK_NavigationController.h"

#if DEBUG

#import "FLEXManager.h"

#endif

@interface WK_NavigationController ()

@property (strong, nonatomic) UISwipeGestureRecognizer *swipeGestureRecognizer;

@end

@implementation WK_NavigationController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (id)initWithRootViewController:(UIViewController *)rootViewController
{
    self = [super initWithRootViewController:rootViewController];
    if (self) {
        if (iOS7_OR_LATER) {
            self.navigationBar.barTintColor = [UIColor whiteColor];
            [self.navigationBar setTitleTextAttributes:
                    [NSDictionary dictionaryWithObjectsAndKeys:
                            [UIFont systemFontOfSize:20],
                            NSFontAttributeName,
                            [UIColor blackColor],
                            UITextAttributeTextColor,
                            nil
                    ]
            ];
        }else{
            [self.navigationBar setTitleTextAttributes:
                    [NSDictionary dictionaryWithObjectsAndKeys:
                            [UIFont systemFontOfSize:20],
                            NSFontAttributeName,
                            [UIColor blackColor],
                            UITextAttributeTextColor,
                            nil
                     ]
             ];
            
            
            
            self.navigationBar.tintColor = [UIColor whiteColor];
        }
        
        [self.navigationBar setBackgroundImage:[self imageWithColor:[UIColor whiteColor] size:CGSizeMake(SCREEN_WIDTH, NAVIGATION_BAR_HEIGHT)]
                                 forBarMetrics:UIBarMetricsDefault];
        [self.navigationBar setShadowImage:[[UIImage alloc] init]];
        
        //跳转渐隐效果
        self.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
//    //自定义返回按钮后，iOS7以后的系统左滑返回失效，通过以下方法重新使此手势生效。。。。。。
//    if ([self respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
//        self.navigationController.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc]
//                                                                      initWithTitle:@""
//                                                                      style:UIBarButtonItemStylePlain
//                                                                      target:nil
//                                                                      action:nil];
//        
//        __weak typeof(self) weakSelf = self;
//        self.interactivePopGestureRecognizer.delegate = (id<UIGestureRecognizerDelegate>)weakSelf;
//        self.delegate = (id<UINavigationControllerDelegate>)weakSelf;
//    }
//    
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.swipeGestureRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipeGesture:)];
    [self.view addGestureRecognizer:self.swipeGestureRecognizer];

    
    
#if DEBUG
    [self setupFLEX];
#endif
    
}


#if DEBUG

- (void)setupFLEX
{
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTap:)];
    tap.numberOfTapsRequired = 2;
    [self.navigationBar addGestureRecognizer:tap];
    
}

- (void)handleTap:(UITapGestureRecognizer *)sender
{
    [[FLEXManager sharedManager] showExplorer];
}

#endif

- (void)handleSwipeGesture:(UISwipeGestureRecognizer *)sender
{
    [self popViewControllerAnimated:YES];
}

//- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated {
//    // Hijack the push method to disable the gesture
//    if ([self respondsToSelector:@selector(interactivePopGestureRecognizer)])
//        self.interactivePopGestureRecognizer.enabled = NO;
//    
//    [super pushViewController:viewController animated:animated];
//}
//
//#pragma mark - UINavigationControllerDelegate
//
//- (void)navigationController:(UINavigationController *)navigationController didShowViewController:(UIViewController *)viewController animated:(BOOL)animate {
//    // Enable the gesture again once the new controller is shown
//    self.interactivePopGestureRecognizer.enabled = ([self respondsToSelector:@selector(interactivePopGestureRecognizer)] && [self.viewControllers count] > 1);
//}



- (UIViewController *)rootViewController
{
    return [self.viewControllers firstObject];
}



-(BOOL)shouldAutorotate
{
    return self.topViewController.shouldAutorotate;
}
-(NSUInteger)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskPortrait;
}

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return self.topViewController.preferredStatusBarStyle;
}

- (BOOL)prefersStatusBarHidden
{
    return self.topViewController.prefersStatusBarHidden;
}


//IOS6 navigation background
-(UIImage *)imageWithColor:(UIColor *)color size:(CGSize)size
{
    CGRect rect = CGRectMake(0, 0, size.width, size.height-1);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

@end
