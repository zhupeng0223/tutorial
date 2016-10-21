//
//  ViewModelClass.h
//  ZPJawaMall
//
//  Created by zhupeng on 16/8/29.
//  Copyright © 2016年 朱鹏. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ViewModelClass : NSObject

@property (nonatomic, strong) ReturnValueBlock returnBlock;
@property (nonatomic, strong) ErrorCodeBlock errorBlock;
@property (nonatomic, strong) FailureBlock failureBlock;

@property (nonatomic, strong) ReturnValueBlock bannerReturnBlock;
@property (nonatomic, strong) ErrorCodeBlock bannerErrorBlock;
@property (nonatomic, strong) FailureBlock bannerFailureBlock;

@property (nonatomic, strong) ReturnValueBlock homePageGoodsReturnBlock;
@property (nonatomic, strong) ErrorCodeBlock homePageGoodsErrorBlock;
@property (nonatomic, strong) FailureBlock homePageGoodsFailureBlock;

@property (nonatomic, strong) ReturnValueBlock hotHomePageGoodsReturnBlock;
@property (nonatomic, strong) ErrorCodeBlock hotHomePageGoodsErrorBlock;
@property (nonatomic, strong) FailureBlock hotHomePageGoodsFailureBlock;

@property (nonatomic, strong) ReturnValueBlock classificationReturnBlock;
@property (nonatomic, strong) ErrorCodeBlock classificationErrorBlock;
@property (nonatomic, strong) FailureBlock classificationFailureBlock;

@property (nonatomic, strong) ReturnValueBlock loginReturnBlock;
@property (nonatomic, strong) ErrorCodeBlock loginErrorBlock;
@property (nonatomic, strong) FailureBlock loginFailureBlock;

@property (nonatomic, strong) ReturnValueBlock sendIdentifyCodeReturnBlock;
@property (nonatomic, strong) ErrorCodeBlock sendIdentifyCodeErrorBlock;
@property (nonatomic, strong) FailureBlock sendIdentifyCodeFailureBlock;

- (void)setBannerBlockWithReturnValueBlock:(ReturnValueBlock)returnBlock withErrorBlock:(ErrorCodeBlock)errorBlock withFailureBlock:(FailureBlock)failureBlock;
- (void)setHomePageGoodsBlockWithReturnValueBlock:(ReturnValueBlock)returnBlock withErrorBlock:(ErrorCodeBlock)errorBlock withFailureBlock:(FailureBlock)failureBlock;
- (void)setHotHomePageGoodsBlockWithReturnValueBlock:(ReturnValueBlock)returnBlock withErrorBlock:(ErrorCodeBlock)errorBlock withFailureBlock:(FailureBlock)failureBlock;
- (void)setClassificationGoodsBlockWithReturnValueBlock:(ReturnValueBlock)returnBlock withErrorBlock:(ErrorCodeBlock)errorBlock withFailureBlock:(FailureBlock)failureBlock;
- (void)setLoginBlockWithReturnValueBlock:(ReturnValueBlock)returnBlock withErrorBlock:(ErrorCodeBlock)errorBlock withFailureBlock:(FailureBlock)failureBlock;
- (void)setBlockWithReturnValueBlock:(ReturnValueBlock)returnBlock withErrorBlock:(ErrorCodeBlock)errorBlock withFailureBlock:(FailureBlock)failureBlock;

- (void)setBlockWithSendIdentifyCodeReturnValueBlock:(ReturnValueBlock)returnBlock withErrorBlock:(ErrorCodeBlock)errorBlock withFailureBlock:(FailureBlock)failureBlock;

@end
