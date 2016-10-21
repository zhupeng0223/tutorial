//
//  ZPGoodsDetailInfoViewController.m
//  ZPJawaMall
//
//  Created by zhupeng on 16/9/12.
//  Copyright © 2016年 朱鹏. All rights reserved.
//

#import "ZPGoodsDetailInfoViewController.h"
#import "BannerTableViewCell.h"
#import "GoodsInfo.h"
#import "ZPPriceDetailTableViewCell.h"
#import "ZPSpecificationsTableViewCell.h"
#import "ZPColorChooseTableViewCell.h"
#import "ZPProductDetailsCommentsTableViewCell.h"
#import "ZPOrderDetailInfoViewController.h"
#import "ZPShoppingCartViewModel.h"
#import "PurchaseCarAnimationTool.h"
#import "ZPHomePageViewModel.h"
#import "ZPPicInfo.h"

@interface ZPGoodsDetailInfoViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, assign) BOOL isCommentView;
@property (nonatomic, assign) NSInteger commentViewCurrentHeight;

@property (nonatomic, strong) UIView *bottomTool;
@property (nonatomic, assign) NSInteger currentColorSlecetedIndex;
@property (nonatomic, assign) NSInteger currentTaimianSlecetedIndex;
@property (nonatomic, strong) UIImageView *animationImageView;
@property (nonatomic, strong) NSArray *imageArray;

@end

@implementation ZPGoodsDetailInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.animationImageView = [[UIImageView alloc] initWithFrame:(CGRectMake(0, 64, kScreenWidth, 180))];
    [self.animationImageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@", kImageBassURL, [[self.goodsInfo.detail.picurl componentsSeparatedByString:@";"] firstObject]]] placeholderImage:[UIImage imageNamed:@"HomePageIcon"]];
    self.animationImageView.hidden = YES;
    [self.view addSubview:self.animationImageView];
    
    self.isCommentView = NO;
    self.commentViewCurrentHeight = 200;
    
    [self createBottomTool];
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.detailsLabel.text = @"Loading...";
    
    ZPHomePageViewModel *viewModle = [[ZPHomePageViewModel alloc] init];
    [viewModle setBlockWithReturnValueBlock:^(id returnValue) {
        
        //
        self.imageArray = returnValue;
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.tableView reloadData];
            [hud hideAnimated:YES];
        });
        
    } withErrorBlock:^(id errorCode) {
        
    } withFailureBlock:^{
        
    }];
    if (self.goodsInfo.detail.gid != nil) {
        [viewModle getPicSizeWithGoodsId:self.goodsInfo.detail.gid];
    }
    
//    [[NSNotificationCenter defaultCenter] postNotificationName:@"Comments_Details" object:@"Details"];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(selectCommentsDetails:) name:@"Comments_Details" object:nil];
    
}

- (void)selectCommentsDetails:(NSNotification *)noti {
    if ([noti.object isEqualToString:@"Details"]) {
        self.isCommentView = NO;
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:4] withRowAnimation:(UITableViewRowAnimationNone)];
        });
    }else if ([noti.object isEqualToString:@"Comments"]) {
        self.isCommentView = YES;
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:4] withRowAnimation:(UITableViewRowAnimationNone)];
        });
    }
}

- (void)createBottomTool {
    self.bottomTool = [[UIView alloc] initWithFrame:(CGRectMake(0, kScreenHeight - 104, kScreenWidth, 60))];
    self.bottomTool.alpha = 0.7;
    self.bottomTool.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.bottomTool];
    
    UIImageView *shopImageView = [[UIImageView alloc] initWithFrame:(CGRectMake(20, kScreenHeight - 96, 44, 44))];
    shopImageView.image = [UIImage imageNamed:@"ShoppingCartIcon"];
    shopImageView.userInteractionEnabled = YES;
    shopImageView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:shopImageView];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(gotoShopVC:)];
    [shopImageView addGestureRecognizer:tap];
    
    UIButton *addShopButton = [UIButton buttonWithType:(UIButtonTypeCustom)];
    addShopButton.frame = CGRectMake(kScreenWidth - 170, kScreenHeight - 96, 100, 44);
    addShopButton.backgroundColor = [UIColor whiteColor];
    addShopButton.layer.borderWidth = 1;
    addShopButton.layer.borderColor = [UIColor redColor].CGColor;
    addShopButton.layer.cornerRadius = 5;
    addShopButton.layer.masksToBounds = YES;
    [addShopButton setTitle:@"加入购物车" forState:(UIControlStateNormal)];
    [addShopButton setTitleColor:[UIColor redColor] forState:(UIControlStateNormal)];
    [addShopButton addTarget:self action:@selector(addShopAction:) forControlEvents:(UIControlEventTouchUpInside)];
    [self.view addSubview:addShopButton];
    
    UIButton *makeButton = [UIButton buttonWithType:(UIButtonTypeCustom)];
    makeButton.frame = CGRectMake(kScreenWidth - 65, kScreenHeight - 96, 50, 44);
    [makeButton setTitle:@"预约" forState:(UIControlStateNormal)];
    makeButton.layer.cornerRadius = 5;
    makeButton.layer.masksToBounds = YES;
    makeButton.backgroundColor = [UIColor redColor];
    [makeButton addTarget:self action:@selector(makeAction:) forControlEvents:(UIControlEventTouchUpInside)];
    [self.view addSubview:makeButton];
}

- (void)gotoShopVC:(UITapGestureRecognizer *)tap {
    ZPLog(@"gotoShopVC");
    
    self.tabBarController.selectedIndex = 2;
    
}

- (void)addShopAction:(UIButton *)btn {
    ZPLog(@"addShopAction");
    
    ZPShoppingCartViewModel *viewModel = [[ZPShoppingCartViewModel alloc] init];
    [viewModel setBlockWithReturnValueBlock:^(id returnValue) {
        
        if ([returnValue isEqualToString:@"success"]) {
            //添加成功
            [[PurchaseCarAnimationTool shareTool] startAnimationandView:self.animationImageView andRect:self.animationImageView.frame andFinisnRect:CGPointMake(ScreenWidth/4*2.5, ScreenHeight-49) andFinishBlock:^(BOOL finish) {
                UIView *tabbarBtn = self.tabBarController.tabBar.subviews[3];
                [PurchaseCarAnimationTool shakeAnimation:tabbarBtn];
            }];
            
        }else {
            //添加失败
            [self showAlertWithMessage:@"抱歉添加失败"];
        }
        
    } withErrorBlock:^(id errorCode) {
        
    } withFailureBlock:^{
        
    }];
    NSString *uid = [[NSUserDefaults standardUserDefaults] objectForKey:@"CURRENT_UID"];
    NSDictionary *dic = @{@"uid":uid,@"gid":self.goodsInfo.detail.gid,@"action":@"add"};
    [viewModel addShoppingCartWithParam:dic];
    
}

- (void)showAlertWithMessage:(NSString *)msg {
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"提示" message:msg preferredStyle:(UIAlertControllerStyleAlert)];
    UIAlertAction *action = [UIAlertAction actionWithTitle:@"确定" style:(UIAlertActionStyleDefault) handler:nil];
    [alertController addAction:action];
    [self presentViewController:alertController animated:YES completion:nil];
    
}

- (void)makeAction:(UIButton *)btn {
    ZPLog(@"addShopAction");
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
    ZPOrderDetailInfoViewController *orderDetailInfoVC = [storyboard instantiateViewControllerWithIdentifier:@"ZPOrderDetailInfoVCSBID"];
    orderDetailInfoVC.selectedTaimianIndex = self.currentTaimianSlecetedIndex;
    orderDetailInfoVC.selectedColorIndex = self.currentColorSlecetedIndex;
    orderDetailInfoVC.selectedDoorIndex = 0;
    orderDetailInfoVC.goodsInfo = self.goodsInfo;
    [self.navigationController pushViewController:orderDetailInfoVC animated:NO];
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return 3;
    }else if (section == 1) {
        return 1;
    }else if (section == 2 || section == 3) {
        return 1;
    }else {
        return 1;
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 5;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            return 180;
        }else if (indexPath.row == 1) {
            return 25;
        }else {
            return 70;
        }
    }else if (indexPath.section == 1) {
        return 30;
    }else if (indexPath.section == 2) {
        CGFloat row = self.goodsInfo.colors.count / 6 + 1;
        return 63 + row * 50 + 23;
    }else if (indexPath.section == 3) {
        CGFloat row = self.goodsInfo.taimian.count / 6 + 1;
        return 63 + row * 50 + 23;
    }else {
        if (self.isCommentView) {
            return self.commentViewCurrentHeight + 44;
        }
        NSInteger height = 0;
        for (ZPPicInfo *picInfo in self.imageArray) {
            height += [self heightForImgWithPicInfo:picInfo];
        }
        return height + 44;
    }
}

- (NSInteger)heightForImgWithPicInfo:(ZPPicInfo *)picInfo {
    
    NSInteger height = kScreenWidth / [picInfo.width integerValue] * [picInfo.height integerValue];
    return height;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            static NSString *reuseIdentifier1 = @"BannerTableViewCell2Identifier";
            BannerTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier1];
            if (cell == nil) {
                cell = [[[NSBundle mainBundle] loadNibNamed:@"BannerTableViewCell" owner:nil options:nil] lastObject];
            }
            if (self.goodsInfo.detail != nil) {
                NSArray *bannerArr = [self.goodsInfo.detail.picurl componentsSeparatedByString:@";"];
                cell.bnanerType = BnanerTypeOfDetail;
                cell.bannerArray = [NSMutableArray arrayWithArray:bannerArr];
            }
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            return cell;
        }else if (indexPath.row == 1) {
            static NSString *reuseIdentifier2 = @"TitleTableViewCellIdentifier";
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier2];
            if (cell == nil) {
                cell = [[UITableViewCell alloc]initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:reuseIdentifier2];
            }
            // Configure the cell...
            if (self.goodsInfo.detail != nil) {
                cell.textLabel.text = _goodsInfo.detail.goodsname;
                cell.textLabel.textColor = kGoodsTitleColor;
            }
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            return cell;
        }else {
            static NSString *reuseIdentifier3 = @"ZPPriceDetailTableViewCellIdentifier";
            
            ZPPriceDetailTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier3];
            if (cell == nil) {
                cell = [[[NSBundle mainBundle] loadNibNamed:@"ZPPriceDetailTableViewCell" owner:nil options:nil] lastObject];
            }
            
            // Configure the cell...
            if (self.goodsInfo.detail != nil) {
                cell.goodsDetail = _goodsInfo.detail;
            }
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            return cell;
        }
    }else if (indexPath.section == 1) {
        static NSString *reuseIdentifier4 = @"cell1";
        
        ZPSpecificationsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier4];
        if (cell == nil) {
            cell = [[[NSBundle mainBundle] loadNibNamed:@"ZPSpecificationsTableViewCell" owner:nil options:nil] lastObject];
        }
        
        // Configure the cell...
        if (_goodsInfo.detail != nil) {
            cell.specifications = _goodsInfo.detail.guide;
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }else if (indexPath.section == 2 || indexPath.section == 3) {
        static NSString *reuseIdentifier5 = @"ZPColorChooseTableViewCellIdentifier";
        
        ZPColorChooseTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier5];
        if (cell == nil) {
            cell = [[[NSBundle mainBundle] loadNibNamed:@"ZPColorChooseTableViewCell" owner:nil options:nil] lastObject];
        }
        
        // Configure the cell...
        switch (indexPath.section) {
            case 2:
            {
                if (self.goodsInfo.colors.count > 0) {
                    cell.Array = self.goodsInfo.colors;
                    cell.type = ColorType;
                    cell.colorNameLabel.text = [NSString stringWithFormat:@"%@:", [[self.goodsInfo.detail.goodsname componentsSeparatedByString:@"_"] lastObject]];
                    cell.currentSelectedIndex = self.currentColorSlecetedIndex;
                    cell.selectedColorBlock = ^(NSInteger index) {
                        //记录选择项
                        self.currentColorSlecetedIndex = index;
                    };
                }
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                return cell;
            }
                break;
            case 3:
            {
                if (self.goodsInfo.taimian.count > 0) {
                    cell.Array = self.goodsInfo.taimian;
                    cell.type = TaimianType;
                    cell.colorNameLabel.text = @"台面:";
                    cell.currentSelectedIndex = self.currentTaimianSlecetedIndex;
                    cell.selectedTaimianBlock = ^(NSInteger index) {
                        //记录选择项
                        self.currentTaimianSlecetedIndex = index;
                    };
                }
            }
                break;
                
            default:
                break;
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }else {
        static NSString *reuseIdentifier6 = @"BannerTableViewCell2Identifier";
        ZPProductDetailsCommentsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier6];
        [[NSUserDefaults standardUserDefaults] setObject:self.goodsInfo.detail.gid forKey:@"CURRENT_GID"];
        if (cell == nil) {
            cell = [[[NSBundle mainBundle] loadNibNamed:@"ZPProductDetailsCommentsTableViewCell" owner:nil options:nil] lastObject];
        }
        // Configure the cell...
        if (self.imageArray.count > 0) {
            cell.imageArr = self.imageArray;
        }
        if (self.isCommentView) {
            cell.currentIndex = 1;
        }else {
            cell.currentIndex = 0;
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
        
    }
}

//- (NSArray *)handelImageArr {
//    NSArray *tempArr = [_goodsInfo.detail.goodsdesc componentsSeparatedByString:@"\""];
//    NSMutableArray *resultArr = [NSMutableArray array];
//    for (NSString *str in tempArr) {
//        if ([str containsString:@"http://www.jvawa.com/"]) {
//            [resultArr addObject:str];
//        }
//    }
//    return resultArr;
//}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return 0;
    }
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
