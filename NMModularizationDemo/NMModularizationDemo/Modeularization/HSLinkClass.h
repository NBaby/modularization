//
//  HSLinkClass.h
//  HiStor
//
//  Created by panzihao on 2018/5/15.
//  Copyright © 2018年 彭惠珍. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
/**
 回调block

 @param retunValue 该方法return 的值
 @param performSuccess 该方法是否执行成功
 @param classIsLoad 该类是否加载
 */
typedef void (^plugInCallBackblock)(id retunValue, BOOL performSuccess,BOOL classIsLoad);


@interface HSLinkClass : NSObject
/**
 调用对象方法

 @param className 类名
 @param selectStr 方法名
 @param params 参数字典
 @param block 回调函数
 */
- (void)hsObjectMethodClassName:(NSString *)className performSelectorStr:(NSString *)selectStr param:(id)params block:(plugInCallBackblock)block;


/**
 调用类方法

 @param className 类名
 @param selectStr 方法名
 @param params 参数字典
 @param block 回调函数
 */
- (void)hsClassMethodClassName:(NSString *)className performSelectorStr:(NSString *)selectStr param:(id)params block:(plugInCallBackblock)block;

/**
 初始方法
 */
+ (instancetype)shareObject;

@end
