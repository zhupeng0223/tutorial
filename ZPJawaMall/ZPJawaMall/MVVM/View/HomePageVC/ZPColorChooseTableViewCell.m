//
//  ZPColorChooseTableViewCell.m
//  ZPJawaMall
//
//  Created by zhupeng on 16/9/12.
//  Copyright © 2016年 朱鹏. All rights reserved.
//

#import "ZPColorChooseTableViewCell.h"
#import "ZPColorChooseCollectionViewCell.h"
#import "Color.h"
#import "Taimian.h"
#import "Door.h"

@interface ZPColorChooseTableViewCell ()<UICollectionViewDelegate, UICollectionViewDataSource>

@property (strong, nonatomic) IBOutlet UICollectionView *collectionView;
@property (strong, nonatomic) IBOutlet UILabel *isChooseInfoLabel;


@end

@implementation ZPColorChooseTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
    //87
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    flowLayout.itemSize = CGSizeMake(35, 50);
    flowLayout.sectionInset = UIEdgeInsetsMake(5, 5, 5, 5);
    
    [self.collectionView setCollectionViewLayout:flowLayout];
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
//    self.collectionView.contentSize = CGSizeMake(0, (self.Array.count / 6 + 1) * 50 + 10);
    self.collectionView.backgroundColor = [UIColor whiteColor];
    [self.collectionView registerNib:[UINib nibWithNibName:@"ZPColorChooseCollectionViewCell" bundle:[NSBundle mainBundle]] forCellWithReuseIdentifier:@"ZPColorChooseCollectionViewCellIdentifier"];
    
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.Array.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    ZPColorChooseCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"ZPColorChooseCollectionViewCellIdentifier" forIndexPath:indexPath];
    cell.indexPath = indexPath;
    if (self.Array.count > 0) {
        switch (self.type) {
            case ColorType:
                cell.color = self.Array[indexPath.item];
                break;
            case TaimianType:
                cell.taimian = self.Array[indexPath.item];
                break;
            case DoorType:
                cell.door = self.Array[indexPath.item];
                break;
                
            default:
                break;
        }
        cell.backGroundView.layer.borderWidth = 1;
        [cell clearBorderColor];
        if (indexPath.item == self.currentSelectedIndex) {
            [cell setRedBorderColor];
            if (self.type == TaimianType) {
            }
            switch (self.type) {
                case ColorType:
                    self.isChooseInfoLabel.text = [NSString stringWithFormat:@"%@/%@", ((Color *)self.Array[indexPath.item]).color, ((Color *)self.Array[indexPath.item]).cname];
                    break;
                case TaimianType:
                    self.isChooseInfoLabel.text = [NSString stringWithFormat:@"%@", ((Taimian *)self.Array[indexPath.item]).tname];
                    break;
                case DoorType:
                    self.isChooseInfoLabel.text = [NSString stringWithFormat:@"%@", ((Door *)self.Array[indexPath.item]).dname];
                    break;
                    
                default:
                    break;
            }
        }
    }
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    NSArray *cellArray = collectionView.visibleCells;
    self.currentSelectedIndex = indexPath.item;
    for (ZPColorChooseCollectionViewCell *cell in cellArray) {
        if (indexPath.item == cell.indexPath.item) {
            [cell setRedBorderColor];
        }else {
            [cell clearBorderColor];
        }
    }
    switch (self.type) {
        case ColorType:
            self.isChooseInfoLabel.text = [NSString stringWithFormat:@"%@/%@", ((Color *)self.Array[indexPath.item]).color, ((Color *)self.Array[indexPath.item]).cname];
            self.selectedColorBlock(indexPath.item);
            break;
        case TaimianType:
            self.isChooseInfoLabel.text = [NSString stringWithFormat:@"%@", ((Taimian *)self.Array[indexPath.item]).tname];
            self.selectedTaimianBlock(indexPath.item);
            break;
        case DoorType:
            self.isChooseInfoLabel.text = [NSString stringWithFormat:@"%@", ((Door *)self.Array[indexPath.item]).dname];
            self.selectedDoorBlock(indexPath.item);
            break;
            
        default:
            break;
    }
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
