//
//  FMCustomPageControl.h
//  BOCMFMI
//
//  Created by Ivan on 14-2-17.
//  Copyright (c) 2014年 BOC. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FMCustomPageControl : UIControl

@property (assign, nonatomic) NSInteger numberOfPages;                  //总页数
@property (assign, nonatomic) NSInteger currentPage;                    //当前页数

@property (copy, nonatomic) NSString *currentPageImageName;             //当前页图片名字
@property (copy, nonatomic) NSString *pageImageName;                    //普通页图片名字

@property (strong, nonatomic) UIColor *pageIndicatorTintColor;          //普通页Indicator颜色
@property (strong, nonatomic) UIColor *currentPageIndicatorTintColor;   //当前页Indicator颜色

/**
 *  @brief  初始化方法
 *  @param  startPoint - 起始位置
 *  @note   宽高自适应
 */
- (id)initWithStartPiont:(CGPoint)startPoint;

@end
