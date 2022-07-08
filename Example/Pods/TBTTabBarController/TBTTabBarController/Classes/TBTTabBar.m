//
//  TBTTabBar.m
//  TBT
//
//  Created by 刘冉 on 2022/6/9.
//

#import "TBTTabBar.h"

@interface TBTTabBar ()

@property (nonatomic,assign) CGFloat itemWidth;
@property (nonatomic,strong) UIView *backgroundView;
@property (nonatomic,strong) CALayer *grayLineLayer;

@end

@implementation TBTTabBar

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self commonInitialization];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)coder {
    if (self = [super initWithCoder:coder]) {
        [self commonInitialization];
    }
    return self;
}

- (instancetype)init {
    return [self initWithFrame:CGRectZero];
}

- (void)commonInitialization {
    _backgroundView = [[UIView alloc] init];
    [self addSubview:_backgroundView];
    _grayLineLayer = [CALayer layer];
    _grayLineLayer.backgroundColor = [UIColor colorWithRed:232/255.0 green:234/255.0 blue:235/255.0 alpha:1].CGColor;
    [_backgroundView.layer addSublayer:_grayLineLayer];
    [self setTranslucent:NO];
    [self setShowGrayLine:YES];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    CGSize frameSize = self.frame.size;
    CGFloat minimumContentHeight = [self minimumContentHeight];
    
    [[self backgroundView] setFrame:CGRectMake(0, frameSize.height - minimumContentHeight, frameSize.width, frameSize.height)];
    _grayLineLayer.frame = CGRectMake(0, 0, frameSize.width, 1);
    [self setItemWidth:roundf((frameSize.width - [self contentEdgeInsets].left - [self contentEdgeInsets].right)/[self items].count)];
    
    NSInteger index = 0;
    for (TBTTabBarItem *item in [self items]) {
        CGFloat itemHeight = [item itemHeight];
        if (!itemHeight) {
            itemHeight = frameSize.height - 1;
        }
        [item setFrame:CGRectMake(self.contentEdgeInsets.left + (index * self.itemWidth), roundf(frameSize.height - itemHeight) - self.contentEdgeInsets.top, self.itemWidth, itemHeight - self.contentEdgeInsets.bottom)];
        [item setNeedsDisplay];
        index ++;
    }
}

- (void)setItemWidth:(CGFloat)itemWidth {
    if (itemWidth > 0) {
        _itemWidth = itemWidth;
    }
}

- (void)setItems:(NSArray *)items {
    for (TBTTabBarItem *item in _items) {
        [item removeFromSuperview];
    }
    _items = [items copy];
    for (TBTTabBarItem *item in _items) {
        [item addTarget:self action:@selector(tabbarItemWasSelected:) forControlEvents:UIControlEventTouchDown];
        [self addSubview:item];
    }
}

- (void)setHeight:(CGFloat)height {
    [self setFrame:CGRectMake(CGRectGetMinX(self.frame), CGRectGetMinY(self.frame), CGRectGetWidth(self.frame), height)];
}

- (CGFloat)minimumContentHeight {
    CGFloat minimumTabBarContentHeight = CGRectGetHeight(self.frame);
    
    for (TBTTabBarItem *item in [self items]) {
        CGFloat itemHeight = [item itemHeight];
        if (itemHeight && (itemHeight < minimumTabBarContentHeight)) {
            minimumTabBarContentHeight = itemHeight;
        }
    }
    return minimumTabBarContentHeight;
}

#pragma mark - Item Selection
- (void)tabbarItemWasSelected:(TBTTabBarItem *)sender {
    if ([[self delegate] respondsToSelector:@selector(tabBar:shouldSelectItemAtIndex:)]) {
        NSInteger index = [self.items indexOfObject:sender];
        if (![[self delegate] tabBar:self shouldSelectItemAtIndex:index]) {
            return;
        }
        
        [self setSelectedItem:sender];
        
        if ([[self delegate] respondsToSelector:@selector(tabBar:didSelectItemAtIndex:)]) {
            NSInteger index = [self.items indexOfObject:sender];
            [[self delegate] tabBar:self didSelectItemAtIndex:index];
        }
    }
}

- (void)setSelectedItem:(TBTTabBarItem *)selectedItem {
    if (selectedItem == _selectedItem) {
        return;
    }
    [_selectedItem setSelected:NO];
    
    _selectedItem = selectedItem;
    
    [_selectedItem setSelected:YES];
}

- (void)setTranslucent:(BOOL)translucent {
    _translucent = translucent;
    CGFloat alpha = (translucent ? 0.9 : 1.0);
    
    [_backgroundView setBackgroundColor:[UIColor colorWithWhite:1.0 alpha:alpha]];
}

- (void)setShowGrayLine:(BOOL)showGrayLine {
    _showGrayLine = showGrayLine;
    _grayLineLayer.hidden = !showGrayLine;
}

@end
