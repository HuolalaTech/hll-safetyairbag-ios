//
//  HLLUSafeCrashProtectorManager.h
//  HLLSafetyAirBag
//
//  Created by sherwin chen on 2021/6/9.
//
/**
 *  该组件会占用一定内存，不过正常情况下不影响性能
 *  关于TryCatch相关疑问可参考apple文档： https://developer.apple.com/library/archive/documentation/Cocoa/Conceptual/Exceptions/Articles/Exceptions64Bit.html#//apple_ref/doc/uid/TP40009044-SW1
 *  >>> 性能无影响，但需要关注异常之后，内存是否存在泄漏.
 *  >>> 初使化安全气囊,根据项目的复杂程度,低端机200ms耗时，高端机40ms耗时，耗时点在方法替换/交换.
 *  HSafe +classSwizzleMethodWithClass: 2.562012
    HSafe +instanceSwizzleMethodWithClass: 2.790039
 */

#import <Foundation/Foundation.h>

/**
 监控Crash防护动作产生后，详细的Crash日志的回调.
 
 @param crashName crash的名称
 @param crashMsg crash的详细信息
 @param exception 异常堆栈详细信息
 */
typedef void(^_Nullable HLLUCrashCallBack)(NSString* _Nonnull crashName,
                                           NSString* _Nonnull crashMsg,
                                       NSException * _Nonnull exception);

/**
 crash防护管理类,负责组件的初使化工作.
 
 接入方式：
 1. HLLUSafeCrashManager
 
 */
@interface HLLUSafeCrashManager : NSObject

/**
 是否开启SafeCrash内部日志输出打印
 
 默认为NO.
 */
@property(nonatomic, assign) BOOL enableLog;

///回调block，详细的Crash日志的回调
@property(nonatomic, copy, readonly) HLLUCrashCallBack crashCallBack;

/**
 单例方法，全局唯一
 */
+ (instancetype _Nonnull )sharedInstance;


/**
 初使化crash防护组件
 
 @param appId  当前接入的应用ID,不为空. 例如："com.huolala.user"
 @param enableLog 是否开启组件内部日志输出. 默认为：NO,也可通过 enableLog单独设置.
 */

- (void)initWithAppId:(NSString *_Nonnull)appId
            enableLog:(BOOL) enableLog;
/// 单例方法，init禁用，请使用 @method(initWithAppId:enableLog:)
- (instancetype _Nonnull )init NS_UNAVAILABLE;

/**
 根据外部配置,启动组件
 [可放子线程进行初使化,根据项目的复杂程度,低端机200ms耗时，高端机40ms耗时，耗时点在方法替换]
 
 数据结构:
 
 {
 "enable" : 1,
 "version": "0.1.0",
 "time" : "2021-06-10"
 "module_map": {
    "NSArray" : {"enable":1},
    "NSMutableArray" : {"enable":1},
    "NSDictionary" : {"enable":1},
    "NSMutableDictionary" : {"enable":1}
    }
 }
 
 @param enableModuleMap 启动的组件的键值开关字典，控制各个防护组件是否开启.
 
 @return 成功后将返回YES，失败将返回NO.
 */
- (BOOL)startSafeCrashProtectorWithConfig:(NSDictionary* _Nonnull) enableModuleMap
                            crashCallBack:(HLLUCrashCallBack) crashBlock;

@end
