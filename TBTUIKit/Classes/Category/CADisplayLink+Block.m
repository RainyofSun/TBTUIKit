//
//  CADisplayLink+Block.m
//  Nicelive
//
//  Created by zhaobin on 2018/2/7.
//  Copyright © 2018年 nice. All rights reserved.
//

#import "CADisplayLink+Block.h"
#import <objc/runtime.h>
static const char kDisplayLinkKey;
@implementation CADisplayLink (Block)
+ (instancetype)kk_displayLinkWithBlock:(KKCADisplayLinkBolck)block
{
   
    CADisplayLink *displayLink = [self displayLinkWithTarget:self selector:@selector(kk_displayLink:)];
    objc_setAssociatedObject(displayLink, &kDisplayLinkKey, block, OBJC_ASSOCIATION_COPY_NONATOMIC);
    return displayLink;
}

+ (void)kk_displayLink:(CADisplayLink *)displayLink
{
    KKCADisplayLinkBolck block = objc_getAssociatedObject(displayLink, &kDisplayLinkKey);
    if(block) {
        block(displayLink);
    }
}

@end
