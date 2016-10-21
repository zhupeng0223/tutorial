//
//  ZPJawaHomepageViewController.m
//  ZPJawaMall
//
//  Created by zhupeng on 16/8/29.
//  Copyright © 2016年 朱鹏. All rights reserved.
//

#import "ZPJawaHomepageViewController.h"
#import "ZPHomePageViewModel.h"
#import "BannerTableViewCell.h"
#import "HomeGoodsTableViewCell.h"
#import "HomePageGoods.h"
#import "ZPHomePageGoodsHeadView.h"

@interface ZPJawaHomepageViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *bannerDataArray;
@property (nonatomic, strong) NSMutableArray *homePageNewGoodsArray;
@property (nonatomic, strong) NSMutableArray *homePageHotGoodsArray;
@property (nonatomic, strong) MBProgressHUD *hud;

@end

@implementation ZPJawaHomepageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    self.bannerDataArray = [NSMutableArray array];
    self.homePageNewGoodsArray = [NSMutableArray array];
    self.homePageHotGoodsArray = [NSMutableArray array];
    
    ZPHomePageViewModel *homePageVM = [[ZPHomePageViewModel alloc] init];
    [homePageVM setBannerBlockWithReturnValueBlock:^(id returnValue) {
        //加载完成数据
        ZPLog(@"%@", returnValue);
        self.bannerDataArray = returnValue;
        [self reloadTableViewData];
        [self waitActivity];
    } withErrorBlock:^(id errorCode) {
        //数据加载失败
        
    } withFailureBlock:^{
        //网络错误
        
    }];
    
    [homePageVM setHomePageGoodsBlockWithReturnValueBlock:^(id returnValue) {
        ZPLog(@"%@", returnValue);
        self.homePageNewGoodsArray = returnValue;
        [self reloadTableViewData];
        [self waitActivity];
    } withErrorBlock:^(id errorCode) {
        
    } withFailureBlock:^{
        
    }];
    
    [homePageVM setHotHomePageGoodsBlockWithReturnValueBlock:^(id returnValue) {
        ZPLog(@"%@", returnValue);
        self.homePageHotGoodsArray = returnValue;
        [self reloadTableViewData];
        [self waitActivity];
    } withErrorBlock:^(id errorCode) {
        
    } withFailureBlock:^{
        
    }];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [homePageVM loadBannerInfo];
        [homePageVM loadNewHomePageInfo];
        [homePageVM loadHotHomePageInfo];
        dispatch_async(dispatch_get_main_queue(), ^{
            self.hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            //
            self.hud.detailsLabel.text = @"Loading...";
        });
    });
    
}

static NSInteger homePageActivity = 0;
- (void)waitActivity {
    homePageActivity++;
    if (homePageActivity == 3) {
        //取消MBProgressHUDS
        [self.hud hideAnimated:YES];
        homePageActivity = 0;
    }
}

- (void)reloadTableViewData {
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.tableView reloadData];
    });
}

#pragma mark-- UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return 1;
    }
    return 1;
    
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 3;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        return kBannerHeight;
    }
    return (((kScreenWidth - 20) / 2 - 5) * 2 / 3 + 80) * 2 + 31;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    ZPHomePageGoodsHeadView *view = [[ZPHomePageGoodsHeadView alloc] initWithFrame:(CGRectMake(0, 0, kScreenWidth, 30))];
    if (section == 0) {
//        UIView *bannerHeadView = [[UIView alloc] initWithFrame:(CGRectMake(0, 0, kScreenWidth, 1))];
//        bannerHeadView.backgroundColor = [UIColor clearColor];
        tableView.tableHeaderView.hidden = YES;
        return nil;
    }
    if (section == 1) {
        view.titleLabel.text = @"新品推荐";
    }
    if (section == 2) {
        view.titleLabel.text = @"热门商品";
    }
    
    return view;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        BannerTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"BannerCellIdentify"];
        if (cell == nil) {
            cell = [[[NSBundle mainBundle] loadNibNamed:@"BannerTableViewCell" owner:self options:nil] lastObject];
        }
        if (self.bannerDataArray.count != 0) {
            cell.bnanerType = BnanerTypeOfHomePage;
            cell.bannerArray = self.bannerDataArray;
        }
        return cell;
    }
    HomeGoodsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"HomePageTableViewCellIdentifly"];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"HomeGoodsTableViewCell" owner:self options:nil] lastObject];
    }
    if (indexPath.section == 1 && self.homePageNewGoodsArray.count != 0) {
        cell.dataArray = self.homePageNewGoodsArray;
    }else if (indexPath.section == 2 && self.homePageHotGoodsArray.count != 0) {
        cell.dataArray = self.homePageHotGoodsArray;
    }
    cell.currentSection = indexPath.section;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    ZPLog(@"%@", indexPath);
}

@end
