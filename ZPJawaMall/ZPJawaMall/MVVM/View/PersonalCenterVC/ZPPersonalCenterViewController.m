//
//  ZPPersonalCenterViewController.m
//  ZPJawaMall
//
//  Created by zhupeng on 16/8/29.
//  Copyright © 2016年 朱鹏. All rights reserved.
//

#import "ZPPersonalCenterViewController.h"
#import "ZPLoginViewModel.h"
#import "ZPPersonalInfoViewController.h"
#import <DLRadioButton/DLRadioButton.h>
#import "ZPRegisterViewModel.h"
#import "ZPSendIdentifyCodeViewModel.h"
#import "ZPResetPassWordViewModel.h"

@interface ZPPersonalCenterViewController ()

@property (strong, nonatomic) IBOutlet UITextField *userNameTF;
@property (strong, nonatomic) IBOutlet UITextField *passWordTF;
@property (strong, nonatomic) IBOutlet UIButton *loginBtn;
@property (strong, nonatomic) IBOutlet UIButton *registerBtn;
@property (strong, nonatomic) IBOutlet UIView *registerView;
@property (strong, nonatomic) IBOutlet UITextView *contentAgreementTF;
@property (strong, nonatomic) IBOutlet UIView *registerDetailView;
@property (nonatomic, strong) DLRadioButton *agreeContentBtn;
@property (nonatomic, assign) BOOL isAgreed;
@property (strong, nonatomic) IBOutlet UITextField *phoneNumberTF;
@property (strong, nonatomic) IBOutlet UITextField *verificationCodeTF;
@property (strong, nonatomic) IBOutlet UITextField *registerPassWordTF;
@property (strong, nonatomic) IBOutlet UITextField *isRegisterPassWordTF;

@property (nonatomic, copy) NSString *registVerificationCode;
@property (strong, nonatomic) IBOutlet UILabel *haveReadLabel;
@property (strong, nonatomic) IBOutlet UIButton *userAgreementLabel;


@property (nonatomic, assign) BOOL isForgetPasswordView;

@end

@implementation ZPPersonalCenterViewController

- (void)dealloc
{
    ZPLog(@"%@", self.returnUserInfoBlock);
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.loginBtn.layer.masksToBounds = YES;
    self.loginBtn.layer.cornerRadius = 5;
    
    CGRect frame = CGRectMake(20, self.isRegisterPassWordTF.frame.origin.y + 128, 25, 25);
    self.agreeContentBtn = [self createRadioButtonWithFrame:frame
                                                      Title:@""
                                                      Color:[UIColor redColor]];
    
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
    [self.registerDetailView addSubview:radioButton];
    
    return radioButton;
}

- (void)logSelectedButton:(DLRadioButton *)radioButton {
    if (self.isAgreed) {
        [radioButton setSelected:NO];
        self.isAgreed = NO;
    }else {
        [radioButton setSelected:YES];
        self.isAgreed = YES;
    }
}

#pragma mark-- 登陆
- (IBAction)loginAction:(id)sender {
    if (self.userNameTF.text.length < 1 || self.passWordTF.text.length < 1) {
        [self showAlertWithString:@"用户名/密码不能为空"];
    }else {
        ZPLoginViewModel *loginVM = [[ZPLoginViewModel alloc] init];
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        hud.detailsLabel.text = @"Loading...";
        
        WS(weakSelf);
        [loginVM setLoginBlockWithReturnValueBlock:^(id returnValue) {
            [self dismissViewControllerAnimated:YES completion:^{
                
                weakSelf.returnUserInfoBlock((UserInfo *)returnValue);
                [hud hideAnimated:YES];
                
            }];
            
        } withErrorBlock:^(id errorCode) {
            
        } withFailureBlock:^{
            
        }];
        
        [loginVM loginWithUserName:self.userNameTF.text passWord:self.passWordTF.text];
    }
}

- (void)showAlertWithString:(NSString *)str {
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"提示" message:str preferredStyle:(UIAlertControllerStyleAlert)];
    UIAlertAction *action = [UIAlertAction actionWithTitle:@"确定" style:(UIAlertActionStyleCancel) handler:^(UIAlertAction * _Nonnull action) {
        if ([str isEqualToString:@"恭喜~注册成功!"]) {
            [self dismissViewControllerAnimated:YES completion:nil];
        }
    }];
    
    [alertController addAction:action];
    [self presentViewController:alertController animated:YES completion:^{
        
    }];
}

#pragma mark-- 跳转到注册页面
- (IBAction)registerAction:(id)sender {
    self.isForgetPasswordView = NO;
    self.registerView.hidden = NO;
}
#pragma mark-- 同意协议方法
- (IBAction)agreedAction:(id)sender {
    self.registerDetailView.hidden = NO;
}
#pragma mark-- 不同意协议方法
- (IBAction)refusedAction:(id)sender {
    
    self.registerView.hidden = YES;
    
}
#pragma mark-- 获取验证码
- (IBAction)getVerificationCode:(id)sender {
    if (self.isForgetPasswordView) {
        //忘记密码 发送验证码
        ZPResetPassWordViewModel *restPWDVM = [[ZPResetPassWordViewModel alloc] init];
        
        [restPWDVM setBlockWithReturnValueBlock:^(id returnValue) {
            
            ZPLog(@"%@", returnValue);
            
        } withErrorBlock:^(id errorCode) {
            
        } withFailureBlock:^{
            
        }];
        if (self.phoneNumberTF.text.length > 10) {
            
            [restPWDVM getVerificationCodeWithPhoneNumber:self.userNameTF.text];
            
        }else {
            [self showAlertWithString:@"手机号不对"];
        }
        
        
    }else {
        //注册 发送验证码
        ZPSendIdentifyCodeViewModel *identifyCodeVM = [[ZPSendIdentifyCodeViewModel alloc] init];
        [identifyCodeVM setBlockWithSendIdentifyCodeReturnValueBlock:^(id returnValue) {
            
            self.registVerificationCode = returnValue[@"code"];
            
        } withErrorBlock:^(id errorCode) {
            
        } withFailureBlock:^{
            
        }];
        if (self.phoneNumberTF.text.length > 10) {
            
            [identifyCodeVM sendIdentifyCodeWithPhoneNumber:self.phoneNumberTF.text];
            
        }else {
            [self showAlertWithString:@"手机号不对"];
        }
    }
    
}
#pragma mark-- 发送注册信息
- (IBAction)sendRegisterInfo:(id)sender {
    
    if (self.isForgetPasswordView) {
        
        //忘记密码
        
    }else {
        //注册
        if (!self.isAgreed) {
            [self showAlertWithString:@"请确认用户协议"];
        }else {
            if (self.phoneNumberTF.text.length > 0 && self.verificationCodeTF.text.length > 0 && self.registerPassWordTF.text.length > 0 && [self.registerPassWordTF.text isEqualToString:self.isRegisterPassWordTF.text]) {
                
                NSDictionary *info = @{@"phoneNum": self.phoneNumberTF.text, @"identifyCode": self.verificationCodeTF.text, @"password": self.registerPassWordTF.text};
                ZPRegisterViewModel *registerVM = [[ZPRegisterViewModel alloc] init];
                if ([self.registVerificationCode isEqualToString:@"200"]) {
                    [registerVM setBlockWithReturnValueBlock:^(id returnValue) {
                        
                        if ([returnValue[@"code"] isEqualToString:@"200"]) {
                            //注册成功
                            [self showAlertWithString:@"恭喜~注册成功!"];
                            
                        }else {
                            //注册失败
                            [self showAlertWithString:@"抱歉~注册失败!"];
                        }
                        
                    } withErrorBlock:^(id errorCode) {
                        
                    } withFailureBlock:^{
                        
                    }];
                    
                    
                    [registerVM registerWithInfo:info];
                }else {
                    [self showAlertWithString:@"请输入正确的验证码"];
                }
                
            }else {
                [self showAlertWithString:@"请填写完整信息"];
            }
        }
        
    }
    
}

#pragma mark-- 用户协议
- (IBAction)userAgreement:(id)sender {
    self.registerDetailView.hidden = YES;
}


#pragma mark-- 忘记密码
- (IBAction)forgotPasswordAction:(id)sender {
    
    self.isForgetPasswordView = YES;
    
    self.registerDetailView.hidden = NO;
    self.userNameTF.placeholder = @"找回密码的手机";
    self.passWordTF.placeholder = @"输入新密码";
    self.isRegisterPassWordTF.placeholder = @"确认新密码";
    self.loginBtn.titleLabel.text = @"密码重置";
    self.agreeContentBtn.hidden = YES;
    self.haveReadLabel.hidden = YES;
    self.userAgreementLabel.hidden = YES;
    
}

- (IBAction)backUserInfoVC:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"refreshTableView" object:nil];
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
