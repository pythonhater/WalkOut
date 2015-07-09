//
//  YHAssistant.m
//  YOHOBoard
//
//  Created by Louis Zhu on 12-7-19.
//  Copyright (c) 2012年 NewPower Co.. All rights reserved.
//

#import "YHAssistant.h"
#import <CommonCrypto/CommonDigest.h>
#import <sys/xattr.h>
#import <CoreGraphics/CoreGraphics.h>
#import <Accelerate/Accelerate.h>


#define kTagWaitView 10099

#ifndef YOHOBuy_YHBConstants_h
#define YOHOBuy_YHBConstants_h

#define kScreenScale                ([UIScreen instancesRespondToSelector:@selector(scale)]?[[UIScreen mainScreen] scale]:(1.0f))
#define kScreenIs4InchRetina        (([UIScreen mainScreen].scale == 2.0f) && ([UIScreen mainScreen].bounds.size.height == 568.0f))


#define kSystemVersion              [[UIDevice currentDevice] systemVersion]

#define kColorStandardGreen     [UIColor colorWithIntegerRed:0x00 green:0x99 blue:0xbb]
#define kStoreKeyPhtotQuality       @"phtotQuality"

#endif


void yoho_dispatch_execute_in_worker_queue(dispatch_block_t block)
{
    dispatch_queue_t workerQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_async(workerQueue, block);
}


void yoho_dispatch_execute_in_main_queue(dispatch_block_t block)
{
    if ([NSThread isMainThread]) {
        block();
    } else {
        dispatch_async(dispatch_get_main_queue(), block);
    }
}


void yoho_dispatch_execute_in_main_queue_after(int64_t delay, dispatch_block_t block)
{
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delay * NSEC_PER_SEC);
    dispatch_after(popTime, dispatch_get_main_queue(), block);
}


BOOL yoho_option_contains_bit(NSUInteger option, NSUInteger bit)
{
    if (option & bit) {
        return YES;
    }
    return NO;
}


@implementation NSObject (YOHO)


- (BOOL)notNilOrEmpty
{
    if ((NSNull *)self == [NSNull null]) {
        return NO;
    }
    
    if ([self respondsToSelector:@selector(count)]) {
        if ([(id)self count] == 0) {
            return NO;
        }
    }
    
    if ([self respondsToSelector:@selector(length)]) {
        if ([(id)self length] == 0) {
            return NO;
        }
    }
    
    return YES;
}

@end


@implementation NSString (YOHO)

- (NSString *)md5String
{
    const char *cStr = [self UTF8String];
    unsigned char result[16];
    CC_MD5( cStr, strlen(cStr), result); // This is the md5 call
    return [NSString stringWithFormat:
            @"%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x",
            result[0], result[1], result[2], result[3], 
            result[4], result[5], result[6], result[7],
            result[8], result[9], result[10], result[11],
            result[12], result[13], result[14], result[15]
            ];  
}


- (BOOL)isEmptyAfterTrimmingWhitespaceAndNewlineCharacters
{
    return [[self stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] length] == 0;
}


- (NSString *)stringByTrimmingWhitespaceAndNewlineCharacters
{
    return [self stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
}


- (NSString *)URLEncodedStringWithCFStringEncoding:(CFStringEncoding)encoding
{
	return  CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(NULL, (__bridge CFStringRef)self, NULL, CFSTR("￼=,!$&'()*+;@?\n\"<>#\t :/"), encoding));
}


- (NSString *)URLEncodedString
{
	return [self URLEncodedStringWithCFStringEncoding:kCFStringEncodingUTF8];
}


+ (NSString *)stringWithDate:(NSDate *)date dateFormat:(NSString *)format
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    NSString *dateFormat = nil;
    if (format == nil) {
        dateFormat = @"y.MM.dd HH: mm: ss";
    } else {
        dateFormat = format;
    }
    formatter.dateFormat = dateFormat;
    NSString *dateString = [formatter stringFromDate:date];
    return dateString;
}


// 是否是邮箱
- (BOOL)conformsToEMailFormat
{
    return [self matchesRegularExpressionPattern:@".+@.+\\..+"];
}


// 长度是否在一个范围之内
- (BOOL)isLengthGreaterThanOrEqual:(NSInteger)minimum lessThanOrEqual:(NSInteger)maximum
{
    return ([self length] >= minimum) && ([self length] <= maximum);
}


- (NSRange)firstRangeOfURLSubstring
{
    static NSDataDetector *dataDetector = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        dataDetector = [NSDataDetector dataDetectorWithTypes:(NSTextCheckingTypeLink | NSTextCheckingTypeLink)
                                                       error:nil];
    });
    
    NSRange range = [dataDetector rangeOfFirstMatchInString:self
                                                    options:0
                                                      range:NSMakeRange(0, [self length])];
    return range;
}


- (NSString *)firstURLSubstring
{
    NSRange range = [self firstRangeOfURLSubstring];
    if (range.location == NSNotFound) {
        return nil;
    }
    
    return [self substringWithRange:range];
}


- (NSArray *)URLSubstrings
{
    static NSDataDetector *dataDetector = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        dataDetector = [NSDataDetector dataDetectorWithTypes:(NSTextCheckingTypeLink | NSTextCheckingTypeLink)
                                                       error:nil];
    });
    
    NSArray *matches = [dataDetector matchesInString:self
                                                options:0
                                                  range:NSMakeRange(0, [self length])];
    NSMutableArray *substrings = [NSMutableArray arrayWithCapacity:[matches count]];
    for (NSTextCheckingResult *result in matches) {
        [substrings addObject:[result.URL absoluteString]];
    }
    return [NSArray arrayWithArray:substrings];
}


- (NSString *)firstMatchUsingRegularExpression:(NSRegularExpression *)regularExpression
{
    NSRange range = [regularExpression rangeOfFirstMatchInString:self
                                                         options:0
                                                           range:NSMakeRange(0, [self length])];
    if (range.location == NSNotFound) {
        return nil;
    }
    
    return [self substringWithRange:range];
}


- (NSString *)firstMatchUsingRegularExpressionPattern:(NSString *)regularExpressionPattern
{
    NSRegularExpression *regularExpression = [NSRegularExpression regularExpressionWithPattern:regularExpressionPattern
                                                                                       options:NSRegularExpressionCaseInsensitive
                                                                                         error:nil];
    return [self firstMatchUsingRegularExpression:regularExpression];
}


- (BOOL)matchesRegularExpressionPattern:(NSString *)regularExpressionPattern
{
    NSRange fullRange = NSMakeRange(0, [self length]);
    NSRegularExpression *regularExpression = [NSRegularExpression regularExpressionWithPattern:regularExpressionPattern
                                                                                       options:NSRegularExpressionCaseInsensitive
                                                                                         error:nil];
    NSRange range = [regularExpression rangeOfFirstMatchInString:self
                                                         options:0
                                                           range:fullRange];
    if (NSEqualRanges(fullRange, range)) {
        return YES;
    }
    return NO;
}


- (NSRange)rangeOfFirstMatchUsingRegularExpressionPattern:(NSString *)regularExpressionPattern
{
    NSRegularExpression *regularExpression = [NSRegularExpression regularExpressionWithPattern:regularExpressionPattern
                                                                                       options:NSRegularExpressionCaseInsensitive
                                                                                         error:nil];
    NSRange range = [regularExpression rangeOfFirstMatchInString:self
                                                         options:0
                                                           range:NSMakeRange(0, [self length])];
    return range;
}


- (NSString *)stringByReplacingMatchesUsingRegularExpressionPattern:(NSString *)regularExpressionPattern withTemplate:(NSString *)templ
{
    NSRegularExpression *regularExpression = [NSRegularExpression regularExpressionWithPattern:regularExpressionPattern
                                                                                       options:NSRegularExpressionCaseInsensitive
                                                                                         error:nil];
    NSString *string = [regularExpression stringByReplacingMatchesInString:self
                                                                   options:0
                                                                     range:NSMakeRange(0, [self length])
                                                              withTemplate:templ];
    return string;
}


- (NSDictionary *)URLParameters
{
    NSString *urlString = [self stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSRange rangeOfQuestionMark = [urlString rangeOfString:@"?" options:NSBackwardsSearch];
    if (rangeOfQuestionMark.location == NSNotFound) {
        return nil;
    }
    
    NSString *parametersString = [urlString substringFromIndex:(rangeOfQuestionMark.location + 1)];
    NSArray *pairs = [parametersString componentsSeparatedByString:@"&"];
    NSMutableDictionary *parameters = [NSMutableDictionary dictionaryWithCapacity:[pairs count]];
    for (NSString *aPair in pairs) {
        NSArray *keyAndValue = [aPair componentsSeparatedByString:@"="];
        if ([keyAndValue count] == 2) {
            [parameters setObject:keyAndValue[1] forKey:keyAndValue[0]];
        }
    }
    return parameters;
}


- (CGFloat)singleLineWidthWithFont:(UIFont *)font;
{
    if (iOS7_OR_LATER) {
        return ceilf([self boundingRectWithSize:CGSizeMake(CGFLOAT_MAX, CGFLOAT_MIN) options:0 attributes:@{NSFontAttributeName:font} context:nil].size.width);
    }
    else {
        return [self sizeWithFont:font constrainedToSize:CGSizeMake(CGFLOAT_MAX, CGFLOAT_MIN)].width;
    }
}


- (CGFloat)heightWithFont:(UIFont *)font constrainedToWidth:(CGFloat)width
{
    if (iOS7_OR_LATER) {
        return ceilf([self boundingRectWithSize:CGSizeMake(width, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:font} context:nil].size.height);
    }
    else {
        return [self sizeWithFont:font constrainedToSize:CGSizeMake(width, CGFLOAT_MAX)].height;
    }
}


- (NSRange)fullRange
{
    return NSMakeRange(0, self.length);
}




@end


@implementation NSArray (YOHO)


- (NSArray *)arrayWithObjectsPassingTest:(BOOL (^)(id obj, NSUInteger idx, BOOL *stop))predicate
{
    NSIndexSet *indexes = [self indexesOfObjectsPassingTest:predicate];
    return [self objectsAtIndexes:indexes];
}


- (NSArray *)arrayByRemovingObjectsOfClass:(Class)aClass
{
    NSMutableArray *array = [NSMutableArray arrayWithArray:self];
    [array removeObjectsPassingTest:^BOOL(id obj, NSUInteger idx, BOOL *stop) {
        if ([obj isKindOfClass:aClass]) {
            return YES;
        }
        else return NO;
    }];
    return [[NSArray alloc] initWithArray:array];
}


- (NSArray *)arrayByKeepingObjectsOfClass:(Class)aClass
{
    NSMutableArray *array = [NSMutableArray arrayWithArray:self];
    [array removeObjectsPassingTest:^BOOL(id obj, NSUInteger idx, BOOL *stop) {
        if ([obj isKindOfClass:aClass]) {
            return NO;
        }
        else return YES;
    }];
    return [[NSArray alloc] initWithArray:array];
}


- (NSArray *)arrayByRemovingObjectsFromArray:(NSArray *)otherArray
{
    NSPredicate *predicate = [NSPredicate predicateWithBlock:^BOOL(id evaluatedObject, NSDictionary *bindings) {
        return ![otherArray containsObject:evaluatedObject];
    }];
    return [self filteredArrayUsingPredicate:predicate];
}


- (NSArray *)transformedArrayUsingHandler:(id (^)(id originalObject, NSUInteger index))handler
{
    NSMutableArray *tempArray = [NSMutableArray arrayWithCapacity:[self count]];
    for (NSInteger i = 0; i < [self count]; i++) {
        id resultObject = handler(self[i], i);
        [tempArray addObject:resultObject];
    }
    return [NSArray arrayWithArray:tempArray];
}


@end


@implementation NSMutableArray (YOHO)


+ (NSMutableArray *)nullArrayWithCapacity:(NSUInteger)capacity
{
    NSMutableArray *array = [[NSMutableArray alloc] initWithCapacity:capacity];
    for (NSInteger i = 0; i < capacity; i++) {
        [array addObject:[NSNull null]];
    }
    return array;
}


- (void)removeObjectsPassingTest:(BOOL (^)(id obj, NSUInteger idx, BOOL *stop))predicate
{
    NSIndexSet *indexes = [self indexesOfObjectsPassingTest:predicate];
    [self removeObjectsAtIndexes:indexes];
}


- (void)removeLatterObjectsToKeepObjectsNoMoreThan:(NSInteger)maxCount
{
    if ([self count] > maxCount) {
        [self removeObjectsInRange:NSMakeRange(maxCount, [self count] - maxCount)];
    }
}


- (void)replaceObject:(id)anObject withObject:(id)anotherObject
{
    NSInteger index = [self indexOfObject:anObject];
    if (index != NSNotFound) {
        [self replaceObjectAtIndex:index withObject:anotherObject];
    }
}


- (void)insertUniqueObject:(id)anObject
{
    [self insertUniqueObject:anObject atIndex:[self count]];
}


- (void)insertUniqueObject:(id)anObject atIndex:(NSInteger)index
{
    for (id object in self) {
        if ([object isEqual:anObject]) {
            return;
        }
    }
    if (index < 0 || index > [self count]) {
        return;
    }
    [self insertObject:anObject atIndex:index];
}


- (void)insertUniqueObjectsFromArray:(NSArray *)otherArray
{
    NSArray *objectsToInsert = [otherArray arrayByRemovingObjectsFromArray:self];
    NSIndexSet *indexSet = [NSIndexSet indexSetWithIndexesInRange:NSMakeRange(0, [objectsToInsert count])];
    [self insertObjects:objectsToInsert atIndexes:indexSet];
}


- (void)appendUniqueObjectsFromArray:(NSArray *)otherArray
{
    NSArray *objectsToAppend = [otherArray arrayByRemovingObjectsFromArray:self];
    [self addObjectsFromArray:objectsToAppend];
}


@end


@implementation NSDictionary (YOHO)


- (NSMutableDictionary *)mutableDeepCopy
{
    NSMutableDictionary *ret = [[NSMutableDictionary alloc] initWithCapacity:[self count]];
    NSArray *keys = [self allKeys];
    for (id key in keys)
    {
        id oneValue = [self valueForKey:key];
        id oneCopy = nil;
        
        if ([oneValue respondsToSelector:@selector(mutableDeepCopy)])
            oneCopy = [oneValue mutableDeepCopy];
        else if ([oneValue respondsToSelector:@selector(mutableCopy)])
            oneCopy = [oneValue mutableCopy];
        if (oneCopy == nil)
            oneCopy = [oneValue copy];
        [ret setValue:oneCopy forKey:key];
    }
    return ret;
}


- (NSString *)stringRepresentationByURLEncoding
{
    NSMutableArray *pairs = [NSMutableArray array];
	for (NSString *key in [self allKeys])
	{
        id object = [self objectForKey:key];
        if (![object isKindOfClass:[NSString class]]) {
            continue;
        }
		[pairs addObject:[NSString stringWithFormat:@"%@=%@", key, [object URLEncodedString]]];
	}
	return [pairs componentsJoinedByString:@"&"];
}


- (NSString *)stringForKey:(id)key
{
    id object = [self objectForKey:key];
    if ([object isEqual:[NSNull null]]) {
        return @"";
    }
    if (![object isKindOfClass:[NSString class]]) {
        return [NSString stringWithFormat:@"%@", object];
    }
    return object;
}


- (NSDate *)dateForKey:(id)key
{
    id object = [self objectForKey:key];
    if ([object isKindOfClass:[NSDate class]]) {
        return object;
    }
    
    if ([object isKindOfClass:[NSNumber class]]) {
        NSNumber *number = (NSNumber *)object;
        NSTimeInterval timeInterval = [number doubleValue];
        return [NSDate dateWithTimeIntervalSince1970:timeInterval];
    }
    
    return nil;
}


- (NSInteger)integerForKey:(id)key
{
    id object = [self objectForKey:key];
    if ([object respondsToSelector:@selector(integerValue)]) {
        NSNumber *number = (NSNumber *)object;
        return [number integerValue];
    }
    
    return 0;
}


@end


@implementation UIColor (YOHO)

+ (UIColor *)colorWithIntegerRed:(NSInteger)r green:(NSInteger)g blue:(NSInteger)b
{
    return [UIColor colorWithRed:((CGFloat)(r) / 255.0f) green:((CGFloat)(g) / 255.0f) blue:((CGFloat)(b) / 255.0f) alpha:1.0f];
}


+ (UIColor *)colorWithHexString:(NSString *)string
{
    NSString *pureHexString = [[string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] uppercaseString];
	
	if ([pureHexString length] != 6) {
        return [UIColor whiteColor];
    }
    
	NSRange range;
	range.location = 0;
	range.length = 2;
	NSString *rString = [pureHexString substringWithRange:range];
	
	range.location += range.length ;
	NSString *gString = [pureHexString substringWithRange:range];
	
	range.location += range.length ;
	NSString *bString = [pureHexString substringWithRange:range];
	
	unsigned int r, g, b;
	[[NSScanner scannerWithString:rString] scanHexInt:&r];
	[[NSScanner scannerWithString:gString] scanHexInt:&g];
	[[NSScanner scannerWithString:bString] scanHexInt:&b];
	
	return [UIColor colorWithRed:((float) r / 255.0f)
						   green:((float) g / 255.0f)
							blue:((float) b / 255.0f)
						   alpha:1.0f];
}

@end


@implementation UIImage (YOHO)

- (BOOL)writeToFile:(NSString *)path atomically:(BOOL)useAuxiliaryFile compress:(BOOL)compress
{
//    CGFloat quality = 1.0f;
    if (compress) {
        NSString *photoQuality = [[NSUserDefaults standardUserDefaults] objectForKey:kStoreKeyPhtotQuality];
        NSData *data = (photoQuality ? UIImageJPEGRepresentation(self, [photoQuality floatValue]) : UIImageJPEGRepresentation(self, 1.0f));
        
        NSString *parentDirPath = [path stringByDeletingLastPathComponent];
        BOOL isExistDir = [[NSFileManager defaultManager] fileExistsAtPath:parentDirPath];
        if (!isExistDir)
        {
            NSLog(@"\n\n错误:writeToFile:atomically:compress: 在存储图片%@时 发现父级目录不存在", path);
            return NO;
        }
        if ([[NSFileManager defaultManager] fileExistsAtPath:path])
        {
            NSLog(@"\n\n警告:writeToFile:atomically:compress: 在存储图片%@时 发现同名文件已经存在, 将有可能被覆盖", path);
        }
        
        return [data writeToFile:path atomically:useAuxiliaryFile];
    }
    else {
        NSString *parentDirPath = [path stringByDeletingLastPathComponent];
        BOOL isExistDir = [[NSFileManager defaultManager] fileExistsAtPath:parentDirPath];
        if (!isExistDir) {
            [[NSFileManager defaultManager] createDirectoryAtPath:path withIntermediateDirectories:YES attributes:NO error:NULL];
        }
        NSData *imageData = UIImagePNGRepresentation(self);
        return [imageData writeToFile:path atomically:useAuxiliaryFile];
    }
}


- (BOOL)writeToFile:(NSString *)path  quality:(CGFloat)quality atomically:(BOOL)useAuxiliaryFile compress:(BOOL)compress
{
    if (compress) {
        NSString *photoQuality = [[NSUserDefaults standardUserDefaults] objectForKey:kStoreKeyPhtotQuality];
        NSData *data = (photoQuality ? UIImageJPEGRepresentation(self, [photoQuality floatValue]) : UIImageJPEGRepresentation(self, quality));
        
        NSString *parentDirPath = [path stringByDeletingLastPathComponent];
        BOOL isExistDir = [[NSFileManager defaultManager] fileExistsAtPath:parentDirPath];
        if (!isExistDir)
        {
            NSLog(@"\n\n错误:writeToFile:atomically:compress: 在存储图片%@时 发现父级目录不存在", path);
            return NO;
        }
        if ([[NSFileManager defaultManager] fileExistsAtPath:path])
        {
            NSLog(@"\n\n警告:writeToFile:atomically:compress: 在存储图片%@时 发现同名文件已经存在, 将有可能被覆盖", path);
        }
        
        return [data writeToFile:path atomically:useAuxiliaryFile];
    }
    else {
        NSData *imageData = UIImagePNGRepresentation(self);
        return [imageData writeToFile:path atomically:useAuxiliaryFile];
    }
}


- (UIImage *)imageInRect:(CGRect)aRect
{
    CGImageRef cg = self.CGImage;
    CGFloat scale = self.scale;
    CGRect rectInCGImage = CGRectMake(aRect.origin.x * scale, aRect.origin.y * scale, aRect.size.width * scale, aRect.size.height * scale);
    CGImageRef newCG = CGImageCreateWithImageInRect(cg, rectInCGImage);
    UIImage *image = [UIImage imageWithCGImage:newCG scale:scale orientation:self.imageOrientation];
    CGImageRelease(newCG);
    return image;
}


- (UIImage *)centerSquareImage
{
    CGImageRef cg = self.CGImage;
    size_t width = CGImageGetWidth(cg);
    size_t height = CGImageGetHeight(cg);
    size_t length = MIN(width, height);
    CGRect rect = CGRectMake(((width / 2.0f) - (length / 2.0f)), ((height / 2.0f) - (length / 2.0f)), length, length);
    CGImageRef newCG = CGImageCreateWithImageInRect(cg, rect);
    UIImage *image = [UIImage imageWithCGImage:newCG scale:kScreenScale orientation:self.imageOrientation];
    CGImageRelease(newCG);
    return image;
}


- (UIImage *)imageScaledToFitUploadSize
{
    UIImage *imageWithoutScale = [UIImage imageWithCGImage:self.CGImage scale:1.0f orientation:self.imageOrientation];
    CGSize size = imageWithoutScale.size;
    if (CGSizeEqualToSize(size, CGSizeZero)) {
        return self;
    }
    
    if ((size.width * size.height) <= 320000.0f) {
        return self;
    }
    
    CGFloat scale = sqrtf(320000.0f / size.width / size.height);
    CGSize newSize = CGSizeMake(ceilf(size.width * scale), ceilf(size.height * scale));
    
    UIGraphicsBeginImageContextWithOptions(newSize, NO, 1.0f);
    [imageWithoutScale drawInRect:CGRectMake(0.0f, 0.0f, newSize.width, newSize.height)]; // the actual scaling happens here, and orientation is taken care of automatically.
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}


- (UIImage *)scaledToFitSize:(CGSize)size
{
    // 创建一个bitmap的context 
    // 并把它设置成为当前正在使用的context 
    UIGraphicsBeginImageContext(size); 
    // 绘制改变大小的图片 
    [self drawInRect:CGRectMake(0.0f, 0.0f, size.width, size.height)];
    // 从当前context中创建一个改变大小后的图片 
    UIImage* scaledImage = UIGraphicsGetImageFromCurrentImageContext(); 
    // 使当前的context出堆栈 
    UIGraphicsEndImageContext(); 
    // 返回新的改变大小后的图片 
    return scaledImage; 
}

- (UIImage *) maskWithImage:(const UIImage *) maskImage
{
    if(!maskImage)
    {
        NSLog(@"Error:maskWithImage is nil");
        return nil;
    }
    CGImageRef imageRef = maskImage.CGImage;
    CGSize imageSize = CGSizeMake(CGImageGetWidth(imageRef), CGImageGetHeight(imageRef));
    CGRect imageRect = (CGRect){.origin = CGPointZero, .size = imageSize};
    
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGBitmapInfo bitmapInfo = CGImageGetBitmapInfo(imageRef);
    
    int infoMask = (bitmapInfo & kCGBitmapAlphaInfoMask);
    BOOL anyNonAlpha = (infoMask == kCGImageAlphaNone ||
                        infoMask == kCGImageAlphaNoneSkipFirst ||
                        infoMask == kCGImageAlphaNoneSkipLast);
    
    // CGBitmapContextCreate doesn't support kCGImageAlphaNone with RGB.
    // https://developer.apple.com/library/mac/#qa/qa1037/_index.html
    if (infoMask == kCGImageAlphaNone && CGColorSpaceGetNumberOfComponents(colorSpace) > 1) {
        // Unset the old alpha info.
        bitmapInfo &= ~kCGBitmapAlphaInfoMask;
        
        // Set noneSkipFirst.
        bitmapInfo |= kCGImageAlphaNoneSkipFirst;
    }
    // Some PNGs tell us they have alpha but only 3 components. Odd.
    else if (!anyNonAlpha && CGColorSpaceGetNumberOfComponents(colorSpace) == 3) {
        // Unset the old alpha info.
        bitmapInfo &= ~kCGBitmapAlphaInfoMask;
        bitmapInfo |= kCGImageAlphaPremultipliedFirst;
    }
    
    // It calculates the bytes-per-row based on the bitsPerComponent and width arguments.
    CGContextRef mainViewContentContext = CGBitmapContextCreate(NULL,
                                                 imageSize.width,
                                                 imageSize.height,
                                                 CGImageGetBitsPerComponent(imageRef),
                                                 0,
                                                 colorSpace,
                                                 bitmapInfo);
    
    CGColorSpaceRelease(colorSpace);
    
    CGContextClipToMask(mainViewContentContext, imageRect, imageRef);
    CGContextDrawImage(mainViewContentContext, imageRect, self.CGImage);
    
    CGImageRef newImage = CGBitmapContextCreateImage(mainViewContentContext);
    CGContextRelease(mainViewContentContext);
    
    UIImage *theImage = [UIImage imageWithCGImage:newImage];
    
    CGImageRelease(newImage);
    
    return theImage;
    
}

+ (UIImage *)retina4CompatibleImageNamed:(NSString *)imageName
{
    if (kScreenIs4InchRetina) {
        NSString *retina4ImageName = [imageName stringByAppendingString:@"-568h"];
        return [UIImage imageNamed:retina4ImageName];
    }
    else {
        return [UIImage imageNamed:imageName];
    }
}


+ (UIImage *)patternImageWithColor:(UIColor *)color
{
    UIGraphicsBeginImageContextWithOptions(CGSizeMake(1.0f, 1.0f), NO, 0.0f);
    CGContextRef context = UIGraphicsGetCurrentContext();
    [color set];
    CGContextFillRect(context, CGRectMake(0.0f, 0.0f, 1.0f, 1.0f));
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}



- (UIImage *)fixOrientation
{
    
    // No-op if the orientation is already correct
    if (self.imageOrientation == UIImageOrientationUp)
        return self;
    
    // We need to calculate the proper transformation to make the image upright.
    // We do it in 2 steps: Rotate if Left/Right/Down, and then flip if Mirrored.
    CGAffineTransform transform = CGAffineTransformIdentity;
    
    switch (self.imageOrientation) {
        case UIImageOrientationDown:
        case UIImageOrientationDownMirrored:
            transform = CGAffineTransformTranslate(transform, self.size.width, self.size.height);
            transform = CGAffineTransformRotate(transform, M_PI);
            break;
            
        case UIImageOrientationLeft:
        case UIImageOrientationLeftMirrored:
            transform = CGAffineTransformTranslate(transform, self.size.width, 0.0f);
            transform = CGAffineTransformRotate(transform, M_PI_2);
            break;
            
        case UIImageOrientationRight:
        case UIImageOrientationRightMirrored:
            transform = CGAffineTransformTranslate(transform, 0.0f, self.size.height);
            transform = CGAffineTransformRotate(transform, - M_PI_2);
            break;
        default:
            break;
    }
    
    switch (self.imageOrientation) {
        case UIImageOrientationUpMirrored:
        case UIImageOrientationDownMirrored:
            transform = CGAffineTransformTranslate(transform, self.size.width, 0.0f);
            transform = CGAffineTransformScale(transform, -1.0f, 1.0f);
            break;
            
        case UIImageOrientationLeftMirrored:
        case UIImageOrientationRightMirrored:
            transform = CGAffineTransformTranslate(transform, self.size.height, 0.0f);
            transform = CGAffineTransformScale(transform, -1.0f, 1.0f);
            break;
        default:
            break;
    }
    
    // Now we draw the underlying CGImage into a new context, applying the transform
    // calculated above.
    CGContextRef ctx = CGBitmapContextCreate(NULL, self.size.width, self.size.height,
                                             CGImageGetBitsPerComponent(self.CGImage), 0.0f,
                                             CGImageGetColorSpace(self.CGImage),
                                             CGImageGetBitmapInfo(self.CGImage));
    CGContextConcatCTM(ctx, transform);
    switch (self.imageOrientation) {
        case UIImageOrientationLeft:
        case UIImageOrientationLeftMirrored:
        case UIImageOrientationRight:
        case UIImageOrientationRightMirrored:
            // Grr...
            CGContextDrawImage(ctx, CGRectMake(0.0f, 0.0f, self.size.height, self.size.width), self.CGImage);
            break;
            
        default:
            CGContextDrawImage(ctx, CGRectMake(0.0f, 0.0f, self.size.width, self.size.height), self.CGImage);
            break;
    }
    
    // And now we just create a new UIImage from the drawing context
    CGImageRef cgimg = CGBitmapContextCreateImage(ctx);
    UIImage *img = [UIImage imageWithCGImage:cgimg];
    CGContextRelease(ctx);
    CGImageRelease(cgimg);
    return img;
}

// 设置图片模糊效果
+ (UIImage *)blurredImageWithImage:(UIImage *)image blur:(CGFloat)blur {
    if (blur < 0.f || blur > 1.f) {
        blur = 0.5f;
    }
    int boxSize = (int)(blur * 50);
    boxSize = boxSize - (boxSize % 2) + 1;
    
    CGImageRef img = image.CGImage;
    vImage_Buffer inBuffer, outBuffer;
    vImage_Error error;
    void *pixelBuffer;
    
    //create vImage_Buffer with data from CGImageRef
    if (img == NULL) {
        return image;
    }
    CGDataProviderRef inProvider = CGImageGetDataProvider(img);
    CFDataRef inBitmapData = CGDataProviderCopyData(inProvider);
    
    inBuffer.width = CGImageGetWidth(img);
    inBuffer.height = CGImageGetHeight(img);
    inBuffer.rowBytes = CGImageGetBytesPerRow(img);
    inBuffer.data = (void*)CFDataGetBytePtr(inBitmapData);
    
    //create vImage_Buffer for output
    
    pixelBuffer = malloc(CGImageGetBytesPerRow(img) * CGImageGetHeight(img));
    
    if(pixelBuffer == NULL)
        NSLog(@"No pixelbuffer");
    outBuffer.data = pixelBuffer;
    outBuffer.width = CGImageGetWidth(img);
    outBuffer.height = CGImageGetHeight(img);
    outBuffer.rowBytes = CGImageGetBytesPerRow(img);
    
    //perform convolution
    error = vImageBoxConvolve_ARGB8888(&inBuffer, &outBuffer, NULL, 0, 0, boxSize, boxSize, NULL, kvImageEdgeExtend);
    if (error) {
        NSLog(@"error from convolution %ld", error);
    }
    
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGContextRef ctx = CGBitmapContextCreate(outBuffer.data,
                                             outBuffer.width,
                                             outBuffer.height,
                                             8,
                                             outBuffer.rowBytes,
                                             colorSpace,
                                             CGImageGetBitmapInfo(image.CGImage));
    CGImageRef imageRef = CGBitmapContextCreateImage (ctx);
    UIImage *returnImage = [UIImage imageWithCGImage:imageRef];
    //    CGBitmapInfo
    //clean up
    CGContextRelease(ctx);
    CGColorSpaceRelease(colorSpace);
    
    free(pixelBuffer);
    CFRelease(inBitmapData);
    CGImageRelease(imageRef);
    return returnImage;
}

@end


@implementation UIImageView (YOHO)

+ (id)imageViewWithImageName:(NSString *)imageName
{
    return [[self alloc] initWithImage:[UIImage imageNamed:imageName]];
}

@end


@implementation UIView (YOHO)


- (void)removeAllSubviews
{
    [self.subviews enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        [obj removeFromSuperview];
    }];
}


- (void)addSubviews:(NSArray *)sb
{
    if ([sb count] == 0) {
        return;
    }
    
    [sb enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        [self addSubview:obj];
    }];
}


- (void)addAlwaysFitSubview:(UIView *)subview
{
    subview.frame = self.bounds;
    if (NSClassFromString(@"NSLayoutConstraint")) {
        [subview setTranslatesAutoresizingMaskIntoConstraints:NO];
        [self addSubview:subview];
        [self addConstraint:[NSLayoutConstraint constraintWithItem:subview
                                                         attribute:NSLayoutAttributeLeft
                                                         relatedBy:NSLayoutRelationEqual
                                                            toItem:self
                                                         attribute:NSLayoutAttributeLeft
                                                        multiplier:1.0f
                                                          constant:0.0f]];
        [self addConstraint:[NSLayoutConstraint constraintWithItem:subview
                                                         attribute:NSLayoutAttributeRight
                                                         relatedBy:NSLayoutRelationEqual
                                                            toItem:self
                                                         attribute:NSLayoutAttributeRight
                                                        multiplier:1.0f
                                                          constant:0.0f]];
        [self addConstraint:[NSLayoutConstraint constraintWithItem:subview
                                                         attribute:NSLayoutAttributeTop
                                                         relatedBy:NSLayoutRelationEqual
                                                            toItem:self
                                                         attribute:NSLayoutAttributeTop
                                                        multiplier:1.0f
                                                          constant:0.0f]];
        [self addConstraint:[NSLayoutConstraint constraintWithItem:subview
                                                         attribute:NSLayoutAttributeBottom
                                                         relatedBy:NSLayoutRelationEqual
                                                            toItem:self
                                                         attribute:NSLayoutAttributeBottom
                                                        multiplier:1.0f
                                                          constant:0.0f]];
    }
    else {
        subview.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        [self addSubview:subview];
    }
}


- (CGFloat)height
{
    return self.frame.size.height;
}


- (CGFloat)width
{
    return self.frame.size.width;
}


- (void)setOrigin:(CGPoint)origin
{
    CGRect frame = self.frame;
    frame.origin = origin;
    self.frame = frame;
}


- (void)setSize:(CGSize)size
{
    CGRect frame = self.frame;
    frame.size = size;
    self.frame = frame;
}


- (void)setX:(CGFloat)x
{
    CGRect frame = self.frame;
    frame.origin.x = x;
    self.frame = frame;
}


- (void)setY:(CGFloat)y
{
    CGRect frame = self.frame;
    frame.origin.y = y;
    self.frame = frame;
}


- (void)setWidth:(CGFloat)width
{
    CGRect frame = self.frame;
    frame.size.width = width;
    self.frame = frame;
}


- (void)setHeight:(CGFloat)height
{
    if (height< 0.0f) {
        height = 0.f;
//        NSLog(@"errrrrrrrrrrrrrrrrrrr");
    }
    CGRect frame = self.frame;
    frame.size.height = height;
    self.frame = frame;
}


- (void)alert:(NSString *)message type:(YHAlertType)type
{
    [self alert:message type:type completion:nil];
}


- (void)alert:(NSString *)message type:(YHAlertType)type completion:(dispatch_block_t)completion
{
//    MBProgressHUD *hud = [[MBProgressHUD alloc] initWithView:self];
//    hud.detailsLabelFont = [UIFont systemFontOfSize:12.0f];
//    hud.detailsLabelText = message;
//    hud.yOffset = -80.0f;
//    hud.removeFromSuperViewOnHide = YES;
//    
//    NSString *alertImageName = @"";
//    if (type == YHAlertTypeFail) {
//        alertImageName = @"shared_alert_fail";
//    }
//    else if (type == YHAlertTypeSuccess) {
//        alertImageName = @"shared_alert_success";
//    }
//    else if (type == YHAlertTypeNetwork) {
//        alertImageName = @"shared_alert_network";
//    }
//    hud.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:alertImageName]];
//    hud.mode = MBProgressHUDModeCustomView;
//    
//    [self addSubview:hud];
//    [hud show:YES];
//    double delayInSeconds = 2.0;
//    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
//    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
//        [hud hide:YES];
//        if (completion) {
//            completion();
//        }
//    });
}


- (void)alertNetwork
{

//    [self alert:NSLocalizedInfoPlistString(@"network failure, please try again later.", @"") type:YHAlertTypeNetwork];
}



- (void)alertDataError
{
    [self alert:@"data error" type:YHAlertTypeNetwork];
}


- (void)showWait
{
//    MBProgressHUD *hud = [[MBProgressHUD alloc] initWithView:self];
//    hud.yOffset = -80.0f;
//    //    hud.removeFromSuperViewOnHide = YES;
//    hud.tag = kTagWaitView;
//    hud.mode = MBProgressHUDModeIndeterminate;
//    [self addSubview:hud];
//    [self bringSubviewToFront:hud];
//    [hud show:YES];
}


- (void)hideWait
{
//    [[self viewWithTag:kTagWaitView] removeFromSuperview];
//    [MBProgressHUD hideHUDForView:self animated:NO];
}

@end


@implementation UILabel (YOHO)


- (void)setFontSize:(NSInteger)size
{
    self.font = [UIFont systemFontOfSize:size];
}


- (void)setTextWithDate:(NSDate *)date dateFormat:(NSString *)format
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    NSString *dateFormat = nil;
    if (format == nil) {
        dateFormat = @"yyyy.MM.dd HH: mm: ss";
    } else {
        dateFormat = format;
    }
    formatter.dateFormat = dateFormat;
    NSString *dateString = [formatter stringFromDate:date];
    self.text = dateString;
}


- (CGFloat)adjustHeightWithText:(NSString *)text constrainedToLineCount:(NSUInteger)maxLineCount
{
    CGFloat height = 0.0f;
    if (maxLineCount == 0) {
        CGSize size = [text sizeWithFont:self.font
                       constrainedToSize:CGSizeMake(self.frame.size.width, CGFLOAT_MAX)
                           lineBreakMode:NSLineBreakByWordWrapping];
        height = size.height;
    }
    else {
        NSMutableString *testString = [NSMutableString stringWithString:@"X"];
        for (NSInteger i = 0; i < maxLineCount - 1; i++) {
            [testString appendString:@"\nX"];
        }
        
        CGFloat maxHeight = [testString sizeWithFont:self.font
                                   constrainedToSize:CGSizeMake(self.frame.size.width, CGFLOAT_MAX)
                                       lineBreakMode:NSLineBreakByWordWrapping].height;
        CGFloat textHeight = [text sizeWithFont:self.font
                              constrainedToSize:CGSizeMake(self.frame.size.width, CGFLOAT_MAX)
                                  lineBreakMode:NSLineBreakByWordWrapping].height;
        height = MIN(maxHeight, textHeight);
    }
    
    height = ceilf(height);
    
    CGRect frame = self.frame;
    frame.size.height = height;
    self.frame = frame;
    self.numberOfLines = maxLineCount;
    return height;
}



- (CGFloat)setText:(NSString *)text constrainedToLineCount:(NSUInteger)maxLineCount
{
    CGFloat height = [self adjustHeightWithText:text constrainedToLineCount:maxLineCount];
    self.numberOfLines = maxLineCount;
    self.text = text;
    return height;
}

@end


@implementation UIButton (YOHO)


+ (id)buttonWithImageName:(NSString *)imageName highlightedImageName:(NSString *)highlightedImageName title:(NSString *)title target:(id)target action:(SEL)action
{
    UIImage *image = [UIImage imageNamed:imageName];
    UIImage *highlightedImage = nil;
    if (highlightedImageName != nil) {
        highlightedImage = [UIImage imageNamed:highlightedImageName];
    }
    CGSize imageSize = [image size];
    CGSize highlightedImageSize = [highlightedImage size];
    if (highlightedImageName != nil) {
        if (!image || !highlightedImage) {
            return nil;
        }
        if (!CGSizeEqualToSize(imageSize, highlightedImageSize)) {
            return nil;
        }
    }
    else {
        if (!image) {
            return nil;
        }
    }
    
    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(0.0f, 0.0f, imageSize.width, imageSize.height)];
    if (title != nil) {
        [button setTitle:title forState:UIControlStateNormal];
        [button.titleLabel setFont:[UIFont boldSystemFontOfSize:12.0f]];
        [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    }
    [button setBackgroundImage:image forState:UIControlStateNormal];
    if (highlightedImageName) {
        [button setBackgroundImage:highlightedImage forState:UIControlStateHighlighted];
    }
    [button addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    return button;
}


@end


@implementation UITextField (YOHO)

- (BOOL)isEmptyAfterTrimmingWhitespaceAndNewlineCharacters
{
    return self.text == nil || [self.text isEmptyAfterTrimmingWhitespaceAndNewlineCharacters];
}

@end


@implementation UITextView (YOHO)

- (BOOL)isEmptyAfterTrimmingWhitespaceAndNewlineCharacters
{
    return self.text == nil || [self.text isEmptyAfterTrimmingWhitespaceAndNewlineCharacters];
}

@end


@implementation UIBarButtonItem (YOHO)


+ (id)itemWithImageName:(NSString *)imageName highlightedImageName:(NSString *)highlightedImageName title:(NSString *)title target:(id)target action:(SEL)action
{
    UIButton *button = [UIButton buttonWithImageName:imageName highlightedImageName:highlightedImageName title:(NSString *)title target:target action:action];
    if (button == nil) {
        return nil;
    }
    return [[UIBarButtonItem alloc] initWithCustomView:button];
}

+ (id)smallItemWithImageName:(NSString *)imageName highlightedImageName:(NSString *)highlightedImageName title:(NSString *)title target:(id)target action:(SEL)action
{
    UIButton *button = [UIButton buttonWithImageName:imageName highlightedImageName:highlightedImageName title:(NSString *)title target:target action:action];
    if (button == nil) {
        return nil;
    }
    CGRect frame = button.frame;
    frame.origin.x = -7.0f;
    frame.origin.y = -7.0f;
    button.frame = frame;
    UIView *menuButtonContainer = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 30.0f, 30.0f)];
    [menuButtonContainer addSubview:button];
    return [[UIBarButtonItem alloc] initWithCustomView:menuButtonContainer];
}

+ (id)itemWithImageName:(NSString *)imageName highlightedImageName:(NSString *)highlightedImageName title:(NSString *)title titleColor:(UIColor *)titleColor target:(id)target action:(SEL)action
{
    UIButton *button = [UIButton buttonWithImageName:imageName highlightedImageName:highlightedImageName title:(NSString *)title target:target action:action];
    [button setTitleColor:titleColor forState:UIControlStateNormal];
    if (button == nil) {
        return nil;
    }
    return [[UIBarButtonItem alloc] initWithCustomView:button];
}


@end


@implementation NSDate (YOHO)

static NSDateFormatter *formatter_ = nil;
- (NSString *)stringRepresentationWithDateFormat:(NSString *)format
{
   formatter_ = [[NSDateFormatter alloc] init];
    NSString *dateFormat = nil;
    if (format == nil) {
        dateFormat = @"yyyy.MM.dd HH: mm: ss";
    } else {
        dateFormat = format;
    }
    formatter_.dateFormat = dateFormat;
    NSString *dateString = [formatter_ stringFromDate:self];
    return dateString;
}


@end


@implementation NSData (YOHOEMAG)

- (NSString *)md5Data
{
    unsigned char result[16];
    CC_MD5( self.bytes, self.length, result ); // This is the md5 call
    return [NSString stringWithFormat:
            @"%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x",
            result[0], result[1], result[2], result[3],
            result[4], result[5], result[6], result[7],
            result[8], result[9], result[10], result[11],
            result[12], result[13], result[14], result[15]
            ];
}

@end


@implementation UIViewController (YOHO)

- (void)popWithAnimation
{
    if (self.navigationController.visibleViewController == self) {
        [self.navigationController popViewControllerAnimated:YES];
    }
}


- (void)dismissModalViewControllerWithAnimation
{
    [self dismissViewControllerAnimated:YES completion:^{}];
}

- (void)pushViewController:(UIViewController *)viewController
{
    if (self.navigationController) {
        [self.navigationController pushViewController:viewController animated:YES];
        return;
    }
}

@end


//@implementation MBProgressHUD (YOHO)
//
//+ (MBProgressHUD *)alertMessage:(NSString *)aMessage addedTo:(UIView *)view animated:(BOOL)animated
//{
//    return [MBProgressHUD alertMessage:aMessage withDuration:0.5 addedTo:view animated:animated];
//}
//
//
//+ (MBProgressHUD *)alertMessage:(NSString *)aMessage withDuration:(double)duration addedTo:(UIView *)view animated:(BOOL)animated
//{
//    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:animated];
//    hud.labelText = aMessage;
//    double delayInSeconds = duration;
//    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
//    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
//        [MBProgressHUD hideHUDForView:view animated:animated];
//    });
//    return hud;
//}
//
//@end


@implementation UITableView (YOHO)

- (NSIndexPath *)lastIndexPath
{
    NSInteger numberOfSections = [self numberOfSections];
    if (numberOfSections == 0) {
        return nil;
    }
    NSInteger lastSection = numberOfSections - 1;
    
    NSInteger numberOfRowsInLastSection = [self numberOfRowsInSection:lastSection];
    if (numberOfRowsInLastSection == 0) {
        return nil;
    }
    NSInteger lastRow = numberOfRowsInLastSection - 1;
    return [NSIndexPath indexPathForRow:lastRow inSection:lastSection];
}


- (void)scrollToLastRowAnimated:(BOOL)animated
{
    NSIndexPath *lastIndexPath = [self lastIndexPath];
    [self scrollToRowAtIndexPath:lastIndexPath
                atScrollPosition:UITableViewScrollPositionBottom
                        animated:animated];
}


- (BOOL)lastCellVisible
{
    NSArray *visibleIndexPaths = [self indexPathsForVisibleRows];
    if ([visibleIndexPaths containsObject:[self lastIndexPath]]) {
        return YES;
    }
    return NO;
}


- (NSIndexPath *)lastSectionIndexPath:(NSInteger)sectionIndex
{
    NSInteger numberOfSections = [self numberOfSections];
    if (numberOfSections == 0) {
        return nil;
    }
    NSInteger lastSectionIndex = numberOfSections - sectionIndex;
    if (lastSectionIndex < 0)
    {
        return nil;
    }
    
    NSInteger numberOfRowsInLastSection = [self numberOfRowsInSection:lastSectionIndex];
    if (numberOfRowsInLastSection == 0) {
        return nil;
    }
    NSInteger lastRow = numberOfRowsInLastSection - 1;
    return [NSIndexPath indexPathForRow:lastRow inSection:lastSectionIndex];
}



- (BOOL)lastSetSectionVisible:(NSInteger)sectionIndex
{
    NSArray *visibleIndexPaths = [self indexPathsForVisibleRows];
    if ([visibleIndexPaths containsObject:[self lastSectionIndexPath:sectionIndex]]) {
        return YES;
    }
    return NO;
}

- (BOOL)lessOrContainVisibleLastSection:(NSInteger)SectionIndex
{
    NSIndexPath *indexPath = [self lastSectionIndexPath:SectionIndex];
    
    NSArray *visibleIndexPaths = [self indexPathsForVisibleRows];
    if ([visibleIndexPaths containsObject:indexPath]) {
        return YES;
    }
    NSUInteger section = 0;
    NSUInteger row = 0;
    for (NSIndexPath *indexPath in visibleIndexPaths) {
        section = MAX(indexPath.section, section);
        row = MAX(indexPath.row, row);
    }
    if(indexPath.section<section){
        return YES;
    }
    if (indexPath.section==section) {
        if (indexPath.row<=row) {
            return YES;
        }
    }
    return NO;
}
//最后一个section里第倒数多少个可访问的cell
- (BOOL)lastSetRowVisible:(NSInteger)rowsIndex
{
    NSUInteger totalSection = [self numberOfSections];
    NSUInteger totalRows = [self numberOfRowsInSection:totalSection-1];
    NSArray *visibleIndexPaths = [self indexPathsForVisibleRows];
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:totalRows-rowsIndex inSection:totalSection-1];
    if ([visibleIndexPaths containsObject:indexPath]) {
        return YES;
    }
    return NO;
}

//最后一个section里第倒数多少个cell是否在可访问的cell的下面
- (BOOL)moreOrContainVisibleLastRows:(NSInteger)rowsIndex
{
    NSUInteger totalSection = [self numberOfSections];
    NSUInteger totalRows = [self numberOfRowsInSection:totalSection-1];
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:totalRows-rowsIndex-1 inSection:totalSection-1];
    NSArray *visibleIndexPaths = [self indexPathsForVisibleRows];
    if ([visibleIndexPaths containsObject:indexPath]) {
        return YES;
    }
    
    NSUInteger section = 0;
    NSUInteger row = 0;
    //取出可访问cell里的最大section值和row值
    for (NSIndexPath *indexPath in visibleIndexPaths) {
        section = MAX(indexPath.section, section);
        row = MAX(indexPath.row, row);
    }
    if(indexPath.section>section){
        return YES;
    }
    if (indexPath.section==section) {
        if (indexPath.row>=row) {
            return YES;
        }
    }
    return NO;

}

- (void)hideTail
{
    self.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
}

@end



@implementation UICollectionView (YOHO)

- (NSIndexPath *)lastIndexPath
{
    NSInteger numberOfSections = [self numberOfSections];
    if (numberOfSections == 0) {
        return nil;
    }
    NSInteger lastSection = numberOfSections - 1;
    
    NSInteger numberOfRowsInLastSection = [self numberOfItemsInSection:lastSection];
    if (numberOfRowsInLastSection == 0) {
        return nil;
    }
    NSInteger lastRow = numberOfRowsInLastSection - 1;
    return [NSIndexPath indexPathForRow:lastRow inSection:lastSection];
}

- (BOOL)lastCellVisible
{
    NSArray *visibleIndexPaths = [self indexPathsForVisibleItems];
    if ([visibleIndexPaths containsObject:[self lastIndexPath]]) {
        return YES;
    }
    return NO;
}


- (NSIndexPath *)backwordsFiveIndexPath
{
    NSInteger numberOfSections = [self numberOfSections];
    if (numberOfSections == 0) {
        return nil;
    }
    NSInteger middleSection = numberOfSections - 1;
    
    NSInteger numberOfRowsInLastSection = [self numberOfItemsInSection:middleSection];
    if (numberOfRowsInLastSection == 0) {
        return nil;
    }
    
    UICollectionViewFlowLayout *flowLayout = (UICollectionViewFlowLayout *)self.collectionViewLayout;
    CGFloat itemWidth = flowLayout.itemSize.width;
    if ([self.delegate respondsToSelector:@selector(collectionView:layout:sizeForItemAtIndexPath:)]) {
        CGSize itemSize = [(id<UICollectionViewDelegateFlowLayout>)self.delegate collectionView:self layout:self.collectionViewLayout sizeForItemAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:middleSection]];
        itemWidth = itemSize.width;
    }
    
    CGFloat spacing = flowLayout.minimumInteritemSpacing;
    if ([self.delegate respondsToSelector:@selector(collectionView:layout:minimumInteritemSpacingForSectionAtIndex:)]) {
        spacing = [(id<UICollectionViewDelegateFlowLayout>)self.delegate collectionView:self layout:self.collectionViewLayout minimumInteritemSpacingForSectionAtIndex:middleSection];
    }
    
    NSInteger itemsCountInRow = (self.width+spacing)/(itemWidth+spacing);
    NSInteger middleRow = numberOfRowsInLastSection - 4*itemsCountInRow;
    return [NSIndexPath indexPathForRow:middleRow inSection:middleSection];
}

- (BOOL)backwordsFiveCellVisible
{
    if (![self.collectionViewLayout isMemberOfClass:[UICollectionViewFlowLayout class]]) {
        return NO;
    }
    NSArray *visibleIndexPaths = [self indexPathsForVisibleItems];
    if ([visibleIndexPaths containsObject:[self backwordsFiveIndexPath]]) {
        return YES;
    }
    return NO;
}

@end



@implementation NSFileManager (YOHO)

+ (void)setExcludedFromBackup:(BOOL)excluded forFileAtPath:(NSString *)path
{
    NSURL *url = [NSURL fileURLWithPath:path];
    NSString *currentSystemVersion = kSystemVersion;
    if ([currentSystemVersion compare:@"5.1"] != NSOrderedAscending) {
        [url setResourceValue:[NSNumber numberWithBool:YES] forKey:NSURLIsExcludedFromBackupKey error:nil];
    }
    else if ([currentSystemVersion compare:@"5.0.1"] != NSOrderedAscending) {
        const char* filePath = [[url path] fileSystemRepresentation];
        const char* attrName = "com.apple.MobileBackup";
        u_int8_t attrValue = 1;
        setxattr(filePath, attrName, &attrValue, sizeof(attrValue), 0, 0);
    }
}


- (unsigned long long int) documentsFolderSize:(NSString *)documentPath
{
    NSString *_documentsDirectory = documentPath;
    NSArray *_documentsFileList;
    NSEnumerator *_documentsEnumerator;
    NSString *_documentFilePath;
    unsigned long long int _documentsFolderSize = 0;
    
    _documentsFileList = [self subpathsAtPath:_documentsDirectory];
    _documentsEnumerator = [_documentsFileList objectEnumerator];
    while (_documentFilePath = [_documentsEnumerator nextObject]) {
        NSDictionary *_documentFileAttributes = [self attributesOfItemAtPath:[_documentsDirectory stringByAppendingPathComponent:_documentFilePath] error:nil];
        _documentsFolderSize += [_documentFileAttributes fileSize];
    }
    
    return _documentsFolderSize;
}


- (void)removeFileAtPath:(NSString *)path condition:(BOOL (^)(NSString *))block
{
    NSArray *files = [self contentsOfDirectoryAtPath:path error:nil];
    for (NSString *filePath in files) {
        NSString *fullPath = [path stringByAppendingPathComponent:filePath];
        if (block(fullPath)) {
            [self removeItemAtPath:fullPath error:nil];
        }
    }
}


+ (void)removeItemIfExistsAtPath:(NSString *)path error:(NSError **)error
{
    if ([[NSFileManager defaultManager] fileExistsAtPath:path]) {
        [[NSFileManager defaultManager] removeItemAtPath:path error:error];
    }
}


@end


@implementation UIApplication (YOHO)

- (void)startYOHOPush
{
    [self registerForRemoteNotificationTypes:UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeAlert | UIRemoteNotificationTypeSound];
}


- (void)clearNotificationMark
{
    [self setApplicationIconBadgeNumber:1];
    [self setApplicationIconBadgeNumber:0];
    NSArray* scheduledNotifications = [NSArray arrayWithArray:self.scheduledLocalNotifications];
    self.scheduledLocalNotifications = scheduledNotifications;
    [self cancelAllLocalNotifications];
}

@end
@implementation UIBarButtonItem (YOHOE)


+ (instancetype)borderedBarButtonItemWithTitle:(NSString *)title target:(id)target action:(SEL)action
{
    return [self yheBarButtonWithTitle:title target:target action:action hasBorder:NO];
    
    UIFont *font = [UIFont boldSystemFontOfSize:17.0f];
    CGSize size = [title sizeWithFont:font];
    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(0.0f, 0.0f, size.width + 10.0f, size.height + 10.0f)];
    [button setTitle:title forState:UIControlStateNormal];
    [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [button setTitleColor:[UIColor lightGrayColor] forState:UIControlStateHighlighted];
    button.titleLabel.font = font;
    button.layer.borderColor = [[UIColor blackColor] CGColor];
    button.layer.borderWidth = 1.0f;
    [button addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *item = [[self alloc] initWithCustomView:button];
    return item;
}


+ (instancetype)yheBarButtonWithTitle:(NSString *)title target:(id)target action:(SEL)action hasBorder:(BOOL)hasBorder
{
    UIFont *font = [UIFont systemFontOfSize:17.0f];
    CGSize size = [title sizeWithFont:font];
    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(0.0f, 0.0f, size.width + 10.0f, size.height + 10.0f)];
    [button setTitle:title forState:UIControlStateNormal];
    [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    button.titleLabel.font = font;
    if (hasBorder) {
        button.layer.borderColor = [[UIColor blackColor] CGColor];
        button.layer.borderWidth = 1.0f;
    }
    
    [button addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *item = [[self alloc] initWithCustomView:button];
    return item;
}




@end