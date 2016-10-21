//
//  ZPChooseAddressView.m
//  ZPJawaMall
//
//  Created by zhupeng on 16/9/29.
//  Copyright © 2016年 朱鹏. All rights reserved.
//

#import "ZPChooseAddressView.h"
#import "ZPPersonViewModel.h"
#import "ZPAddress.h"
#import "ZPChooseAddressTableViewCell.h"

@interface ZPChooseAddressView ()<UITableViewDelegate, UITableViewDataSource>

@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *addressInfoArray;
@property (strong, nonatomic) IBOutlet UIButton *backBtn;
@property (nonatomic, copy) NSString *UID;
@property (strong, nonatomic) IBOutlet UIView *addAddressView;
@property (strong, nonatomic) IBOutlet UITextField *nameTF;
@property (strong, nonatomic) IBOutlet UITextField *phoneTF;
@property (strong, nonatomic) IBOutlet UITextView *addressTV;

@end

@implementation ZPChooseAddressView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        
        self.tableView.delegate = self;
        self.tableView.dataSource = self;
        
        self.backBtn.hidden = YES;
        self = [[[NSBundle mainBundle] loadNibNamed:@"ZPChooseAddressView" owner:nil options:nil] lastObject];
        self.UID = [[NSUserDefaults standardUserDefaults] valueForKey:@"CURRENT_UID"];
        if (self.UID.length > 0) {
            ZPPersonViewModel *viewMoel = [[ZPPersonViewModel alloc] init];
            [viewMoel setBlockWithReturnValueBlock:^(id returnValue) {
                
                self.addressInfoArray = [NSMutableArray arrayWithArray:returnValue];
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self.tableView reloadData];
                });
                
            } withErrorBlock:^(id errorCode) {
                
            } withFailureBlock:^{
                
            }];
            [viewMoel getAddress:self.UID];
        }else {
            UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"提示" message:@"请先登录~!" preferredStyle:(UIAlertControllerStyleAlert)];
            UIAlertAction *action = [UIAlertAction actionWithTitle:@"确定" style:(UIAlertActionStyleDefault) handler:nil];
            [alertController addAction:action];
            [self.inputViewController presentViewController:alertController animated:YES completion:nil];
        }
        
    }
    return self;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.addressInfoArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *reuseIdentifier = @"chooseAddressCellIdentifier";
    
    ZPChooseAddressTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"ZPChooseAddressTableViewCell" owner:nil options:nil] lastObject];
    }
    if (self.addressInfoArray.count > 0) {
        cell.address = self.addressInfoArray[indexPath.row];
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [[NSNotificationCenter defaultCenter] postNotificationName:@"chooesAddressNotiName" object:self.addressInfoArray[indexPath.row]];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"dissmissAddressViewNotiName" object:nil];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 70;
}

- (IBAction)addNewAddress:(id)sender {
    self.backBtn.hidden = NO;
    self.addAddressView.hidden = NO;
}

- (IBAction)addAddressAction:(id)sender {
    
    //发送添加地址
    ZPPersonViewModel *viewModel = [[ZPPersonViewModel alloc] init];
    [viewModel setBlockWithReturnValueBlock:^(id returnValue) {
        //解析returnValue
        if ([returnValue[@"info"] isEqualToString:@"success"]) {
            ZPPersonViewModel *viewMoel1 = [[ZPPersonViewModel alloc] init];
            [viewMoel1 setBlockWithReturnValueBlock:^(id returnValue) {
                
                self.addressInfoArray = [NSMutableArray arrayWithArray:returnValue];
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self.tableView reloadData];
                });
                
            } withErrorBlock:^(id errorCode) {
                
            } withFailureBlock:^{
                
            }];
            [viewMoel1 getAddress:self.UID];
            self.backBtn.hidden = YES;
            [self.addAddressView endEditing:YES];
            self.addAddressView.hidden = YES;
        }
        
    } withErrorBlock:^(id errorCode) {
        
    } withFailureBlock:^{
        
    }];
    if (self.nameTF.text.length > 0 && self.phoneTF.text.length > 0) {
        NSDictionary *info = @{@"uid":self.UID, @"reciverName":self.nameTF.text, @"phoneNum":self.phoneTF.text, @"address":self.addressTV.text, @"isDefault":@"0", @"action":@"add"};
        [viewModel editNewAddressWithInfo:info];
    }else {
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"提示" message:@"请填写完整信息" preferredStyle:(UIAlertControllerStyleAlert)];
        UIAlertAction *action = [UIAlertAction actionWithTitle:@"确定" style:(UIAlertActionStyleDefault) handler:nil];
        [alertController addAction:action];
        UIViewController *VC = [self currentViewController];
        [VC presentViewController:alertController animated:YES completion:nil];
    }
    
}

-(UIViewController *)currentViewController {
    UIViewController *vc;
    for (UIView* next = [self superview]; next; next = next.superview) {
        UIResponder* nextResponder = [next nextResponder];
        if ([nextResponder isKindOfClass:[objc_getClass("UIViewController") class]] ) {
            vc=(UIViewController*)nextResponder;
            
            return vc;
        }
    }
    return vc;
}

- (IBAction)backAction:(id)sender {
    self.backBtn.hidden = YES;
    [self.tableView reloadData];
    [self.addAddressView endEditing:YES];
    self.addAddressView.hidden = YES;
}
- (IBAction)dissMissAction:(id)sender {
    
}

@end
