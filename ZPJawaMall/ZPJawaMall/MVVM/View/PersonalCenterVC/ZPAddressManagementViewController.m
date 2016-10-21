//
//  ZPAddressManagementViewController.m
//  ZPJawaMall
//
//  Created by zhupeng on 16/9/22.
//  Copyright © 2016年 朱鹏. All rights reserved.
//

#import "ZPAddressManagementViewController.h"
#import "ZPAddAddressTableViewCell.h"
#import "ZPPersonViewModel.h"
#import "ZPAddress.h"
#import "ZPAddressDetailInfoTableViewCell.h"
#import "ZPAddressInfoViewController.h"

@interface ZPAddressManagementViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *addressArray;

@end

@implementation ZPAddressManagementViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    self.addressArray = [NSMutableArray array];
    
    ZPPersonViewModel *viewModel = [[ZPPersonViewModel alloc] init];
    [viewModel setBlockWithReturnValueBlock:^(id returnValue) {
        
        ZPLog(@"%@", returnValue);
        self.addressArray = returnValue;
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.tableView reloadData];
        });
    } withErrorBlock:^(id errorCode) {
        
    } withFailureBlock:^{
        
    }];
    
    [viewModel getAddress:self.UID];

}

//AddAddressCellIdentity
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.addressArray.count + 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    //AddressTableViewCellIdentifier
    if (indexPath.row == 0) {
        ZPAddAddressTableViewCell *cell1 = [tableView dequeueReusableCellWithIdentifier:@"IdentityForAddAddressCell" forIndexPath:indexPath];
        ;
        return cell1;
    }
    ZPAddressDetailInfoTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"AddressTableViewCellIdentifier" forIndexPath:indexPath];
    if (self.addressArray.count >= 1) {
        cell.address = self.addressArray[indexPath.row - 1];
    }
    cell.layer.borderWidth = 1;
    cell.layer.borderColor = kLightGrayColor.CGColor;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
    ZPAddressInfoViewController *infoViewController = [storyboard instantiateViewControllerWithIdentifier:@"ZPAddressInfoViewControllerSBID"];
    infoViewController.isUpdate = YES;
    infoViewController.UID = self.UID;
    infoViewController.upAddress = self.addressArray[indexPath.row - 1];
    [self.navigationController pushViewController:infoViewController animated:NO];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    switch (indexPath.row) {
        case 0:
            return 30;
            break;
            
        default:
            return 65;
            break;
    }
    return 30;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) return NO;
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        ZPPersonViewModel *viewModel = [[ZPPersonViewModel alloc] init];
        [viewModel setBlockWithReturnValueBlock:^(id returnValue) {
            if ([returnValue[@"info"] isEqualToString:@"success"]) {
                [self.addressArray removeObjectAtIndex:indexPath.row - 1];
                [self.tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:(UITableViewRowAnimationFade)];
            }
            
        } withErrorBlock:^(id errorCode) {
            
        } withFailureBlock:^{
            
        }];
        [viewModel editNewAddressWithInfo:@{@"uid":self.UID,@"aid":((ZPAddress *)self.addressArray[indexPath.row - 1]).aid,@"action":@"delete"}];
    }
    
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    ZPAddressInfoViewController *vc = [segue destinationViewController];
    vc.UID = self.UID;
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
