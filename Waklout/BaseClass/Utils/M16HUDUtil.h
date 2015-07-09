//
//  M16HUDUtil.h
//  M16
//
//

#import <Foundation/Foundation.h>

#define TIP_DELAY_IN_SECOND 2

@class JGProgressHUD;
@protocol JGProgressHUDDelegate;


@interface M16HUDUtil : NSObject

+ (void)successWithText:(NSString *)text inView:(UIView *)view;
+ (void)errorWithText:(NSString *)text inView:(UIView *)view;
+ (void)textOnly:(NSString *)text inView:(UIView *)view;
+ (JGProgressHUD *)loadingWithText:(NSString *)text delgate:(id<JGProgressHUDDelegate>)delegate inView:(UIView *)view;

+ (void)showShareTip:(NSString *)text inView:(UIView *)view;

@end
