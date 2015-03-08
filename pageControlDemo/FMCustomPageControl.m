//
//  FMCustomPageControl.m
//  BOCMFMI
//
//  Created by Ivan on 14-2-17.
//  Copyright (c) 2014年 BOC. All rights reserved.
//

#import "FMCustomPageControl.h"
#import <QuartzCore/QuartzCore.h>

@interface FMCustomPageControl ()
{
    CGFloat _halfWidth;
    CGFloat _halfHeight;
    CGFloat _radiusIn;
    CGFloat _radiusOut;
    CGFloat _beginMargin;
    CGFloat _margin;
    
    BOOL _isImage;
}

@property (strong, nonatomic) UIImage *currentPageImage;
@property (strong, nonatomic) UIImage *pageImage;

@end

@implementation FMCustomPageControl

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.clipsToBounds = YES;
        self.backgroundColor = [UIColor clearColor];
        self.layer.cornerRadius = 7.0f;
        self.alpha = .8f;
        
        [self resetParameters];
    }
    return self;
}

/**
 *  @brief  重置所有参数
 */
- (void)resetParameters
{
    _beginMargin = 3.0f;
    _margin = 4.0f;
    
    _halfWidth = self.bounds.size.width / 2;
    _halfHeight = self.bounds.size.height / 2;
    _radiusIn = 5.0f;
    _radiusOut = 5.0f;
}

/**
 *  @brief  初始化方法
 *  @param  startPoint - 起始位置
 *  @note   宽高自适应
 */
- (id)initWithStartPiont:(CGPoint)startPoint
{
    return [self initWithFrame:CGRectMake(startPoint.x, startPoint.y, 0, 0)];
}

/**
 *  @brief  添加Indicator图片
 */
#define beginTag    100
- (void)addImageToView
{
    if (_numberOfPages) {
        for (int i = 0; i < _numberOfPages; i++) {
            CGFloat locationX = _beginMargin + i * (_currentPageImage.size.width + _margin);
            NSLog(@"%@",NSStringFromCGSize(_currentPageImage.size));
            UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(locationX, _halfHeight - _currentPageImage.size.width / 2, _currentPageImage.size.width, _currentPageImage.size.width)];
            imageView.backgroundColor = [UIColor clearColor];
            [self addSubview:imageView];
            
            imageView.tag = beginTag + i;
            if (i == _currentPage) {
                imageView.image = _currentPageImage;
            } else {
                imageView.image = _pageImage;
            }
        }
    }
}

/**
 *  @brief  变更当前所选Indicator图片
 */
- (void)changeImage
{
    if (_numberOfPages) {
        for (UIView *element in self.subviews) {
            if ([element isKindOfClass:[UIImageView class]]) {
                if ((element.tag - beginTag) == _currentPage) {
                    ((UIImageView *) element).image = _currentPageImage;
                } else {
                    ((UIImageView *) element).image = _pageImage;
                }
            }
        }
    }
}

/**
 *  @brief  判断Indicator是 图片 ? 画图
 */
- (BOOL)decideWhetherImage
{
    if (_currentPageImageName && _currentPageImageName.length && _pageImageName && _pageImageName.length) {
        _isImage = YES;
    } else {
        _isImage = NO;
    }
    return _isImage;
}

//==========================================================
#pragma mark - set method -
//==========================================================
- (void)setBackgroundColor:(UIColor *)backgroundColor
{
    [super setBackgroundColor:backgroundColor];
}

/**
 *  @brief  自适应宽高
 */
- (void)resetSelfFrame
{
    CGRect frame = self.frame;
    frame.size.width = _numberOfPages * (_radiusOut * 2 + _margin) + _beginMargin * 2 - _margin;
    frame.size.height = _radiusOut * 2 + 4;
    self.frame = frame;
    
    [self resetParameters];
}

/**
 *  @brief  子视图刷新方法
 */
- (void)layoutImageView
{
    if (_isImage) {
        [self changeImage];
    } else {
        [self setNeedsDisplay];
    }
}

/**
 *  @brief  设置Indicator图片
 */
- (void)resetImage
{
    if ([self decideWhetherImage]) {
        _pageImage = [UIImage imageNamed:_pageImageName];
        _currentPageImage = [UIImage imageNamed:_currentPageImageName];
        [self addImageToView];
    }
}

//==========================================================
#pragma mark - @property Set Methods -
//==========================================================
- (void)setCurrentPage:(NSInteger)currentPage
{
    _currentPage = currentPage;
    if (_currentPage >= _numberOfPages) {
        _currentPage = 0;
    }
    [self layoutImageView];
}

- (void)setNumberOfPages:(NSInteger)numberOfPages
{
    _numberOfPages = numberOfPages;
    if (_numberOfPages) {
        [self resetSelfFrame];
    }
    if (_pageImageName && _currentPageImageName) {
        [self resetImage];
    }
}

- (void)setPageIndicatorTintColor:(UIColor *)pageIndicatorTintColor
{
    _pageIndicatorTintColor = pageIndicatorTintColor;
}

- (void)setCurrentPageIndicatorTintColor:(UIColor *)currentPageIndicatorTintColor
{
    _currentPageIndicatorTintColor = currentPageIndicatorTintColor;
}

- (void)setCurrentPageImageName:(NSString *)currentPageImageName
{
    _currentPageImageName = nil;
    if (![currentPageImageName isKindOfClass:[NSNull class]] && currentPageImageName && currentPageImageName.length) {
        _currentPageImageName = currentPageImageName;
    }
    [self resetImage];
}

- (void)setPageImageName:(NSString *)pageImageName
{
    _pageImageName = nil;
    if (![pageImageName isKindOfClass:[NSNull class]] && pageImageName && pageImageName.length) {
        _pageImageName = pageImageName;
    }
    [self resetImage];
}

- (void)setCurrentPageImage:(UIImage *)currentPageImage
{
    _currentPageIndicatorTintColor = [UIColor clearColor];
    _currentPageImage = currentPageImage;
}

- (void)setPageImage:(UIImage *)pageImage
{
    _pageIndicatorTintColor = [UIColor clearColor];
    _pageImage = pageImage;
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
    if (!_isImage) {
        CGContextRef con = UIGraphicsGetCurrentContext();
        for (int i = 0; i < _numberOfPages; i++) {
            CGFloat locationX = _beginMargin + i * (_radiusOut * 2 + _margin);
            CGContextAddEllipseInRect(con, CGRectMake(locationX, _halfHeight - _radiusIn, 2 * _radiusIn, 2 * _radiusIn));
            if (i == _currentPage) {
                CGContextSetFillColorWithColor(con, [UIColor colorWithRed:61.0f/255.0f green:193.0f/255.0f blue:195.0f/255.0f alpha:1.0f].CGColor);
            } else {
                CGContextSetFillColorWithColor(con, [UIColor clearColor].CGColor);
            }
            
            CGContextFillPath(con);
            
            UIBezierPath * p = [UIBezierPath bezierPathWithOvalInRect:CGRectMake(locationX - (_radiusOut - _radiusIn), _halfHeight - _radiusOut, 2 * _radiusOut, 2 * _radiusOut)];
            [[UIColor colorWithRed:61.0f/255.0f green:193.0f/255.0f blue:195.0f/255.0f alpha:1.0f] setStroke];
            p.lineWidth = 1.0f;
            [p stroke];
        }
    }
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    CGFloat locationX = .0f;
    locationX = [touch locationInView:self].x;
    int locationXX = locationX;
    int radiusOut = _radiusOut;
    int beginMargin = _beginMargin;
    int margin = _margin;
    if (locationXX > beginMargin + margin / 2 + radiusOut * 2) {
        int touchPointX = locationXX - beginMargin - radiusOut * 2 - margin / 2;
        int perWidth = (_margin + 2 * _radiusOut);
        _currentPage = touchPointX / perWidth + 1;
        if (_currentPage >= _numberOfPages) {
            _currentPage = _numberOfPages - 1;
        }
        if (_currentPage < 1) {
            _currentPage = 0;
        }
    } else {
        _currentPage = 0;
    }
    [self layoutImageView];
}

@end
