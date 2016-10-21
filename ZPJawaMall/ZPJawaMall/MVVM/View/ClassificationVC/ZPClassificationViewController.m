//
//  ZPClassificationViewController.m
//  ZPJawaMall
//
//  Created by zhupeng on 16/8/29.
//  Copyright © 2016年 朱鹏. All rights reserved.
//

#import "ZPClassificationViewController.h"
#import "ZPClassificationViewModel.h"
#import "ZPClassTitleCollectionViewCell.h"
#import "ZPClassificationDetailsCollectionViewCell.h"
#import "ZPClassTitle.h"
#import "GoodsList.h"
#import "ZPClassificationDetailsViewModel.h"
#import "ZPGoodsDetailInfoViewController.h"

@interface ZPClassificationViewController ()<UICollectionViewDelegate, UICollectionViewDataSource>

@property (strong, nonatomic) IBOutlet UICollectionView *leftCollectionView;
@property (strong, nonatomic) IBOutlet UICollectionView *rightCollectionView;
@property (nonatomic, strong) NSMutableArray *classTitleArray;
@property (nonatomic, strong) NSMutableArray *classArray;
@property (nonatomic, strong) NSIndexPath *currentIndexPath;
@property (nonatomic, strong) NSMutableArray *heightArray;
@property (nonatomic, strong) NSMutableArray *goodsListArray;
@property (nonatomic, assign) BOOL isHeightLight;
@property (nonatomic, strong) MBProgressHUD *hud;

@end

@implementation ZPClassificationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.classTitleArray = [NSMutableArray array];
    self.classArray = [NSMutableArray array];
    self.heightArray = [NSMutableArray array];
    self.goodsListArray = [NSMutableArray array];
    self.currentIndexPath = [NSIndexPath indexPathForItem:1 inSection:0];
    
    [self loadCollectionView];
    
    self.hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    self.hud.detailsLabel.text = @"Loading...";
    
    ZPClassificationViewModel *classificationVM = [[ZPClassificationViewModel alloc] init];
    [classificationVM setClassificationGoodsBlockWithReturnValueBlock:^(id returnValue) {
        //
        [self handleValue:returnValue];
    } withErrorBlock:^(id errorCode) {
        
    } withFailureBlock:^{
        
    }];
    [classificationVM loadClassificationInfo];
    
    
    //rightCollectionView刷新
    ZPClassificationDetailsViewModel *viewModel = [[ZPClassificationDetailsViewModel alloc] init];
    [viewModel setBlockWithReturnValueBlock:^(id returnValue) {
        
        ZPLog(@"%@", returnValue);
        self.goodsListArray = returnValue;
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.rightCollectionView reloadData];
            [self hidenHUD];
        });
    } withErrorBlock:^(id errorCode) {
        
    } withFailureBlock:^{
        
    }];
    [viewModel getClassificationListDetailsWithName:@"小康美厨"];
    
}

static NSInteger classificationActivity = 0;
- (void)hidenHUD {
    classificationActivity++;
    if (classificationActivity == 2) {
        [self.hud hideAnimated:YES];
        classificationActivity = 0;
    }
}

- (void)handleValue:(NSArray *)arr {
    
    NSMutableArray *tempArr = [NSMutableArray array];
    
    for (NSDictionary *dic in arr) {
        ZPClassTitle *classTitle = [[ZPClassTitle alloc] init];
        [classTitle setValuesForKeysWithDictionary:dic];
        if (classTitle.parentid == 0) {
            [self.classTitleArray addObject:classTitle];
        }else {
            [tempArr addObject:classTitle];
        }
    }
    for (ZPClassTitle *class in self.classTitleArray) {
        NSMutableArray *array = [NSMutableArray array];
        for (ZPClassTitle *classTitle in tempArr) {
            if (class.ID == classTitle.parentid) {
                [array addObject:classTitle];
            }
        }
        NSDictionary *result = @{class.name : array};
        [self.classArray addObject:result];
    }
    [self.leftCollectionView reloadData];
    [self hidenHUD];
}

- (void)loadCollectionView {
    
    UICollectionViewFlowLayout *leftFlowLayout = [[UICollectionViewFlowLayout alloc] init];
    leftFlowLayout.itemSize = CGSizeMake(100, 30);
    leftFlowLayout.sectionInset = UIEdgeInsetsMake(1, 0, 1, 0);
    leftFlowLayout.minimumLineSpacing = 1;
    self.leftCollectionView.collectionViewLayout = leftFlowLayout;
    self.leftCollectionView.delegate = self;
    self.leftCollectionView.dataSource = self;
    self.leftCollectionView.tag = 1000;
    [self.leftCollectionView registerClass:[ZPClassTitleCollectionViewCell class] forCellWithReuseIdentifier:@"leftCell"];
    [self.leftCollectionView registerNib:[UINib nibWithNibName:@"ZPClassTitleCollectionViewCell" bundle:[NSBundle mainBundle]] forCellWithReuseIdentifier:@"leftCell"];
    
    UICollectionViewFlowLayout *rightFlowLayout = [[UICollectionViewFlowLayout alloc] init];
    rightFlowLayout.itemSize = CGSizeMake(kScreenWidth - 140, 200);
    rightFlowLayout.sectionInset = UIEdgeInsetsMake(20, 20, 20, 20);
    self.rightCollectionView.collectionViewLayout = rightFlowLayout;
    self.rightCollectionView.delegate = self;
    self.rightCollectionView.dataSource = self;
    self.rightCollectionView.tag = 1001;
    [self.rightCollectionView registerNib:[UINib nibWithNibName:@"ZPClassificationDetailsCollectionViewCell" bundle:[NSBundle mainBundle]] forCellWithReuseIdentifier:@"rightCell"];
}

#pragma mark-- UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    if (collectionView.tag == 1000) {
        if (self.currentIndexPath.section == section) {
            if (self.classTitleArray.count > 0) {
                NSString *name = ((ZPClassTitle *)self.classTitleArray[self.currentIndexPath.section]).name;
                NSDictionary *dic = self.classArray[self.currentIndexPath.section];
                NSArray *tempArr = dic[name];
                return tempArr.count + 1;
            }
        }
    }else if (collectionView.tag == 1001) {
        return self.goodsListArray.count;
    }
    return 1;
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    if (collectionView.tag == 1000) {
        return self.classTitleArray.count;
    }else if (collectionView.tag == 1001) {
        return 1;
    }
    return 0;
}

// The cell that is returned must be retrieved from a call to -dequeueReusableCellWithReuseIdentifier:forIndexPath:
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewCell *cell = nil;
    if (collectionView.tag == 1000) {
        ZPClassTitleCollectionViewCell *cell1 = [collectionView dequeueReusableCellWithReuseIdentifier:@"leftCell" forIndexPath:indexPath];
        if (indexPath.section == self.currentIndexPath.section && indexPath.item != 0) {
            cell1.classView.hidden = NO;
            NSString *name = ((ZPClassTitle *)self.classTitleArray[self.currentIndexPath.section]).name;
            NSDictionary *dic = self.classArray[indexPath.section];
            NSArray *tempArr = dic[name];
            cell1.classNameLabel.text = ((ZPClassTitle *)tempArr[indexPath.item - 1]).name;
            if (self.currentIndexPath.item == indexPath.item) {
                cell1.classRedView.hidden = NO;
                cell1.classView.backgroundColor = [UIColor clearColor];
                cell1.backgroundColor = [UIColor clearColor];
                [cell1 setClassTitleViewHidden:YES];
            }else {
                cell1.classRedView.hidden = YES;
                cell1.classView.backgroundColor = kLightGrayColor;
                cell1.backgroundColor = [UIColor grayColor];
            }
            [self.heightArray addObject:[NSNumber numberWithInt:30]];
        }else {
            if (indexPath.section == self.currentIndexPath.section && indexPath.item == 0) {
                cell1.rightIconImageView.image = [UIImage imageNamed:@"drop_down_Icon"];
            }else {
                cell1.rightIconImageView.image = [UIImage imageNamed:@"right_down"];
            }
            
            if (((ZPClassTitle *)self.classTitleArray[indexPath.item]).name.length > 0) {
                [cell1 setClassTitleViewHidden:NO];
                cell1.classView.hidden = YES;
                cell1.titleLabel.text = ((ZPClassTitle *)self.classTitleArray[indexPath.section]).name;
                cell1.backgroundColor = [UIColor colorWithRed:255.0 / 255 green:102.0 / 255 blue:102.0 / 255 alpha:1];
            }
            [self.heightArray addObject:[NSNumber numberWithInt:50]];
        }
        
        return cell1;
    }else if (collectionView.tag == 1001) {
        ZPClassificationDetailsCollectionViewCell *cell2 = [collectionView dequeueReusableCellWithReuseIdentifier:@"rightCell" forIndexPath:indexPath];
        cell2.backgroundColor = kLightGrayColor;
        if (self.goodsListArray.count > 0) {
            cell2.goodsList = self.goodsListArray[indexPath.item];
        }
        cell2.layer.cornerRadius = 8;
        cell2.layer.masksToBounds = YES;
        return cell2;
    }
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath  {
    if (collectionView.tag == 1000) {
        if (self.classTitleArray.count > 0) {
            NSString *name = ((ZPClassTitle *)self.classTitleArray[indexPath.section]).name;
            if (indexPath.item == 0) {
                NSDictionary *dic = @{NSFontAttributeName:[UIFont systemFontOfSize:15]};
                CGRect rect = [name boundingRectWithSize:(CGSizeMake(100, 10000)) options:NSStringDrawingUsesLineFragmentOrigin attributes:dic context:nil];
                if (rect.size.height < 10) {
                    return CGSizeMake(100, 30);
                }else {
                    return CGSizeMake(100, rect.size.height + 20);
                }
            }else {
                NSDictionary *dic = self.classArray[indexPath.section];
                NSArray *tempArr = dic[name];
                NSString *name2 = ((ZPClassTitle *)tempArr[indexPath.item - 1]).name;
                NSDictionary *dic2 = @{NSFontAttributeName:[UIFont systemFontOfSize:15]};
                CGRect rect = [name2 boundingRectWithSize:(CGSizeMake(100, 10000)) options:NSStringDrawingUsesLineFragmentOrigin attributes:dic2 context:nil];
                if (rect.size.height < 20) {
                    return CGSizeMake(100, 30);
                }else {
                    return CGSizeMake(100, rect.size.height + 10);
                }
            }
        }
    }else if (collectionView.tag == 1001) {
        return CGSizeMake(kScreenWidth - 140, 200);
    }
    return CGSizeMake(100, 30);
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    if (collectionView.tag == 1000) {
        //leftCollectionView刷新
        self.currentIndexPath = indexPath;
        
        [self.leftCollectionView reloadData];
        
        if (indexPath.item != 0) {            
            //rightCollectionView刷新
            ZPClassificationDetailsViewModel *viewModel = [[ZPClassificationDetailsViewModel alloc] init];
            [viewModel setBlockWithReturnValueBlock:^(id returnValue) {
                
                ZPLog(@"%@", returnValue);
                self.goodsListArray = returnValue;
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self.rightCollectionView reloadData];
                });
            } withErrorBlock:^(id errorCode) {
                
            } withFailureBlock:^{
                
            }];
            NSString *name = ((ZPClassTitle *)self.classTitleArray[self.currentIndexPath.section]).name;
            NSDictionary *dic = self.classArray[indexPath.section];
            NSArray *tempArr = dic[name];
            NSString *key = ((ZPClassTitle *)tempArr[indexPath.item - 1]).name;
            ZPLog(@"%@", key);
            [viewModel getClassificationListDetailsWithName:key];
        }
    }else if (collectionView.tag == 1001) {
        
        ZPClassificationDetailsViewModel *viewModel = [[ZPClassificationDetailsViewModel alloc] init];
        
        [viewModel setClassificationGoodsBlockWithReturnValueBlock:^(id returnValue) {
            
            UIStoryboard *storyBoard = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
            ZPGoodsDetailInfoViewController *detailVC = [storyBoard instantiateViewControllerWithIdentifier:@"GoodsDetailInfoViewControllerIdentity"];
            detailVC.goodsInfo = returnValue;
            [self.navigationController pushViewController:detailVC animated:NO];
            
        } withErrorBlock:^(id errorCode) {
            
        } withFailureBlock:^{
            
        }];
        NSString *key = ((GoodsList *)self.goodsListArray[0]).ID;
        [viewModel getClassificationListDetailsWithId:key];
        
    }
    
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
