//
//  ZPColorChooseTableViewCell.h
//  ZPJawaMall
//
//  Created by zhupeng on 16/9/12.
//  Copyright © 2016年 朱鹏. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^SelectedDoorBlock) (NSInteger index);
typedef void (^SelectedTaimianBlock) (NSInteger index);
typedef void (^SelectedColorBlock) (NSInteger index);

@interface ZPColorChooseTableViewCell : UITableViewCell

@property (nonatomic, strong) NSArray *Array;
@property (nonatomic, assign) ColorOrTaimianType type;
@property (strong, nonatomic) IBOutlet UILabel *colorNameLabel;
@property (nonatomic, assign) NSInteger currentSelectedIndex;

@property (nonatomic, strong) SelectedDoorBlock selectedDoorBlock;
@property (nonatomic, strong) SelectedTaimianBlock selectedTaimianBlock;
@property (nonatomic, strong) SelectedColorBlock selectedColorBlock;

@end
