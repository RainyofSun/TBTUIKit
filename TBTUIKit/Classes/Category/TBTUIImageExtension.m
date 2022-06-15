//
//  TBTUIImageExtension.m
//  Pods
//
//  Created by 刘冉 on 2022/6/14.
//

#import "TBTUIImageExtension.h"

@implementation TBTUIImageExtension

+ (UIImage *)getGradientImageFromColors:(NSArray*)colors imgSize:(CGSize)imgSize {
    CGRect rect = (CGRect){0.f, 0.f, imgSize};
    NSMutableArray *ar = [NSMutableArray array];
    for(UIColor *c in colors) {
        [ar addObject:(id)c.CGColor];
    }
    UIGraphicsBeginImageContextWithOptions(imgSize, NO, UIScreen.mainScreen.scale);
    CGContextAddPath(UIGraphicsGetCurrentContext(),
                     [UIBezierPath bezierPathWithRoundedRect:rect cornerRadius:24].CGPath);
    CGContextClip(UIGraphicsGetCurrentContext());
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSaveGState(context);
    CGColorSpaceRef colorSpace = CGColorGetColorSpace([[colors lastObject] CGColor]);
    CGGradientRef gradient = CGGradientCreateWithColors(colorSpace, (CFArrayRef)ar, NULL);

    CGPoint  start = CGPointMake(0.0, 0.0);
    CGPoint  end = CGPointMake(imgSize.width, 0.0);

    CGContextDrawLinearGradient(context, gradient, start, end, kCGGradientDrawsBeforeStartLocation | kCGGradientDrawsAfterEndLocation);
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    CGGradientRelease(gradient);
    CGContextRestoreGState(context);
    CGColorSpaceRelease(colorSpace);
    UIGraphicsEndImageContext();
    return image;
}

@end
