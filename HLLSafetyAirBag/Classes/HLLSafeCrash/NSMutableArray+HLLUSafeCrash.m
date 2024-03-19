//
//  NSMutableArray+HLLUSafeCrash.m
//  HLLSafetyAirBag
//
//  Created by sherwin chen on 2021/6/9.
//

#import "NSMutableArray+HLLUSafeCrash.h"
#import "NSObject+HLLUSwizzle.h"

@implementation NSMutableArray (HLLUSafeCrash)

+ (void)_safecrash_enableMutableArrayProtector:(NSDictionary* _Nonnull) enableMethodMap {
    
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
    //====================
    //   instance method
    //====================
    Class __NSArrayM = NSClassFromString(@"__NSArrayM");

    // objectAtIndex:
    float curSystemVersion = [[UIDevice currentDevice].systemVersion floatValue];
    if (curSystemVersion>=11.0) {
        //iOS10 会crash（搜：[UIKeyboardTaskEntry dealloc]），需做安全处理: https://juejin.cn/post/6844903646451204104
        [self hllu_instanceSwizzleMethodWithClass:__NSArrayM orginalMethod:@selector(objectAtIndex:) replaceMethod:@selector(hllu_objectAtIndex:)];
        
        //因hllu_objectAtIndexedSubscript会调用hllu_objectAtIndex方法，解决循环调用crash的问题.
        [self hllu_instanceSwizzleMethodWithClass:__NSArrayM orginalMethod:@selector(objectAtIndexedSubscript:) replaceMethod:@selector(hllu_objectAtIndexedSubscript:)];
    }

    //insertObject:atIndex:
    [self hllu_instanceSwizzleMethodWithClass:__NSArrayM orginalMethod:@selector(insertObject:atIndex:) replaceMethod:@selector(hllu_insertObject:atIndex:)];

    //removeObjectAtIndex:
    [self hllu_instanceSwizzleMethodWithClass:__NSArrayM orginalMethod:@selector(removeObjectAtIndex:) replaceMethod:@selector(hllu_removeObjectAtIndex:)];

    //setObject:atIndexedSubscript:
    [self hllu_instanceSwizzleMethodWithClass:__NSArrayM orginalMethod:@selector(setObject:atIndexedSubscript:) replaceMethod:@selector(hllu_setObject:atIndexedSubscript:)];

    [self hllu_instanceSwizzleMethodWithClass:__NSArrayM orginalMethod:@selector(getObjects:range:) replaceMethod:@selector(hllu_getObjects:range:)];
    return;
}

- (id)hllu_objectAtIndex:(NSUInteger)index {
    id object = nil;
    @try {
        object = [self hllu_objectAtIndex:index];
    }
    @catch (NSException *exception) {
        
        NSString *crashName = @"NSMutableArray#objectAtIndex:";
        [HLLUSafeCrashLog hllu_noteErrorWithException:exception
                                            crashName:crashName
                                         attachedTODO:@""];
        
    }
    @finally {
        return object;
    }
}

- (id)hllu_objectAtIndexedSubscript:(NSUInteger)index {
    id object = nil;
    @try {
        object = [self hllu_objectAtIndex:index];
    }
    @catch (NSException *exception) {
        NSString *crashName = @"NSMutableArray#objectAtIndexedSubscript:";
        [HLLUSafeCrashLog hllu_noteErrorWithException:exception
                                            crashName:crashName
                                         attachedTODO:@""];
    }
    @finally {
        return object;
    }
}

- (void)hllu_insertObject:(id)anObject
                  atIndex:(NSUInteger)index {
    
    @try {
        [self hllu_insertObject:anObject atIndex:index];
    }
    @catch (NSException *exception) {
        NSString *crashName = @"NSMutableArray#insertObject:";
        [HLLUSafeCrashLog hllu_noteErrorWithException:exception
                                            crashName:crashName
                                         attachedTODO:@""];
    }
    @finally {
    }
}

- (void)hllu_removeObjectAtIndex:(NSUInteger)index {
    @try {
        [self hllu_removeObjectAtIndex:index];
    }
    @catch (NSException *exception) {
        NSString *crashName = @"NSMutableArray#removeObjectAtIndex:";
        [HLLUSafeCrashLog hllu_noteErrorWithException:exception
                                            crashName:crashName
                                         attachedTODO:@""];
    }
    @finally {
    }
}

- (void)hllu_setObject:(id)obj
    atIndexedSubscript:(NSUInteger)idx {
    
    @try {
        [self hllu_setObject:obj atIndexedSubscript:idx];
    }
    @catch (NSException *exception) {
        NSString *crashName = @"NSMutableArray#setObject:atIndexedSubscript:";
        [HLLUSafeCrashLog hllu_noteErrorWithException:exception
                                            crashName:crashName
                                         attachedTODO:@""];
    }
    @finally {
    }
}

- (void)hllu_getObjects:(__unsafe_unretained id  _Nonnull *)objects
                  range:(NSRange)range {
    
    @try {
        [self hllu_getObjects:objects range:range];
    } @catch (NSException *exception) {
        NSString *crashName = @"NSMutableArray#getObjects:range:";
        [HLLUSafeCrashLog hllu_noteErrorWithException:exception
                                            crashName:crashName
                                         attachedTODO:@""];
    } @finally {
    }
}

@end
