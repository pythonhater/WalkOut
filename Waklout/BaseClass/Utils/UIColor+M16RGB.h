//
//  UIColor+M16RGB.h
//  M16
//


#import <UIKit/UIKit.h>

@interface UIColor (M16RGB)

// hexString - @"#9c9c9c"
+ (UIColor *)m16_colorwithHexString:(NSString *)hexString;

/** Creates and returns a color object using the specific hex value.
 @param hex The hex value that will decide the color.
 @return The `UIColor` object.
 */
+ (UIColor *)m16_colorWithHex:(unsigned int)hex;

/** Creates and returns a color object using the specific hex value.
 @param hex The hex value that will decide the color.
 @param alpha The opacity of the color.
 @return The `UIColor` object.
 */
+ (UIColor *)m16_colorWithHex:(unsigned int)hex alpha:(CGFloat)alpha;

/** Creates and returns a color object with a random color value. The alpha property is 1.0.
 @return The `UIColor` object.
 */
+ (UIColor *)m16_randomColor;

@end
