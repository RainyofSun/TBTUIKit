//
//  CADisplayLink+Block.h
//  Nicelive
//
//  Created by zhaobin on 2018/2/7.
//  Copyright © 2018年 nice. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^KKCADisplayLinkBolck) (CADisplayLink *displayLink);

@interface CADisplayLink (Block)
+ (instancetype)kk_displayLinkWithBlock:(KKCADisplayLinkBolck)block;
@end
