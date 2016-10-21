//
//  ZPShopingCenterViewController.m
//  ZPJawaMall
//
//  Created by zhupeng on 16/8/29.
//  Copyright © 2016年 朱鹏. All rights reserved.
//

#import "ZPShopingCenterViewController.h"
#import "ZPstatisticsFooterView.h"
#import <DLRadioButton/DLRadioButton.h>
#import "ZPShoppingCartViewModel.h"
#import "ZPShoppingCart.h"
#import "ZPStoresInfoView.h"
#import "ZPChooseAddressView.h"
#import "ZPEmployees.h"
#import "ZPAddress.h"

@interface ZPShopingCenterViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, strong) NSMutableArray *selectedDataArray;
@property (strong, nonatomic) IBOutlet UIView *ZPShoppingCartBottomView;
@property (strong, nonatomic) IBOutlet UILabel *allPriceLabel;
@property (strong, nonatomic) IBOutlet UILabel *goodsCountLabel;

@property (nonatomic, strong) UIView *blackBackgroundView;
@property (nonatomic, strong) ZPStoresInfoView *infoView;
@property (nonatomic, strong) ZPChooseAddressView *chooseAddressView;
@property (nonatomic, strong) ZPAddress *address;
@property (nonatomic, strong) ZPEmployees *employe;

@property (nonatomic, strong) MBProgressHUD *hud;

@end

@implementation ZPShopingCenterViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(dismissView) name:@"dissmissStoresInfoView" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(recordEmployees:) name:@"recordEmployees" object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(recordAddress:) name:@"chooesAddressNotiName" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(addressViewDismissView) name:@"dissmissAddressViewNotiName" object:nil];

}

- (void)recordEmployees:(NSNotification *)noti {
    ZPLog(@"%@", noti.object);
    
    self.employe = noti.object;
    [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:(UITableViewRowAnimationNone)];
    
}

- (void)recordAddress:(NSNotification *)noti {
    self.address = noti.object;
    [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:1] withRowAnimation:(UITableViewRowAnimationNone)];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.dataArray = [NSMutableArray array];
    self.selectedDataArray = [NSMutableArray array];
    
    self.tableView.tableFooterView = [self createFootView];
    
    if (((NSString *)[[NSUserDefaults standardUserDefaults] objectForKey:@"CURRENT_UID"]).length > 0) {
        self.hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        self.hud.detailsLabel.text = @"Loading...";
        
        ZPShoppingCartViewModel *viewModel = [[ZPShoppingCartViewModel alloc] init];
        [viewModel setBlockWithReturnValueBlock:^(id returnValue) {
            
            ZPLog(@"%@", returnValue);
            self.dataArray = returnValue;
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.tableView reloadData];
                [self.hud hideAnimated:YES];
            });
        } withErrorBlock:^(id errorCode) {
            
        } withFailureBlock:^{
            
        }];
        NSString *uid = [[NSUserDefaults standardUserDefaults] objectForKey:@"CURRENT_UID"];
        [viewModel getShoppingCarWithUID:uid];
    }else {
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"提示" message:@"请先登录" preferredStyle:(UIAlertControllerStyleAlert)];
        UIAlertAction *action = [UIAlertAction actionWithTitle:@"确定" style:(UIAlertActionStyleCancel) handler:nil];
        [alertController addAction:action];
        [self presentViewController:alertController animated:YES completion:nil];
    }
    
}

- (ZPstatisticsFooterView *)createFootView {
    ZPstatisticsFooterView *view = [[[NSBundle mainBundle] loadNibNamed:@"statisticsFooterView" owner:nil options:nil] lastObject];
    view.goodsCount.text = [NSString stringWithFormat:@"%ld", self.selectedDataArray.count];
    NSInteger allPrice = 0;
    for (ZPShoppingCart *shoppingCart in [self.selectedDataArray mutableCopy]) {
        allPrice += [shoppingCart.price integerValue];
    }
    view.allPriceLabel.text = [NSString stringWithFormat:@"%ld", allPrice];
    view.backgroundColor = [UIColor clearColor];
    return view;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 2) {
        return self.dataArray.count;
    }
    if (section == 1 && self.address != nil) {
        return 2;
    }
    return 1;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 3;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 15;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    if (section == 2) {
        return 15;
    }else {
        return 0;
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    return [[UIView alloc] init];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section != 2) {
        return 44;
    }else {
        return 100;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = nil;
    if (indexPath.section != 2) {
        if (cell == nil) {
            cell = [tableView dequeueReusableCellWithIdentifier:@"shopingChooseStoreCellIdentifier" forIndexPath:indexPath];
        }
        
        for (UIView *subView in [self getSubViewsWithCell:cell]) {
            if (subView.tag == 8001) {
                if (indexPath.section == 0) {
                    if (self.employe == nil) {
                        ((UILabel *)subView).text = @"请选择门店";
                    }else {
                        ((UILabel *)subView).text = [NSString stringWithFormat:@"%@ %@(%@)", self.employe.storeName, self.employe.truename, self.employe.salerno];
                    }
                }else if (indexPath.section == 1) {
                    if (self.address != nil) {
                        if (indexPath.row == 0) {
                            ((UILabel *)subView).text = [NSString stringWithFormat:@"%@ %@", self.address.receivername, self.address.phone];
                        }else {
                            ((UILabel *)subView).text = [NSString stringWithFormat:@"%@", self.address.address];
                        }
                    }else {
                        ((UILabel *)subView).text = @"选择配送地址";
                    }
                }
            }
        }
        cell.selectionStyle = UITableViewCellSeparatorStyleNone;
        return cell;
    }else {
        if (cell == nil) {
            cell = [tableView dequeueReusableCellWithIdentifier:@"shopingGoodsInfoCellIdentifier" forIndexPath:indexPath];
        }
        CGRect frame = CGRectMake(10, 40, 20, 20);
        DLRadioButton *radioButton = [self createRadioButtonWithFrame:frame
                                                                Title:@"默认地址"
                                                                Color:[UIColor redColor]];
        [cell addSubview:radioButton];
        
        if (self.dataArray.count > 0) {
            for (UIView *subView in [self getSubViewsWithCell:cell]) {
                ZPShoppingCart *shoppingCart = (ZPShoppingCart *)self.dataArray[indexPath.row];
                switch (subView.tag) {
                    case 8101:
                    {
                        //图片
                        [((UIImageView *)subView) sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@", kImageBassURL, shoppingCart.imgurl]] placeholderImage:[UIImage imageNamed:@"HomePageIcon"]];
                    }
                        break;
                    case 8102:
                    {
                        //title
                        ((UILabel *)subView).text = shoppingCart.goodsname;
                    }
                        break;
                    case 8103:
                    {
                        //金额
                        ((UILabel *)subView).text = shoppingCart.price;
                    }
                        break;
                    case 8104:
                    {
                        //预约金
                    }
                        break;
                        
                    default:
                        break;
                }
            }
        }
        
        return cell;
    }
}

- (NSMutableArray *)getSubViewsWithCell:(UITableViewCell *)cell {
    NSMutableArray *result = [NSMutableArray array];
    NSArray *views = cell.subviews;
    for (UIView *tempView in views) {
        NSArray *subViews = tempView.subviews;
        for (UIView *subView in subViews) {
            [result addObject:subView];
        }
    }
    return result;
}
static NSInteger allGoodsCount = 0;
- (void)logSelectedButton:(DLRadioButton *)btn {
    //选择支付订单
    if (btn.selected) {
        //选中
        NSIndexPath *indexPath =[self.tableView indexPathForCell:(UITableViewCell *)btn.superview];
        [self.selectedDataArray addObject:self.dataArray[indexPath.row]];
        allGoodsCount++;
    }else {
        //取消选择
        NSIndexPath *indexPath =[self.tableView indexPathForCell:(UITableViewCell *)btn.superview];
        [self.selectedDataArray removeObject:self.dataArray[indexPath.row]];
        allGoodsCount--;
    }
//    [self.tableView reloadData];
    self.tableView.tableFooterView = [self createFootView];
    
    NSInteger allPrice = 0;
    for (ZPShoppingCart *shoppingCart in [self.selectedDataArray mutableCopy]) {
        allPrice += [shoppingCart.price integerValue];
    }
    self.allPriceLabel.text = [NSString stringWithFormat:@"%ld", allPrice];
    self.goodsCountLabel.text = [NSString stringWithFormat:@"%ld", allGoodsCount];
}

- (DLRadioButton *)createRadioButtonWithFrame:(CGRect) frame Title:(NSString *)title Color:(UIColor *)color
{
    DLRadioButton *radioButton = [[DLRadioButton alloc] initWithFrame:frame];
    radioButton.titleLabel.font = [UIFont systemFontOfSize:17];
    [radioButton setTitle:title forState:UIControlStateNormal];
    [radioButton setTitleColor:kLightGrayColor forState:UIControlStateNormal];
    [radioButton setTitleColor:color forState:UIControlStateSelected];
    radioButton.iconColor = color;
    radioButton.indicatorColor = color;
    radioButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
    radioButton.multipleSelectionEnabled = YES;
    [radioButton addTarget:self action:@selector(logSelectedButton:) forControlEvents:UIControlEventTouchUpInside];
    
    return radioButton;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    switch (indexPath.section) {
        case 0:
        {
            //选择门店
            self.blackBackgroundView = [[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds];
            self.blackBackgroundView.backgroundColor = [UIColor blackColor];
            self.blackBackgroundView.alpha = 0.5;
            [self.tableView addSubview:self.blackBackgroundView];
            
            UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissView)];
            [self.blackBackgroundView addGestureRecognizer:tap];
            
            self.infoView = [[ZPStoresInfoView alloc] initWithFrame:(CGRectMake(kScreenWidth - 300, 20, 300, 500)) City:@"南京" type:Store_Type]; //定位暂且写死
            _infoView.frame = (CGRectMake(kScreenWidth - 300, 20, 300, 500));
            [self.tableView addSubview:self.infoView];
        }
            break;
        case 1:
        {
            //选择配送地址
            self.blackBackgroundView = [[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds];
            self.blackBackgroundView.backgroundColor = [UIColor blackColor];
            self.blackBackgroundView.alpha = 0.5;
            [self.tableView addSubview:self.blackBackgroundView];
            
            UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(addressViewDismissView)];
            [self.blackBackgroundView addGestureRecognizer:tap];
            
            self.chooseAddressView = [[ZPChooseAddressView alloc] initWithFrame:(CGRectMake(kScreenWidth - 300, 20, 300, 500))]; //定位暂且写死
            _chooseAddressView.frame = (CGRectMake(kScreenWidth - 300, 20, 300, 500));
            [self.tableView addSubview:self.chooseAddressView];
        }
            break;
        case 2:
        {
            
        }
            break;
            
        default:
            break;
    }
    
}

- (void)dismissView {
    self.infoView.hidden = YES;
    self.infoView = nil;
    
    self.blackBackgroundView.hidden = YES;
    self.blackBackgroundView = nil;
}

- (void)addressViewDismissView {
    self.chooseAddressView.hidden = YES;
    self.chooseAddressView = nil;
    
    self.blackBackgroundView.hidden = YES;
    self.blackBackgroundView = nil;
}

//全选购物车的商品
- (IBAction)selectedAllAction:(id)sender {
    
}
//删除购物车的商品
- (IBAction)deleteAction:(id)sender {
    
}
//结账
- (IBAction)checkAction:(id)sender {
    if (self.address == nil || self.employe == nil || self.selectedDataArray.count == 0) {
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"提示" message:@"请选择门店/地址/商品" preferredStyle:(UIAlertControllerStyleAlert)];
        UIAlertAction *action = [UIAlertAction actionWithTitle:@"确定" style:(UIAlertActionStyleDefault) handler:nil];
        [alertController addAction:action];
        [self presentViewController:alertController animated:YES completion:nil];
    }else {
        
        for (ZPShoppingCart *shoppingCart in self.selectedDataArray) {
            if ([shoppingCart.subtitle isEqualToString:@""]) {
                //提交主件
//暂定
//                ZPShoppingCartViewModel *viewModel = [[ZPShoppingCartViewModel alloc] init];
//                [viewModel setBlockWithReturnValueBlock:^(id returnValue) {
//                    
//                    ZPLog(@"%@", returnValue);
//                    
//                } withErrorBlock:^(id errorCode) {
//                    
//                } withFailureBlock:^{
//                    
//                }];
//                
//                NSDictionary *param = [self createParam];
//
//                [viewModel checkShoppingCartWithParam:param];
                
            }else if ([shoppingCart.subtitle isEqualToString:@"配件"]) {
                //提交配件
                
            }
        }
        
    }
}

- (NSDictionary *)createParam {
    NSString *uid = [[NSUserDefaults standardUserDefaults] objectForKey:@"CURRENT_UID"];
    ZPShoppingCart *shoppingCart = self.selectedDataArray[0];//目前只实现了单个商品支付
    NSString *buyCount = @"1"; //购买数量默认为1
    NSString *desingerprice = @"0"; //修改价格默认为0
    NSString *cityName = [[self.address.address componentsSeparatedByString:@" "] firstObject];
    //这里预约金总价都写成了2000后期修改
    NSDictionary *result = @{@"uid":uid, @"billprice":self.allPriceLabel.text, @"schedprice":@"2000", @"storeid":self.employe.storeId, @"phone":self.address.phone, @"receivername":self.address.receivername, @"receiveraddress":self.address.address, @"isperfe":@"0", @"salerno":self.employe.salerno, @"goodsid":shoppingCart.ID, @"picurl":shoppingCart.imgurl, @"num":buyCount, @"desingerprice":desingerprice, @"color":@"iOS客户端", @"colorid":@"", @"taimianid":@"", @"doorid":@"", @"mishu1":@"3", @"mishu2":@"1", @"huodongneirong":@"", @"kehuyaoqiu":@"", @"lingjifeixiang":@"", @"beizhu":@"", @"bzpj":@"", @"diypj":@"", @"goodsname":shoppingCart.goodsname, @"cityName":cityName
      };
    
    /*
     mishu1是地柜台面   默认3
     mishu2是吊柜      默认1
     */
    return result;
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
