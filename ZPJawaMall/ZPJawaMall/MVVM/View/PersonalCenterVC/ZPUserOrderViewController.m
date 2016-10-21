//
//  ZPUserOrderViewController.m
//  ZPJawaMall
//
//  Created by zhupeng on 16/9/22.
//  Copyright © 2016年 朱鹏. All rights reserved.
//

#import "ZPUserOrderViewController.h"
#import "ZPPersonViewModel.h"

@interface ZPUserOrderViewController ()

@property (strong, nonatomic) IBOutlet UISegmentedControl *segment;

@end

@implementation ZPUserOrderViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.segment.tintColor = [UIColor clearColor];
    NSDictionary *selectedAttributes = @{NSFontAttributeName:[UIFont systemFontOfSize:16], NSForegroundColorAttributeName: [UIColor redColor]};
    [self.segment setTitleTextAttributes:selectedAttributes forState:(UIControlStateSelected)];
    NSDictionary *unselectedAttributes = @{NSFontAttributeName:[UIFont systemFontOfSize:16], NSForegroundColorAttributeName:[UIColor grayColor]};
    [self.segment setTitleTextAttributes:unselectedAttributes forState:(UIControlStateNormal)];
    
    ZPPersonViewModel *viewModel = [[ZPPersonViewModel alloc] init];
    [viewModel setBlockWithReturnValueBlock:^(id returnValue) {
        
        
        
    } withErrorBlock:^(id errorCode) {
        
    } withFailureBlock:^{
        
    }];
    [viewModel getUserOrderWithUID:self.uid];
    
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
