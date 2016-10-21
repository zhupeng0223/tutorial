//
//  ZPOrderDetailInfoViewController.m
//  ZPJawaMall
//
//  Created by zhupeng on 16/9/28.
//  Copyright © 2016年 朱鹏. All rights reserved.
//

#import "ZPOrderDetailInfoViewController.h"
#import "ZPColorChooseTableViewCell.h"
#import "GoodsInfo.h"
#import "Color.h"
#import "ZPEmployees.h"
#import "ZPAddress.h"
#import "ZPStoresInfoView.h"
#import "ZPChooseAddressView.h"
#import "ZPConfirmOrderInfoToPayViewController.h"

@interface ZPOrderDetailInfoViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) IBOutlet UILabel *orderPrice;
@property (strong, nonatomic) IBOutlet UILabel *allPrice;

@property (nonatomic, strong) UIView *blackBackgroundView;
@property (nonatomic, strong) ZPStoresInfoView *infoView;
@property (nonatomic, strong) ZPChooseAddressView *chooseAddressView;
@property (nonatomic, strong) ZPEmployees *employe;
@property (nonatomic, strong) ZPAddress *address;

@property (nonatomic, strong) NSMutableDictionary *orderDataDic;

@end

@implementation ZPOrderDetailInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    self.orderDataDic = [NSMutableDictionary dictionary];
    [self.orderDataDic setObject:self.goodsInfo forKey:@"goodsInfo"];
    [self.orderDataDic setObject:[NSNumber numberWithInteger:self.selectedDoorIndex] forKey:@"doorSelecedIndex"];
    [self.orderDataDic setObject:[NSNumber numberWithInteger:self.selectedColorIndex] forKey:@"colorSelecedIndex"];
    [self.orderDataDic setObject:[NSNumber numberWithInteger:self.selectedTaimianIndex] forKey:@"taimianSelecedIndex"];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(dismissView) name:@"dissmissStoresInfoView" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(recordEmployees:) name:@"recordEmployees" object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(recordAddress:) name:@"chooesAddressNotiName" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(addressViewDismissView) name:@"dissmissAddressViewNotiName" object:nil];
}

- (void)recordEmployees:(NSNotification *)noti {
    ZPLog(@"%@", noti.object);
    
    self.employe = noti.object;
    [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:(UITableViewRowAnimationNone)];
    [self.orderDataDic setObject:noti.object forKey:@"employe"];
    
}

- (void)recordAddress:(NSNotification *)noti {
    self.address = noti.object;
    [self.orderDataDic setObject:noti.object forKey:@"address"];
    [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:1] withRowAnimation:(UITableViewRowAnimationNone)];
}

#pragma mark-- UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (self.address != nil && section == 1) {
        return 2;
    }
    if (section == 2) {
        return 4;
    }
    return 1;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 7;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    switch (indexPath.section) {
        case 2:
        {
            if (indexPath.row == 0) {
                return 120;
            }
        }
            break;
        case 3:
        {
            //动态更新
            CGFloat row = self.goodsInfo.door.count / 6 + 1;
            return 63 + row * 50 + 23;
        }
            break;
        case 4:
        {
            CGFloat row = self.goodsInfo.colors.count / 6 + 1;
            return 63 + row * 50 + 23;
        }
            break;
        case 5:
        {
            CGFloat row = self.goodsInfo.taimian.count / 6 + 1;
            return 63 + row * 50 + 23;
        }
            break;
        case 6:
        {
            return 100;
        }
            break;
            
        default:
            break;
    }
    return 44;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    switch (indexPath.section) {
        case 0:
        {
            UITableViewCell *cell0 = [tableView dequeueReusableCellWithIdentifier:@"chooseInfoCellIdentifier" forIndexPath:indexPath];
            if (self.employe != nil) {
                cell0.textLabel.text = [NSString stringWithFormat:@"%@ %@(%@)", self.employe.storeName, self.employe.truename, self.employe.salerno];
            }
            return cell0;
        }
            break;
        case 1:
        {
            UITableViewCell *cell1 = [tableView dequeueReusableCellWithIdentifier:@"chooseAddressCellIdentifier" forIndexPath:indexPath];
            if (self.address != nil) {
                if (indexPath.row == 0) {
                    cell1.textLabel.text = [NSString stringWithFormat:@"%@ %@", self.address.receivername, self.address.phone];
                }else {
                    cell1.textLabel.text = [NSString stringWithFormat:@"%@", self.address.address];
                }
            }
            return cell1;
        }
            break;
        case 2:
        {
            if (indexPath.row == 0) {
                UITableViewCell *cell2 = [tableView dequeueReusableCellWithIdentifier:@"iconTitleCellIdentifier" forIndexPath:indexPath];
                for (UIView *subView in [self getSubViewsWithCell:cell2]) {
                    switch (subView.tag) {
                        case 5001:
                        {
                            NSString *picUrl = [NSString stringWithFormat:@"%@%@",kImageBassURL, [[self.goodsInfo.detail.picurl componentsSeparatedByString:@";"] firstObject]];
                            [((UIImageView *)subView) sd_setImageWithURL:[NSURL URLWithString:picUrl] placeholderImage:[UIImage imageNamed:@""]];
                        }
                            break;
                        case 5002:
                        {
                            ((UILabel *)subView).text = self.goodsInfo.detail.goodsname;
                        }
                            break;
                        case 5003:
                        {
                            [((UIButton *)subView) addTarget:self action:@selector(subtractCountAction:) forControlEvents:(UIControlEventTouchUpInside)];
                        }
                            break;
                        case 5004:
                        {
                            ((UILabel *)subView).text = [NSString stringWithFormat:@"%d", 2000];
                        }
                            break;
                        case 5005:
                        {
                            [((UIButton *)subView) addTarget:self action:@selector(addCountAction:) forControlEvents:(UIControlEventTouchUpInside)];
                        }
                            break;
                            
                        default:
                            break;
                    }
                }
                return cell2;
            }else if (indexPath.row == 1) {
                UITableViewCell *cell3 = [tableView dequeueReusableCellWithIdentifier:@"AllPriceCellIdentifier" forIndexPath:indexPath];
                for (UIView *subView in [self getSubViewsWithCell:cell3]) {
                    if (subView.tag == 5011) {
                        ((UILabel *)subView).text = self.goodsInfo.detail.price;
                    }
                }
                return cell3;
            }else if (indexPath.row == 2) {
                UITableViewCell *cell4 = [tableView dequeueReusableCellWithIdentifier:@"materialCountCellIdentifier" forIndexPath:indexPath];
                for (UIView *subView in [self getSubViewsWithCell:cell4]) {
                    if (subView.tag == 5012) {
                        ((UILabel *)subView).text = [NSString stringWithFormat:@"%ld", self.goodsInfo.taimian.count];
                    }
                }
                return cell4;
            }else if (indexPath.row == 3) {
                UITableViewCell *cell5 = [tableView dequeueReusableCellWithIdentifier:@"materialCountCellIdentifier" forIndexPath:indexPath];
                for (UIView *subView in [self getSubViewsWithCell:cell5]) {
                    if (subView.tag == 5012) {
                        ((UILabel *)subView).text = [NSString stringWithFormat:@"%ld", self.goodsInfo.door.count];
                    }
                    if (subView.tag == 5013) {
                        ((UILabel *)subView).text = @"吊柜";
                    }
                }
                return cell5;
            }
        }
            break;
        case 3:
        {
            ZPColorChooseTableViewCell *cell6 = [tableView dequeueReusableCellWithIdentifier:@"ZPColorChooseTableViewCellIdentifier"];
            if (cell6 == nil) {
                cell6 = [[[NSBundle mainBundle] loadNibNamed:@"ZPColorChooseTableViewCell" owner:nil options:nil] lastObject];
            }
            cell6.Array = self.goodsInfo.door;
            cell6.type = DoorType;
            cell6.colorNameLabel.text = @"门型:";
            cell6.currentSelectedIndex = [self.orderDataDic[@"doorSelecedIndex"] integerValue];
            cell6.selectedDoorBlock = ^(NSInteger index) {
                [self.orderDataDic setObject:[NSNumber numberWithInteger:index] forKey:@"doorSelecedIndex"];
            };
            return cell6;
        }
            break;
        case 4:
        {
            ZPColorChooseTableViewCell *cell7 = [tableView dequeueReusableCellWithIdentifier:@"ZPColorChooseTableViewCellIdentifier"];
            if (cell7 == nil) {
                cell7 = [[[NSBundle mainBundle] loadNibNamed:@"ZPColorChooseTableViewCell" owner:nil options:nil] lastObject];
            }
            cell7.Array = self.goodsInfo.colors;
            cell7.type = ColorType;
            cell7.colorNameLabel.text = [NSString stringWithFormat:@"%@", ((Color *)self.goodsInfo.colors[0]).color];
            cell7.currentSelectedIndex = [self.orderDataDic[@"colorSelecedIndex"] integerValue];
            cell7.selectedColorBlock = ^(NSInteger index) {
                [self.orderDataDic setObject:[NSNumber numberWithInteger:index] forKey:@"colorSelecedIndex"];
            };
            return cell7;
        }
            break;
        case 5:
        {
            ZPColorChooseTableViewCell *cell8 = [tableView dequeueReusableCellWithIdentifier:@"ZPColorChooseTableViewCellIdentifier"];
            if (cell8 == nil) {
                cell8 = [[[NSBundle mainBundle] loadNibNamed:@"ZPColorChooseTableViewCell" owner:nil options:nil] lastObject];
            }
            cell8.Array = self.goodsInfo.taimian;
            cell8.type = TaimianType;
            cell8.colorNameLabel.text = @"台面";
            cell8.currentSelectedIndex = [self.orderDataDic[@"taimianSelecedIndex"] integerValue];
            cell8.selectedTaimianBlock = ^(NSInteger index) {
                [self.orderDataDic setObject:[NSNumber numberWithInteger:index] forKey:@"taimianSelecedIndex"];
            };
            return cell8;
        }
            break;
        case 6:
        {
            UITableViewCell *cell9 = [tableView dequeueReusableCellWithIdentifier:@"noteCellIdentifier" forIndexPath:indexPath];
            for (UIView *subView in [self getSubViewsWithCell:cell9]) {
                if (subView.tag == 5013) {
                    [self.orderDataDic setObject:((UITextView *)subView).text forKey:@"noteDes"];
                }
            }
            //5013
            return cell9;
        }
            break;
        default:
            break;
    }
    
    
    static NSString *reuseIdentifier = @"cell1";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:reuseIdentifier];
    }
    
    // Configure the cell...
    
    
    return cell;
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

//减
- (void)subtractCountAction:(UIButton *)btn {
    
}
//加
- (void)addCountAction:(UIButton *)btn {
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    switch (indexPath.section) {
        case 0:
        {
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

#pragma mark-- 提交订单
- (IBAction)submitOrder:(id)sender {
    if (self.employe!= nil && self.address != nil) {
        //提交
        
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
        ZPConfirmOrderInfoToPayViewController *confirmOrderInfoToPayVC = [storyboard instantiateViewControllerWithIdentifier:@"ZPConfirmOrderInfoToPayViewControllerSBID"];
        confirmOrderInfoToPayVC.orderDataDic = self.orderDataDic;
        [self.navigationController pushViewController:confirmOrderInfoToPayVC animated:NO];
        
    }else {
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"提示" message:@"请先选择导购员/收货地址" preferredStyle:(UIAlertControllerStyleAlert)];
        UIAlertAction *action = [UIAlertAction actionWithTitle:@"确定" style:(UIAlertActionStyleCancel) handler:nil];
        [alertController addAction:action];
        [self presentViewController:alertController animated:YES completion:nil];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 20;
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
