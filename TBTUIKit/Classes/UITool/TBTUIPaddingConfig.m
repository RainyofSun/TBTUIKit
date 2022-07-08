//
//  TBTUIPaddingConfig.m
//  TBTUIKit
//
//  Created by 苍蓝猛兽 on 2022/7/8.
//

#import "TBTUIPaddingConfig.h"

static CGFloat edage_basic_distance = 20;
static CGFloat widget_basic_distance = 4;

@implementation TBTUIPaddingConfig

+ (CGFloat)tbt_edagePaddingWithScale:(CGFloat)scale {
    return MAX(edage_basic_distance * scale, edage_basic_distance);
}

+ (CGFloat)tbt_widgetPaddingWithScale:(CGFloat)scale {
    return MAX(widget_basic_distance * scale, widget_basic_distance);
}

@end
