//
//  AdLoopView.m
//  LPAdScrollView
//
//  Created by QFWangLP on 2016/11/1.
//  Copyright © 2016年 LeeFengHY. All rights reserved.
//

#import "AdLoopView.h"

#define pageControlPointWidth 20

@interface AdLoopView()<UIScrollViewDelegate>


@property (nonatomic, strong) UIScrollView *contentScrollView;
@property (nonatomic, strong) UIImageView *currentImageView;
@property (nonatomic, strong) UIImageView *lastImageView;
@property (nonatomic, strong) UIImageView *nextImageView;
@property (nonatomic, strong) UILabel *currentTextLabel;
@property (nonatomic, strong) UILabel *lastTextLabel;
@property (nonatomic, strong) UILabel *nextTextLabel;
@property (nonatomic, strong) UIPageControl *pageControl;

@end

@implementation AdLoopView

- (CGFloat)lp_height
{
    return self.frame.size.height;
}
- (void)setLp_height:(CGFloat)lp_height
{
    CGRect frame = self.frame;
    frame.size.height = lp_height;
    self.frame = frame;
}

- (CGFloat)lp_width
{
    return self.frame.size.width;
}
- (void)setLp_width:(CGFloat)lp_width
{
    CGRect frame = self.frame;
    frame.size.width = lp_width;
    self.frame = frame;
}

- (instancetype)initWithFrame:(CGRect)frame
                   imageArray:(NSArray *)imageArray
                   titleArray:(NSArray *)titleArray
{
    self = [super initWithFrame:frame];
    if (self) {
        _imageArray = imageArray;
        _titleArray = titleArray;
        self.currentIndex = 0;
        _timeInterval = 2.0;
        [self configUI];
    }
    return self;
}
- (void)configUI
{
    _contentScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, self.lp_width, self.lp_height)];
    _contentScrollView.showsVerticalScrollIndicator = NO;
    _contentScrollView.showsHorizontalScrollIndicator = NO;
    _contentScrollView.pagingEnabled = YES;
    _contentScrollView.bounces = NO;
    _contentScrollView.delegate = self;
    _contentScrollView.contentSize = CGSizeMake(self.lp_width * 3, 0);
    [self addSubview:_contentScrollView];
    
    _currentImageView = [[UIImageView alloc] initWithFrame:CGRectMake(self.lp_width, 0, self.lp_width, self.lp_height)];
    _currentImageView.userInteractionEnabled = YES;
    [_contentScrollView addSubview:_currentImageView];
    UITapGestureRecognizer *imageTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(currentImageTap:)];
    [_currentImageView addGestureRecognizer:imageTap];
    
    _lastImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.lp_width, self.lp_height)];
    [_contentScrollView addSubview:_lastImageView];
    
    _nextImageView = [[UIImageView alloc] initWithFrame:CGRectMake(self.lp_width * 2, 0, self.lp_width, self.lp_height)];
    [_contentScrollView addSubview:_nextImageView];
    
    [self setupScrollViewImage];
    [_contentScrollView setContentOffset:CGPointMake(self.lp_width, 0) animated:NO];
    
    _pageControl = [[UIPageControl alloc] initWithFrame:CGRectMake(self.lp_width - pageControlPointWidth * self.imageArray.count, self.lp_height - (pageControlPointWidth + 10), pageControlPointWidth * self.imageArray.count, 20)];
    _pageControl.currentPageIndicatorTintColor = [UIColor purpleColor];
    _pageControl.pageIndicatorTintColor = [UIColor yellowColor];
    _pageControl.numberOfPages = _imageArray.count;
    _pageControl.hidesForSinglePage = YES;
    [self addSubview:_pageControl];
    
    _timer = [NSTimer scheduledTimerWithTimeInterval:_timeInterval target:self selector:@selector(timerAction) userInfo:nil repeats:YES];
    NSRunLoop  *runLoop = [NSRunLoop currentRunLoop];
    [runLoop addTimer:_timer forMode:NSRunLoopCommonModes];
    
}
- (void)setTimeInterval:(NSTimeInterval)timeInterval
{
    _timeInterval = timeInterval;
    [_timer invalidate];
    _timer = nil;
    _timer = [NSTimer scheduledTimerWithTimeInterval:_timeInterval target:self selector:@selector(timerAction) userInfo:nil repeats:YES];
    NSRunLoop  *runLoop = [NSRunLoop currentRunLoop];
    [runLoop addTimer:_timer forMode:NSRunLoopCommonModes];
}
#pragma mark currentImageViewTap
- (void)currentImageTap:(UITapGestureRecognizer *)tap
{
    if (_delegate && [_delegate respondsToSelector:@selector(didTapImageWithIndex:)]) {
        [_delegate didTapImageWithIndex:_currentIndex];
    }
}
#pragma mark public method
- (void)setImageArray:(NSArray *)imageArray
{
    _imageArray = imageArray;
    if (self.pageControl) {
        _pageControl.enabled = _imageArray.count == 1?NO:YES;
        _pageControl.frame = CGRectMake(self.lp_width - pageControlPointWidth * _imageArray.count, self.lp_height - (pageControlPointWidth + 10), pageControlPointWidth * _imageArray.count, pageControlPointWidth);
        _pageControl.numberOfPages = _imageArray.count;
    }
}
- (void)setCurrentIndex:(NSInteger)currentIndex
{
    _currentIndex = currentIndex;
    if (self.pageControl) {
        _pageControl.currentPage = _currentIndex;
    }
}
- (void)setupScrollViewImage
{
    _currentImageView.image = [UIImage imageNamed:_imageArray[self.currentIndex]];
    _lastImageView.image = [UIImage imageNamed:_imageArray[[self getLastImageViewIndex:self.currentIndex]]];
    _nextImageView.image = [UIImage imageNamed:_imageArray[[self getNextImageViewIndex:self.currentIndex]]];
    
}
- (NSInteger)getLastImageViewIndex:(NSInteger)currentIndex
{
    NSInteger tempIndex = currentIndex - 1;
    if (tempIndex <= -1) {
        tempIndex = _imageArray.count - 1;
    }
    return tempIndex;
}
- (NSInteger)getNextImageViewIndex:(NSInteger)currentIndex
{
    NSInteger tempIndex = currentIndex + 1;
    if (tempIndex >= _imageArray.count) {
        tempIndex = 0;
    }
    return tempIndex;
}
- (void)timerAction
{
    NSLog(@"timerAction");
    [_contentScrollView setContentOffset:CGPointMake(self.lp_width * 2, 0) animated:YES];
}
#pragma mark UIScrollViewDelegate
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    CGFloat offset = scrollView.contentOffset.x/self.lp_width;
    if (offset == 0) {
        self.currentIndex = [self getLastImageViewIndex:_currentIndex];
    }else if (offset == 2){
        self.currentIndex = [self getNextImageViewIndex:_currentIndex];
    }
    [self setupScrollViewImage];
    [scrollView setContentOffset:CGPointMake(self.lp_width, 0) animated:NO];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    if (!decelerate) {
        [self scrollViewDidEndDecelerating:scrollView];
    }
}
- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView
{
    [self scrollViewDidEndDecelerating:scrollView];
}
@end
