//
//  ZPProductDetailsCommentsTableViewCell.m
//  ZPJawaMall
//
//  Created by zhupeng on 16/9/13.
//  Copyright © 2016年 朱鹏. All rights reserved.
//

#import "ZPProductDetailsCommentsTableViewCell.h"
#import "ZPPicInfo.h"

@interface ZPProductDetailsCommentsTableViewCell ()

@property (strong, nonatomic) IBOutlet UISegmentedControl *segMentController;
@property (nonatomic, strong) UIView *productDetailView;
@property (strong, nonatomic) IBOutlet UIView *commentsView;

@property (nonatomic, strong) NSDictionary *picSizeArray;

@end

@implementation ZPProductDetailsCommentsTableViewCell

- (void)dealloc {
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"[NSUserDefaults standardUserDefaults]"];
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
//    [self createCommentsView];
    
    NSInteger height = 0;
    for (ZPPicInfo *picInfo in self.imageArr) {
        height += [picInfo.height integerValue];
    }
    
    self.productDetailView = [[UIView alloc] initWithFrame:(CGRectMake(0, 44, kScreenWidth, height))];
    [self.segMentController addSubview:self.productDetailView];
    self.segMentController.selectedSegmentIndex = self.currentIndex;
    
    self.segMentController.tintColor = [UIColor clearColor];//去掉颜色,现在整个segment都看不见
    NSDictionary* selectedTextAttributes = @{NSFontAttributeName:[UIFont boldSystemFontOfSize:16],
                                             NSForegroundColorAttributeName: [UIColor redColor]};
    [self.segMentController setTitleTextAttributes:selectedTextAttributes forState:UIControlStateSelected];//设置文字属性
    NSDictionary* unselectedTextAttributes = @{NSFontAttributeName:[UIFont boldSystemFontOfSize:16],
                                               NSForegroundColorAttributeName:kGoodsTitleColor};
    [self.segMentController setTitleTextAttributes:unselectedTextAttributes forState:UIControlStateNormal];
}


- (void)layoutSubviews {
    [super layoutSubviews];
    [self bringSubviewToFront:self.productDetailView];
    self.segMentController.selectedSegmentIndex = self.currentIndex;
    if (self.currentIndex == 0) {
        self.commentsView.hidden = YES;
        self.productDetailView.hidden = NO;
        
        if (self.productDetailView.subviews.count <= 0) {
            NSInteger currentPicHeight = 0;
            NSInteger index = 0;
            for (ZPPicInfo *picInfo in self.imageArr) {
                UIImageView *imageView = [[UIImageView alloc] initWithFrame:(CGRectMake(0, 0 + currentPicHeight, kScreenWidth, [self heightForImgWithPicInfo:picInfo]))];
                imageView.contentMode = UIViewContentModeScaleAspectFit;
                [imageView sd_setImageWithURL:[NSURL URLWithString:picInfo.url] placeholderImage:[UIImage imageNamed:@"HomePageIcon"]];
                imageView.contentMode = UIViewContentModeScaleAspectFit;
                currentPicHeight += [self heightForImgWithPicInfo:picInfo];
                index++;
                [self.productDetailView addSubview:imageView];
            }
        }
    }else {
        self.commentsView.hidden = NO;
        self.productDetailView.hidden = YES;
    }
}

- (NSInteger)heightForImgWithPicInfo:(ZPPicInfo *)picInfo {
    
    NSInteger height = kScreenWidth / [picInfo.width integerValue] * [picInfo.height integerValue];
    return height;
    
}

- (IBAction)segAction:(id)sender {
    UISegmentedControl *segmentedControl = (UISegmentedControl *)sender;
    switch (segmentedControl.selectedSegmentIndex) {
        case 0:
        {
            //商品详情
            self.productDetailView.hidden = NO;
            self.commentsView.hidden = YES;
            [[NSNotificationCenter defaultCenter] postNotificationName:@"Comments_Details" object:@"Details"];
        }
            break;
        case 1:
        {
            //商品评价
            self.productDetailView.hidden = YES;
            self.commentsView.hidden = NO;
            [[NSNotificationCenter defaultCenter] postNotificationName:@"Comments_Details" object:@"Comments"];
        }
            break;
            
        default:
            break;
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
