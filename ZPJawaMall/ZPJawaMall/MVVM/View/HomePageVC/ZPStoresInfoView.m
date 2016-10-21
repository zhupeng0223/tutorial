//
//  ZPStoresInfo.m
//  ZPJawaMall
//
//  Created by zhupeng on 16/9/28.
//  Copyright © 2016年 朱鹏. All rights reserved.
//

#import "ZPStoresInfoView.h"
#import "ZPStoreInfoViewModel.h"
#import "ZPStores.h"
#import "ZPEmployees.h"

@interface ZPStoresInfoView ()

@property (nonatomic, strong) NSMutableArray *cityArray;
@property (nonatomic, strong) NSMutableArray *storesArray;
@property (nonatomic, strong) NSMutableArray *employeesArray;
@property (nonatomic, strong) MBProgressHUD *hud;

@end

@implementation ZPStoresInfoView

- (instancetype)initWithFrame:(CGRect)frame City:(NSString *)city type:(CurrentStoreInfoType)type {
    self = [super initWithFrame:frame];
    if (self) {
        self = [[[NSBundle mainBundle] loadNibNamed:@"ZPStoresInfoView" owner:nil options:nil] lastObject];
        self.currentCity = city;
        self.currentType = type;
        
        self.infoTableView.delegate = self;
        self.infoTableView.dataSource = self;
        self.infoTableView.tableFooterView = [[UIView alloc] init];
        
        self.cityArray = [NSMutableArray arrayWithObjects:@"南京", @"上海", @"兰州", @"沈阳", nil];
        
        [self.selectedCityBtn setTitle:self.currentCity forState:(UIControlStateNormal)];
        
        self.hud = [MBProgressHUD showHUDAddedTo:self animated:YES];
        self.hud.detailsLabel.text = @"Loading...";
        
        ZPStoreInfoViewModel *viewModel = [[ZPStoreInfoViewModel alloc] init];
        [viewModel setBlockWithReturnValueBlock:^(id returnValue) {
           //
            self.storesArray = [NSMutableArray arrayWithArray:returnValue];
            [self reloadTableView];
            
        } withErrorBlock:^(id errorCode) {
            
        } withFailureBlock:^{
            
        }];
        [viewModel getStoresInfoWithCity:city];
        
    }
    return self;
}

- (void)dismissAlertController:(UIAlertController *)alertC {
    [alertC dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark-- UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    switch (self.currentType) {
        case City_Type:
        {
            return 4;
        }
            break;
        case Store_Type:
        {
            return self.storesArray.count;
        }
            break;
        case Employees_Type:
        {
            return self.employeesArray.count;
        }
            break;
            
        default:
            break;
    }
    return 4;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    switch (self.currentType) {
        case City_Type:
        {
            static NSString *reuseIdentifier = @"cityCellIdentifier";
            
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier];
            if (cell == nil) {
                cell = [[UITableViewCell alloc]initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:reuseIdentifier];
            }
            
            // Configure the cell...
            if (self.cityArray.count > 0) {
                cell.textLabel.text = self.cityArray[indexPath.row];
            }
            
            return cell;
        }
            break;
        case Store_Type:
        {
            static NSString *reuseIdentifier1 = @"storesCellIdentifier";
            
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier1];
            if (cell == nil) {
                cell = [[UITableViewCell alloc]initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:reuseIdentifier1];
            }
            
            // Configure the cell...
            if (self.storesArray.count > 0) {
                
                cell.textLabel.text = ((ZPStores *)self.storesArray[indexPath.row]).storeName;
            }
            
            return cell;
        }
            break;
        case Employees_Type:
        {
            static NSString *reuseIdentifier2 = @"employeesCellIdentifier";
            
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier2];
            if (cell == nil) {
                cell = [[UITableViewCell alloc]initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:reuseIdentifier2];
            }
            
            // Configure the cell...
            if (self.employeesArray.count > 0) {
                ZPEmployees *employe = ((ZPEmployees *)self.employeesArray[indexPath.row]);
                cell.textLabel.text = [NSString stringWithFormat:@"%@(工号 %@)", employe.truename, employe.salerno];
            }
            
            return cell;
        }
            break;
            
        default:
            break;
    }
    
    static NSString *reuseIdentifier = @"infoTabelViewCellIdentifier";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:reuseIdentifier];
    }
    
    // Configure the cell...
    
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    switch (self.currentType) {
        case City_Type:
        {
            
            self.currentType = Store_Type;
            ZPStoreInfoViewModel *viewModel = [[ZPStoreInfoViewModel alloc] init];
            [viewModel setBlockWithReturnValueBlock:^(id returnValue) {
                [self.storesArray removeAllObjects];
                self.storesArray = [NSMutableArray arrayWithArray:returnValue];
                [self reloadTableView];
                
            } withErrorBlock:^(id errorCode) {
                
            } withFailureBlock:^{
                
            }];
            [viewModel getStoresInfoWithCity:self.cityArray[indexPath.row]];
            
        }
            break;
        case Store_Type:
        {
            ZPStoreInfoViewModel *viewModel = [[ZPStoreInfoViewModel alloc] init];
            [viewModel setBlockWithReturnValueBlock:^(id returnValue) {
                
                //
                self.currentType = Employees_Type;
                [self.backBtn setTitle:@"返回上页" forState:(UIControlStateNormal)];
                self.employeesArray = [NSMutableArray arrayWithArray:returnValue];
                [self reloadTableView];
                
            } withErrorBlock:^(id errorCode) {
                
            } withFailureBlock:^{
                
            }];
            
            [viewModel getEmployeesWithStoreName:((ZPStores *)self.storesArray[indexPath.row]).storeName];
        }
            break;
        case Employees_Type:
        {
            [[NSNotificationCenter defaultCenter] postNotificationName:@"recordEmployees" object:((ZPEmployees *)self.employeesArray[indexPath.row])];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"dissmissStoresInfoView" object:nil];
        }
            break;
            
        default:
            break;
    }
}

- (void)reloadTableView{
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.infoTableView reloadData];
        [self.hud hideAnimated:YES];
    });
}

- (IBAction)chooseCityAction:(id)sender {
    
    self.currentType = City_Type;
    [self reloadTableView];
    
}

- (IBAction)backAction:(id)sender {
    if (self.currentType == Employees_Type) {
        self.currentType = Store_Type;
        [self reloadTableView];
        [self.backBtn setTitle:@"关闭" forState:(UIControlStateNormal)];
    }else {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"dissmissStoresInfoView" object:nil];
    }
}

@end
