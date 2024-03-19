//
//  HLLUSafeCrashProtectorManager.m
//  HLLSafetyAirBag
//
//  Created by sherwin chen on 2021/6/9.
//

#import <libkern/OSAtomic.h>

#import "HLLUSafeCrashManager.h"

#import "NSArray+HLLUSafeCrash.h"
#import "NSMutableArray+HLLUSafeCrash.h"

#import "NSDictionary+HLLUSafeCrash.h"
#import "NSMutableDictionary+HLLUSafeCrash.h"

#import "NSAttributedString+HLLUSafeCrash.h"
#import "NSMutableAttributedString+HLLUSafeCrash.h"

#import "NSObject+UnrecognizedSelector.h"

#import "HLLUSafeCrashLog.h"

@interface HLLUSafeCrashManager ()
@property(nonatomic, copy) NSString *appId;
@property(nonatomic, copy) HLLUCrashCallBack crashCallBack;
@end

@implementation HLLUSafeCrashManager

static HLLUSafeCrashManager* manager = nil;

+ (instancetype)sharedInstance {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        manager = [[HLLUSafeCrashManager alloc] init];
    });
    return manager;
}

+ (instancetype)allocWithZone:(struct _NSZone *)zone {
    if (!manager) {
        OSSpinLock spinlock = OS_SPINLOCK_INIT;
        OSSpinLockLock(&spinlock);
        manager = [super allocWithZone:zone];
        OSSpinLockUnlock(&spinlock);
    }
    return manager;
}
- (id)copyWithZone:(NSZone *)zone {
    return manager;
}

- (void)initWithAppId:(NSString *_Nonnull)appId
            enableLog:(BOOL) enableLog {
    self.appId = appId;
    self.enableLog = enableLog;
    return;
}

- (BOOL)startSafeCrashProtectorWithConfig:(NSDictionary* _Nonnull) enableModuleMap
                            crashCallBack:(HLLUCrashCallBack) crashBlock {
   
    if (enableModuleMap.count <1) {
        NSAssert(0, @"参数不能为空.");
        return NO;
    }
    
    if (self.appId.length<1) {
        NSAssert(0, @"警告!!!请先调用[[HLLUSafeCrashManager.sharedInstance initWithAppId:enableLog:] 进行初使化.");
        return NO;
    }
    
    //设置回调
    self.crashCallBack = crashBlock;
    
    //读取配置开启项
    NSString *keyEnableStr = @"enable";
    
    NSNumber *enableAll = enableModuleMap[keyEnableStr];
    if (enableAll == nil ||
        ![enableAll isKindOfClass:NSNumber.class] ||
        [enableAll boolValue] == NO) {
        
        NSLog(@">>> [%@] 总开关是关闭的状态,将不开启 SafeCrash 防护.",kGBHLLSafetyLogTag);
        return NO;
    }
    
    NSDictionary *module_map = enableModuleMap[@"module_map"];
    if (module_map == nil ||
        ![module_map isKindOfClass:NSDictionary.class] ||
        module_map.count < 1
        ) {
        NSLog(@">>> [%@] module_list数据为空，将不启动任何模块防护",kGBHLLSafetyLogTag);
        return NO;
    }

    //开启的防护模块
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        //开启的防护模块
        [NSArray _safecrash_enableArrayProtector:module_map[@"NSArray"]];
        [NSDictionary _safecrash_enableDictionaryProtector:module_map[@"NSDictionary"]];
        
        [NSMutableArray _safecrash_enableMutableArrayProtector:module_map[@"NSMutableArray"]];
        [NSMutableDictionary _safecrash_enableMutableDictionaryProtector:module_map[@"NSMutableDictionary"]];
        
        [NSAttributedString _safecrash_enableAttributedStringProtector:module_map[@"NSAttributedString"]];
        [NSMutableAttributedString _safecrash_enableMutAttributedStringProtector:module_map[@"NSMutableAttributedString"]];
        
        [NSObject _safecrash_enableCrashDefendProtector:module_map[@"UnrecognizedSelector"]];
        
    });
     
    return YES;
}

@end
