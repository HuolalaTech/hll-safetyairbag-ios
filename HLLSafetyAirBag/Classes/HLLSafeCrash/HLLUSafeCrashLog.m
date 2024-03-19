//
//  HLLUSafeCrashLog.m
//  HLLSafetyAirBag
//
//  Created by sherwin chen on 2021/6/9.
//


#import "HLLUSafeCrashLog.h"
#import "HLLUSafeCrashManager.h"

void hllSafetyWithFormat(const char *filename, const char *func, int line, NSString *nsFormat, ...) {
    
    //如果日志处理关闭，将不进行日志输出.
    if (!HLLUSafeCrashManager.sharedInstance.enableLog) {
        return;
    }
    
    va_list argList;
    va_start(argList, nsFormat);
    NSString *message = [[NSString alloc] initWithFormat:nsFormat arguments:argList];
    va_end(argList);

    NSString *strFormat = [NSString stringWithFormat:@"[%@] <%s:%d::%s> %@",kGBHLLSafetyLogTag, filename, line, func, message];
    
    NSLog(@"%@", strFormat);
    return;
}

@implementation HLLUSafeCrashLog


+ (void)hllu_noteErrorWithException:(NSException *_Nonnull)exception
                          crashName:(NSString *_Nonnull)crashName
                       attachedTODO:(NSString *_Nullable)todo {
    
    if(HLLUSafeCrashManager.sharedInstance.crashCallBack == nil ) {
        
        NSLog(@"CrashLogBlock 未开启.Crash日志将不输出");
        return;
    }
        
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        NSString *crashType   = [NSString stringWithFormat:@">>> [Crash Type]: %@",exception.name];
        NSString *errorReason = [NSString stringWithFormat:@">>> [Crash Reason]: %@",exception.reason];;
        NSString *errorPlace  = [NSString stringWithFormat:@">>> [Crash Name]: %@",crashName];
        NSString *crashProtector = [NSString stringWithFormat:@">>> [Attached TODO]: %@",todo];
        NSString *logErrorMessage = [NSString stringWithFormat:@"\n\n%@\n%@\n%@\n%@\n", crashType, errorReason, errorPlace, crashProtector];
        
        if( HLLUSafeCrashManager.sharedInstance.crashCallBack ) {
            HLLUSafeCrashManager.sharedInstance.crashCallBack(crashName, logErrorMessage, exception);
        }
        
    });
}

@end
