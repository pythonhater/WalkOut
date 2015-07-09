//
//  M16RootViewControllerProtocol.h
//  M16
//

#import <Foundation/Foundation.h>

@protocol M16ControllerProtocol <NSObject>

- (void)showLoadingView;
- (void)hideLoadingView;
- (void)showSuccessView;
- (void)showErrorView;
- (void)showText:(NSString *)text;
- (void)showTextWhileLoading:(NSString *)text;

- (UIViewController *)viewControllerWithIdentifier:(NSString *)identifier withStoryboardName:(NSString *)stroyboardName;
- (UIViewController *)viewControllerWithIdentifier:(NSString *)identifier inStoryboard:(UIStoryboard *)storyboard;

- (void)displayContentController:(UIViewController *)contentViewController;
- (void)displayContentController:(UIViewController *)contentViewController identifier:(NSString *)identifier;

- (CGRect)frameForContentViewController:(NSString *)identifier;

- (void)hideContentController:(UIViewController *)contentViewController;

@end
