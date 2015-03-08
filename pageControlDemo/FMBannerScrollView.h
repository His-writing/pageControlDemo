//
//  FMBannerScrollView.h
//  BOCMFMI
//
//  Created by Ivan on 14-2-18.
//  Copyright (c) 2014年 BOC. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol FMBannerScrollViewDelegate <NSObject>

- (void)ClickBanner:(NSInteger)index;

@end

@interface FMBannerScrollView : UIView

@property (assign, nonatomic) id<FMBannerScrollViewDelegate> delegate;

@end
