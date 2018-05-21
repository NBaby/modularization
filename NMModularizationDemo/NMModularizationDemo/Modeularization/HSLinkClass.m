//
//  HSLinkClass.m
//  HiStor
//
//  Created by panzihao on 2018/5/15.
//  Copyright © 2018年 彭惠珍. All rights reserved.
//

#import "HSLinkClass.h"
#import "objc/runtime.h"
@implementation HSLinkClass

/**
 初始方法
 
 */
+ (instancetype)shareObject{
    return [[self alloc] init];
}

/**
 调用对象方法
 
 @param className 类名
 @param selectStr 方法名
 @param params 参数字典
 @param block 回调函数
 */
- (void)hsObjectMethodClassName:(NSString *)className performSelectorStr:(NSString *)selectStr param:(id)params block:(plugInCallBackblock)block{
    
    Class classObj = NSClassFromString(className);
    if (classObj == nil) {
        if (block) {
            block(nil,NO,NO);
        }
    }
    
    id object = [[classObj alloc] init];
    if ([object respondsToSelector:NSSelectorFromString(selectStr)]) {
        id returnValue = nil;
        if (params != nil) {
            returnValue = [object performSelector:NSSelectorFromString(selectStr) withObject:params];
            if (block) {
                block(returnValue,YES,YES);
            }
        }
        else {
            returnValue = [object performSelector:NSSelectorFromString(selectStr)];
            if (block) {
                block(returnValue,YES,YES);
            }
        }
    }
    else {
        if (block) {
            block(nil,NO,YES);
        }
    }
    
}


/**
 调用类方法
 
 @param className 类名
 @param selectStr 方法名
 @param params 参数字典
 @param block 回调函数
 */
- (void)hsClassMethodClassName:(NSString *)className performSelectorStr:(NSString *)selectStr param:(NSDictionary *)params block:(plugInCallBackblock)block{
    Class classObj = NSClassFromString(className);
    if (classObj == nil) {
        if (block) {
            block(nil,NO,NO);
        }
    }
    if ([classObj respondsToSelector:NSSelectorFromString(selectStr)]) {
        id returnValue = nil;
        if (params != nil) {
            returnValue = [classObj performSelector:NSSelectorFromString(selectStr) withObject:params];
            if (block) {
                block(returnValue,YES,YES);
            }
        }
        else {
            returnValue = [classObj performSelector:NSSelectorFromString(selectStr)];
            if (block) {
                block(returnValue,YES,YES);
            }
        }
    }
    else {
        if (block) {
            block(nil,NO,YES);
        }
    }
}
@end
