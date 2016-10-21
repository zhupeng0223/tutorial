//
//  ZPAddressInfoViewController.m
//  ZPJawaMall
//
//  Created by zhupeng on 16/9/22.
//  Copyright © 2016年 朱鹏. All rights reserved.
//

#import "ZPAddressInfoViewController.h"
#import "ZPChooseAddressCollectionViewCell.h"
#import "ZPPersonViewModel.h"
#import "ZPAddress.h"
#import <DLRadioButton/DLRadioButton.h>

typedef enum {
    CITY_TYPE,
    AREA_TYPE,
    STREET_TYPE
}REGION_TYPE;

@interface ZPAddressInfoViewController ()<UICollectionViewDelegate, UICollectionViewDataSource, UIPickerViewDelegate, UIPickerViewDataSource, UITextFieldDelegate>

@property (strong, nonatomic) IBOutlet UIView *View1;
@property (strong, nonatomic) IBOutlet UIView *View2;
@property (strong, nonatomic) IBOutlet UIView *View5;
@property (strong, nonatomic) IBOutlet UIView *View6;

@property (strong, nonatomic) IBOutlet UITextField *consigneeTF;
@property (strong, nonatomic) IBOutlet UITextField *phoneNumberTF;
@property (strong, nonatomic) IBOutlet UICollectionView *collectionView;
@property (strong, nonatomic) IBOutlet UITextView *addressTextView;

@property (nonnull, strong) UIPickerView *pickerView;

@property (nonatomic, strong) NSMutableDictionary *rootDic;
@property (nonatomic, strong) NSMutableArray *cityArray;
@property (nonatomic, strong) NSMutableArray *areaArray;
@property (nonatomic, strong) NSMutableArray *streetArray;

@property (nonatomic, strong) NSMutableDictionary *nameDic;
@property (nonatomic, assign) REGION_TYPE currentSelected;
@property (strong, nonatomic) IBOutlet UIButton *submitBtn;

@property (nonatomic, assign) BOOL isDefault;

@end

@implementation ZPAddressInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.rootDic = [NSMutableDictionary dictionary];
    self.cityArray = [NSMutableArray array];
    self.areaArray = [NSMutableArray array];
    self.streetArray = [NSMutableArray array];
    self.nameDic = [NSMutableDictionary dictionary];
    
    self.consigneeTF.delegate = self;
    self.phoneNumberTF.delegate = self;
    
    CGRect frame = CGRectMake(20, 7, 262, 30);
    DLRadioButton *radioButton = [self createRadioButtonWithFrame:frame
                               Title:@"默认地址"
                               Color:[UIColor redColor]];
    
    [self setBordeWithView:self.View1];
    [self setBordeWithView:self.View2];
    [self setBordeWithView:self.View5];
    [self setBordeWithView:self.View6];
    
    
    if ([self.upAddress.isdefault isEqualToString:@"1"]) {
        [radioButton setSelected:YES];
        self.isDefault = YES;
    } else {
        [radioButton setSelected:NO];
        self.isDefault = NO;
    }
    
    [self handleCityInfo];
    
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    flowLayout.itemSize = CGSizeMake(150, 30);
    flowLayout.sectionInset = UIEdgeInsetsMake(10, 20, 10, 20);
    
    [self.collectionView setCollectionViewLayout:flowLayout];
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    [self.collectionView registerNib:[UINib nibWithNibName:@"ZPChooseAddressCollectionViewCell" bundle:[NSBundle mainBundle]] forCellWithReuseIdentifier:@"ZPChooseAddressCollectionViewCellIdentity"];
    
    self.pickerView = [[UIPickerView alloc] initWithFrame:(CGRectMake(0, kScreenHeight - 20, kScreenWidth, 150))];
    self.pickerView.backgroundColor = kLightGrayColor;
    self.pickerView.delegate = self;
    self.pickerView.dataSource = self;
    [self.view addSubview:self.pickerView];
    
    if (self.isUpdate) {
        self.consigneeTF.text = self.upAddress.receivername;
        self.phoneNumberTF.text = self.upAddress.phone;
        self.addressTextView.text = self.upAddress.address;
        NSArray *tempArr = [self.upAddress.address componentsSeparatedByString:@" "];
        if (tempArr.count > 0) {
            [self.nameDic setObject:tempArr[0] forKey:@"city"];
        }
        if (tempArr.count > 1) {
            [self.nameDic setObject:tempArr[1] forKey:@"area"];
        }
        if (tempArr.count > 2) {
            [self.nameDic setObject:tempArr[2] forKey:@"street"];
        }
        self.submitBtn.titleLabel.text = @"更新";
        [self.submitBtn setTitle:@"更新" forState:(UIControlStateNormal)];
        [self.submitBtn setTitle:@"更新" forState:(UIControlStateSelected)];
    }
    
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
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
    radioButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    [radioButton addTarget:self action:@selector(logSelectedButton:) forControlEvents:UIControlEventTouchUpInside];
    [self.View6 addSubview:radioButton];
    
    return radioButton;
}

- (void)logSelectedButton:(DLRadioButton *)radioButton {
    ZPPersonViewModel *viewModel = [[ZPPersonViewModel alloc] init];
    [viewModel setBlockWithReturnValueBlock:^(id returnValue) {
        
        UIAlertController *alertConroller = [UIAlertController alertControllerWithTitle:@"提示" message:@"设置成功" preferredStyle:(UIAlertControllerStyleAlert)];
        [self presentViewController:alertConroller animated:YES completion:nil];
        [alertConroller performSelector:@selector(dismissViewControllerAnimated:completion:) withObject:nil afterDelay:0.3];
        
    } withErrorBlock:^(id errorCode) {
        
    } withFailureBlock:^{
        
    }];
    if (self.isDefault) {
        if (self.isUpdate) {
            NSDictionary *info = @{@"uid":self.UID,@"aid":self.upAddress.aid,@"isDefault":@"0",@"action":@"setDefault"};
            [viewModel editNewAddressWithInfo:info];
        }
        
        [radioButton setSelected:NO];
        self.isDefault = NO;
    } else {
        if (self.isUpdate) {
            NSDictionary *info = @{@"uid":self.UID,@"aid":self.upAddress.aid,@"isDefault":@"1",@"action":@"setDefault"};
            [viewModel editNewAddressWithInfo:info];
        }
        
        [radioButton setSelected:YES];
        self.isDefault = YES;
    }
}

- (void)setBordeWithView:(UIView *)view {
    view.layer.borderWidth = 1;
    view.layer.borderColor = kLightGrayColor.CGColor;
}

- (void)handleCityInfo {
    self.currentSelected = CITY_TYPE;
    NSString *path = [[NSBundle mainBundle] pathForResource:@"Address" ofType:@"plist"];
    self.rootDic = [[NSMutableDictionary alloc] initWithContentsOfFile:path];
    [self.cityArray removeAllObjects];
    for (NSString *key in self.rootDic) {
        [self.cityArray addObject:key];
    }
}

#pragma mark-- UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return 3;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    ZPChooseAddressCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"ZPChooseAddressCollectionViewCellIdentity" forIndexPath:indexPath];
    cell.layer.borderWidth = 1;
    cell.layer.borderColor = kLightGrayColor.CGColor;
    cell.layer.cornerRadius = 5;
    cell.layer.masksToBounds = YES;
    switch (indexPath.item) {
        case 0:
            cell.addressLabel.text = self.nameDic[@"city"];
            break;
        case 1:
            cell.addressLabel.text = self.nameDic[@"area"];
            break;
        case 2:
            cell.addressLabel.text = self.nameDic[@"street"];
            break;
            
        default:
            break;
    }
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    [self.pickerView selectRow:0 inComponent:0 animated:NO];
    switch (indexPath.item) {
        case 0:
        {
            self.currentSelected = CITY_TYPE;
            [self handleCityInfo];
            [self.pickerView reloadAllComponents];
            [UIView animateWithDuration:1 animations:^{
                self.pickerView.frame = CGRectMake(0, kScreenHeight - 180 - 44, kScreenWidth, 180);
            }];
        }
            break;
        case 1:
        {
            if (self.nameDic[@"city"] == nil) {
                [self showAlertWithMessage:@"请选择城市/区"];
            }else {
                self.currentSelected = AREA_TYPE;
                NSDictionary *tempDic = self.rootDic[self.nameDic[@"city"]];
                [self.areaArray removeAllObjects];
                for (NSString *key in tempDic) {
                    [self.areaArray addObject:key];
                }
                [self.pickerView reloadAllComponents];
                [UIView animateWithDuration:1 animations:^{
                    self.pickerView.frame = CGRectMake(0, kScreenHeight - 180 - 44, kScreenWidth, 180);
                }];
            }
        }
            break;
        case 2:
        {
            if (self.nameDic[@"area"] == nil) {
                [self showAlertWithMessage:@"请选择城市/区"];
            }else {
                self.currentSelected = STREET_TYPE;
                [self.streetArray removeAllObjects];
                self.streetArray = self.rootDic[self.nameDic[@"city"]][self.nameDic[@"area"]];
                [self.pickerView reloadAllComponents];
                [UIView animateWithDuration:1 animations:^{
                    self.pickerView.frame = CGRectMake(0, kScreenHeight - 180 - 44, kScreenWidth, 180);
                }];
            }
        }
            break;
            
        default:
            break;
    }
    
}

- (void)showAlertWithMessage:(NSString *)message {
    UIAlertController *alertConroller = [UIAlertController alertControllerWithTitle:@"提示" message:message preferredStyle:(UIAlertControllerStyleAlert)];
    UIAlertAction *action = [UIAlertAction actionWithTitle:@"确定" style:(UIAlertActionStyleDefault) handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    [alertConroller addAction:action];
    [self presentViewController:alertConroller animated:YES completion:nil];
}

#pragma mark-- UIPickerViewDataSource
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    switch (self.currentSelected) {
        case CITY_TYPE:
            return self.cityArray.count;
            break;
        case AREA_TYPE:
            return self.areaArray.count;
            break;
        case STREET_TYPE:
            return self.streetArray.count;
            break;
            
        default:
            break;
    }
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    switch (self.currentSelected) {
        case CITY_TYPE:
            if (self.cityArray.count > 0 ) {
                return self.cityArray[row];
            }
            break;
        case AREA_TYPE:
            if (self.areaArray.count > 0) {
                return self.areaArray[row];
            }
            break;
        case STREET_TYPE:
            if (self.streetArray.count > 0) {
                return self.streetArray[row];
            }
            break;
            
        default:
            break;
    }
    return @"";
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    
    switch (self.currentSelected) {
        case CITY_TYPE:
        {
            if (self.cityArray.count > 0) {
                NSLog(@"%ld === %ld", row, component);
                [self.nameDic setObject:self.cityArray[row] forKey:@"city"];
                [UIView animateWithDuration:1 animations:^{
                    self.pickerView.frame = CGRectMake(0, kScreenHeight - 20, kScreenWidth, 180);
                }];
                [self.areaArray removeAllObjects];
                [self.streetArray removeAllObjects];
                [self.nameDic removeObjectForKey:@"area"];
                [self.nameDic removeObjectForKey:@"street"];
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self.collectionView reloadData];
                });
                self.addressTextView.text = [NSString stringWithFormat:@"%@ ", self.nameDic[@"city"]];
            }
        }
            break;
        case AREA_TYPE:
        {
            if (self.areaArray.count > 0) {
                [self.nameDic setObject:self.areaArray[row] forKey:@"area"];
                [UIView animateWithDuration:1 animations:^{
                    self.pickerView.frame = CGRectMake(0, kScreenHeight - 20, kScreenWidth, 180);
                }];
                [self.streetArray removeAllObjects];
                [self.nameDic removeObjectForKey:@"street"];
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self.collectionView reloadData];
                });
                self.addressTextView.text = [NSString stringWithFormat:@"%@ %@ ", self.nameDic[@"city"], self.nameDic[@"area"]];
            }
        }
            break;
        case STREET_TYPE:
        {
            if (self.streetArray.count > 0) {
                [self.nameDic setObject:self.streetArray[row] forKey:@"street"];
                [UIView animateWithDuration:1 animations:^{
                    self.pickerView.frame = CGRectMake(0, kScreenHeight - 20, kScreenWidth, 180);
                }];
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self.collectionView reloadData];
                });
                self.addressTextView.text = [NSString stringWithFormat:@"%@ %@ %@ ", self.nameDic[@"city"], self.nameDic[@"area"], self.nameDic[@"street"]];
            }
        }
            break;
            
        default:
            break;
    }
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark-- 新增
- (IBAction)newAction:(id)sender {
    if (self.consigneeTF.text.length > 0 && self.phoneNumberTF.text.length > 0 && self.addressTextView.text.length > 4) {
        ZPPersonViewModel *viewModel = [[ZPPersonViewModel alloc] init];
        [viewModel setBlockWithReturnValueBlock:^(id returnValue) {
            //
            if([returnValue[@"info"] isEqualToString:@"success"]) {
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"提示" message:@"恭喜添加成功~!" preferredStyle:(UIAlertControllerStyleAlert)];
                    [self presentViewController:alertController animated:YES completion:nil];
                    [self performSelector:@selector(dismissAction:) withObject:alertController afterDelay:1];
                });
            }else {
                
            }
        } withErrorBlock:^(id errorCode) {
            
        } withFailureBlock:^{
            
        }];
        if (self.isUpdate) {
            //"uid":"2502","aid":"786""reciverName":"小明","phoneNum":"13770963698","address":"南京市江宁区九龙湖企业园B1座","isDefault":"0","action":"update"
            NSDictionary *info = @{@"uid":self.UID,@"aid":self.upAddress.aid,@"reciverName":self.consigneeTF.text,@"phoneNum":self.phoneNumberTF.text,@"address":self.addressTextView.text,@"isDefault":[NSString stringWithFormat:@"%d", self.isDefault],@"action":@"update"};
            NSLog(@"%@", info);
            [viewModel editNewAddressWithInfo:info];
        }else {
            //{"uid":"2502","reciverName":"小明","phoneNum":"13770963698","address":"南京市江宁区九龙湖企业园B1座","isDefault":"1","action":"add"}
            [viewModel editNewAddressWithInfo:@{@"uid":self.UID, @"reciverName":self.consigneeTF.text, @"phoneNum":self.phoneNumberTF.text, @"address":self.addressTextView.text, @"isDefault":[NSString stringWithFormat:@"%d", self.isDefault],@"action":@"add"}];
        }
    }else {
        [self showAlertWithMessage:@"请填写完整信息"];
    }
}
- (void)dismissAction:(UIAlertController *)alert {
    [alert dismissViewControllerAnimated:YES completion:^{
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.navigationController popViewControllerAnimated:NO];
        });
    }];
}

- (IBAction)back:(id)sender {
    [self.navigationController popToRootViewControllerAnimated:YES];
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
