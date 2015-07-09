//
//  M16ViewController.m
//  M16
//

#import "M16ViewController.h"

#import "M16HUDUtil.h"

#import "WK_NavigationController.h"

static NSInteger const kLinkStateHeight = 36;
static NSInteger const kLinkStateImagePaddingLeft = 18;
static NSInteger const kLinkStateImageSize = 20;
static NSInteger const kLinkStateLabelPaddingLeft = 5;

@interface M16ViewController () <UIGestureRecognizerDelegate, UIScrollViewDelegate>

@property (nonatomic, weak)	UIView* scrollableView;
@property (assign, nonatomic) float lastContentOffset;
@property (strong, nonatomic) UIPanGestureRecognizer* panGesture;
@property (strong, nonatomic) UIView* overlayView;
@property (assign, nonatomic) BOOL isCollapsed;
@property (assign, nonatomic) BOOL isExpanded;
@property (nonatomic, weak) UIView* toolbarView;


@end

@implementation M16ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    if (iOS7_OR_LATER) {
        self.edgesForExtendedLayout = UIRectEdgeNone;
        self.extendedLayoutIncludesOpaqueBars = NO;
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    
    if (self.push) {
        [self setupNaviBarView];
    }
    
    if (self.showLinkState) {
        [self createLinkStateView];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(networkReachabilityDidChange:) name:AFNetworkingReachabilityDidChangeNotification object:nil];
    }
}

- (void)dealloc
{
    if (self.showLinkState) {
        [[NSNotificationCenter defaultCenter] removeObserver:self];
    }
    
    if ([self.scrollableView isKindOfClass:[UIScrollView class]]) {
        UIScrollView *scrollView = (UIScrollView*)self.scrollableView;
        scrollView.delegate = nil;
    }
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark - Autoratate

-(BOOL)shouldAutorotate
{
    return NO;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation
{
    return (toInterfaceOrientation == UIInterfaceOrientationPortrait);
}

- (NSUInteger)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskPortrait;
}

#pragma mark - M16ControllerProtocol

- (UIView *)HUDContainerView
{
    return self.view;
}

- (void)showLoadingView
{
    self.HUD = [M16HUDUtil loadingWithText:nil delgate:self inView:[self HUDContainerView]];
}

- (void)hideLoadingView
{
    if (self.HUD.targetView) {
        [self.HUD dismiss];
    }
}

- (void)hideLoadingView:(BOOL)animated
{
    if (self.HUD.targetView) {
        [self.HUD dismissAnimated:animated];
    }
}

- (void)showSuccessView
{
    [M16HUDUtil successWithText:@"Success!" inView:[self HUDContainerView]];
}

- (void)showErrorView
{
    [M16HUDUtil errorWithText:@"Error!" inView:[self HUDContainerView]];
}

- (void)showTextWhileLoading:(NSString *)text
{
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.6 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        self.HUD.indicatorView = nil;
        self.HUD.textLabel.text = text;
        [self.HUD dismissAfterDelay:TIP_DELAY_IN_SECOND];
    });
}

- (void)showText:(NSString *)text
{
    if ([text notNilOrEmpty]) {
        [M16HUDUtil textOnly:text inView:[self HUDContainerView]];
    }
}

- (UIViewController *)viewControllerWithIdentifier:(NSString *)identifier inStoryboard:(UIStoryboard *)storyboard withStoryboardName:(NSString *)stroyboardName
{
    if (!storyboard) {
        storyboard = [UIStoryboard storyboardWithName:stroyboardName bundle:nil];
    }
    
    UIViewController *viewController = [storyboard instantiateViewControllerWithIdentifier:identifier];
    return viewController;
}

- (UIViewController *)viewControllerWithIdentifier:(NSString *)identifier inStoryboard:(UIStoryboard *)storyboard
{
    return [self viewControllerWithIdentifier:identifier inStoryboard:storyboard withStoryboardName:nil];
}

- (UIViewController *)viewControllerWithIdentifier:(NSString *)identifier withStoryboardName:(NSString *)stroyboardName
{
    return [self viewControllerWithIdentifier:identifier inStoryboard:nil withStoryboardName:stroyboardName];
}

- (void)displayContentController:(UIViewController *)contentViewController identifier:(NSString *)identifier
{
    [self addChildViewController:contentViewController];
    
    if (!identifier || [identifier isEqualToString:@""]) {
        identifier = NSStringFromClass([contentViewController class]);
    }
    
    contentViewController.view.frame = [self frameForContentViewController:identifier];
    [self.view addSubview:contentViewController.view];
    [contentViewController didMoveToParentViewController:self];
}

- (void)displayContentController:(UIViewController *)contentViewController
{
    [self displayContentController:contentViewController identifier:nil];
}

- (CGRect)frameForContentViewController:(NSString *)identifier
{
    return CGRectZero;
}

- (void)hideContentController:(UIViewController *)contentViewController
{
    [contentViewController willMoveToParentViewController:nil];
    [contentViewController.view removeFromSuperview];
    [contentViewController removeFromParentViewController];
}


#pragma mark - JGProgressHUDDelegate

- (void)progressHUD:(JGProgressHUD *)progressHUD willPresentInView:(UIView *)view
{

}

- (void)progressHUD:(JGProgressHUD *)progressHUD didPresentInView:(UIView *)view
{

}

- (void)progressHUD:(JGProgressHUD *)progressHUD willDismissFromView:(UIView *)view
{

}

- (void)progressHUD:(JGProgressHUD *)progressHUD didDismissFromView:(UIView *)view
{

}

#pragma mark - ScrollingNavbar

- (void)followedToolbarView:(UIView*)toolbarView;
{
    if (SYSTEM_VERSION_LESS_THAN(@"7.0")) {
        return;
    }
    
    self.toolbarView = toolbarView;
}

- (void)followScrollView:(UIView*)scrollableView
{
    if (SYSTEM_VERSION_LESS_THAN(@"7.0")) {
        return;
    }
    
    if (scrollableView == self.scrollableView) {
        return;
    }
    
    if (self.scrollableView) {
        [self.scrollableView removeGestureRecognizer:self.panGesture];
    }
    
    self.scrollableView = scrollableView;
    
    if (!self.scrollableView) {
        return;
    }
    
    if (self.panGesture == nil) {
        self.panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePan:)];
        [self.panGesture setMaximumNumberOfTouches:1];
        [self.panGesture setDelegate:self];
    }

    [self.scrollableView addGestureRecognizer:self.panGesture];
    
    /* The navbar fadeout is achieved using an overlay view with the same barTintColor.
     this might be improved by adjusting the alpha component of every navbar child */
    [self resetColor];
    
    if ([self.scrollableView isKindOfClass:[UIScrollView class]]) {
        UIScrollView *scrollView = (UIScrollView*)self.scrollableView;
        scrollView.delegate = self;
    }
}

#pragma mark - UIGestureRecognizerDelegate

- (BOOL)gestureRecognizerShouldBegin:(UIPanGestureRecognizer *)panGestureRecognizer
{
    if (self.panGesture == panGestureRecognizer) {
        CGPoint velocity = [panGestureRecognizer velocityInView:[self.scrollableView superview]];
        return fabs(velocity.y) > fabs(velocity.x);
    }
    
    return YES;
    
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
    return YES;
}

- (void)handlePan:(UIPanGestureRecognizer*)gesture
{
    CGPoint translation = [gesture translationInView:[self.scrollableView superview]];
    
    CGFloat delta = self.lastContentOffset - translation.y;
    CGFloat deltaToolBar = delta;
    self.lastContentOffset = translation.y;
    
    CGRect frame;
    
    if (delta > 0) {
        if (self.isCollapsed) {
            return;
        }

        frame = self.navigationController.navigationBar.frame;
        
        if (frame.origin.y - delta < (STATUS_BAR_HEIGHT - NAVIGATION_BAR_HEIGHT)) {
            delta = frame.origin.y + (NAVIGATION_BAR_HEIGHT - STATUS_BAR_HEIGHT);
        }
        
        frame.origin.y = MAX((STATUS_BAR_HEIGHT - NAVIGATION_BAR_HEIGHT), frame.origin.y - delta);
        self.navigationController.navigationBar.frame = frame;
        
        if (frame.origin.y == (STATUS_BAR_HEIGHT - NAVIGATION_BAR_HEIGHT)) {
            self.isCollapsed = YES;
            self.isExpanded = NO;
        }

        
        //隐藏toolbarView
        if (self.toolbarView) {
            CGRect frameToolBar = self.toolbarView.frame;
            CGFloat superHeight = self.toolbarView.superview.frame.size.height;
            
            deltaToolBar += delta;
            frameToolBar.origin.y = MIN(superHeight + delta, frameToolBar.origin.y + deltaToolBar);
            //DLog(@"superHeight=%f, y=%f, delta=%f", superHeight, frameToolBar.origin.y, deltaToolBar);
            self.toolbarView.frame = frameToolBar;
        }
        [self updateColor];
        [self updateSizingWithDelta:delta];
        
        // Keeps the view's scroll position steady until the navbar is gone
        if ([self.scrollableView isKindOfClass:[UIScrollView class]]) {
            [(UIScrollView*)self.scrollableView setContentOffset:CGPointMake(((UIScrollView*)self.scrollableView).contentOffset.x, ((UIScrollView*)self.scrollableView).contentOffset.y - delta)];
        }
    }
    
    if (delta < 0) {
        if (self.isExpanded) {
            return;
        }
        
        frame = self.navigationController.navigationBar.frame;
        
        if (frame.origin.y - delta > STATUS_BAR_HEIGHT) {
            delta = frame.origin.y - STATUS_BAR_HEIGHT;
        }
        frame.origin.y = MIN(STATUS_BAR_HEIGHT, frame.origin.y - delta);
        self.navigationController.navigationBar.frame = frame;
        
        if (frame.origin.y == STATUS_BAR_HEIGHT) {
            self.isExpanded = YES;
            self.isCollapsed = NO;
        }
        
        
        //显示toolbarView
        if (self.toolbarView) {
            CGRect frameToolBar = self.toolbarView.frame;
            CGFloat superHeight = self.toolbarView.superview.frame.size.height;
            
            deltaToolBar += delta;
            frameToolBar.origin.y = MAX(superHeight + delta - frameToolBar.size.height, frameToolBar.origin.y + deltaToolBar);
            self.toolbarView.frame = frameToolBar;
        }
        [self updateColor];
        [self updateSizingWithDelta:delta];
    }
    
    if ([gesture state] == UIGestureRecognizerStateEnded) {
        // Reset the nav bar if the scroll is partial
        self.lastContentOffset = 0;
        if ([self shouldCheckForPartialScroll]) {
            [self checkForPartialScroll];
        }
        
    }
}

- (BOOL)shouldCheckForPartialScroll
{
    return YES;
}

- (void)checkForPartialScroll
{
    CGFloat pos = self.navigationController.navigationBar.frame.origin.y;
    
    // Get back down
    if (pos >= -2) {
        [UIView animateWithDuration:0.1 animations:^{
            
            self.navigationController.navigationBar.frame = CGRectMake(0, STATUS_BAR_HEIGHT, SCREEN_WIDTH, NAVIGATION_BAR_HEIGHT);
            
            self.isExpanded = YES;
            self.isCollapsed = NO;
            
            [self resetColor];
            
            if (self.scrollableView) {
                
                if ([self.scrollableView isKindOfClass:[UIWebView class]]) {
                    // Changing the layer's frame avoids UIWebView's glitchiness
                    self.scrollableView.layer.frame = CGRectMake(0, 0, SCREEN_WIDTH, CONTENT_HEIGHT);
                }
                else{
                    // Use view's frame avoids bounds error when ios7
                    if (self.showLinkState && !self.linkStateView.hidden) {
                        self.scrollableView.frame = CGRectMake(0, STATUS_AND_NAVIGATION_HEIGHT, SCREEN_WIDTH, CONTENT_HEIGHT);
                    }
                    else {
                        self.scrollableView.frame = CGRectMake(0, STATUS_AND_NAVIGATION_HEIGHT, SCREEN_WIDTH, CONTENT_HEIGHT);
                    }
                    
                }
            }
            
            if (self.toolbarView) {
                CGRect frameToolBar = self.toolbarView.frame;
                CGFloat superHeight = self.toolbarView.superview.frame.size.height;
                frameToolBar.origin.y = superHeight - frameToolBar.size.height;
                self.toolbarView.frame = frameToolBar;
            }
        }];
    } else {
        // And back up
        [UIView animateWithDuration:0.1 animations:^{

            self.isExpanded = NO;
            self.isCollapsed = YES;
            
            self.navigationController.navigationBar.frame = CGRectMake(0, STATUS_BAR_HEIGHT - NAVIGATION_BAR_HEIGHT, SCREEN_WIDTH, NAVIGATION_BAR_HEIGHT);
            
            [self updateColor];
            
            if (self.scrollableView) {
                
                if ([self.scrollableView isKindOfClass:[UIWebView class]]) {
                    // Changing the layer's frame avoids UIWebView's glitchiness
                    self.scrollableView.layer.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - STATUS_BAR_HEIGHT);
                }
                else{
                    // Use view's frame avoids bounds error when ios7
                    if (self.showLinkState && !self.linkStateView.hidden) {
                        self.scrollableView.frame = CGRectMake(0, STATUS_BAR_HEIGHT, SCREEN_WIDTH, SCREEN_HEIGHT - STATUS_BAR_HEIGHT);
                    }
                    else {
                        self.scrollableView.frame = CGRectMake(0, STATUS_BAR_HEIGHT, SCREEN_WIDTH, SCREEN_HEIGHT - STATUS_BAR_HEIGHT);
                    }
                    
                }
            }
            
            if (self.toolbarView) {
                CGRect frameToolBar = self.toolbarView.frame;
                CGFloat superHeight = self.toolbarView.superview.frame.size.height;
                frameToolBar.origin.y = superHeight;
                self.toolbarView.frame = frameToolBar;
            }
        }];
    }
}

- (void)updateSizingWithDelta:(CGFloat)delta
{
    if (delta == 0.0f) {
        return;
    }
    
    if ([self.scrollableView isKindOfClass:[UIWebView class]]) {
        // Changing the layer's frame avoids UIWebView's glitchiness
        CGRect frame = self.scrollableView.layer.frame;
        frame.origin.y -= delta;
        frame.size.height += delta;
        self.scrollableView.layer.frame = frame;
    }
    else{
        // Use view's frame avoids bounds error when ios7
        CGRect frame = self.scrollableView.frame;
        frame.origin.y -= delta;
        frame.size.height += delta;
        self.scrollableView.frame = frame;
    }
}

- (void)updateColor
{
    CGRect frame = self.navigationController.navigationBar.frame;
    
    float alpha = (frame.origin.y + (NAVIGATION_BAR_HEIGHT - STATUS_BAR_HEIGHT)) / frame.size.height;
    [self.overlayView setAlpha:1 - alpha];
    //DLog(@"[updateColor]overlay color alpha:%f", 1 - alpha);
    self.navigationController.navigationBar.tintColor = [self.navigationController.navigationBar.tintColor colorWithAlphaComponent:alpha];
}

- (void)resetColor
{
    [self.overlayView setAlpha:0];
    //DLog(@"[resetColor]overlay color alpha:%f", 0.0f);
    self.navigationController.navigationBar.tintColor = [self.navigationController.navigationBar.tintColor colorWithAlphaComponent:1];
}

- (void)resetNavigation
{
    [self resetNavigation:self.scrollableView];
}

- (void)resetNavigation:(UIView *)scrollableView
{
    if (SYSTEM_VERSION_LESS_THAN(@"7.0")) {
        return;
    }
    
    [self.navigationController.navigationBar bringSubviewToFront:self.overlayView];
    
    self.lastContentOffset = 0;
    
    if ([self shouldResetNavigationBar]) {
        self.navigationController.navigationBar.frame = CGRectMake(0, STATUS_BAR_HEIGHT, SCREEN_WIDTH, NAVIGATION_BAR_HEIGHT);
    }
    
    self.isExpanded = YES;
    self.isCollapsed = NO;
    
    [self resetColor];
    
    if (self.scrollableView) {
        
        if ([self.scrollableView isKindOfClass:[UIWebView class]]) {
            // Changing the layer's frame avoids UIWebView's glitchiness
            self.scrollableView.layer.frame = CGRectMake(0, 0, SCREEN_WIDTH, CONTENT_HEIGHT);
        }
        else{
            // Use view's frame avoids bounds error when ios7
            if (self.showLinkState && !self.linkStateView.hidden) {
                self.scrollableView.frame = CGRectMake(0, STATUS_AND_NAVIGATION_HEIGHT, SCREEN_WIDTH, CONTENT_HEIGHT);
            }
            else {
                self.scrollableView.frame = CGRectMake(0, STATUS_AND_NAVIGATION_HEIGHT, SCREEN_WIDTH, CONTENT_HEIGHT);
            }
            
        }
    }
    
    if (self.toolbarView) {
        CGRect frameToolBar = self.toolbarView.frame;
        CGFloat superHeight = self.toolbarView.superview.frame.size.height;
        frameToolBar.origin.y = superHeight - frameToolBar.size.height;
        self.toolbarView.frame = frameToolBar;
    }
}

- (BOOL)shouldResetNavigationBar
{
    return YES;
}

- (UIView *)overlayView
{
    if (_overlayView == nil) {
        if ([self.navigationController isKindOfClass:[WK_NavigationController class]]) {
            WK_NavigationController *navi = (WK_NavigationController *)self.navigationController;
            if (navi.overlayView){
                _overlayView = navi.overlayView;
            }
            else {
                CGRect frame = self.navigationController.navigationBar.frame;
                frame.origin = CGPointZero;
                _overlayView = [[UIView alloc] initWithFrame:frame];
                
                if (iOS7_OR_LATER) {
                    if (!self.navigationController.navigationBar.barTintColor) {
                        DLog(@"[%s]: %@", __func__, @"Warning: no bar tint color set");
                    }
                    [_overlayView setBackgroundColor:self.navigationController.navigationBar.barTintColor];
                }
                
                [_overlayView setUserInteractionEnabled:NO];
                [self.navigationController.navigationBar addSubview:_overlayView];
                navi.overlayView = _overlayView;
            }
        }
    }
    
    return _overlayView;
}

#pragma mark - Custom Navigation

- (void)setupNaviBarView
{
    [self setupLeftButton];
    [self setupNaviBarTitleView];
    [self setupRightButton];
}

- (void)setupLeftButton
{
    UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    backButton.exclusiveTouch = YES;
    backButton.frame = CGRectMake(0, 0, NAVIGATION_BAR_HEIGHT, NAVIGATION_BAR_HEIGHT);
    [backButton setImage:[UIImage imageNamed:@"button_back_black_normal"] forState:UIControlStateNormal];
    [backButton setImage:[UIImage imageNamed:@"button_back_black_highlighted"] forState:UIControlStateHighlighted];
    [backButton addTarget:self action:@selector(back:) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *negativeSeperatorItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    negativeSeperatorItem.width = iOS7_OR_LATER? -10:0;
    UIBarButtonItem *backButtonItem = [[UIBarButtonItem alloc] initWithCustomView:backButton];
    
    self.navigationItem.leftBarButtonItems = @[negativeSeperatorItem, backButtonItem];
}

- (void)setupNaviBarTitleView
{

}

- (void)setupRightButton
{
    
}

- (void)back:(UIButton *)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}


#pragma mark - network state
- (void)networkReachabilityDidChange:(NSNotification *)notification
{
    AFNetworkReachabilityStatus status = [[notification.userInfo objectForKey:AFNetworkingReachabilityNotificationStatusItem] integerValue];
    if (status == AFNetworkReachabilityStatusNotReachable || status == AFNetworkReachabilityStatusUnknown) {
        [self showLinkStateView];
    }
    else {
        [self hideLinkStateView];
    }
}

- (void)showLinkStateView
{
    if (self.linkStateView.hidden == YES && self.scrollableView) {
        self.linkStateView.hidden = NO;
        self.linkStateLabel.text = NSLocalizedString(@"LOSTINTERNET", nil);
        CGRect viewFrame = self.scrollableView.frame;
        viewFrame.origin.y +=  CGRectGetMaxY(self.linkStateView.frame);
        viewFrame.size.height -= CGRectGetMaxY(self.linkStateView.frame);
        self.scrollableView.frame = viewFrame;
    }
}

- (void)hideLinkStateView
{
    if (self.linkStateView.hidden == NO && self.scrollableView) {
        self.linkStateView.hidden = YES;
        CGRect viewFrame = self.scrollableView.frame;
        viewFrame.origin.y -=  CGRectGetMaxY(self.linkStateView.frame);
        viewFrame.size.height += CGRectGetMaxY(self.linkStateView.frame);
        self.scrollableView.frame = viewFrame;
    }
}

- (UIImageView *)createLinkStateView
{
    if (!_linkStateView) {
        _linkStateView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, kLinkStateHeight)];
        _linkStateView.backgroundColor = [UIColor m16_colorwithHexString:@"#fafafa"];
        _linkStateView.hidden = YES;
        [self.view addSubview:_linkStateView];
        
        _linkStateImageView = [[UIImageView alloc] initWithFrame:CGRectMake(kLinkStateImagePaddingLeft, (kLinkStateHeight - kLinkStateImageSize) / 2, kLinkStateImageSize, kLinkStateImageSize)];
        _linkStateImageView.image = [UIImage imageNamed:@"warning"];
        [_linkStateView addSubview:_linkStateImageView];
        
        _linkStateLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_linkStateImageView.frame) + kLinkStateLabelPaddingLeft, 0, SCREEN_WIDTH - kLinkStateImagePaddingLeft * 2 - kLinkStateLabelPaddingLeft - kLinkStateImageSize, kLinkStateHeight)];
        _linkStateLabel.numberOfLines = 0;
        _linkStateLabel.font = [UIFont fontWithName:@"Helvetica Light" size:14];
        [_linkStateView addSubview:_linkStateLabel];
    }
    
    return _linkStateView;
    
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidScrollToTop:(UIScrollView *)scrollView
{
    [self resetNavigation];
}

@end
