//
//  UIImage+Crop.m
//  KKShopping
//
//  Created by Albert Lee on 8/1/13.
//  Copyright (c) 2013 KiDulty. All rights reserved.
//

#import "UIImage+Crop.h"
#import <AssetsLibrary/AssetsLibrary.h>
@implementation UIImage (Crop)
+ (UIImage *)croppedImage:(UIImage*)originalImage orientation:(UIDeviceOrientation)orientation{
    @autoreleasepool {
        // 注释掉上面那一坨，是由于，iPhone4/5拍出的照片尺寸是一样的，不用特出处理。宽高比都是3:4
        originalImage = [UIImage scaleImage:originalImage];
        NSInteger iWidth = originalImage.size.width;
        // 这里rect的height计算方法是，取景器是320*426的，取景器顶在页面最上
        double rectY = iWidth/[UIScreen mainScreen].bounds.size.width * 44;
        CGRect rect = CGRectMake(0,rectY, iWidth, iWidth);
        UIGraphicsBeginImageContext(rect.size);
        CGContextRef context = UIGraphicsGetCurrentContext();
        CGRect drawRect = CGRectMake(-rect.origin.x, -rect.origin.y, originalImage.size.width, originalImage.size.height);
        CGContextClipToRect(context, CGRectMake(0, 0, rect.size.width, rect.size.height));
        [originalImage drawInRect:drawRect];
        UIImage* croppedImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        return [UIImage rotateOritation:croppedImage orientation:orientation];
    }
}

- (UIImage *)imageByScalingAndCroppingForSize:(CGSize)targetSize
{
    UIImage *sourceImage = self;
    UIImage *newImage = nil;
    CGSize imageSize = sourceImage.size;
    CGFloat width = imageSize.width;
    CGFloat height = imageSize.height;
    CGFloat targetWidth = targetSize.width;
    CGFloat targetHeight = targetSize.height;
    CGFloat scaleFactor = 0.0;
    CGFloat scaledWidth = targetWidth;
    CGFloat scaledHeight = targetHeight;
    CGPoint thumbnailPoint = CGPointMake(0.0, 0.0);
    
    if (CGSizeEqualToSize(imageSize, targetSize) == NO)
    {
        CGFloat widthFactor = targetWidth / width;
        CGFloat heightFactor = targetHeight / height;
        
        if (widthFactor > heightFactor)
        {
            scaleFactor = widthFactor; // scale to fit height
        }
        else
        {
            scaleFactor = heightFactor; // scale to fit width
        }
        scaledWidth = width * scaleFactor;
        scaledHeight = height * scaleFactor;
        
        // Center the image
        if (widthFactor > heightFactor)
        {
            thumbnailPoint.y = (targetHeight - scaledHeight) * 0.5;
        }
        else if (widthFactor < heightFactor)
        {
            thumbnailPoint.x = (targetWidth - scaledWidth) * 0.5;
        }
    }
    UIGraphicsBeginImageContext(targetSize); // this will crop
    
    CGRect thumbnailRect = CGRectZero;
    thumbnailRect.origin = thumbnailPoint;
    thumbnailRect.size.width = scaledWidth;
    thumbnailRect.size.height = scaledHeight;
    
    [sourceImage drawInRect:thumbnailRect];
    
    newImage = UIGraphicsGetImageFromCurrentImageContext();
    if (newImage == nil)
    {
        NSLog(@"could not scale image");
    }
    
    // Pop the context to get back to the default
    UIGraphicsEndImageContext();
    return newImage;
}

- (UIImage *)imageKeepScalingCroppingForSize:(CGSize)targetSize
{
    UIImage *sourceImage = self;
    UIImage *newImage = nil;
    CGSize imageSize = sourceImage.size;
    CGFloat width = imageSize.width;
    CGFloat height = imageSize.height;
    CGFloat targetWidth = targetSize.width;
    CGFloat targetHeight = targetSize.height;
    CGFloat scaleFactor = 0.0;
    CGFloat scaledWidth = targetWidth;
    CGFloat scaledHeight = targetHeight;
    CGPoint thumbnailPoint = CGPointMake(0.0, 0.0);
    
    if (CGSizeEqualToSize(imageSize, targetSize) == NO)
    {
        CGFloat widthFactor = targetWidth / width;
        CGFloat heightFactor = targetHeight / height;
        
        if (widthFactor > heightFactor)
        {
            scaleFactor = widthFactor; // scale to fit height
        }
        else
        {
            scaleFactor = heightFactor; // scale to fit width
        }
        scaledWidth = width * scaleFactor;
        scaledHeight = height * scaleFactor;
        
        // Center the image
        if (widthFactor > heightFactor)
        {
            thumbnailPoint.y = (targetHeight - scaledHeight) * 0.5;
        }
        else if (widthFactor < heightFactor)
        {
            thumbnailPoint.x = (targetWidth - scaledWidth) * 0.5;
        }
    }
    UIGraphicsBeginImageContextWithOptions(targetSize,
                                           NO,
                                           self.scale);
    
    CGRect thumbnailRect = CGRectZero;
    thumbnailRect.origin = thumbnailPoint;
    thumbnailRect.size.width = scaledWidth;
    thumbnailRect.size.height = scaledHeight;
    
    [sourceImage drawInRect:thumbnailRect];
    
    newImage = UIGraphicsGetImageFromCurrentImageContext();
    if (newImage == nil)
    {
        NSLog(@"could not scale image");
    }
    
    // Pop the context to get back to the default
    UIGraphicsEndImageContext();
    return newImage;
}

+(UIImage *)rotateOritation:(UIImage *)aImage orientation:(UIDeviceOrientation)orientation
{
    @autoreleasepool {
        CGImageRef imgRef = aImage.CGImage;
        CGFloat width = CGImageGetWidth(imgRef);
        CGAffineTransform transform = CGAffineTransformIdentity;
        CGRect bounds = CGRectMake(0, 0, width, width);
        switch(orientation)
        {
            case UIDeviceOrientationPortrait:
                return aImage;
                break;
            case UIDeviceOrientationPortraitUpsideDown:
                transform = CGAffineTransformMakeTranslation(width, 0.0);
                transform = CGAffineTransformScale(transform, -1.0, 1.0);
                break;
            case UIDeviceOrientationLandscapeLeft:
                transform = CGAffineTransformMakeTranslation(width, width);
                transform = CGAffineTransformScale(transform, -1.0, 1.0);
                transform = CGAffineTransformRotate(transform, 3.0 * M_PI / 2.0);
                break;
            case UIDeviceOrientationLandscapeRight:
                transform = CGAffineTransformMakeScale(-1.0, 1.0);
                transform = CGAffineTransformRotate(transform, M_PI / 2.0);
                break;
            case UIDeviceOrientationFaceDown:
                return aImage;
                break;
            case UIDeviceOrientationFaceUp:
                return aImage;
                break;
            case UIDeviceOrientationUnknown:
                return aImage;
                break;
            default:
                transform = CGAffineTransformIdentity;
                break;
        }
        UIGraphicsBeginImageContext(bounds.size);
        CGContextRef context = UIGraphicsGetCurrentContext();
        CGContextConcatCTM(context, transform);
        CGContextDrawImage(UIGraphicsGetCurrentContext(), CGRectMake(0, 0, width, width), imgRef);
        UIImage *imageCopy = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        return imageCopy;
    }
}

+ (UIImage *)reSizeImage:(UIImage *)image toSize:(CGSize)reSize{
    @autoreleasepool {
        UIGraphicsBeginImageContext(CGSizeMake(reSize.width, reSize.height));
        [image drawInRect:CGRectMake(0, 0, reSize.width, reSize.height)];
        UIImage *reSizeImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        return reSizeImage;
    }
}

+ (UIImage *)scaleImage:(UIImage *)image{
    @autoreleasepool {
        CGFloat photoWidth = [UIScreen mainScreen].bounds.size.width > 320 ? 1080.0 : 750.0;
        CGFloat scaleSize = photoWidth/image.size.width;
        CGSize imgSize = CGSizeMake(photoWidth,image.size.height*scaleSize);
        UIGraphicsBeginImageContext(imgSize);
        [image drawInRect:CGRectMake(0, 0, imgSize.width, imgSize.height)];
        UIImage *scaledImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        
        return scaledImage;
    }
}

- (UIImage *)centerSquareCropImageWithLength:(NSUInteger)length
{
    CGFloat squareLength = MIN(length, MIN(self.size.width, self.size.height));
    CGRect clippedRect = CGRectMake((self.size.width - squareLength) / 2, (self.size.height - squareLength) / 2, squareLength, squareLength);
    
    // Crop logic
    CGImageRef imageRef = CGImageCreateWithImageInRect([self CGImage], clippedRect);
    UIImage * croppedImage = [UIImage imageWithCGImage:imageRef];
    CGImageRelease(imageRef);
    return croppedImage;
}

- (NSData *)croppedAvatarImage{
    @autoreleasepool {
        UIImage *originalImage = self;
        CGSize size = originalImage.size;
        if (size.width<=size.height) {
            return [UIImage scaleAvatarImage:originalImage];
        }
        else{
            CGRect rect = CGRectMake((size.width-size.height)/2,0, size.height, size.height);
            
            UIGraphicsBeginImageContext(rect.size);
            CGContextRef context = UIGraphicsGetCurrentContext();
            CGRect drawRect = CGRectMake(-rect.origin.x, -rect.origin.y, originalImage.size.width, originalImage.size.height);
            CGContextClipToRect(context, CGRectMake(0, 0, rect.size.width, rect.size.height));
            [originalImage drawInRect:drawRect];
            UIImage* croppedImage = UIGraphicsGetImageFromCurrentImageContext();
            UIGraphicsEndImageContext();
            return [UIImage scaleAvatarImage:croppedImage];
        }
        return nil;
    }
}
+ (NSData *)scaleAvatarImage:(UIImage *)image{
    @autoreleasepool {
        UIGraphicsBeginImageContext(CGSizeMake(640.0,640.0));
        [image drawInRect:CGRectMake(0, 0, 640.0, 640.0)];
        UIImage *scaledImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        NSData *data = UIImageJPEGRepresentation(scaledImage, 0.95);
        return data;
    }
}

//将宽图，背景填充颜色，宽图居中
+ (UIImage *)reSizeImage:(UIImage *)image withBgColor:(UIColor *)color {
    CGFloat height = image.size.height;
    CGFloat width = image.size.width;
    
    CGSize size = CGSizeMake(width, width);
    UIGraphicsBeginImageContext(size);
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSaveGState(context);
    
    CGContextBeginPath(context);
    CGContextMoveToPoint(context, 0, 0);
    CGContextAddLineToPoint(context, 0, width);
    CGContextAddLineToPoint(context, width, width);
    CGContextAddLineToPoint(context, width, 0);
    CGContextClosePath(context);
    CGContextSetFillColorWithColor(context, color.CGColor);
    CGContextFillPath(context);
    
    CGRect rect = CGRectMake(0, (width-height)/2, width, height);
    
    [image drawInRect:rect];
    
    UIImage* img2 = UIGraphicsGetImageFromCurrentImageContext();
    
    CGContextRestoreGState(context);
    
    UIGraphicsEndImageContext();
    
    return img2;
}

- (UIImage *)fixOrientation
{
    // No-op if the orientation is already correct
    if (self.imageOrientation == UIImageOrientationUp) return self;
    
    // We need to calculate the proper transformation to make the image upright.
    // We do it in 2 steps: Rotate if Left/Right/Down, and then flip if Mirrored.
    CGAffineTransform transform = [self affineTransformForCurrentOrientation];
    
    // Now we draw the underlying CGImage into a new context, applying the transform
    // calculated above.
    CGContextRef ctx = CGBitmapContextCreate(NULL, self.size.width, self.size.height,
                                             CGImageGetBitsPerComponent(self.CGImage), 0,
                                             CGImageGetColorSpace(self.CGImage),
                                             CGImageGetBitmapInfo(self.CGImage));
    CGContextConcatCTM(ctx, transform);
    switch (self.imageOrientation) {
        case UIImageOrientationLeft:
        case UIImageOrientationLeftMirrored:
        case UIImageOrientationRight:
        case UIImageOrientationRightMirrored:
            // Grr...
            CGContextDrawImage(ctx, CGRectMake(0,0,self.size.height,self.size.width), self.CGImage);
            break;
            
        default:
            CGContextDrawImage(ctx, CGRectMake(0,0,self.size.width,self.size.height), self.CGImage);
            break;
    }
    
    // And now we just create a new UIImage from the drawing context
    CGImageRef cgimg = CGBitmapContextCreateImage(ctx);
    UIImage *img = [UIImage imageWithCGImage:cgimg];
    CGContextRelease(ctx);
    CGImageRelease(cgimg);
    return img;
}

- (CGAffineTransform)affineTransformForCurrentOrientation
{
    CGAffineTransform transform = CGAffineTransformIdentity;
    
    switch (self.imageOrientation) {
        case UIImageOrientationDown:
        case UIImageOrientationDownMirrored:
            transform = CGAffineTransformTranslate(transform, self.size.width, self.size.height);
            transform = CGAffineTransformRotate(transform, M_PI);
            break;
        case UIImageOrientationLeft:
        case UIImageOrientationLeftMirrored:
            transform = CGAffineTransformTranslate(transform, self.size.width, 0);
            transform = CGAffineTransformRotate(transform, M_PI_2);
            break;
        case UIImageOrientationRight:
        case UIImageOrientationRightMirrored:
            transform = CGAffineTransformTranslate(transform, 0, self.size.height);
            transform = CGAffineTransformRotate(transform, -M_PI_2);
            break;
        case UIImageOrientationUpMirrored:
            transform = CGAffineTransformTranslate(transform, self.size.width, 0);
            transform = CGAffineTransformScale(transform, -1, 1);
            break;
        case UIImageOrientationUp:
        default:
            break;
    }
    
    switch (self.imageOrientation) {
        case UIImageOrientationUpMirrored:
        case UIImageOrientationDownMirrored:
            transform = CGAffineTransformTranslate(transform, self.size.width, 0);
            transform = CGAffineTransformScale(transform, -1, 1);
            break;
            
        case UIImageOrientationLeftMirrored:
        case UIImageOrientationRightMirrored:
            transform = CGAffineTransformTranslate(transform, self.size.height, 0);
            transform = CGAffineTransformScale(transform, -1, 1);
            break;
        case UIImageOrientationUp:
        case UIImageOrientationDown:
        case UIImageOrientationLeft:
        case UIImageOrientationRight:
        default:
            break;
    }
    
    return transform;
}

- (UIImage *)rotatedImageWithtransform:(CGAffineTransform)transform
{
    CGSize size = self.size;
    
    UIGraphicsBeginImageContextWithOptions(size,
                                           NO,
                                           self.scale);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextTranslateCTM(context, size.width / 2, size.height / 2);
    CGContextConcatCTM(context, transform);
    CGContextTranslateCTM(context, size.width / -2, size.height / -2);
    [self drawInRect:CGRectMake(0.0f, 0.0f, size.width, size.height)];
    
    UIImage *rotatedImage = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return rotatedImage;
}

// 用于微信分享限制图片大小32k，
// 裁减图片是因为微信分享是小图，以后裁减尺寸和压缩比例可以做成参数
- (UIImage *)reSizeImageDataToSize:(CGFloat)kbyte {
    NSUInteger byteCount = kbyte * 1024;
    NSData *data = UIImageJPEGRepresentation(self, 1);
    if (data.length < byteCount) {
        return self;
    }
    
    UIImage *img = self;
    
    if (img.size.width > 180 && img.size.height > 180) {
        img = [UIImage reSizeImage:img toSize:CGSizeMake(180, 180)];
    }
    
    CGFloat compressionQuality = 0.95;
    data = UIImageJPEGRepresentation(img, compressionQuality);
    while (data.length > byteCount) {
        compressionQuality -= 0.05;
        data = UIImageJPEGRepresentation(img, compressionQuality);
    }
    return img;
}


- (NSData *)reSizeImageDataToSize:(CGFloat)kbyte size:(CGSize)size
{
    NSUInteger byteCount = kbyte * 1024;
    NSData *data = UIImageJPEGRepresentation(self, 1);
    if (data.length < byteCount) {
        return data;
    }
    
    UIImage *img = self;
    if(!CGSizeEqualToSize(size, CGSizeZero)) {
        if (img.size.width > size.width && img.size.height > size.height) {
            img = [UIImage reSizeImage:img toSize:size];
        }
    }
    
    
    CGFloat compressionQuality = 0.95;
    data = UIImageJPEGRepresentation(img, compressionQuality);
    while (data.length > byteCount) {
        compressionQuality -= 0.05;
        data = UIImageJPEGRepresentation(img, compressionQuality);
    }
    return data;
}

- (UIImage *)reSizeNormalImageDataToSize:(CGFloat)kbyte {
    NSUInteger byteCount = kbyte * 1024;
    NSData *data = UIImageJPEGRepresentation(self, 1);
    if (data.length < byteCount) {
        return self;
    }
    
    UIImage *img = self;
    
    if (img.size.width > 180 && img.size.height > 180) {
        img = [UIImage reSizeImage:img toSize:CGSizeMake(180, 180 * (img.size.height / img.size.width))];
    }
    
    CGFloat compressionQuality = 0.95;
    data = UIImageJPEGRepresentation(img, compressionQuality);
    while (data.length > byteCount) {
        compressionQuality -= 0.05;
        data = UIImageJPEGRepresentation(img, compressionQuality);
    }
    return img;
}

- (UIImage *)drawOnAnotherImage:(UIImage*)base withinRect:(CGRect)rect
{
    CGSize imageSize = CGSizeMake(base.size.width, base.size.height);
    UIGraphicsBeginImageContext(imageSize);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSaveGState(context);
    [base drawInRect:CGRectMake(0, 0, imageSize.width, imageSize.height)];
    [self drawInRect:rect];
    UIImage *resultImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return resultImage;
}

- (UIImage *)drawOnAnotherImageKeepScale:(UIImage*)base withinRect:(CGRect)rect
{
    CGSize imageSize = CGSizeMake(base.size.width, base.size.height);
    UIGraphicsBeginImageContext(imageSize);
    UIGraphicsBeginImageContextWithOptions(imageSize, NO, self.scale);
    [base drawInRect:CGRectMake(0, 0, imageSize.width, imageSize.height)];
    [self drawInRect:rect];
    UIImage *resultImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return resultImage;
}

- (UIImage *)resizedImageAspectFitWithbounds:(CGSize)bounds
{
    return [self resizedImageWithContentMode:UIViewContentModeScaleAspectFit bounds:bounds interpolationQuality:kCGInterpolationDefault];
}

- (UIImage *)resizedImageAspectFillWithbounds:(CGSize)bounds
{
    return [self resizedImageWithContentMode:UIViewContentModeScaleAspectFill bounds:bounds interpolationQuality:kCGInterpolationDefault];
}

- (UIImage *)thumbnailImage:(NSInteger)thumbnailSize
{
    return [self thumbnailImage:thumbnailSize transparentBorder:0 cornerRadius:0 interpolationQuality:kCGInterpolationDefault];
}

- (UIImage *)thumbnailImage:(NSInteger)thumbnailSize
              transparentBorder:(NSUInteger)borderSize
                   cornerRadius:(NSUInteger)cornerRadius
           interpolationQuality:(CGInterpolationQuality)quality {
    UIImage *resizedImage = [self resizedImageWithContentMode:UIViewContentModeScaleAspectFill
                                                           bounds:CGSizeMake(thumbnailSize, thumbnailSize)
                                             interpolationQuality:quality];
    
    // Crop out any part of the image that's larger than the thumbnail size
    // The cropped rect must be centered on the resized image
    // Round the origin points so that the size isn't altered when CGRectIntegral is later invoked
    CGRect cropRect = CGRectMake(round((resizedImage.size.width - thumbnailSize) / 2),
                                 round((resizedImage.size.height - thumbnailSize) / 2),
                                 thumbnailSize,
                                 thumbnailSize);
    UIImage *croppedImage = [resizedImage croppedImage:cropRect];
    
    UIImage *transparentBorderImage = borderSize ? [croppedImage transparentBorderImage:borderSize] : croppedImage;
    
    return [transparentBorderImage roundedCornerImage:cornerRadius borderSize:borderSize];
}

- (UIImage *)resizedImageWithContentMode:(UIViewContentMode)contentMode
                                  bounds:(CGSize)bounds
                    interpolationQuality:(CGInterpolationQuality)quality
{
    CGFloat horizontalRatio = bounds.width / self.size.width;
    CGFloat verticalRatio = bounds.height / self.size.height;
    CGFloat ratio;
    
    switch (contentMode) {
        case UIViewContentModeScaleAspectFill:
            ratio = MAX(horizontalRatio, verticalRatio);
            break;
            
        case UIViewContentModeScaleAspectFit:
            ratio = MIN(horizontalRatio, verticalRatio);
            break;
            
        default:
            [NSException raise:NSInvalidArgumentException format:@"Unsupported content mode: %d", (int)contentMode];
    }
    
    CGSize newSize = CGSizeMake(roundf(self.size.width * ratio), roundf(self.size.height * ratio));
    
    return [self resizedImage:newSize interpolationQuality:quality];
}

- (UIImage *)resizedImage:(CGSize)newSize interpolationQuality:(CGInterpolationQuality)quality {
    BOOL drawTransposed;
    
    switch (self.imageOrientation) {
        case UIImageOrientationLeft:
        case UIImageOrientationLeftMirrored:
        case UIImageOrientationRight:
        case UIImageOrientationRightMirrored:
            drawTransposed = YES;
            break;
            
        default:
            drawTransposed = NO;
    }
    
    return [self resizedImage:newSize
                        transform:[self transformForOrientation:newSize]
                   drawTransposed:drawTransposed
             interpolationQuality:quality];
}

- (UIImage *)resizedImage:(CGSize)newSize
                transform:(CGAffineTransform)transform
           drawTransposed:(BOOL)transpose
     interpolationQuality:(CGInterpolationQuality)quality
{
    CGRect newRect = CGRectIntegral(CGRectMake(0, 0, newSize.width, newSize.height));
    CGRect transposedRect = CGRectMake(0, 0, newRect.size.height, newRect.size.width);
    CGImageRef imageRef = self.CGImage;
    
    // Build a context that's the same dimensions as the new size
    CGColorSpaceRef rgbColorSpace = CGColorSpaceCreateDeviceRGB();
    CGContextRef bitmap = CGBitmapContextCreate(NULL,
                                                newRect.size.width,
                                                newRect.size.height,
                                                8,
                                                newRect.size.width * 4,
                                                rgbColorSpace,					// CGImageGetColorSpace(imageRef)
                                                (CGBitmapInfo)kCGImageAlphaNoneSkipFirst);
    CGColorSpaceRelease(rgbColorSpace);
    
    // Default white background color.
    CGRect rect = CGRectMake(0, 0, newRect.size.width, newRect.size.height);
    CGContextSetRGBFillColor(bitmap, 1, 1, 1, 1);
    CGContextFillRect(bitmap, rect);
    
    // Rotate and/or flip the image if required by its orientation
    CGContextConcatCTM(bitmap, transform);
    
    // Set the quality level to use when rescaling
    CGContextSetInterpolationQuality(bitmap, quality);
    
    // Draw into the context; this scales the image
    CGContextDrawImage(bitmap, transpose ? transposedRect : newRect, imageRef);
    
    // Get the resized image from the context and a UIImage
    CGImageRef newImageRef = CGBitmapContextCreateImage(bitmap);
    UIImage *newImage = [UIImage imageWithCGImage:newImageRef];
    
    // Clean up
    CGContextRelease(bitmap);
    CGImageRelease(newImageRef);
    
    return newImage;
}

- (CGAffineTransform)transformForOrientation:(CGSize)newSize {
    CGAffineTransform transform = CGAffineTransformIdentity;
    
    switch (self.imageOrientation) {
        case UIImageOrientationDown:           // EXIF = 3
        case UIImageOrientationDownMirrored:   // EXIF = 4
            transform = CGAffineTransformTranslate(transform, newSize.width, newSize.height);
            transform = CGAffineTransformRotate(transform, M_PI);
            break;
            
        case UIImageOrientationLeft:           // EXIF = 6
        case UIImageOrientationLeftMirrored:   // EXIF = 5
            transform = CGAffineTransformTranslate(transform, newSize.width, 0);
            transform = CGAffineTransformRotate(transform, M_PI_2);
            break;
            
        case UIImageOrientationRight:          // EXIF = 8
        case UIImageOrientationRightMirrored:  // EXIF = 7
            transform = CGAffineTransformTranslate(transform, 0, newSize.height);
            transform = CGAffineTransformRotate(transform, -M_PI_2);
            break;
            
        default:
            break;
    }
    
    switch (self.imageOrientation) {
        case UIImageOrientationUpMirrored:     // EXIF = 2
        case UIImageOrientationDownMirrored:   // EXIF = 4
            transform = CGAffineTransformTranslate(transform, newSize.width, 0);
            transform = CGAffineTransformScale(transform, -1, 1);
            break;
            
        case UIImageOrientationLeftMirrored:   // EXIF = 5
        case UIImageOrientationRightMirrored:  // EXIF = 7
            transform = CGAffineTransformTranslate(transform, newSize.height, 0);
            transform = CGAffineTransformScale(transform, -1, 1);
            break;
            
        default:
            break;
    }
    
    return transform;
}

- (UIImage *)croppedImage:(CGRect)bounds {
    bounds = CGRectMake(bounds.origin.x * self.scale, bounds.origin.y * self.scale, bounds.size.width * self.scale, bounds.size.height * self.scale);
    
    CGImageRef imageRef = CGImageCreateWithImageInRect([self CGImage], bounds);
    UIImage *croppedImage = [UIImage imageWithCGImage:imageRef scale:self.scale orientation:self.imageOrientation];
    CGImageRelease(imageRef);
    return croppedImage;
}

- (UIImage *)transparentBorderImage:(NSUInteger)borderSize {
    // If the image does not have an alpha layer, add one
    UIImage *image = [self imageWithAlpha];
    
    CGRect newRect = CGRectMake(0, 0, image.size.width + borderSize * 2, image.size.height + borderSize * 2);
    
    // Build a context that's the same dimensions as the new size
    CGContextRef bitmap = CGBitmapContextCreate(NULL,
                                                newRect.size.width,
                                                newRect.size.height,
                                                CGImageGetBitsPerComponent(self.CGImage),
                                                0,
                                                CGImageGetColorSpace(self.CGImage),
                                                CGImageGetBitmapInfo(self.CGImage));
    
    // Draw the image in the center of the context, leaving a gap around the edges
    CGRect imageLocation = CGRectMake(borderSize, borderSize, image.size.width, image.size.height);
    CGContextDrawImage(bitmap, imageLocation, self.CGImage);
    CGImageRef borderImageRef = CGBitmapContextCreateImage(bitmap);
    
    // Create a mask to make the border transparent, and combine it with the image
    CGImageRef maskImageRef = [self newBorderMask:borderSize size:newRect.size];
    CGImageRef transparentBorderImageRef = CGImageCreateWithMask(borderImageRef, maskImageRef);
    UIImage *transparentBorderImage = [UIImage imageWithCGImage:transparentBorderImageRef];
    
    // Clean up
    CGContextRelease(bitmap);
    CGImageRelease(borderImageRef);
    CGImageRelease(maskImageRef);
    CGImageRelease(transparentBorderImageRef);
    
    return transparentBorderImage;
}

- (CGImageRef)newBorderMask:(NSUInteger)borderSize size:(CGSize)size {
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceGray();
    
    // Build a context that's the same dimensions as the new size
    CGContextRef maskContext = CGBitmapContextCreate(NULL,
                                                     size.width,
                                                     size.height,
                                                     8, // 8-bit grayscale
                                                     0,
                                                     colorSpace,
                                                     kCGBitmapByteOrderDefault | kCGImageAlphaNone);
    
    // Start with a mask that's entirely transparent
    CGContextSetFillColorWithColor(maskContext, [UIColor blackColor].CGColor);
    CGContextFillRect(maskContext, CGRectMake(0, 0, size.width, size.height));
    
    // Make the inner part (within the border) opaque
    CGContextSetFillColorWithColor(maskContext, [UIColor whiteColor].CGColor);
    CGContextFillRect(maskContext, CGRectMake(borderSize, borderSize, size.width - borderSize * 2, size.height - borderSize * 2));
    
    // Get an image of the context
    CGImageRef maskImageRef = CGBitmapContextCreateImage(maskContext);
    
    // Clean up
    CGContextRelease(maskContext);
    CGColorSpaceRelease(colorSpace);
    
    return maskImageRef;
}

- (BOOL)hasAlpha {
    CGImageAlphaInfo alpha = CGImageGetAlphaInfo(self.CGImage);
    return (alpha == kCGImageAlphaFirst ||
            alpha == kCGImageAlphaLast ||
            alpha == kCGImageAlphaPremultipliedFirst ||
            alpha == kCGImageAlphaPremultipliedLast);
}

// Returns a copy of the given image, adding an alpha channel if it doesn't already have one
- (UIImage *)imageWithAlpha {
    if ([self hasAlpha]) {
        return self;
    }
    
    CGImageRef imageRef = self.CGImage;
    size_t width = CGImageGetWidth(imageRef);
    size_t height = CGImageGetHeight(imageRef);
    
    // The bitsPerComponent and bitmapInfo values are hard-coded to prevent an "unsupported parameter combination" error
    CGContextRef offscreenContext = CGBitmapContextCreate(NULL,
                                                          width,
                                                          height,
                                                          8,
                                                          0,
                                                          CGImageGetColorSpace(imageRef),
                                                          kCGBitmapByteOrderDefault | kCGImageAlphaPremultipliedFirst);
    
    // Draw the image into the context and retrieve the new image, which will now have an alpha layer
    CGContextDrawImage(offscreenContext, CGRectMake(0, 0, width, height), imageRef);
    CGImageRef imageRefWithAlpha = CGBitmapContextCreateImage(offscreenContext);
    UIImage *imageWithAlpha = [UIImage imageWithCGImage:imageRefWithAlpha];
    
    // Clean up
    CGContextRelease(offscreenContext);
    CGImageRelease(imageRefWithAlpha);
    
    return imageWithAlpha;
}

- (UIImage *)roundedCornerImage:(NSInteger)cornerSize borderSize:(NSInteger)borderSize {
    // If the image does not have an alpha layer, add one
    UIImage *image = [self imageWithAlpha];
    
    // Build a context that's the same dimensions as the new size
    CGContextRef context = CGBitmapContextCreate(NULL,
                                                 image.size.width,
                                                 image.size.height,
                                                 CGImageGetBitsPerComponent(image.CGImage),
                                                 0,
                                                 CGImageGetColorSpace(image.CGImage),
                                                 CGImageGetBitmapInfo(image.CGImage));
    
    // Create a clipping path with rounded corners
    CGContextBeginPath(context);
    [self addRoundedRectToPath:CGRectMake(borderSize, borderSize, image.size.width - borderSize * 2, image.size.height - borderSize * 2)
                           context:context
                         ovalWidth:cornerSize
                        ovalHeight:cornerSize];
    CGContextClosePath(context);
    CGContextClip(context);
    
    // Draw the image to the context; the clipping path will make anything outside the rounded rect transparent
    CGContextDrawImage(context, CGRectMake(0, 0, image.size.width, image.size.height), image.CGImage);
    
    // Create a CGImage from the context
    CGImageRef clippedImage = CGBitmapContextCreateImage(context);
    CGContextRelease(context);
    
    // Create a UIImage from the CGImage
    UIImage *roundedImage = [UIImage imageWithCGImage:clippedImage];
    CGImageRelease(clippedImage);
    
    return roundedImage;
}

- (void)addRoundedRectToPath:(CGRect)rect context:(CGContextRef)context ovalWidth:(CGFloat)ovalWidth ovalHeight:(CGFloat)ovalHeight {
    if (ovalWidth == 0 || ovalHeight == 0) {
        CGContextAddRect(context, rect);
        return;
    }
    CGContextSaveGState(context);
    CGContextTranslateCTM(context, CGRectGetMinX(rect), CGRectGetMinY(rect));
    CGContextScaleCTM(context, ovalWidth, ovalHeight);
    CGFloat fw = CGRectGetWidth(rect) / ovalWidth;
    CGFloat fh = CGRectGetHeight(rect) / ovalHeight;
    CGContextMoveToPoint(context, fw, fh/2);
    CGContextAddArcToPoint(context, fw, fh, fw/2, fh, 1);
    CGContextAddArcToPoint(context, 0, fh, 0, fh/2, 1);
    CGContextAddArcToPoint(context, 0, 0, fw/2, 0, 1);
    CGContextAddArcToPoint(context, fw, 0, fw, fh/2, 1);
    CGContextClosePath(context);
    CGContextRestoreGState(context);
}

- (UIImage *)cropImageWithFromPoint:(CGPoint)point imageSize:(CGSize)imageSize
{
    CGRect cropRect = CGRectMake(point.x, point.y, imageSize.width, imageSize.height);
    CGImageRef imageRef = CGImageCreateWithImageInRect([self CGImage], cropRect);
    UIImage *newImage = [UIImage imageWithCGImage:imageRef];
    if (imageRef) {
        CGImageRelease(imageRef);
    }
    return newImage;
}

- (UIImage *)cropImageWithCropRectSize:(CGRect)cropRectSize
{
    NSAssert(self.size.width >= cropRectSize.size.width + cropRectSize.origin.x && self.size.height >= cropRectSize.size.height + cropRectSize.origin.y, @"orgin size small than cropsize");
    CGImageRef imageRef = CGImageCreateWithImageInRect([self CGImage], cropRectSize);
    UIImage *newImage = [UIImage imageWithCGImage:imageRef];
    if (imageRef) {
        CGImageRelease(imageRef);
    }
    return newImage;
}

- (UIImage *)cropImageWithCropRectScale:(CGRect)cropRectScale
{
    CGFloat width = self.size.width;
    CGFloat height = self.size.height;
    CGRect cropSize = CGRectMake( width * cropRectScale.origin.x, height * cropRectScale.origin.y, width * width * cropRectScale.size.width/self.scale, height * cropRectScale.size.height/self.scale);
    
    CGImageRef imageRef = CGImageCreateWithImageInRect([self CGImage], cropSize);
    UIImage *newImage = [UIImage imageWithCGImage:imageRef];
    if (imageRef) {
        CGImageRelease(imageRef);
    }
    return newImage;
}

- (UIImage *)resizeImageFitCenterToSize:(CGSize)imageSize
{
    UIGraphicsBeginImageContext(imageSize);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSaveGState(context);
    [self drawInRect:CGRectMake(0,(imageSize.height - self.size.height * 2) * 0.5, self.size.width * 2, self.size.height * 2)];
    UIImage *resultImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return resultImage;
}

- (UIImage *)resizeImageInSize:(CGSize)imageSize
{
    UIGraphicsBeginImageContext(imageSize);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSaveGState(context);
    [self drawInRect:CGRectMake(0,0, imageSize.width, imageSize.height)];
    UIImage *resultImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return resultImage;
}

- (UIImage *)convertImageToRGB
{
    UIGraphicsBeginImageContext(self.size);
    [self drawInRect:CGRectMake( 0, 0, self.size.width, self.size.height)];
    
    UIImage *targetImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return targetImage;
}

@end
