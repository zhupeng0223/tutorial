//
//  ZPConfirmOrderInfoToPayViewController.m
//  ZPJawaMall
//
//  Created by zhupeng on 16/9/30.
//  Copyright © 2016年 朱鹏. All rights reserved.
//

#import "ZPConfirmOrderInfoToPayViewController.h"
#import "ZPEmployees.h"
#import "ZPAddress.h"
#import "GoodsInfo.h"
#import "Door.h"
#import "Color.h"
#import "Taimian.h"
#import "ZPShoppingCartViewModel.h"
#import "ZPOrderInfo.h"

@interface ZPConfirmOrderInfoToPayViewController ()<UITableViewDelegate, UITableViewDataSource, BeeCloudDelegate>

@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) ZPEmployees *employees;
@property (nonatomic, strong) ZPAddress *address;
@property (nonatomic, strong) GoodsInfo *goodsInfo;
@property (nonatomic, strong) Door *door;
@property (nonatomic, strong) Color *color;
@property (nonatomic, strong) Taimian *taimian;

@property (nonatomic, strong) NSString *channelStr;//支付渠道
@property (nonatomic, strong) NSString *resultStr;//返回给服务器的支付结果字符串

@end

@implementation ZPConfirmOrderInfoToPayViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    [self handelDictionary];
    
}

- (void)handelDictionary {
    
    self.employees = self.orderDataDic[@"employe"];
    self.address = self.orderDataDic[@"address"];
    self.goodsInfo = self.orderDataDic[@"goodsInfo"];
    self.door = [self.goodsInfo.door objectAtIndex:[self.orderDataDic[@"doorSelecedIndex"] integerValue]];
    self.color = [self.goodsInfo.colors objectAtIndex:[self.orderDataDic[@"colorSelecedIndex"] integerValue]];
    self.taimian = [self.goodsInfo.taimian objectAtIndex:[self.orderDataDic[@"taimianSelecedIndex"] integerValue]];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    switch (section) {
        case 0:
            return 3;
            break;
        case 1:
            return 2;
            break;
            
        default:
            return 1;
            break;
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 4;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    switch (indexPath.section) {
        case 0:
        {
            if (indexPath.row != 2) {
                return 44;
            }else {
                return 100;
            }
        }
            break;
        case 1:
        {
            if (indexPath.row != 1) {
                return 230;
            }else {
                return 280;
            }
        }
            break;
        case 2:
        {
            return 44;
        }
            break;
        case 3:
        {
            return 44;
        }
            break;
            
        default:
            return 44;
            break;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = nil;
    switch (indexPath.section) {
        case 0:
        {
            if (indexPath.row != 2) {
                cell = [tableView dequeueReusableCellWithIdentifier:@"labelTFCellIdentifier" forIndexPath:indexPath];
                UILabel *tempLabel = nil;
                UITextField *tempTF = nil;
                for (UIView *subView in [self getSubViewsWithCell:cell]) {
                    if (subView.tag == 6001) {
                        tempLabel = (UILabel *)subView;
                    }
                    if (subView.tag == 6002) {
                        tempTF = (UITextField *)subView;
                    }
                }
                if (indexPath.row == 0) {
                    tempLabel.text = @"收 货 人:";
                    tempTF.text = self.address.receivername;
                }else if (indexPath.row == 1) {
                    tempLabel.text = @"手 机 号:";
                    tempTF.text = self.address.phone;
                }
            }else {
                cell = [tableView dequeueReusableCellWithIdentifier:@"addressInfomationCellIdentifier" forIndexPath:indexPath];
                UITextView *addressTV = nil;
                for (UIView *subView in [self getSubViewsWithCell:cell]) {
                    if (subView.tag == 6003) {
                        addressTV = (UITextView *)subView;
                    }
                }
                addressTV.text = self.address.address;
            }
            cell.layer.borderWidth = 0.5;
            cell.layer.masksToBounds = YES;
            cell.layer.borderColor = kLightGrayColor.CGColor;
            return cell;
        }
            break;
        case 1:
        {
            if (indexPath.row == 0) {
                cell = [tableView dequeueReusableCellWithIdentifier:@"orderImageInfoCellIdentifier" forIndexPath:indexPath];
                for (UIView *subView in [self getSubViewsWithCell:cell]) {
                    if (subView.tag == 6100) {
                        //图片
                        NSString *imgURL = [[self.goodsInfo.detail.picurl componentsSeparatedByString:@";"] firstObject];
                        [((UIImageView *)subView) sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@", kImageBassURL, imgURL]] placeholderImage:[UIImage imageNamed:@"HomePageIcon"]];
                    }
                    if (subView.tag == 6101) {
                        //title
                        ((UILabel *)subView).text = self.goodsInfo.detail.goodsname;
                    }
                }
            }else {
                cell = [tableView dequeueReusableCellWithIdentifier:@"OrderDetailInfoCellIdentifier" forIndexPath:indexPath];
                for (UIView *subView in [self getSubViewsWithCell:cell]) {
                    switch (subView.tag) {
                        case 7001:
                        {
                            //规格
                            ((UILabel *)subView).text = self.goodsInfo.detail.guide;
                        }
                            break;
                        case 7002:
                        {
                            //预约金
                            ((UILabel *)subView).text = [NSString stringWithFormat:@"%ld", self.goodsInfo.detail.ordermoney];
                        }
                            break;
                        case 7003:
                        {
                            //预估价
                            
                        }
                            break;
                        case 7004:
                        {
                            //门型
                            if (self.door.dname.length > 0) {
                                ((UILabel *)subView).text = self.door.dname;
                            }else {
                                ((UILabel *)subView).text = @" ";
                            }
                        }
                            break;
                        case 7005:
                        {
                            //颜色
                            if (self.color.cname.length > 0) {
                                ((UILabel *)subView).text = self.color.cname;
                            }else {
                                ((UILabel *)subView).text = @" ";
                            }
                        }
                            break;
                        case 7006:
                        {
                            //台面
                            if (self.taimian.tname.length > 0) {
                                ((UILabel *)subView).text = self.taimian.tname;
                            }else {
                                ((UILabel *)subView).text = @" ";
                            }
                        }
                            break;
                        case 7007:
                        {
                            //导购
                            ((UILabel *)subView).text = [NSString stringWithFormat:@"%@/%@", self.employees.storeName, self.employees.truename];
                        }
                            break;
                        case 7008:
                        {
                            //活动内容
                        }
                            break;
                        case 7009:
                        {
                            //客户要求
                        }
                            break;
                        case 7010:
                        {
                            //另计费项
                        }
                            break;
                        case 7011:
                        {
                            //备注
                        }
                            break;
                        
                        default:
                            break;
                    }
                }
            }
            
        }
            break;
        case 2:
        {
            cell = [tableView dequeueReusableCellWithIdentifier:@"truePayOrderCellIdentifier" forIndexPath:indexPath];
        }
            break;
        case 3:
        {
            cell = [tableView dequeueReusableCellWithIdentifier:@"payButtonCellIdentifier" forIndexPath:indexPath];
            //支付按钮
            for (UIView *subView in [self getSubViewsWithCell:cell]) {
                if (subView.tag == 7013) {
                    [((UIButton *)subView) addTarget:self action:@selector(payAction) forControlEvents:(UIControlEventTouchUpInside)];
                }
            }
        }
            break;
        default:
            break;
    }
    cell.layer.borderWidth = 0.5;
    cell.layer.masksToBounds = YES;
    cell.layer.borderColor = kLightGrayColor.CGColor;
    return cell;
}

- (void)payAction {
//    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    if ([self.goodsInfo.detail.subtitle isEqualToString:@""]) {
        //提交主件
        //支付
        ZPShoppingCartViewModel *viewModel = [[ZPShoppingCartViewModel alloc] init];
        [viewModel setBlockWithReturnValueBlock:^(id returnValue) {
            
//            if (![hud isHidden]) {
//                [hud hideAnimated:YES];
//            }
            ZPOrderInfo *orderInfo = returnValue;
            //调支付宝
            [BeeCloud setBeeCloudDelegate:self];
            [self payWithInfo:orderInfo];
            
        } withErrorBlock:^(id errorCode) {
            
        } withFailureBlock:^{
            
        }];
        NSDictionary *param = [self createParam];
        [viewModel checkShoppingCartWithParam:param];
        
    }else if ([self.goodsInfo.detail.subtitle isEqualToString:@"配件"]) {
        //提交配件
        
        ZPShoppingCartViewModel *shoppingCartVM = [[ZPShoppingCartViewModel alloc] init];
        [shoppingCartVM setBlockWithReturnValueBlock:^(id returnValue) {
            
//            if (![hud isHidden]) {
//                [hud hideAnimated:YES];
//            }
            
            ZPOrderInfo *orderInfo = returnValue;
            //调支付宝
            [BeeCloud setBeeCloudDelegate:self];
            [self payWithInfo:orderInfo];
            
        } withErrorBlock:^(id errorCode) {
            
        } withFailureBlock:^{
            
        }];
        NSDictionary *param = [self createPartParam];
        [shoppingCartVM checkShoppingCartProductsWithParam:param];
        
    }else if ([self.goodsInfo.detail.subtitle isEqualToString:@"全屋定制"]) {
        //全屋
        ZPShoppingCartViewModel *shoppingCartVM = [[ZPShoppingCartViewModel alloc] init];
        [shoppingCartVM setBlockWithReturnValueBlock:^(id returnValue) {
            
            //            if (![hud isHidden]) {
            //                [hud hideAnimated:YES];
            //            }
            
            ZPOrderInfo *orderInfo = returnValue;
            //调支付宝
            [BeeCloud setBeeCloudDelegate:self];
            [self payWithInfo:orderInfo];
            
        } withErrorBlock:^(id errorCode) {
            
        } withFailureBlock:^{
            
        }];
        NSDictionary *param = [self createPartParam];
        [shoppingCartVM checkShoppingCartGenerateHomeOrderWithParam:param];
        
    }
    
}

- (void)payWithInfo:(ZPOrderInfo *)info {
    BCPayReq *payReq = [[BCPayReq alloc] init];
//    payReq.channel = PayChannelAliApp; //支付渠道
    payReq.channel = PayChannelWxApp;
    payReq.title = @"zpTestTitle";//订单标题
//    payReq.totalFee = [NSString stringWithFormat:@"%ld", info.allSchedprice];//订单价格
    payReq.totalFee = @"1";
    //payReq.totalFee = @"1";
//    payReq.billNo = @"as12314asd";//商户自定义订单号
    payReq.billNo = [NSString stringWithFormat:@"%ld", info.superbillid];
    payReq.scheme = @"pay";//URL Scheme,在Info.plist中配置; 支付宝必有参数
    payReq.billTimeOut = 300;//订单超时时间
    payReq.viewController = self; //银联支付和Sandbox环境必填
    [BeeCloud sendBCReq:payReq];
}

#pragma mark-- BeeCloudDelegate
- (void)onBeeCloudResp:(BCBaseResp *)resp {
    
    //支付回调
    switch (resp.type) {
        case BCObjsTypePayResp:
        {
            // 支付请求响应
            BCPayResp *tempResp = (BCPayResp *)resp;
            if (tempResp.resultCode == 0) {
                //微信、支付宝、银联支付成功
                BCPayReq *payReq = (BCPayReq *)resp.request;
                //                NSString *orderNum = payReq.billNo;
                //判断支付方式
                switch (payReq.channel) {
                    case 10:
                    case 11:
                        _channelStr = @"微信支付";
                        break;
                    case 20:
                    case 21:
                    case 22:
                        _channelStr = @"支付宝支付";
                        break;
                    case 30:
                        _channelStr = @"银联支付";
                        break;
                    default:
                        break;
                }
                //返回给后台的信息
                //                _resultStr = [NSString stringWithFormat:@"%@;%@_app;%@;%@",_orderArr[1],_channelStr,orderNum,_orderArr[4]];
                //                NSLog(@"++++++++%@",_resultStr);
                //[self dismissViewControllerAnimated:YES completion:NULL];
                BCQueryBillByIdReq *req = [[BCQueryBillByIdReq alloc] initWithObjectId:tempResp.bcId];
                [BeeCloud sendBCReq:req];
                [self showAlertView:resp.resultMsg];
                
            } else {
                //支付取消或者支付失败
                [self showAlertView:[NSString stringWithFormat:@"%@ : %@",tempResp.resultMsg, tempResp.errDetail]];
            }
        }
            break;
        default:
        {
            if (resp.resultCode == 0) {
                [self showAlertView:resp.resultMsg];
            } else {
                [self showAlertView:[NSString stringWithFormat:@"%@ : %@",resp.resultMsg, resp.errDetail]];
            }
        }
            break;
    }
}

//显示提示信息
- (void)showAlertView:(NSString *)msg {
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:msg delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
    alert.delegate = self;
    [alert show];
    
}

- (NSDictionary *)createParam {
    NSString *uid = [[NSUserDefaults standardUserDefaults] objectForKey:@"CURRENT_UID"];
//    ZPShoppingCart *shoppingCart = self.selectedDataArray[0];//目前只实现了单个商品支付
    NSString *buyCount = @"1"; //购买数量默认为1
    NSString *desingerprice = @"0"; //修改价格默认为0
    NSString *cityName = [[self.address.address componentsSeparatedByString:@" "] firstObject];
    //这里预约金总价都写成了2000后期修改
    NSDictionary *result = @{@"uid":uid, @"billprice":@"2000", @"schedprice":@"2000", @"storeid":self.employees.storeId, @"phone":self.address.phone, @"receivername":self.address.receivername, @"receiveraddress":self.address.address, @"isperfe":@"0", @"salerno":self.employees.salerno, @"goodsid":self.goodsInfo.detail.gid, @"picurl":self.goodsInfo.detail.picurl, @"num":buyCount, @"desingerprice":desingerprice, @"color":@"iOS客户端", @"colorid":self.color.cid, @"taimianid":self.taimian.tid, @"doorid":self.door.did, @"mishu1":@"3", @"mishu2":@"1", @"huodongneirong":@"", @"kehuyaoqiu":@"", @"lingjifeixiang":@"", @"beizhu":@"", @"bzpj":@"", @"diypj":@"", @"goodsname":self.goodsInfo.detail.goodsname, @"cityName":cityName};
    
    /*
     mishu1是地柜台面   默认3
     mishu2是吊柜      默认1
     */
    return result;
}

- (NSDictionary *)createPartParam {
    
    NSString *uid = [[NSUserDefaults standardUserDefaults] objectForKey:@"CURRENT_UID"];
    NSString *buyCount = @"1"; //购买数量默认为1
    NSString *desingerprice = @"0"; //修改价格默认为0
    NSString *cityName = [[self.address.address componentsSeparatedByString:@" "] firstObject];
    NSDictionary *result = @{@"uid":uid, @"billprice":self.goodsInfo.detail.price, @"schedprice":self.goodsInfo.detail.price, @"storeid":self.employees.storeId, @"phone":self.address.phone, @"receivername":self.address.receivername, @"receiveraddress":self.address.address, @"isperfe":@"0", @"salerno":self.employees.salerno, @"goodsid":self.goodsInfo.detail.gid, @"picurl":self.goodsInfo.detail.picurl, @"num":buyCount, @"desingerprice":desingerprice, @"color":@"iOS客户端", @"cityName":cityName, @"goodsname":self.goodsInfo.detail.goodsname, @"activityid":@"0"};
    
    return result;
}


- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section > 1) {
        return 15;
    }else {
        return 30;
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *headerV = [[UIView alloc] initWithFrame:(CGRectMake(0, 0, kScreenWidth, 30))];
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:(CGRectMake(10, 0, 150, 30))];
    headerV.backgroundColor = kLightGrayColor;
    titleLabel.textColor = kGoodsTitleColor;
    switch (section) {
        case 0:
            titleLabel.text = @"配送信息";
            break;
        case 1:
            titleLabel.text = @"预约订单信息";
            break;
            
        default:
            break;
    }
    [headerV addSubview:titleLabel];
    return headerV;
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
