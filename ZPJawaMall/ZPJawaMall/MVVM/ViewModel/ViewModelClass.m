//
//  ViewModelClass.m
//  ZPJawaMall
//
//  Created by zhupeng on 16/8/29.
//  Copyright © 2016年 朱鹏. All rights reserved.
//

#import "ViewModelClass.h"

@implementation ViewModelClass

- (void)setBannerBlockWithReturnValueBlock:(ReturnValueBlock)returnBlock withErrorBlock:(ErrorCodeBlock)errorBlock withFailureBlock:(FailureBlock)failureBlock {
    _bannerReturnBlock = returnBlock;
    _bannerErrorBlock = errorBlock;
    _bannerFailureBlock = failureBlock;
}

- (void)setHomePageGoodsBlockWithReturnValueBlock:(ReturnValueBlock)returnBlock withErrorBlock:(ErrorCodeBlock)errorBlock withFailureBlock:(FailureBlock)failureBlock {
    _homePageGoodsReturnBlock = returnBlock;
    _homePageGoodsErrorBlock = errorBlock;
    _homePageGoodsFailureBlock = failureBlock;
}

- (void)setHotHomePageGoodsBlockWithReturnValueBlock:(ReturnValueBlock)returnBlock withErrorBlock:(ErrorCodeBlock)errorBlock withFailureBlock:(FailureBlock)failureBlock {
    _hotHomePageGoodsReturnBlock = returnBlock;
    _hotHomePageGoodsErrorBlock = errorBlock;
    _hotHomePageGoodsFailureBlock = failureBlock;
}

- (void)setClassificationGoodsBlockWithReturnValueBlock:(ReturnValueBlock)returnBlock withErrorBlock:(ErrorCodeBlock)errorBlock withFailureBlock:(FailureBlock)failureBlock {
    _classificationReturnBlock = returnBlock;
    _classificationErrorBlock = errorBlock;
    _classificationFailureBlock = failureBlock;
}

- (void)setLoginBlockWithReturnValueBlock:(ReturnValueBlock)returnBlock withErrorBlock:(ErrorCodeBlock)errorBlock withFailureBlock:(FailureBlock)failureBlock {
    _loginReturnBlock = returnBlock;
    _loginErrorBlock = errorBlock;
    _loginFailureBlock = failureBlock;
}

- (void)setBlockWithReturnValueBlock:(ReturnValueBlock)returnBlock withErrorBlock:(ErrorCodeBlock)errorBlock withFailureBlock:(FailureBlock)failureBlock {
    _returnBlock = returnBlock;
    _errorBlock = errorBlock;
    _failureBlock = failureBlock;
}

- (void)setBlockWithSendIdentifyCodeReturnValueBlock:(ReturnValueBlock)returnBlock withErrorBlock:(ErrorCodeBlock)errorBlock withFailureBlock:(FailureBlock)failureBlock {
    _sendIdentifyCodeReturnBlock = returnBlock;
    _sendIdentifyCodeErrorBlock = errorBlock;
    _sendIdentifyCodeFailureBlock = failureBlock;
}

@end
