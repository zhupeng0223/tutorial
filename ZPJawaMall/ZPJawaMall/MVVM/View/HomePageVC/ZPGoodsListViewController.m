//
//  ZPGoodsListViewController.m
//  ZPJawaMall
//
//  Created by zhupeng on 16/9/9.
//  Copyright © 2016年 朱鹏. All rights reserved.
//

#import "ZPGoodsListViewController.h"
#import "ZPHomePageViewModel.h"
#import "ZPGoodsListTableViewCell.h"
#import "ZPGoodsListHeadView.h"
#import "ZPGoodsDetailInfoViewController.h"

@interface ZPGoodsListViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (strong, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation ZPGoodsListViewController

- (void)dealloc {
    ZPLog(@"dealloc %@", self);
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.tableFooterView = [[UIView alloc] init];
    
    
    if (!(self.dataArray.count > 0)) {
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        hud.detailsLabel.text = @"Loading...";
        
        ZPHomePageViewModel *homePageVM = [[ZPHomePageViewModel alloc] init];
        [homePageVM setBlockWithReturnValueBlock:^(id returnValue) {
            self.dataArray = returnValue;
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.tableView reloadData];
                [hud hideAnimated:YES];
            });
        } withErrorBlock:^(id errorCode) {
            
        } withFailureBlock:^{
            
        }];
        
        [homePageVM getGoodsListWithGoods:self.goods];
        
    }
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 120;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    ZPLog(@"dataArrayCount:%ld", self.dataArray.count);
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *reuseIdentifier = @"ZPGoodsListTableViewCell";
    
    ZPGoodsListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"ZPGoodsListTableViewCell" owner:self options:nil] lastObject];
    }
    
    // Configure the cell...
    if (self.dataArray.count > 0) {
        cell.goodsList = (GoodsList *)self.dataArray[indexPath.row];
        ZPLog(@"%ld", (long)indexPath.row);
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    ZPHomePageViewModel *homePageVM = [[ZPHomePageViewModel alloc] init];
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.detailsLabel.text = @"Loading...";
    
    [homePageVM setBlockWithReturnValueBlock:^(id returnValue) {
        ZPLog(@"%@", returnValue);
        UIStoryboard *storyBoard = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
        ZPGoodsDetailInfoViewController *detailVC = [storyBoard instantiateViewControllerWithIdentifier:@"GoodsDetailInfoViewControllerIdentity"];
        detailVC.goodsInfo = returnValue;
        [hud hideAnimated:YES];
        [self.navigationController pushViewController:detailVC animated:NO];
    } withErrorBlock:^(id errorCode) {
        
    } withFailureBlock:^{
        
    }];
    [homePageVM getGoodsDetailWithGoodsId:((HomePageGoods *)self.dataArray[indexPath.row]).ID];
    
}


- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    ZPGoodsListHeadView *headerView = [[ZPGoodsListHeadView alloc] initWithFrame:(CGRectMake(0, 0, kScreenWidth, 25))];
    headerView.countLabel.text = [NSString stringWithFormat:@"%ld", (long)self.dataArray.count];
    return headerView;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
