//
//  UIButton+TBTTimerBtn.m
//  TBTUIKit
//
//  Created by 刘冉 on 2022/6/22.
//

#import "UIButton+TBTTimerBtn.h"

@implementation UIButton (TBTTimerBtn)

-(void)startWithTime:(NSInteger)timeLine
               title:(NSString *)title
      countDownTitle:(NSString *)subTitle
           mainColor:(UIColor *)mColor
          countColor:(UIColor *)color
{
    //倒计时时间
    __block NSInteger timeOut = timeLine;
    //创建一个线程
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    //创建一个时间源
    dispatch_source_t _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);
    //时间每秒执行一次
    dispatch_source_set_timer(_timer, dispatch_walltime(NULL, 0), 1.0*NSEC_PER_SEC, 0);
    dispatch_source_set_event_handler(_timer, ^{
        //小于0时
        if (timeOut <= 0)
        {
            dispatch_source_cancel(_timer);
            dispatch_async(dispatch_get_main_queue(), ^{
                self.backgroundColor = mColor;
                [self setTitle:title forState:UIControlStateNormal];
                self.userInteractionEnabled = YES;
            });
        }
        else
        {
            //大于0时计算需要显示的文字
            int seconds = (int)timeOut % 60;
            NSString * timeStr = [NSString stringWithFormat:@"%d",seconds];
            dispatch_async(dispatch_get_main_queue(), ^{
                self.backgroundColor = color;
                [self setTitle:[NSString stringWithFormat:@"%@(%@s)",subTitle,timeStr] forState:UIControlStateNormal];
                self.userInteractionEnabled = NO;
            });
            timeOut--;
        }
    });
    dispatch_resume(_timer);
}

@end
