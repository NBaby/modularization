#IOS组件化方案

##前言
***
应用在逐步迭代中，代码体积越来越大。现有的工程代码虽然已经按照模块分门别类存放，但是其引用文件还是很随意，代码间的耦合性高，使得代码“牵一发而动全身”，使开发人员对源代码的维护带来极大的不便。因此，为了今后更好的增删和重用代码，需要将各个业务逻辑拆分，实现组件化。

demo地址：[demo地址](https://github.com/NBaby/modularization/new/master)
##组件化简介
***
组件化就是将各个业务逻辑代码或者功能代码拆分出来，形成独立的一部分。组件化的最初目的是代码重用，比如一个弹窗提示功能会在很多项目很多页面调用，它的样式相对固定，使用频率高，因此可以提取出来作为一个组件，其他项目只要引用该组件就能在自己的页面中调用，这样可以减少大量的重复代码。其特点是高内聚，即脱离掉主工程代码也能编译通过，低耦合，从主工程中剥离简单容易。

##组件化方案
***
###基本概念
组件化应当是可以完全剥离出主程序，并可以独立编译通过并且运行，但是实际项目中，特别是没有组件化架构的项目想要中途将业务逻辑拆分出来还是有一定困难。因此在方案上我进行了调整，允许初期组件化各个组件对主程序有依赖，如下图所示：
![业务逻辑](/Users/nuomi/Desktop/经验案例/图片/业务逻辑.png)

总结下方案设计大致有如下要求：

* 各个组件可以脱离主程序独立成块并编译，但允许存在少量依赖。
* 主程序脱离各个组件可以独立运行，对组件没有依赖。

##组件化实现
***
###采用静态库脱离主程序
网络上有很多组件化的方法，经过多次尝试，发现都有一定弊端，而且适合新项目，对已有项目不友好。最后，我采取静态库加工程组的方式进行组件化。

所谓工程组，就是将多个项目工程关联到一起，由`.xcworkspace`文件管理。常用的cocoaPods就是用这种形式。

![工程管理](/Users/nuomi/Desktop/经验案例/图片/工程管理.png)

建多个项目文件的好处是可以将组建的代码和主程序代码完全剥离开来，做到高内聚的特点。

下面我将演示如何创建一个静态库工程。

1、在文件夹中创建新项目
![创建静态库](/Users/nuomi/Desktop/经验案例/图片/创建静态库1.png)

2、创建项目的时候选取项目组
![选取项目组](/Users/nuomi/Desktop/经验案例/图片/选择项目组.png)

3、静态库项目中将编译格式切换成`static Library`
![选择编译模式](/Users/nuomi/Desktop/经验案例/图片/选择编译模式.png)

4、创建资源文件`target`
![创建资源文件](/Users/nuomi/Desktop/经验案例/图片/创建资源文件.png)

![创建资源文件2](/Users/nuomi/Desktop/经验案例/图片/创建资源文件2.png)

![创建资源文件3](/Users/nuomi/Desktop/经验案例/图片/创建资源文件3.png)

![修改资源文件属性](/Users/nuomi/Desktop/经验案例/图片/修改资源文件属性.png)

5、将静态包引入主工程，并设置先后编译顺序

![5关联静态库](/Users/nuomi/Desktop/经验案例/图片/5关联静态库.png)

![关联静态库2](/Users/nuomi/Desktop/经验案例/图片/关联静态库2.png)





按照以上方法配置，一个组件化就完成，后续可以在`NMModelA.xcodeproj`中编写组件代码。`NMModelAResource` targets主要是为了存放一些资源文件，比如图片资源、xib编译后的nib文件。**每次改动图片或者xib都需要把新新生成的资源文件替换掉主程序中的资源文件** 过程如下图所示：

![将变动的资源文件复制到主工程](/Users/nuomi/Desktop/经验案例/图片/将变动的资源文件复制到主工程.png)

**每次添加新资源文件或者新建xib记得从`NMModelA` target删除，添加到 `NMModelAResource`中，否则实际包会生成2份或多份图片，造成包大小变大**

![删除图片](/Users/nuomi/Desktop/经验案例/图片/删除图片.png)

![添加图片](/Users/nuomi/Desktop/经验案例/图片/添加图片.png)

使用静态库加工程组的方式的好处：

* **高内聚，低耦合**

由于工程的限制，主程序的代码无法直接引用各个组件的代码，组件中的代码也无法直接引用主程序，真正实现了组件化的概念。

* **编译调试方便**

在验证组件化功能的时候可以直接编译主程序，在组件工程里下断点，就像编译一个程序一样，简单方便。

* **静态库只需要.h不需要.m就能编译**

前面我们说到，一些没有组件化架构的项目想要完全去除依赖非常困难，因此组件化程序往往需要引用主程序的头文件。使用静态库可以很好解决该问题，只要在静态库中添加需要引用的.h文件，而不用添加.m文件就能编译通过，并打成静态包，可以作为临时过渡期的方法。该方案同样适用于解决库冲突问题。

* **图片资源、本地化文件与主程序共用**

将图片资源、本地化文件添加到主程序中，可以实现本地化、图片资源共用。

* **完成组件代码测试后可以打成.framework包引入工程**

静态库文件不会暴露源代码，因此可以大大减少编程人员误修改组件代码，导致出错的问题。

##组件与主程序之间的交互
***
既然组件代码与主程序不能直接交互，那么怎么做到一些常用操作，比如界面跳转呢？
答案是`RunTime`。object使用runTime可以很好解决耦合问题，甚至做到不变动代码，删除组件，主程序成功编译并且不崩溃的神奇效果。以下是总体设计思想：
![设计思路](/Users/nuomi/Desktop/经验案例/图片/总体设计思路.png)

* 主程序和组件代码只能通过各自的接口文件获取数据

* 接口程序间通过runtime调用方法

* 由于runtime performSelector方法的参数个数限制和回调类型限制，这里规定接口最终回调类型必须是对象，参数传id,多个参数用NSDictionary封装传递

这里我创建了一个接口基本类`HSLinkClass`，所有的接口都是继承自该类，主要提供了对象方法和类方法的调用。

.h文件

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

.m文件

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

通过Runtime可以判断该模块是否加载，在基本类中做了多种情况保护防止其崩溃。

主程序和组件程序都需要新建一个`HSLinkClass`的子类作为接口，也称之为中间层，分别提供**索取方法**和**供应方法**。组件的索取方法就是主程序的供应方法，反之也一样。

下面是主程序跳转到视频扥类页面的例子：

主程序接口代码：
![索取方法](/Users/nuomi/Desktop/经验案例/图片/索取方法.png)

组件接口代码：
![提供方法](/Users/nuomi/Desktop/经验案例/图片/提供方法.png)

主程序代码：
![主程序代码](/Users/nuomi/Desktop/经验案例/图片/主程序代码.png)

#建议以及优化
***
* 每次xib变动或者添加图片都得手动复制到主程序中去十分麻烦，这里可以学习cocoapods的做法，写一个脚本放到Build Phases中，可以减少不少操作

* 接口基类目前只是实现了基本方法用runtime调用，还有很大的提升空间，比如增加属性判断组件是否加载

#总结
***

组件化的确会增加一定工作量，原来#import一个文件就能解决的事，现在需要多好几步操作。不过，也正是因为之前的随意，导致后续代码功能变更，牵一发而动全身，痛苦万分。吃苦在前，享乐在后才是正确的工作态度。



