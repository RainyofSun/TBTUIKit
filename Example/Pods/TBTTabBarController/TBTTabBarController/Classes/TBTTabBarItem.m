//
//  TBTTabBarItem.m
//  TBT
//
//  Created by 刘冉 on 2022/6/9.
//

#import "TBTTabBarItem.h"

@interface TBTTabBarItem ()
{
    NSString *_title;
    UIOffset _imagePositionAdjustment;
    NSDictionary *_unselectedTitleAttributes;
    NSDictionary *_selectedTitleAttributes;
}

@property (nonatomic,strong) UIImage *unselectedBackgroundImg;
@property (nonatomic,strong) UIImage *selectedBackgroundImg;
@property (nonatomic,strong) UIImage *unselectedImg;
@property (nonatomic,strong) UIImage *selectedImg;

@end

@implementation TBTTabBarItem

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self commonInitialization];
    }
    return self;
}

- (instancetype)init {
    return [self initWithFrame:CGRectZero];
}

- (void)commonInitialization {
    [self setBackgroundColor:[UIColor clearColor]];
    
    _title = @"";
    _titlePositionAdjustment = UIOffsetZero;
    
    if (NSFoundationVersionNumber > NSFoundationVersionNumber_iOS_6_1) {
        _unselectedTitleAttributes = @{NSFontAttributeName:[UIFont systemFontOfSize:12],
                                       NSForegroundColorAttributeName:[UIColor blackColor]
        };
    }
    
    _selectedTitleAttributes = [_unselectedTitleAttributes copy];
    _badgeBackgroundColor = [UIColor redColor];
    _badgeTextColor = [UIColor whiteColor];
    _badgeTextFont = [UIFont systemFontOfSize:12];
    _badgePositionAdjustment = UIOffsetZero;
}

- (void)drawRect:(CGRect)rect {
    CGSize frameSize = self.frame.size;
    CGSize imageSize = CGSizeZero;
    CGSize titleSize = CGSizeZero;
    NSDictionary *titleAttributes = nil;
    UIImage *backgroudImage = nil;
    UIImage *image = nil;
    CGFloat imageStartingY = 0.f;
    
    if ([self isSelected]) {
        image = [self selectedImg];
        backgroudImage = [self selectedBackgroundImg];
        titleAttributes = [self selectedTitleAttributes];
        if (!titleAttributes) {
            titleAttributes = [self unselectedTitleAttributes];
        }
    } else {
        image = [self unselectedImg];
        backgroudImage = [self unselectedBackgroundImg];
        titleAttributes = [self unselectedTitleAttributes];
    }
    CGFloat scale = 0.5;
    imageSize = CGSizeMake(image.size.width * scale, image.size.height * scale);
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSaveGState(context);
    
    [backgroudImage drawInRect:self.bounds];
    if (!_title.length) {
        CGRect imgRect = CGRectMake(frameSize.width * 0.5 - imageSize.width * 0.5 + _imagePositionAdjustment.horizontal, frameSize.height * 0.5 - imageSize.height * 0.5 + _imagePositionAdjustment.vertical, imageSize.width, imageSize.height);
        [image drawInRect:imgRect];
    } else {
        if (NSFoundationVersionNumber > NSFoundationVersionNumber_iOS_6_1) {
            titleSize = [_title boundingRectWithSize:CGSizeMake(frameSize.width, 20) options:NSStringDrawingUsesLineFragmentOrigin attributes:titleAttributes context:nil].size;
            imageStartingY = (frameSize.height - imageSize.height - titleSize.height) * 0.5;
            CGRect imgRect = CGRectMake(frameSize.width * 0.5 - imageSize.width * 0.5 + _imagePositionAdjustment.horizontal, imageStartingY + _imagePositionAdjustment.vertical, imageSize.width, imageSize.height);
            [image drawInRect:imgRect];
            CGContextSetFillColorWithColor(context, [titleAttributes[NSForegroundColorAttributeName] CGColor]);
            [_title drawInRect:CGRectMake(frameSize.width * 0.5 - titleSize.width * 0.5 + _titlePositionAdjustment.horizontal, imageSize.height + _titlePositionAdjustment.vertical, titleSize.width, titleSize.height) withAttributes:titleAttributes];
        }
    }
    
    if ([[self badgeValue] length]) {
        CGSize badgeSize = CGSizeZero;
        if (NSFoundationVersionNumber > NSFoundationVersionNumber_iOS_6_1) {
            badgeSize = [_badgeValue boundingRectWithSize:CGSizeMake(frameSize.width, 20) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[self badgeTextFont]} context:nil].size;
        }
        CGFloat textOffset = 2.0f;
        if (badgeSize.width < badgeSize.height) {
            badgeSize = CGSizeMake(badgeSize.height, badgeSize.height);
        }
        CGRect badgeBackgroudFrame = CGRectMake(frameSize.width * 0.5 + (imageSize.width * 0.5) * 0.9 + [self badgePositionAdjustment].horizontal, textOffset + [self badgePositionAdjustment].vertical, badgeSize.width + 2 * textOffset, badgeSize.height + 2 * textOffset);
        if ([self badgeBackgroundColor]) {
            CGContextSetFillColorWithColor(context, [[self badgeBackgroundColor] CGColor]);
            CGContextFillRect(context, badgeBackgroudFrame);
        } else if ([self badgeBackgroundImage]) {
            [[self badgeBackgroundImage] drawInRect:badgeBackgroudFrame];
        }
        CGContextSetFillColorWithColor(context, [[self badgeTextColor] CGColor]);
        
        if (NSFoundationVersionNumber > NSFoundationVersionNumber_iOS_6_1) {
            NSMutableParagraphStyle *badgeTextStyle = [[NSMutableParagraphStyle defaultParagraphStyle] mutableCopy];
            [badgeTextStyle setLineBreakMode:NSLineBreakByWordWrapping];
            [badgeTextStyle setAlignment:NSTextAlignmentCenter];
            
            NSDictionary *badgeTextAttributes = @{NSFontAttributeName:[self badgeTextFont],
                                                  NSForegroundColorAttributeName:[self badgeTextColor],
                                                  NSParagraphStyleAttributeName:badgeTextStyle
            };
            [[self badgeValue] drawInRect:CGRectMake(CGRectGetMinX(badgeBackgroudFrame) + textOffset, CGRectGetMinY(badgeBackgroudFrame) + textOffset, badgeSize.width, badgeSize.height) withAttributes:badgeTextAttributes];
        }
    }
    
    CGContextRestoreGState(context);
}

- (UIImage *)finishedSelectedImage {
    return [self selectedImg];
}

- (UIImage *)finishedUnselectedImage {
    return [self unselectedImg];
}

- (void)setFinishedSelectedImage:(UIImage *)selectedImage withFinishedUnselectedImage:(UIImage *)unselectedImage {
    if (selectedImage && selectedImage != [self selectedImg]) {
        [self setSelectedImg:selectedImage];
    }
    
    if (unselectedImage && unselectedImage != [self unselectedImg]) {
        [self setUnselectedImg:unselectedImage];
    }
}

- (void)setBadgeValue:(NSString *)badgeValue {
    _badgeValue = badgeValue;
    [self setNeedsDisplay];
}

- (UIImage *)backgroundSelectedImage {
    return [self selectedBackgroundImg];
}

- (UIImage *)backgroundUnselectedImage {
    return [self unselectedBackgroundImg];
}

- (void)setBackgroundSelectedImage:(UIImage *)selectedImage withUnselectedImage:(UIImage *)unselectedImage {
    if (selectedImage && selectedImage != [self selectedBackgroundImg]) {
        [self setSelectedBackgroundImg:selectedImage];
    }
    if (unselectedImage && unselectedImage != [self unselectedBackgroundImg]) {
        [self setUnselectedBackgroundImg:unselectedImage];
    }
}

@end
