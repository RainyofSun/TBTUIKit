//
//  NSString+Size.m
//  Pods
//
//  Created by 刘冉 on 2022/6/14.
//

#import "NSString+Size.h"

@implementation NSString (Size)

- (CGSize)tbt_sizeWithFont:(UIFont *)font
{
    return [self tbt_sizeWithFont:font width:CGFLOAT_MAX lineBreakMode:NSLineBreakByWordWrapping];
}

- (CGSize)tbt_sizeWithFont:(UIFont *)font width:(CGFloat)width
{
    return [self tbt_sizeWithFont:font width:width lineBreakMode:NSLineBreakByWordWrapping];
}

- (CGSize)tbt_sizeWithFontSize:(CGFloat)fontSize width:(CGFloat)width
{
    return [self tbt_sizeWithFont:[UIFont systemFontOfSize:fontSize] width:width lineBreakMode:NSLineBreakByWordWrapping];
}

- (CGSize)tbt_sizeWithFont:(UIFont *)font width:(CGFloat)width lineBreakMode:(NSLineBreakMode)lineBreakMode
{
    return [self tbt_sizeWithFont:font constrainedToSize:CGSizeMake(width, CGFLOAT_MAX) lineBreakMode:lineBreakMode];
}

- (CGSize)tbt_sizeWithFont:(UIFont *)font constrainedToSize:(CGSize)size lineBreakMode:(NSLineBreakMode)lineBreakMode {
    return [self tbt_sizeWithFont:font constrainedToSize:size lineBreakMode:lineBreakMode attributes:nil];
}

- (CGSize)tbt_sizeWithFont:(UIFont *)font constrainedToSize:(CGSize)size lineBreakMode:(NSLineBreakMode)lineBreakMode attributes:(NSDictionary *)attributes {
    if (!font) {
        return CGSizeZero;
    }
    NSMutableParagraphStyle *paragraphStyle = [NSMutableParagraphStyle new];
    paragraphStyle.lineBreakMode = lineBreakMode;
    paragraphStyle.alignment = NSTextAlignmentLeft;
    
    NSMutableDictionary *mutableAttributes = [NSMutableDictionary dictionaryWithDictionary:attributes];
    [mutableAttributes setValuesForKeysWithDictionary:@{NSFontAttributeName:font,
                                                        NSParagraphStyleAttributeName:paragraphStyle}];
    return [self boundingRectWithSize:size
                              options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading
                           attributes:mutableAttributes
                              context:NULL].size;
}

- (CGSize)threadSafeSizeWithFont:(UIFont *)font {
    return [self threadSafeSizeWithFont:font constrainedToSize:CGSizeMake(CGFLOAT_MAX, CGFLOAT_MAX)];
}

- (CGSize)threadSafeSizeWithFont:(UIFont *)font constrainedToSize:(CGSize)size {
    NSAttributedString *attributedText =
    [[NSAttributedString alloc] initWithString:self attributes:@{NSFontAttributeName:font}];
    CGRect rect = [attributedText boundingRectWithSize:size
                                               options:NSStringDrawingUsesLineFragmentOrigin
                                               context:nil];
    return rect.size;
}

@end
