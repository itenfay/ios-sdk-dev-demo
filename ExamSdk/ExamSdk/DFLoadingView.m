//
//  DFLoadingView.m
//
//  Created by dyf on 15/3/23.
//  Copyright (c) 2015 dyf. All rights reserved.
//

#import "DFLoadingView.h"

CGFloat kMargin = 10;

@implementation DFLoadingView

- (instancetype)init {
    self = [super init];
    if (self) {
        self.color = [UIColor blackColor];
        self.cornerRadius = 0.0;
        self.aalpha = 0.7;
        self.text = @"加载中...";
    }
    return self;
}

- (void)setAllViews {
    UIView *contentView = [[UIView alloc] init];
    contentView.backgroundColor = [UIColor clearColor];
    [self addSubview:contentView];
    
    UIView *backgroundView = [[UIView alloc] init];
    backgroundView.alpha = self.aalpha;
    backgroundView.backgroundColor = self.color;
    [contentView addSubview:backgroundView];
    
    UIActivityIndicatorView *anIndicator = [[UIActivityIndicatorView alloc] init];
    anIndicator.frame = CGRectMake(kMargin, kMargin, 40, 40);
    [anIndicator setActivityIndicatorViewStyle:UIActivityIndicatorViewStyleWhiteLarge];
    [anIndicator startAnimating];
    [contentView addSubview:anIndicator];
    
    UILabel *label = [[UILabel alloc] init];
    label.frame = CGRectMake(anIndicator.frame.size.width + 2*kMargin, (anIndicator.frame.size.height + 2*kMargin - 30)/2, 100, 30);
    label.text = self.text;
    label.adjustsFontSizeToFitWidth = YES;
    label.textColor = [UIColor whiteColor];
    label.font = [UIFont systemFontOfSize:16];
    label.backgroundColor = [UIColor clearColor];
    label.textAlignment = NSTextAlignmentLeft;
    [contentView addSubview:label];
    
    CGPoint aCenter = self.center;
    CGFloat aWidth = anIndicator.frame.size.width + label.frame.size.width + 2.5*kMargin;
    CGFloat aHeight = anIndicator.frame.size.height + 2*kMargin;
    CGRect aBounds = CGRectMake(0, 0, aWidth, aHeight);
    contentView.center = aCenter;
    contentView.bounds = aBounds;
    backgroundView.frame = contentView.bounds;
}

- (void)showLoading:(UIView *)superView animated:(BOOL)animated {
    self.frame = superView.bounds;
    if (animated) { //暂未处理
        [self setAllViews];
    }
    [superView addSubview:self];
}

- (void)dismissLoading:(BOOL)animated {
    if (animated) {
        //暂未处理
    } else {
        //暂未处理
    }
    [self removeFromSuperview];
}

@end
