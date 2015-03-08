//
//  FMBannerScrollView.m
//  BOCMFMI
//
//  Created by Ivan on 14-2-18.
//  Copyright (c) 2014年 BOC. All rights reserved.
//

#import "FMBannerScrollView.h"
#import "FMCustomPageControl.h" //PageCongrol

@interface FMBannerScrollView () <UIScrollViewDelegate>
{
    //开始设置当前页为 0
   NSInteger  _currentPage;

}
@property (strong, nonatomic) UIScrollView *scrollViewBanner;
@property (strong, nonatomic) NSMutableArray *arrayImage;
@property (strong, nonatomic) FMCustomPageControl *customPageControl;

@end

@implementation FMBannerScrollView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        
        [self initSelf];
    }
    return self;
}

/**
 *  @brief  视图初始化
 */
- (void)initSelf
{
    UIImage *imageBanner = [UIImage imageNamed:@"banner.png"];
    self.arrayImage = [NSMutableArray arrayWithObjects:imageBanner,imageBanner,imageBanner,imageBanner, nil];
    
    self.backgroundColor = [UIColor clearColor];
    // MARK: 广告栏
    self.scrollViewBanner = [[UIScrollView alloc] initWithFrame:self.bounds];
    _scrollViewBanner.backgroundColor = [UIColor clearColor];
    _scrollViewBanner.tag = 101;
    _scrollViewBanner.delegate = self;
    _scrollViewBanner.pagingEnabled = YES;
    _scrollViewBanner.bounces = NO;
    _scrollViewBanner.showsHorizontalScrollIndicator = NO;
    _scrollViewBanner.showsVerticalScrollIndicator = NO;[_scrollViewBanner setContentSize:CGSizeMake(_scrollViewBanner.frame.size.width*3, _scrollViewBanner.frame.size.height-1)];
    [self addSubview:_scrollViewBanner];
    
    self.customPageControl = [[FMCustomPageControl alloc] initWithStartPiont:CGPointMake(230, 200)];
    _customPageControl.currentPage = 0;
    _customPageControl.pageImageName = @"pageImage.png";
    _customPageControl.currentPageImageName = @"currentPageImage.png";
    _customPageControl.userInteractionEnabled = NO;
    _customPageControl.numberOfPages = [_arrayImage count];
    [self addSubview:_customPageControl];
    //开始设置当前页为 0
    _currentPage = 0;

    [self loadImage];
    
    [NSTimer scheduledTimerWithTimeInterval:2.0 target:self selector:@selector(handleTimer:) userInfo:nil repeats:YES];
}

/**
 *  @brief  控制3秒换一张图片
 */
- (void)handleTimer:(NSTimer *)timer
{
    if (_customPageControl.currentPage == _customPageControl.numberOfPages - 1) {
        _customPageControl.currentPage = 0;
    } else {
        _customPageControl.currentPage++;
    }
    CGFloat x = _scrollViewBanner.contentOffset.x + 320;
    
    if(x >= self.arrayImage.count*320) {
        x = 0;
    }
    //滚动到某个坐标
    [UIView animateWithDuration:0.7 //速度0.7秒
                     animations:^{//修改坐标
                         [_scrollViewBanner setContentOffset:CGPointMake(x, 0) animated:YES];
                     }];
}

/**
 *  @brief  清除UIScrollView里面所有的子视图
 */
- (void)clearSubViews
{
    for(UIView *view in _scrollViewBanner.subviews) {
        [view removeFromSuperview];
    }
}

/**
 *  @brief  加载广告位图片
 */
- (void)loadImage
{
    [self clearSubViews];
    
    //上一个索引
    NSInteger prePage = [self getPage:_currentPage - 1];
    //下一个索引
    NSInteger nextPage = [self getPage:_currentPage + 1];
    //上一张图片
    UIImage *preImage = [self.arrayImage objectAtIndex:prePage];
    //下一张图片
    UIImage *nextImage = [self.arrayImage objectAtIndex:nextPage];
    //当前图片
    UIImage *currentImage = [self.arrayImage objectAtIndex:_currentPage];
    
    //上一个图片视图
    UIImageView *preImageView = [[UIImageView alloc]initWithImage:preImage];
    preImageView.frame = CGRectMake(0, 0, 320, _scrollViewBanner.frame.size.height);
    [_scrollViewBanner addSubview:preImageView];
    
    //下一个图片视图
    UIImageView *nextImageView = [[UIImageView alloc]initWithImage:nextImage];
    nextImageView.frame = CGRectMake(640, 0, 320, _scrollViewBanner.frame.size.height);
    [_scrollViewBanner addSubview:nextImageView];
    
    //当前图片视图
    UIImageView *currentImageView = [[UIImageView alloc]initWithImage:currentImage];
    currentImageView.frame = CGRectMake(320, 0, 320, _scrollViewBanner.frame.size.height);
    [_scrollViewBanner addSubview:currentImageView];
    
    //设置从中间图片开始显示
    _scrollViewBanner.contentOffset = CGPointMake(320, 0);
}

/**
 *  @brief  获得当前第几页
 */
- (NSInteger)getPage:(NSInteger)page
{
    //如果索引小于 0 ，取得最后一个索引
    if(page < 0) {
        page = [self.arrayImage count] - 1;
        
    } else {
        //如果索引大于等于数组长度，索引从 0 开始
        if (page >= [self.arrayImage count])
        {
            page = 0;
        }
    }
    return page;
}

/**
 *  @brief  banner点击事件
 */
- (void)doSomething:(UIButton *)button
{
    NSInteger buttonTag = button.tag - 400;
    if (_delegate && [_delegate respondsToSelector:@selector(ClickBanner:)]) {
        [_delegate ClickBanner:buttonTag];
    }
}

/**
 *  @brief  property set method
 */
- (void)setDelegate:(id<FMBannerScrollViewDelegate>)delegate
{
    _delegate = delegate;
}

//==========================================================
#pragma mark - UIScrollViewDelegate Methods -
//==========================================================
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    if (scrollView.tag == 101) {
//        _customPageControl.currentPage = scrollView.contentOffset.x / _scrollViewBanner.frame.size.width;
            _customPageControl.currentPage = _currentPage;
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGFloat x = scrollView.contentOffset.x;
    if(x >= 640)
    {
        //加入下 3 张图片
        _currentPage = [self getPage:_currentPage + 1];
        [self loadImage];
    } else if (x <= 0) {
        //加入上 3 张图片
        _currentPage = [self getPage:_currentPage - 1];
        [self loadImage];
    }
    //改变分页控件为当前的页数
    //_customPageControl.currentPage = _currentPage;
}

@end
