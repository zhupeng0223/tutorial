//
//  ZPStoresInfo.h
//  ZPJawaMall
//
//  Created by zhupeng on 16/9/28.
//  Copyright © 2016年 朱鹏. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZPStoresInfoView : UIView<UITableViewDelegate, UITableViewDataSource>

@property (strong, nonatomic) IBOutlet UIButton *selectedCityBtn;
@property (strong, nonatomic) IBOutlet UILabel *chooseCityLabel;
@property (strong, nonatomic) IBOutlet UIButton *backBtn;
@property (strong, nonatomic) IBOutlet UITableView *infoTableView;

@property (nonatomic, assign) CurrentStoreInfoType currentType;
@property (nonatomic, copy) NSString *currentCity;

- (instancetype)initWithFrame:(CGRect)frame City:(NSString *)city type:(CurrentStoreInfoType)type;

@end
