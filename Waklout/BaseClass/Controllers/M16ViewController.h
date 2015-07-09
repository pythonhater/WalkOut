//
//  M16ViewController.h
//  M16
//

#import "M16ControllerProtocol.h"

#import "JGProgressHUD.h"

#import "AFNetworkReachabilityManager.h"

@interface M16ViewController : UIViewController <M16ControllerProtocol, JGProgressHUDDelegate>

@property (nonatomic, strong) JGProgressHUD *HUD;

@property (nonatomic, assign, getter=isPush) BOOL push;

@property (nonatomic, assign, getter=isShowLinkState) BOOL showLinkState;

//网络无链接提示
@property (nonatomic,strong) UIImageView *linkStateImageView;
@property (nonatomic,strong) UILabel *linkStateLabel;
@property (nonatomic,strong) UIImageView *linkStateView;

@property (strong, nonatomic) NSString *channelName;    //频道名称
@property (strong, nonatomic) NSString *channelId;      //频道id

- (UIView *)HUDContainerView;
/** Scrolling init method
 *
 * Enables the scrolling on a generic UIView.
 *
 * @param scrollableView The UIView where the scrolling is performed.
 */
- (void)followScrollView:(UIView*)scrollableView;

- (void)followedToolbarView:(UIView*)toolbarView;

- (void)handlePan:(UIPanGestureRecognizer*)gesture;

// custom navigationitem
- (void)setupNaviBarView;
- (void)setupLeftButton;
- (void)setupNaviBarTitleView;
- (void)setupRightButton;
- (void)back:(UIButton *)sender;
- (void)resetNavigation;
- (void)resetNavigation:(UIView *)scrollableView;
- (BOOL)shouldResetNavigationBar;
- (BOOL)shouldCheckForPartialScroll;

// network link state
- (void)networkReachabilityDidChange:(NSNotification *)notification;
- (void)showLinkStateView;
- (void)hideLinkStateView;

@end
