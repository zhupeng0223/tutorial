//
//  HomeGoodsTableViewCell.m
//  ZPJawaMall
//
//  Created by zhupeng on 16/8/30.
//  Copyright © 2016年 朱鹏. All rights reserved.
//

#import "HomeGoodsTableViewCell.h"
#import "HomeGoodsCollectionViewCell.h"
#import "ZPJawaHomepageViewController.h"
#import "ZPGoodsListViewController.h"

@interface HomeGoodsTableViewCell ()<UICollectionViewDelegate, UICollectionViewDataSource>

@end

@implementation HomeGoodsTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
//    [self.collectionView registerNib:[[[NSBundle mainBundle] loadNibNamed:@"HomeGoodsCollectionViewCell"  owner:self options:nil] lastObject] forCellWithReuseIdentifier:@"HomeGoodsCollectionViewCellIdentifier"];
//    UICollectionViewFlowLayout *flow = [[UICollectionViewFlowLayout alloc] init];
//    flow.
    
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    flowLayout.itemSize = CGSizeMake((kScreenWidth - 20) / 2 - 5, ((kScreenWidth - 20) / 2 - 5) * 2 / 3 + 80);
//    [flowLayout setScrollDirection:UICollectionViewScrollDirectionVertical];
    flowLayout.sectionInset = UIEdgeInsetsMake(10, 10, 10, 10);
    [self.collectionView setCollectionViewLayout:flowLayout];
    self.collectionView.alwaysBounceVertical = NO;
//    self.collectionView.contentSize = CGSizeMake(kScreenWidth, 0);
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    self.collectionView.backgroundColor = [UIColor colorWithRed:230 / 255.0 green:230 / 255.0 blue:230 / 255.0 alpha:1.0];
    [self.collectionView registerClass:[HomeGoodsCollectionViewCell class] forCellWithReuseIdentifier:@"HomeGoodsCollectionViewCellIdentifier"];

    
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
}

#pragma mark-- UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return 4;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    HomeGoodsCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"HomeGoodsCollectionViewCellIdentifier" forIndexPath:indexPath];
    if (self.dataArray.count > 0) {
        cell.goods = self.dataArray[indexPath.item];
    }
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    HomePageGoods *goods = self.dataArray[indexPath.item];
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
    ZPGoodsListViewController *goodsListVC = [storyboard instantiateViewControllerWithIdentifier:@"GoodsListVCIdentityID"];
    goodsListVC.goods = goods;
    ZPLog(@"%@", [self parentVC].navigationController);
    [[self parentVC].navigationController pushViewController:goodsListVC animated:NO];
    
}

- (UIViewController *)parentVC {
    for (UIView *next = [self superview]; next; next = next.superview) {
        UIResponder *nextResponder = [next nextResponder];
        if ([nextResponder isKindOfClass:[ZPJawaHomepageViewController class]]) {
            return (UIViewController *)nextResponder;
        }
    }
    return nil;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
