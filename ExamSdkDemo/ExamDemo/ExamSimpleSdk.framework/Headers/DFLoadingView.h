//
//  DFLoadingView.h
//  ExamDemo
//
//  Created by dyf on 15/3/23.
//  Copyright (c) 2015 dyf. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DFLoadingView : UIView
@property (nonatomic, retain) UIColor *color;
@property (nonatomic, assign) CGFloat cornerRadius;
@property (nonatomic,  copy ) NSString *text;
@property (nonatomic, assign) CGFloat aalpha;

- (void)showLoading:(UIView *)superView animated:(BOOL)animated;

- (void)dismissLoading:(BOOL)animated;

@end
