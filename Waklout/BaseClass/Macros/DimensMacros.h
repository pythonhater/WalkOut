//
//  DimensMacros.h
//  M16
//

#ifndef M16_DimensMacros_h
#define M16_DimensMacros_h

//状态栏高度
#define STATUS_BAR_HEIGHT 20
//NavBar高度
#define NAVIGATION_BAR_HEIGHT 44
//tab bar高度
#define TAB_BAR_HEIGHT 49
//状态栏 ＋ 导航栏 高度
#define STATUS_AND_NAVIGATION_HEIGHT ((STATUS_BAR_HEIGHT) + (NAVIGATION_BAR_HEIGHT))

//屏幕 rect
#define SCREEN_RECT ([UIScreen mainScreen].bounds)

#define SCREEN_WIDTH ([UIScreen mainScreen].bounds.size.width)
#define SCREEN_HEIGHT ([UIScreen mainScreen].bounds.size.height)

#define SCREEN_MAX_LENGTH (MAX(SCREEN_WIDTH, SCREEN_HEIGHT))
#define SCREEN_MIN_LENGTH (MIN(SCREEN_WIDTH, SCREEN_HEIGHT))

#define CONTENT_HEIGHT (SCREEN_HEIGHT - NAVIGATION_BAR_HEIGHT - STATUS_BAR_HEIGHT)

//屏幕分辨率
#define SCREEN_RESOLUTION (SCREEN_WIDTH * SCREEN_HEIGHT * ([UIScreen mainScreen].scale))


//广告栏高度
#define BANNER_HEIGHT 215

#define STYLEPAGE_HEIGHT 21

#define SMALLTV_HEIGHT 77

#define SMALLTV_WIDTH 110

#define FOLLOW_HEIGHT 220

#define SUBCHANNEL_HEIGHT 62

#define NAVTITLE_WIDTH    120

#endif
