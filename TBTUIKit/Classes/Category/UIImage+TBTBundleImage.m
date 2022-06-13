//
//  UIImage+TBTBundleImage.m
//  TBT
//
//  Created by 刘冉 on 2022/6/9.
//

#import "UIImage+TBTBundleImage.h"

NSString *const kResourcesBundleName = @"TBTResourcesPod";
static NSBundle *resourceBundle = nil;

@implementation UIImage (TBTBundleImage)

+ (instancetype)tbt_imgWithName:(NSString *)name {
    if (!resourceBundle) {
        NSBundle *mainBundle = [NSBundle mainBundle];
        NSString *resourcePath = [[NSBundle mainBundle] pathForResource:kResourcesBundleName ofType:@"bundle"];
        resourceBundle = [NSBundle bundleWithPath:resourcePath] ?: mainBundle;
    }
    UIImage *image = [UIImage imageNamed:name inBundle:resourceBundle compatibleWithTraitCollection:nil];
    return image;
}

+ (instancetype)tbt_imgWithColor:(UIColor *)imgColor {
    CGRect rect = CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [imgColor CGColor]);
    CGContextFillRect(context, rect);
    UIImage *theImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();

    return theImage;
}

@end
