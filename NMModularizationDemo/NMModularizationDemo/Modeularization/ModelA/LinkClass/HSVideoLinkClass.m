//
//  HSVideoLinkClass.m
//  NMModularizationDemo
//
//  Created by 糯米 on 2018/5/20.
//  Copyright © 2018年 nuomi. All rights reserved.
//

#import "HSVideoLinkClass.h"

@implementation HSVideoLinkClass
#pragma mark - 提供方法

#pragma mark - 索取方法
/**
 获取视频分类页面
 */
- (UIViewController *)getVideoController{
    __block UIViewController * controller = nil;
    [self hsObjectMethodClassName:@"NMVideoPlugInLinkClasss" performSelectorStr:@"getVideoController" param:nil block:^(id retunValue, BOOL performSuccess, BOOL classIsLoad) {
        if (retunValue) {
            controller = retunValue;
        }
    }];
    return controller;
    
}
@end
