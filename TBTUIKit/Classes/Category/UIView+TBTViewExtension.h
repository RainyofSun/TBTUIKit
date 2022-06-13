//
//  UIView+TBTViewExtension.h
//  TBT
//
//  Created by 刘冉 on 2022/6/13.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIView (TBTViewExtension)

/// FrameLeft
@property (nonatomic, assign) CGFloat FL;
/// FrameRight
@property (nonatomic, assign) CGFloat FR;
/// FrameTop
@property (nonatomic, assign) CGFloat FT;
/// FrameBottom
@property (nonatomic, assign) CGFloat FB;
/// FrameWidth
@property (nonatomic, assign) CGFloat FW;
/// FrameHeight
@property (nonatomic, assign) CGFloat FH;
/// FrameCenterX
@property (nonatomic, assign) CGFloat FCX;
/// FrameCenterY
@property (nonatomic, assign) CGFloat FCY;
/// FrameSize
@property (nonatomic, assign) CGSize  FSize;

@end

NS_ASSUME_NONNULL_END
