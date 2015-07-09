//
//  M16HUDUtil.m
//  M16
//

#import "M16HUDUtil.h"

#import "JGProgressHUD.h"
#import "JGProgressHUDIndicatorView.h"


@implementation M16HUDUtil

+ (void)successWithText:(NSString *)text inView:(UIView *)view
{
    JGProgressHUD *HUD = [[JGProgressHUD alloc] initWithStyle:JGProgressHUDStyleDark];
    HUD.userInteractionEnabled = NO;
    
    UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"jg_hud_success.png"]];
    HUD.textLabel.text = text;
    JGProgressHUDIndicatorView *ind = [[JGProgressHUDIndicatorView alloc] initWithContentView:imageView];
    HUD.indicatorView = ind;
    
    HUD.square = YES;
    
    [HUD showInView:view];
    
    [HUD dismissAfterDelay:TIP_DELAY_IN_SECOND];
}

+ (void)errorWithText:(NSString *)text inView:(UIView *)view
{
    JGProgressHUD *HUD = [[JGProgressHUD alloc] initWithStyle:JGProgressHUDStyleDark];
    HUD.userInteractionEnabled = NO;
    
    UIImageView *errorImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"jg_hud_error.png"]];
    HUD.textLabel.text = text;
    JGProgressHUDIndicatorView *ind = [[JGProgressHUDIndicatorView alloc] initWithContentView:errorImageView];
    HUD.indicatorView = ind;
    
    HUD.square = YES;
    
    [HUD showInView:view];
    
    [HUD dismissAfterDelay:TIP_DELAY_IN_SECOND];
}

+ (void)textOnly:(NSString *)text inView:(UIView *)view
{
    JGProgressHUD *HUD = [[JGProgressHUD alloc] initWithStyle:JGProgressHUDStyleDark];
    HUD.indicatorView = nil;
    HUD.textLabel.text = text;
    HUD.position = JGProgressHUDPositionCenter;
    HUD.interactionType = JGProgressHUDInteractionTypeBlockAllTouches;
    HUD.marginInsets = (UIEdgeInsets) {
        .top = 0.0f,
        .bottom = 20.0f,
        .left = 0.0f,
        .right = 0.0f,
    };
    
    
    [HUD showInView:view];
    
    [HUD dismissAfterDelay:TIP_DELAY_IN_SECOND];
}

+ (JGProgressHUD *)loadingWithText:(NSString *)text delgate:(id<JGProgressHUDDelegate>)delegate inView:(UIView *)view
{
    JGProgressHUD *HUD = [[JGProgressHUD alloc] initWithStyle:JGProgressHUDStyleDark];
    HUD.textLabel.text = text;
    HUD.interactionType = JGProgressHUDInteractionTypeBlockAllTouches;
    HUD.delegate = delegate;
    
    [HUD showInView:view];
    
    return HUD;
}


+ (void)showShareTip:(NSString *)text inView:(UIView *)view
{
    JGProgressHUD *HUD = [[JGProgressHUD alloc] initWithStyle:JGProgressHUDStyleLight];
    
    HUD.indicatorView = nil;
    HUD.textLabel.text = text;
    HUD.position = JGProgressHUDPositionCenter;
    HUD.interactionType = JGProgressHUDInteractionTypeBlockAllTouches;
    HUD.marginInsets = (UIEdgeInsets) {
        .top = 0.0f,
        .bottom = 20.0f,
        .left = 0.0f,
        .right = 0.0f,
    };
    
    NSArray *HUDs = [JGProgressHUD allProgressHUDsInView:view];
    for (JGProgressHUD *item in HUDs) {
        [item dismissAnimated:YES];
    }
    
    [HUD showInRect:CGRectMake(CGRectGetMinX(view.frame), CGRectGetMinY(view.frame), CGRectGetWidth(view.frame), CGRectGetHeight(view.frame) / 2) inView:view];
    
    [HUD dismissAfterDelay:TIP_DELAY_IN_SECOND];
}

@end
