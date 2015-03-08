//
//  ViewController.m
//  pageControlDemo
//
//  Created by panyanming on 15-2-6.
//  Copyright (c) 2015年 panyanming. All rights reserved.
//

#import "ViewController.h"
#import "FMBannerScrollView.h"
@interface ViewController ()<FMBannerScrollViewDelegate>

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    FMBannerScrollView *bannerScrollView = [[FMBannerScrollView alloc] initWithFrame:CGRectMake(0, 10, 320, 155)];
    bannerScrollView.delegate = self;
    [self.view addSubview:bannerScrollView];
}

- (void)ClickBanner:(NSInteger)index
{
    NSLog(@"%ld",(long)index);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
