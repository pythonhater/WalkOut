//
//  UIColor+M16RGB.m
//  M16
//

#import "UIColor+M16RGB.h"

@implementation UIColor (M16RGB)

+ (UIColor *)m16_colorwithHexString:(NSString *)hexString
{
    unsigned int hex = 0;
    NSScanner *scanner = [NSScanner scannerWithString:hexString];
    [scanner setScanLocation:1]; // bypass '#' character
    [scanner scanHexInt:&hex];
    return [UIColor m16_colorWithHex:hex];
}

+ (id)m16_colorWithHex:(unsigned int)hex
{
	return [UIColor m16_colorWithHex:hex alpha:1];
}

+ (id)m16_colorWithHex:(unsigned int)hex alpha:(CGFloat)alpha
{
	return [UIColor colorWithRed:((float)((hex & 0xFF0000) >> 16)) / 255.0
                           green:((float)((hex & 0xFF00) >> 8)) / 255.0
                            blue:((float)(hex & 0xFF)) / 255.0
                           alpha:alpha];
	
}

+ (UIColor*)m16_randomColor{
	
	NSInteger r = arc4random() % 255;
	NSInteger g = arc4random() % 255;
	NSInteger b = arc4random() % 255;
	return [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:1];
	
}

@end
