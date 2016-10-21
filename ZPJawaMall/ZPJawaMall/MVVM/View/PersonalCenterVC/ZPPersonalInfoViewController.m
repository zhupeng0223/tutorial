//
//  ZPPersonalInfoViewController.m
//  ZPJawaMall
//
//  Created by zhupeng on 16/9/1.
//  Copyright © 2016年 朱鹏. All rights reserved.
//

#import "ZPPersonalInfoViewController.h"
#import "ZPPersonalCenterViewController.h"
#import "ZPTopIconInfoTableViewCell.h"
#import "ZPPersonalInfoTableViewCell.h"
#import "ZPUserOrderViewController.h"
#import "ZPZPActivityViewController.h"
#import "ZPAddressManagementViewController.h"

@interface ZPPersonalInfoViewController ()<UITableViewDelegate, UITableViewDataSource, UITabBarControllerDelegate>

@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) UserInfo *currentUserInfo;
@property (nonatomic, strong) NSArray *titleArray;

@end

@implementation ZPPersonalInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    self.titleArray = [NSMutableArray arrayWithObjects:@"全部订单", @"我的礼券", @"最新活动", @"查询礼券", @"礼券统计", @"地址管理", @"扫一扫", @"退出系统", nil];
    
    [self login];
    
    self.tabBarController.delegate = self;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshTableView) name:@"refreshTableView" object:nil];
    
}

- (void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController {
    if (viewController == self.tabBarController.customizableViewControllers[3]) {
        [self login];
    }
}

- (void)login {
    BOOL isLogin = [[NSUserDefaults standardUserDefaults] boolForKey:@"isLogin"];
    if (isLogin) {
        self.currentUserInfo = [self readUserInfoFromLocalDatabase];
        [[NSUserDefaults standardUserDefaults] setValue:self.currentUserInfo.ID forKey:@"CURRENT_UID"];
        NSLog(@"%@", [[NSUserDefaults standardUserDefaults] valueForKey:@"CURRENT_UID"]);
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.tableView reloadData];
        });
    }else {
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
        ZPPersonalCenterViewController *loginVC = [storyboard instantiateViewControllerWithIdentifier:@"ZPPersonalCenterID"];
        loginVC.returnUserInfoBlock = ^(UserInfo *value) {
            //刷新数据
            dispatch_async(dispatch_get_main_queue(), ^{
                // 写入本地
                [self writeToLocalDatabaseWithUserInfo:value];
                self.currentUserInfo = value;
                [[NSUserDefaults standardUserDefaults] setValue:self.currentUserInfo.ID forKey:@"CURRENT_UID"];
                [self.tableView reloadData];
            });
        };
        [self presentViewController:loginVC animated:YES completion:nil];
    }
}

#pragma mark-- WriteToLocalDatabase
- (void)writeToLocalDatabaseWithUserInfo:(UserInfo *)userInfo {
    if (userInfo == nil) {
        [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"isLogin"];
        [[NSUserDefaults standardUserDefaults] setValue:@"" forKey:@"CURRENT_UID"];
    }else {
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"isLogin"];
    }
    [[NSUserDefaults standardUserDefaults] setObject:userInfo.ID forKey:@"ID"];
    [[NSUserDefaults standardUserDefaults] setObject:userInfo.username forKey:@"username"];
    [[NSUserDefaults standardUserDefaults] setObject:userInfo.nickname forKey:@"nickname"];
    [[NSUserDefaults standardUserDefaults] setObject:userInfo.password forKey:@"password"];
    [[NSUserDefaults standardUserDefaults] setObject:userInfo.phone forKey:@"phone"];
    [[NSUserDefaults standardUserDefaults] setObject:userInfo.wx_openid forKey:@"wx_openid"];
    [[NSUserDefaults standardUserDefaults] setObject:userInfo.status forKey:@"status"];
    [[NSUserDefaults standardUserDefaults] setObject:userInfo.createtime forKey:@"createtime"];
    [[NSUserDefaults standardUserDefaults] setObject:userInfo.headImg forKey:@"headImg"];
    [[NSUserDefaults standardUserDefaults] setObject:userInfo.area forKey:@"area"];
    [[NSUserDefaults standardUserDefaults] setObject:userInfo.credit forKey:@"credit"];
    [[NSUserDefaults standardUserDefaults] setObject:userInfo.lasttime forKey:@"lasttime"];
    [[NSUserDefaults standardUserDefaults] setObject:userInfo.num forKey:@"num"];
    [[NSUserDefaults standardUserDefaults] setObject:userInfo.auth_key forKey:@"auth_key"];
    [[NSUserDefaults standardUserDefaults] setObject:userInfo.updated_at forKey:@"updated_at"];
    [[NSUserDefaults standardUserDefaults] setObject:userInfo.email forKey:@"email"];
}

- (UserInfo *)readUserInfoFromLocalDatabase {
    UserInfo *userInfo = [[UserInfo alloc] init];
    BOOL isLogin = [[NSUserDefaults standardUserDefaults] boolForKey:@"isLogin"];
    if (isLogin) {
        userInfo.ID = [[NSUserDefaults standardUserDefaults] objectForKey:@"ID"];
        userInfo.username = [[NSUserDefaults standardUserDefaults] objectForKey:@"username"];
        userInfo.nickname = [[NSUserDefaults standardUserDefaults] objectForKey:@"nickname"];
        userInfo.password = [[NSUserDefaults standardUserDefaults] objectForKey:@"password"];
        userInfo.phone = [[NSUserDefaults standardUserDefaults] objectForKey:@"phone"];
        userInfo.wx_openid = [[NSUserDefaults standardUserDefaults] objectForKey:@"wx_openid"];
        userInfo.status = [[NSUserDefaults standardUserDefaults] objectForKey:@"status"];
        userInfo.createtime = [[NSUserDefaults standardUserDefaults] objectForKey:@"createtime"];
        userInfo.headImg = [[NSUserDefaults standardUserDefaults] objectForKey:@"headImg"];
        userInfo.area = [[NSUserDefaults standardUserDefaults] objectForKey:@"area"];
        userInfo.credit = [[NSUserDefaults standardUserDefaults] objectForKey:@"credit"];
        userInfo.lasttime = [[NSUserDefaults standardUserDefaults] objectForKey:@"lasttime"];
        userInfo.num = [[NSUserDefaults standardUserDefaults] objectForKey:@"num"];
        userInfo.auth_key = [[NSUserDefaults standardUserDefaults] objectForKey:@"auth_key"];
        userInfo.updated_at = [[NSUserDefaults standardUserDefaults] objectForKey:@"updated_at"];
        userInfo.email = [[NSUserDefaults standardUserDefaults] objectForKey:@"email"];
    }
    return userInfo;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        return 180;
    }
    return 50;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return 1;
    }
    return 8;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        ZPTopIconInfoTableViewCell *cell1 = [tableView dequeueReusableCellWithIdentifier:@"topInfoCellIdentifier"];
        if (cell1 == nil) {
            cell1 = [[[NSBundle mainBundle] loadNibNamed:@"ZPTopIconInfoTableViewCell" owner:nil options:nil] lastObject];
        }
        if (self.currentUserInfo != nil) {
            cell1.userInfo = self.currentUserInfo;
        }
        return cell1;
    }else {
        ZPPersonalInfoTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"personalInfoTableViewCellIdentifier"];
        if (cell == nil) {
            cell = [[[NSBundle mainBundle] loadNibNamed:@"ZPPersonalInfoTableViewCell" owner:nil options:nil] lastObject];
        }
        cell.titleLabel.text = self.titleArray[indexPath.row];
        if (indexPath.row == 0) {
            cell.TrackingOrderLabel.hidden = NO;
        }else {
            cell.TrackingOrderLabel.hidden = YES;
        }
        return cell;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.currentUserInfo.ID == nil) {
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"提示" message:@"请先登录" preferredStyle:(UIAlertControllerStyleAlert)];
        UIAlertAction *action = [UIAlertAction actionWithTitle:@"确定" style:(UIAlertActionStyleDefault) handler:nil];
        [alertController addAction:action];
        [self presentViewController:alertController animated:YES completion:nil];
        return;
    }
    
    if (indexPath.section == 1) {
        switch (indexPath.row) {
            case 0:
            {
                UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
                ZPUserOrderViewController *orderVC = [storyboard instantiateViewControllerWithIdentifier:@"ZPUserOrderViewControllerSBID"];
                orderVC.uid = self.currentUserInfo.ID;
                [self.navigationController pushViewController:orderVC animated:NO];
                
                
            }
                break;
            case 1:
            {
                
            }
                break;
            case 2:
            {
                
                //ZPActivityViewControllerSBID
                UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
                ZPZPActivityViewController *activityVC = [storyboard instantiateViewControllerWithIdentifier:@"ZPActivityViewControllerSBID"];
                [self.navigationController pushViewController:activityVC animated:NO];
                
                
            }
                break;
            case 3:
            {
                
            }
                break;
            case 4:
            {
                
            }
                break;
            case 5:
            {
                UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
                ZPAddressManagementViewController *addressManagementVC = [storyboard instantiateViewControllerWithIdentifier:@"ZPAddressManagementViewControllerSBID"];
                addressManagementVC.UID = self.currentUserInfo.ID;
                [self.navigationController pushViewController:addressManagementVC animated:NO];
                
            }
                break;
            case 6:
            {
                
            }
                break;
            case 7:
            {
                [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"isLogin"];
                self.currentUserInfo = nil;
                [self writeToLocalDatabaseWithUserInfo:nil];
                UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
                ZPPersonalCenterViewController *loginVC = [storyboard instantiateViewControllerWithIdentifier:@"ZPPersonalCenterID"];
                loginVC.returnUserInfoBlock = ^(UserInfo *value) {
                    
                    //刷新数据
                    dispatch_async(dispatch_get_main_queue(), ^{
                        // 写入本地
                        [self writeToLocalDatabaseWithUserInfo:value];
                        self.currentUserInfo = value;
                        [self.tableView reloadData];
                    });
                    
                };
                [self presentViewController:loginVC animated:YES completion:nil];
            }
                break;
                
            default:
                break;
        }
        
    }
    
}

- (void)refreshTableView {
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.tableView reloadData];
    });
    
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
