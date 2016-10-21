//
//  BannerTableViewCell.m
//  ZPJawaMall
//
//  Created by zhupeng on 16/8/29.
//  Copyright © 2016年 朱鹏. All rights reserved.
//

#import "BannerTableViewCell.h"
#import "BannerGoods.h"
#import "GoodsDetail.h"

@interface BannerTableViewCell ()<UIScrollViewDelegate>

@property (strong, nonatomic) IBOutlet UIScrollView *BannerScrollView;
@property (strong, nonatomic) IBOutlet UIPageControl *BannerPageControl;
@property (nonatomic, strong) NSTimer *timer;

@end

@implementation BannerTableViewCell

- (void)dealloc {
    [self.timer invalidate];
    self.timer = nil;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    self.BannerScrollView.showsVerticalScrollIndicator = NO;
    self.BannerScrollView.showsHorizontalScrollIndicator = NO;
}

- (void)pageChanged:(UIPageControl *)page {
    NSInteger currentPage = page.currentPage;
    [self.BannerScrollView setContentOffset:(CGPointMake((currentPage + 1)*kScreenWidth, 0)) animated:YES];
}

#pragma mark - 定时器自动执行方法autoPlay:
- (void)autoPlay:(NSTimer *)timer {
    
    if (kBannerArrayCount > 1) {
        CGFloat width = self.BannerScrollView.frame.size.width;
        CGPoint offSet = self.BannerScrollView.contentOffset;
        
        if (offSet.x == width * kBannerArrayCount) {
            // 切换到第一张图片
            [self.BannerScrollView setContentOffset:CGPointZero animated:NO]; // 注意切换时不做动画
            
            // 切换后,然后偏移width
            [self.BannerScrollView setContentOffset:CGPointMake(width, offSet.y) animated:YES];
            
        } else {
            [self.BannerScrollView setContentOffset:CGPointMake(offSet.x + width, offSet.y) animated:YES];
        }
        
        offSet = self.BannerScrollView.contentOffset;
        // 2.计算当前显示的页面
        NSInteger page = offSet.x / width;
        self.BannerPageControl.currentPage = page;
    }else {
        self.timer = nil;
    }
    
}

#pragma mark-- UIScrollViewDelegate
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    
    CGFloat width = scrollView.frame.size.width;
    
    CGPoint offSet = scrollView.contentOffset;
    
    NSInteger page = offSet.x / width;
    // 如果为第一张图片,因为第一张图为衔接图,与最后一张图相同,pageControl设0.为最后页面
    if (page == 0) {
        self.BannerPageControl.currentPage = self.BannerPageControl.numberOfPages - 1;
    }else {
        self.BannerPageControl.currentPage = page - 1;
    }
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(beginTimer) object:nil];
    [self.timer setFireDate:[NSDate distantFuture]];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(beginTimer) object:nil];
    [self performSelector:@selector(beginTimer) withObject:nil afterDelay:2];
}

- (void)beginTimer {
     [self.timer setFireDate:[NSDate distantPast]];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (scrollView.contentOffset.x > kBannerArrayCount  * scrollView.bounds.size.width) {
        self.BannerScrollView.contentOffset = CGPointMake(0, 0);
    }
    if (scrollView.contentOffset.x < 0) {
        self.BannerScrollView.contentOffset = CGPointMake(kBannerArrayCount * scrollView.bounds.size.width, 0);
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setBannerArray:(NSMutableArray *)bannerArray {
    _bannerArray = bannerArray;
    
    if (kBannerArrayCount < 2) {
        for (int i = 0; i < kBannerArrayCount; i++) {
            switch (self.bnanerType) {
                    
                case BnanerTypeOfHomePage:
                {
                    BannerGoods *goods = self.bannerArray[i];
                    UIImageView *imageV = [[UIImageView alloc] initWithFrame:(CGRectMake(i * kScreenWidth, 0, kScreenWidth, kBannerHeight))];
                    [imageV sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@", kImageBassURL, goods.imgurl]] placeholderImage:nil];
                    ZPLog(@"%@", goods.imgurl);
                    [self.BannerScrollView addSubview:imageV];
                }
                    break;
                case BnanerTypeOfDetail:
                {
                    
                    NSString *imgeURL = self.bannerArray[i];
                    UIImageView *imageV = [[UIImageView alloc] initWithFrame:(CGRectMake(i * kScreenWidth, 0, kScreenWidth, kBannerHeight))];
                    [imageV sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@", kImageBassURL, imgeURL]] placeholderImage:nil];
                    ZPLog(@"%@", imgeURL);
                    [self.BannerScrollView addSubview:imageV];
                }
                    break;
                    
                default:
                    break;
            }
            
        }
    }else {
        for (int i = 0,j = 0; i < kBannerArrayCount + 1; i++) {
            if (i == 0) {
                j = kBannerArrayCount - 1;
            } else {
                j = i - 1;
            }
            
            switch (self.bnanerType) {
                
                case BnanerTypeOfHomePage:
                {
                    BannerGoods *goods = self.bannerArray[j];
                    UIImageView *imageV = [[UIImageView alloc] initWithFrame:(CGRectMake(i*kScreenWidth, 0, kScreenWidth, kBannerHeight))];
                    imageV.userInteractionEnabled = YES;
                    [imageV sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://www.jvawa.com/%@", goods.imgurl]] placeholderImage:nil];
                    ZPLog(@"%@", goods.imgurl);
                    [self.BannerScrollView addSubview:imageV];
                }
                    break;
                case BnanerTypeOfDetail:
                {
                    UIImageView *imageV = [[UIImageView alloc] initWithFrame:(CGRectMake(i*kScreenWidth, 0, kScreenWidth, kBannerHeight))];
                    imageV.userInteractionEnabled = YES;
                    [imageV sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://www.jvawa.com/%@", self.bannerArray[j]]] placeholderImage:nil];
                    ZPLog(@"%@", self.bannerArray[j]);
                    [self.BannerScrollView addSubview:imageV];
                }
                    break;
                    
                default:
                    break;
            }
            
            
        }
    }
    
}

- (void)layoutSubviews {
    self.BannerScrollView.delegate = self;
    if (kBannerArrayCount < 2) {
        self.BannerScrollView.contentSize = CGSizeMake(kScreenWidth, 0);
    }else {
        self.BannerScrollView.contentSize = CGSizeMake((kBannerArrayCount + 1) * kScreenWidth, 0);
    }
    self.BannerScrollView.contentOffset = CGPointMake(kScreenWidth, 0);
    self.BannerScrollView.pagingEnabled = YES;
    
    self.BannerPageControl.numberOfPages = kBannerArrayCount;
    self.BannerPageControl.currentPage = 0;
    [self.BannerPageControl addTarget:self action:@selector(pageChanged:) forControlEvents:(UIControlEventValueChanged)];
    self.timer = [NSTimer scheduledTimerWithTimeInterval:2 target:self selector:@selector(autoPlay:) userInfo:@"传递给Timer的信息" repeats:YES];

}

@end
