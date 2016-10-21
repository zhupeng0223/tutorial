//
//  BassViewController.m
//  ZPJawaMall
//
//  Created by zhupeng on 16/8/29.
//  Copyright © 2016年 朱鹏. All rights reserved.
//

#import "BassViewController.h"
#import "TopBarView.h"
#import <AVFoundation/AVFoundation.h>
#import "ZPHomePageViewModel.h"
#import "ZPGoodsDetailInfoViewController.h"
#import "ZPClassificationDetailsViewModel.h"
#import "ZPGoodsListViewController.h"

@interface BassViewController ()<AVCaptureMetadataOutputObjectsDelegate, UISearchBarDelegate>

@property (nonatomic, strong) TopBarView *topBarView;
@property (nonatomic, strong) AVCaptureDevice *device;
@property (nonatomic, strong) AVCaptureDeviceInput *input;
@property (nonatomic, strong) AVCaptureMetadataOutput *output;
@property (nonatomic, strong) AVCaptureSession *session;
@property (nonatomic, strong) AVCaptureVideoPreviewLayer *preview;
@property (nonatomic, strong) UIView *tempView;
@property (nonatomic, strong) NSString *searchSting;

@end


@implementation BassViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.topBarView = [[TopBarView alloc] initWithFrame:(CGRectMake(0, 0, kScreenWidth, 64))];
    [self.view addSubview:self.topBarView];
    
    [self.topBarView.scanFunBtn addTarget:self action:@selector(scanFunctionAction) forControlEvents:(UIControlEventTouchUpInside)];
    [self.topBarView.localCountryBtn addTarget:self action:@selector(chooseCountryAction) forControlEvents:(UIControlEventTouchUpOutside)];
    self.topBarView.seachBar.delegate = self;
    
}

- (void)chooseCountryAction {
    //选择城市
    
}

- (void)scanFunctionAction {
    [self setupCamera];
}

- (void)setupCamera
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        // 耗时的操作
        // Device
        _device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
        
        // Input
        _input = [AVCaptureDeviceInput deviceInputWithDevice:self.device error:nil];
        
        // Output
        _output = [[AVCaptureMetadataOutput alloc]init];
        //    [_output setMetadataObjectsDelegate:self queue:dispatch_get_main_queue()];
        [_output setMetadataObjectsDelegate:self queue:dispatch_get_main_queue()];
        
        // Session
        _session = [[AVCaptureSession alloc]init];
        [_session setSessionPreset:AVCaptureSessionPresetHigh];
        if ([_session canAddInput:self.input])
        {
            [_session addInput:self.input];
        }
        
        if ([_session canAddOutput:self.output])
        {
            [_session addOutput:self.output];
        }
        
        // 条码类型 AVMetadataObjectTypeQRCode
        _output.metadataObjectTypes =@[AVMetadataObjectTypeQRCode];
        dispatch_async(dispatch_get_main_queue(), ^{
            // 更新界面
            // Preview
            _preview =[AVCaptureVideoPreviewLayer layerWithSession:self.session];
            _preview.videoGravity = AVLayerVideoGravityResizeAspectFill;
            _preview.frame =CGRectMake((kScreenWidth - 280) / 2,(kScreenHeight - 280) / 2,280,280);
            _tempView = [[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds];
            _tempView.backgroundColor = [UIColor blackColor];
            UIButton *backBtn = [UIButton buttonWithType:(UIButtonTypeCustom)];
            backBtn.frame = CGRectMake(20, 20, 32, 32);
            backBtn.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"back"]];
            [backBtn addTarget:self action:@selector(backAction) forControlEvents:(UIControlEventTouchUpInside)];
            [_tempView addSubview:backBtn];
            [_tempView.layer insertSublayer:self.preview atIndex:0];
            [self.view addSubview:_tempView];
            self.tabBarController.tabBar.hidden = YES;
            // Start
            [_session startRunning];
        });
    });
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    
    NSLog(@"%@", searchBar.text);
    [searchBar resignFirstResponder];
    ZPClassificationDetailsViewModel *viewModel = [[ZPClassificationDetailsViewModel alloc] init];
    [viewModel setBlockWithReturnValueBlock:^(id returnValue) {
        
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
        ZPGoodsListViewController *goodsListVC = [storyboard instantiateViewControllerWithIdentifier:@"GoodsListVCIdentityID"];
        goodsListVC.dataArray = returnValue;
        [self.navigationController pushViewController:goodsListVC animated:NO];
        
    } withErrorBlock:^(id errorCode) {
        
    } withFailureBlock:^{
        
    }];
    [viewModel getClassificationListDetailsWithName:searchBar.text];
    
}

- (void)backAction {
    [self.tempView removeFromSuperview];
    self.tabBarController.tabBar.hidden = NO;
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    if (_session && ![_session isRunning]) {
        [_session startRunning];
    }
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}

- (void)captureOutput:(AVCaptureOutput *)captureOutput didOutputMetadataObjects:(NSArray *)metadataObjects fromConnection:(AVCaptureConnection *)connection
{
    
    NSString *stringValue;
    
    if ([metadataObjects count] >0)
    {
        AVMetadataMachineReadableCodeObject * metadataObject = [metadataObjects objectAtIndex:0];
        stringValue = metadataObject.stringValue;
    }
    
    [_session stopRunning];
    if ([stringValue containsString:@"http://www.jvawa.com"]) {
        //是本网站
        NSString *ID = [[stringValue componentsSeparatedByString:@"="] lastObject];
        ZPHomePageViewModel *viewModel = [[ZPHomePageViewModel alloc] init];
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        hud.detailsLabel.text = @"Loading...";
        [viewModel setBlockWithReturnValueBlock:^(id returnValue) {
            ZPLog(@"%@", returnValue);
            UIStoryboard *storyBoard = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
            ZPGoodsDetailInfoViewController *detailVC = [storyBoard instantiateViewControllerWithIdentifier:@"GoodsDetailInfoViewControllerIdentity"];
            detailVC.goodsInfo = returnValue;
            self.tabBarController.tabBar.hidden = NO;
            [self.navigationController pushViewController:detailVC animated:NO];
            hud.hidden = YES;
        } withErrorBlock:^(id errorCode) {
            
        } withFailureBlock:^{
            
        }];
        [viewModel getGoodsDetailWithGoodsId:ID];
        [self.tempView removeFromSuperview];
        self.tabBarController.tabBar.hidden = NO;
    }else {
        //不是本网站
    }
    NSLog(@"%@",stringValue);
    
}

@end
