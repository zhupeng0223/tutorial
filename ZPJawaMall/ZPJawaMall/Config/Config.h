//
//  Config.h
//  ZPJawaMall
//
//  Created by zhupeng on 16/8/29.
//  Copyright © 2016年 朱鹏. All rights reserved.
//

#ifndef Config_h
#define Config_h

typedef void (^ReturnValueBlock) (id returnValue);
typedef void (^ErrorCodeBlock) (id errorCode);
typedef void (^FailureBlock) ();

typedef enum  {
    BnanerTypeOfHomePage,
    BnanerTypeOfDetail
}BnanerType;

typedef enum  {
    ColorType,
    TaimianType,
    DoorType
}ColorOrTaimianType;

typedef enum  {
    City_Type,
    Store_Type,
    Employees_Type
}CurrentStoreInfoType;

#define ZPLog(xx, ...)  NSLog(@"%s(%d): " xx, __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__)
#define kLoginURL @"http://192.168.1.61/test/jvawa/login.php"
#define kBannerURL @"http://192.168.1.61/test/jvawa/index_banner.php"
#define kHomePageURL @"http://192.168.1.61/test/jvawa/index_goods.php"
#define kGetPicSize @"http://192.168.1.61/test/jvawa/get_picsize.php"
#define kGoodsListURL @"http://192.168.1.61/test/jvawa/product_list.php"
#define kGetUserOrderURL @"http://192.168.1.61/test/jvawa/get_userorder_list.php"
#define kEditAddressURL @"http://192.168.1.61/test/jvawa/edit_address.php"
#define kGetAddressUrl @"http://192.168.1.61/test/jvawa/get_address.php"
#define kGetActivityURL @"http://192.168.1.61/test/jvawa/get_activity_list.php"
#define kGoodsDetailURL @"http://192.168.1.61/test/jvawa/product_detail.php"
#define kimageHeightURL @"http://192.168.1.61/test/jvawa/get_picsize.php"
#define kRegisterURL @"http://192.168.1.61/test/jvawa/register_new_user.php"
#define kVerificationCode @"http://192.168.1.61/test/jvawa/sms/register.php"
#define kRetrievePasswordVerCode @"http://192.168.1.61/test/jvawa/sms/forgetpwd.php"
#define kGetClassURL @"http://192.168.1.61/test/jvawa/get_class.php"
#define kGetStoresURL @"http://192.168.1.61/test/jvawa/get_store_info.php"
#define kGetStoreInfoURL @"http://192.168.1.61/test/jvawa/get_store_info.php"
#define kImageBassURL @"http://www.jvawa.com/"
#define kAddShoppingCart @"http://192.168.1.61/test/jvawa/add_shoppingcart.php"
#define kGetShoppingCart @"http://192.168.1.61/test/jvawa/get_shopping_cart.php"
#define kGenerateMainOrder @"http://192.168.1.61/test/jvawa/generate_main_order.php" //主件
#define kGeneratePartsOrder @"http://192.168.1.61/test/jvawa/generate_parts_order.php" //配件
#define kGenerateHomeOrder @"http://192.168.1.54/test/jvawa/generate_home_order.php" //全屋
#define kScreenWidth [UIScreen mainScreen].bounds.size.width
#define kScreenHeight [UIScreen mainScreen].bounds.size.height
#define kBannerArrayCount self.bannerArray.count
#define kBannerHeight 180
#define kGoodsTitleColor [UIColor colorWithRed:111 / 255.0 green:113 / 255.0 blue:121 / 255.0 alpha:1.0]
#define kOldPriceColor [UIColor colorWithRed:170 / 255.0 green:170 / 255.0 blue:170 / 255.0 alpha:1.0] 
#define kFooterColor [UIColor colorWithRed:179 / 255.0 green:179 / 255.0 blue:179 / 255.0 alpha:1.0]
#define kLightGrayColor [UIColor colorWithRed:204 / 255.0 green:204 / 255.0 blue:204 / 255.0 alpha:1.0]

#define IOS7_OR_LATER   ( [[[UIDevice currentDevice] systemVersion] compare:@"7.0"] != NSOrderedAscending )

#define WS(WeakSelf)  __weak __typeof(&*self)WeakSelf = self;

#endif /* Config_h */
