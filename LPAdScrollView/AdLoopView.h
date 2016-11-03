//
//  AdLoopView.h
//  LPAdScrollView
//
//  Created by QFWangLP on 2016/11/1.
//  Copyright © 2016年 LeeFengHY. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol AdLoopViewDelegate <NSObject>

@optional
- (void)didTapImageWithIndex:(NSInteger)index;

@end

@interface AdLoopView : UIView

@property (nonatomic, copy) NSArray *imageArray;
@property (nonatomic, copy) NSArray *titleArray;
@property (nonatomic, assign) NSInteger currentIndex;
@property (nonatomic, strong) NSTimer *timer;
@property (nonatomic, assign) NSTimeInterval timeInterval;
@property (nonatomic, assign) CGFloat lp_width;
@property (nonatomic, assign) CGFloat lp_height;
@property (nonatomic, weak)  id<AdLoopViewDelegate> delegate;

- (instancetype)initWithFrame:(CGRect)frame imageArray:(NSArray *)imageArray titleArray:(NSArray *)titleArray;

@end
