//
//  HLLUSafeCrashLog.h
//  HLLSafetyAirBag
//
//  Created by sherwin chen on 2021/6/9.
//


#import <Foundation/Foundation.h>

//! 日志输出标识
static const NSString * _Nonnull kGBHLLSafetyLogTag = @"HLLSafetyAB";

/**
 调试日志输出. 调试环境下才开启，Release模式自动关闭
 */
#ifdef DEBUG
    #define HLLSafetyLog(format, ...) hllSafetyWithFormat(__FILE_NAME__, __func__, __LINE__, format, ##__VA_ARGS__)
#else
    #define HLLSafetyLog(format, ...)
#endif

/**
 日志格式化输出
 
 外部不用关注此方法的调用，请使用HLLSafetyLog(format, ...)
 */
void hllSafetyWithFormat(const char * _Nonnull filename, const char * _Nonnull func, int line, NSString * _Nullable nsFormat, ...);

@interface HLLUSafeCrashLog : NSObject

/**
 日志记录
 
 产生crash时，将关键信息记录，用于后续排查问题
 
 @param exception  异常堆栈信息
 @param crashName  崩溃名称
 @param todo       额外附加信息
 */
+ (void)hllu_noteErrorWithException:(NSException *_Nonnull)exception
                          crashName:(NSString *_Nonnull)crashName
                       attachedTODO:(NSString *_Nullable)todo;

@end
