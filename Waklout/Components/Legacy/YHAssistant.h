//
//  YHAssistant.h
//  YOHOBoard
//
//  Created by Louis Zhu on 12-7-19.
//  Copyright (c) 2012年 NewPower Co.. All rights reserved.
//

#import <Foundation/Foundation.h>

extern void yoho_dispatch_execute_in_worker_queue(dispatch_block_t block);
extern void yoho_dispatch_execute_in_main_queue(dispatch_block_t block);
extern void yoho_dispatch_execute_in_main_queue_after(int64_t delay, dispatch_block_t block);


extern BOOL yoho_option_contains_bit(NSUInteger option, NSUInteger bit);


typedef NS_ENUM(NSInteger, YHAlertType) {
    YHAlertTypeFail,
    YHAlertTypeSuccess,
    YHAlertTypeNetwork,
};
static NSString * const YHEAPIErrorDomain = @"YHEAPIErrorDomain";
typedef NS_ENUM(NSInteger, YHEFollowerAndFollowingStatus){
    YHEFollowerAndFollowingStatusUnFollower = 0,
    YHEFollowerAndFollowingStatusFollowing,
    YHEFollowerAndFollowingStatusMutualFollowed,
};
typedef NS_ENUM(NSInteger, YHEMasterType){
    YHEMasterTypeNormal,
    YHEMasterTypeV,
    YHEMasterTypeStar,
    YHEMasterTypeBrand
};

@interface NSObject (YOHO)

- (BOOL)notNilOrEmpty;

@end


@interface NSString (YOHO)

- (NSString *)md5String;
- (BOOL)isEmptyAfterTrimmingWhitespaceAndNewlineCharacters;
- (NSString *)stringByTrimmingWhitespaceAndNewlineCharacters;

// 是否是邮箱
- (BOOL)conformsToEMailFormat;
// 长度是否在一个范围之内,包括范围值
- (BOOL)isLengthGreaterThanOrEqual:(NSInteger)minimum lessThanOrEqual:(NSInteger)maximum;

- (NSRange)firstRangeOfURLSubstring;
- (NSString *)firstURLSubstring;
- (NSArray *)URLSubstrings;
- (NSString *)firstMatchUsingRegularExpression:(NSRegularExpression *)regularExpression;
- (NSString *)firstMatchUsingRegularExpressionPattern:(NSString *)regularExpressionPattern;
// 注意这个是全文匹配
- (BOOL)matchesRegularExpressionPattern:(NSString *)regularExpressionPattern;
- (NSRange)rangeOfFirstMatchUsingRegularExpressionPattern:(NSString *)regularExpressionPattern;

- (NSString *)stringByReplacingMatchesUsingRegularExpressionPattern:(NSString *)regularExpressionPattern withTemplate:(NSString *)templ;

- (NSDictionary *)URLParameters;
+ (NSString *)stringWithDate:(NSDate *)date dateFormat:(NSString *)format;

// iOS7出了新的计算字符大小的方法，这里封装一下顺便少写一些参数,当然也只能算出一行的
- (CGFloat)singleLineWidthWithFont:(UIFont *)font;
- (CGFloat)heightWithFont:(UIFont *)font constrainedToWidth:(CGFloat)width;
- (NSRange)fullRange;


@end



@interface NSArray (YOHO)

- (NSArray *)arrayWithObjectsPassingTest:(BOOL (^)(id obj, NSUInteger idx, BOOL *stop))predicate;
- (NSArray *)arrayByRemovingObjectsOfClass:(Class)aClass;
- (NSArray *)arrayByKeepingObjectsOfClass:(Class)aClass;
- (NSArray *)arrayByRemovingObjectsFromArray:(NSArray *)otherArray;

- (NSArray *)transformedArrayUsingHandler:(id (^)(id originalObject, NSUInteger index))handler;

@end


@interface NSMutableArray (YOHO)

+ (NSMutableArray *)nullArrayWithCapacity:(NSUInteger)capacity;
- (void)removeObjectsPassingTest:(BOOL (^)(id obj, NSUInteger idx, BOOL *stop))predicate;
- (void)removeLatterObjectsToKeepObjectsNoMoreThan:(NSInteger)maxCount;
- (void)replaceObject:(id)anObject withObject:(id)anotherObject;
- (void)insertUniqueObject:(id)anObject;
- (void)insertUniqueObject:(id)anObject atIndex:(NSInteger)index;
- (void)insertUniqueObjectsFromArray:(NSArray *)otherArray;
- (void)appendUniqueObjectsFromArray:(NSArray *)otherArray;

@end


@interface NSDictionary (YOHO)

- (NSMutableDictionary *)mutableDeepCopy;
- (NSString *)stringRepresentationByURLEncoding;
- (NSString *)stringForKey:(id)key;
- (NSDate *)dateForKey:(id)key;
- (NSInteger)integerForKey:(id)key;

@end


@interface UIColor (YOHO)

+ (UIColor *)colorWithIntegerRed:(NSInteger)r green:(NSInteger)g blue:(NSInteger)b;
+ (UIColor *)colorWithHexString:(NSString *)string;

@end


@interface UIImage (YOHO)

// 如果参数比原image的size小，是截取原image相应的rect里的部分，如果参数比原image大，则是白底填充原image
- (UIImage *)imageInRect:(CGRect)aRect;
- (UIImage *)centerSquareImage;
- (UIImage *) maskWithImage:(const UIImage *) maskImage;//使用maskImage遮罩原来图片
- (UIImage *)imageScaledToFitUploadSize;
- (UIImage *)scaledToFitSize:(CGSize)size;
- (BOOL)writeToFile:(NSString *)path atomically:(BOOL)useAuxiliaryFile compress:(BOOL)compress;
- (BOOL)writeToFile:(NSString *)path quality:(CGFloat)quality atomically:(BOOL)useAuxiliaryFile compress:(BOOL)compress;
- (UIImage *)fixOrientation;
+ (UIImage *)retina4CompatibleImageNamed:(NSString *)imageName;
+ (UIImage *)patternImageWithColor:(UIColor *)color;
@end


@interface UIView (YOHO)

- (void)removeAllSubviews;
- (void)addSubviews:(NSArray *)sb;
- (void)addAlwaysFitSubview:(UIView *)subview;

- (CGFloat)height;
- (CGFloat)width;

- (void)setOrigin:(CGPoint)origin;
- (void)setSize:(CGSize)size;
- (void)setX:(CGFloat)x;
- (void)setY:(CGFloat)y;
- (void)setWidth:(CGFloat)width;
- (void)setHeight:(CGFloat)height;

- (void)alert:(NSString *)message type:(YHAlertType)type;
- (void)alert:(NSString *)message type:(YHAlertType)type completion:(dispatch_block_t)completion;
- (void)alertNetwork;
- (void)alertDataError;
- (void)showWait;
- (void)hideWait;

@end


@interface UIImageView (YOHO)

+ (id)imageViewWithImageName:(NSString *)imageName;

@end


@interface UILabel (YOHO)

- (void)setFontSize:(NSInteger)size;
- (void)setTextWithDate:(NSDate *)date dateFormat:(NSString *)format;
- (CGFloat)adjustHeightWithText:(NSString *)text constrainedToLineCount:(NSUInteger)maxLineCount;
- (CGFloat)setText:(NSString *)text constrainedToLineCount:(NSUInteger)maxLineCount;

@end


@interface UIButton (YOHO)

+ (id)buttonWithImageName:(NSString *)imageName highlightedImageName:(NSString *)highlightedImageName title:(NSString *)title target:(id)target action:(SEL)action;

@end


@interface UITextField (YOHO)

- (BOOL)isEmptyAfterTrimmingWhitespaceAndNewlineCharacters;

@end


@interface UIViewController (YOHO)

- (void)popWithAnimation;
- (void)dismissModalViewControllerWithAnimation;
- (void)pushViewController:(UIViewController *)viewController;

@end


@interface UITextView (YOHO)

- (BOOL)isEmptyAfterTrimmingWhitespaceAndNewlineCharacters;

@end


@interface UIBarButtonItem (YOHO)

+ (id)itemWithImageName:(NSString *)imageName highlightedImageName:(NSString *)highlightedImageName title:(NSString *)title target:(id)target action:(SEL)action;
+ (id)itemWithImageName:(NSString *)imageName highlightedImageName:(NSString *)highlightedImageName title:(NSString *)title titleColor:(UIColor *)titleColor target:(id)target action:(SEL)action;

+ (id)smallItemWithImageName:(NSString *)imageName highlightedImageName:(NSString *)highlightedImageName title:(NSString *)title target:(id)target action:(SEL)action;
@end


@interface NSDate (YOHO)

//若format为nil ,默认为 yyyy.MM.dd HH: mm: ss 格式
- (NSString *)stringRepresentationWithDateFormat:(NSString *)format;

@end

@interface NSData (YOHO)

- (NSString *)md5Data;

@end


//@interface MBProgressHUD (YOHO)
//
//+ (MBProgressHUD *)alertMessage:(NSString *)aMessage addedTo:(UIView *)view animated:(BOOL)animated;
//+ (MBProgressHUD *)alertMessage:(NSString *)aMessage withDuration:(double)duration addedTo:(UIView *)view animated:(BOOL)animated;
//
//@end


@interface UITableView (YOHO)

- (NSIndexPath *)lastIndexPath;
- (void)scrollToLastRowAnimated:(BOOL)animated;
- (BOOL)lastCellVisible;
// 没有内容的后面也没有线条
- (void)hideTail;

- (BOOL)lastSetSectionVisible:(NSInteger)sectionIndex;

- (BOOL)lastSetRowVisible:(NSInteger)rowsIndex;

- (BOOL)lessOrContainVisibleLastSection:(NSInteger)SectionIndex;
/**
 *  判断tableView是否已经滚动超过指定的行数，适用于只有一个section时
 *
 *  @param rowsIndex 指定的tableView行数
 *
 *  @return BOOL值
 */
- (BOOL)moreOrContainVisibleLastRows:(NSInteger)rowsIndex;

@end

@interface  UICollectionView (YOHO)

- (NSIndexPath *)lastIndexPath;

- (BOOL)lastCellVisible;
/**
 *  确认第多少行cell是否可以访问，只能用于collectionView的layout是UICollectionViewFlowLayout时
 *
 *  @return 返回倒数第几行的cell是否可见
 */
- (BOOL)backwordsFiveCellVisible;

@end

@interface NSFileManager (YOHO)

+ (void)setExcludedFromBackup:(BOOL)excluded forFileAtPath:(NSString *)path;
- (unsigned long long int)documentsFolderSize:(NSString *)documentPath;
- (void)removeFileAtPath:(NSString *)path condition:(BOOL (^)(NSString *))block;
+ (void)removeItemIfExistsAtPath:(NSString *)path error:(NSError **)error;

@end

@interface UIApplication (YOHO)

- (void)startYOHOPush;
- (void)clearNotificationMark;

@end

@interface UIBarButtonItem (YOHOE)

+ (instancetype)borderedBarButtonItemWithTitle:(NSString *)title target:(id)target action:(SEL)action;
+ (instancetype)yheBarButtonWithTitle:(NSString *)title target:(id)target action:(SEL)action hasBorder:(BOOL)hasBorder;
@end