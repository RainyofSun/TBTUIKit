//
//  UIImage+Crop.h
//  KKShopping
//
//  Created by Albert Lee on 8/1/13.
//  Copyright (c) 2013 KiDulty. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

@interface UIImage (Crop)
+ (UIImage *)croppedImage:(UIImage*)originalImage orientation:(UIDeviceOrientation)orientation;

- (NSData *)croppedAvatarImage;
+ (UIImage *)scaleImage:(UIImage *)image;
+ (UIImage *)reSizeImage:(UIImage *)image toSize:(CGSize)reSize;
+ (UIImage *)reSizeImage:(UIImage *)image withBgColor:(UIColor *)color;
- (UIImage *)fixOrientation;
- (CGAffineTransform)affineTransformForCurrentOrientation;
- (UIImage *)imageByScalingAndCroppingForSize:(CGSize)targetSize;
- (UIImage *)imageKeepScalingCroppingForSize:(CGSize)targetSize;
- (UIImage *)rotatedImageWithtransform:(CGAffineTransform)transform;
- (UIImage *)reSizeImageDataToSize:(CGFloat)kbyte;
- (UIImage *)reSizeNormalImageDataToSize:(CGFloat)ktype;            // 按图片比例来重置图片大小
- (UIImage *)drawOnAnotherImage:(UIImage*)base withinRect:(CGRect)rect;
- (UIImage *)drawOnAnotherImageKeepScale:(UIImage*)base withinRect:(CGRect)rect;
- (UIImage *)centerSquareCropImageWithLength:(NSUInteger)length;
- (UIImage *)resizedImageWithContentMode:(UIViewContentMode)contentMode
                                  bounds:(CGSize)bounds
                    interpolationQuality:(CGInterpolationQuality)quality;
- (UIImage *)resizedImageAspectFitWithbounds:(CGSize)bounds;
- (UIImage *)resizedImageAspectFillWithbounds:(CGSize)bounds;

- (UIImage *)thumbnailImage:(NSInteger)thumbnailSize;
- (UIImage *)thumbnailImage:(NSInteger)thumbnailSize
          transparentBorder:(NSUInteger)borderSize
               cornerRadius:(NSUInteger)cornerRadius
       interpolationQuality:(CGInterpolationQuality)quality;
- (UIImage *)cropImageWithFromPoint:(CGPoint)point imageSize:(CGSize)imageSize;

//CGRect cropRectScale = CGRectMake(0,44,375,375);
- (UIImage *)cropImageWithCropRectSize:(CGRect)cropRectSize;
//CGRect cropRectScale = CGRectMake(0,0.125,1,0.75);
- (UIImage *)cropImageWithCropRectScale:(CGRect)cropRectScale;

- (UIImage *)resizeImageFitCenterToSize:(CGSize)imageSize;

- (UIImage *)resizeImageInSize:(CGSize)imageSize;
//size 为zero  不裁剪照片大小
- (NSData *)reSizeImageDataToSize:(CGFloat)kbyte size:(CGSize)size;
- (UIImage *)convertImageToRGB;

@end
