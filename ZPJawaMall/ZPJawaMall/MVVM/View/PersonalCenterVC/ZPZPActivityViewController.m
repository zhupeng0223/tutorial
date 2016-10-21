//
//  ZPZPActivityViewController.m
//  ZPJawaMall
//
//  Created by zhupeng on 16/9/22.
//  Copyright © 2016年 朱鹏. All rights reserved.
//

#import "ZPZPActivityViewController.h"
#import "ZPActivityTableViewCell.h"
#import "ZPPersonViewModel.h"
#import "ZPActivityHeaderView.h"

@interface ZPZPActivityViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSMutableDictionary *dataDictionary;

@end

@implementation ZPZPActivityViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.tableFooterView = [[UIView alloc] init];
    self.dataDictionary = [NSMutableDictionary dictionary];
    ZPPersonViewModel *viewModel = [[ZPPersonViewModel alloc] init];
    [viewModel setBlockWithReturnValueBlock:^(id returnValue) {
        self.dataDictionary = [NSMutableDictionary dictionaryWithDictionary:returnValue];
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.tableView reloadData];
        });
        
    } withErrorBlock:^(id errorCode) {
        
    } withFailureBlock:^{
        
    }];
    
    [viewModel getActivityInfo];
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return ((NSArray *)self.dataDictionary[@"new"]).count;
    }else {
        return ((NSArray *)self.dataDictionary[@"old"]).count;
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 220;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    ZPActivityTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ZPActivityTableViewCellIdentifier"];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"ZPActivityTableViewCell" owner:nil options:nil] lastObject];
    }
    if (((NSArray *)self.dataDictionary[@"new"]).count > 0) {
        if (indexPath.section == 0) {
            cell.activity = ((NSArray *)self.dataDictionary[@"new"])[indexPath.row];
        }else if (indexPath.section == 1) {
            cell.activity = ((NSArray *)self.dataDictionary[@"old"])[indexPath.row];
        }
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.layer.cornerRadius = 10;
    cell.layer.masksToBounds = YES;
    return cell;
}


- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 30;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    ZPActivityHeaderView *headerView = [[ZPActivityHeaderView alloc] initWithFrame:(CGRectMake(0, 0, kScreenWidth, 30))];
    if (section == 0) {
        [headerView setRed];
    }else {
        [headerView setGray];
    }
    return headerView;
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
