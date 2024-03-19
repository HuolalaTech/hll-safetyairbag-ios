//
//  NSMutableDictionary+HLLUSafeCrash.m
//  HLLSafetyAirBag
//
//  Created by sherwin chen on 2021/6/9.
//

#import "NSMutableDictionary+HLLUSafeCrash.h"
#import "NSObject+HLLUSwizzle.h"

@implementation NSMutableDictionary (HLLUSafeCrash)

+ (void)_safecrash_enableMutableDictionaryProtector:(NSDictionary* _Nonnull) enableMethodMap {
    
    if (enableMethodMap == nil ||
        ![enableMethodMap isKindOfClass:NSDictionary.class] ||
        enableMethodMap.count <1 ) {
        HLLSafetyLog(@"未检测到开关参数，%@防护将不开启. 示例参考: {'enable':1}",NSStringFromClass([self class]));
        return;
    }
    
    // 如果当前组件总开关关闭，直接中断后续流程.
    if (![enableMethodMap[@"enable"] boolValue]) {
        HLLSafetyLog(@"检测到开关值为0，%@防护将不开启. %@",NSStringFromClass([self class]), enableMethodMap);
        return;
    }
    
    HLLSafetyLog(@">>> %@防护将开启.",NSStringFromClass([self class]));
    Class dictionaryM = NSClassFromString(@"__NSDictionaryM");
    
    //setObject:forKey:
    [self hllu_instanceSwizzleMethodWithClass:dictionaryM orginalMethod:@selector(setObject:forKey:) replaceMethod:@selector(hllu_setObject:forKey:)];
    
    //removeObjectForKey:
    [self hllu_instanceSwizzleMethodWithClass:dictionaryM orginalMethod:@selector(removeObjectForKey:) replaceMethod:@selector(hllu_removeObjectForKey:)];
    
    return;
}


- (void)hllu_setObject:(id)anObject
                forKey:(id<NSCopying>)aKey {
    
    @try {
        [self hllu_setObject:anObject forKey:aKey];
    }
    @catch (NSException *exception) {
        NSString *crashName = @"NSMutableDictionary#setObject:forKey:";
        [HLLUSafeCrashLog hllu_noteErrorWithException:exception
                                            crashName:crashName
                                         attachedTODO:@""];
    }
    @finally {
    }
}

- (void)hllu_removeObjectForKey:(id)aKey {
    
    @try {
        [self hllu_removeObjectForKey:aKey];
    }
    @catch (NSException *exception) {
        NSString *crashName = @"NSMutableDictionary#removeObjectForKey:";
        [HLLUSafeCrashLog hllu_noteErrorWithException:exception
                                            crashName:crashName
                                         attachedTODO:@""];
    }
    @finally {
    }
}

@end
