//
//  ViewController.m
//  LPAdScrollView
//
//  Created by QFWangLP on 2016/11/1.
//  Copyright © 2016年 LeeFengHY. All rights reserved.
//

#import "ViewController.h"
#import "AdLoopView.h"

@interface ViewController ()<AdLoopViewDelegate>

@property (nonatomic, strong) AdLoopView *adLoopView;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.title = @"广告循环轮播";
    NSArray *imageArray = @[@"first.jpg",@"second.jpg",@"third.jpg"];
    _adLoopView = [[AdLoopView alloc] initWithFrame:CGRectMake(0, 64, self.view.frame.size.width, 200) imageArray:imageArray titleArray:nil];
    _adLoopView.delegate = self;
    [self.view addSubview:_adLoopView];
}


- (void)didTapImageWithIndex:(NSInteger)index
{
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil message:[NSString stringWithFormat:@"点击了第%ld张照片",index+1] delegate:self cancelButtonTitle:@"Cancle" otherButtonTitles: nil];
    [alertView show];
}


@end
