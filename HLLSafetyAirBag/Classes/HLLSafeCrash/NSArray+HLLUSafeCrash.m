//
//  NSArray+HLLUSafeCrash.m
//  HLLSafetyAirBag
//
//  Created by sherwin chen on 2021/6/9.
//

/**
 
 iOS 8:下都是__NSArrayI
 iOS11: 之后分 __NSArrayI、  __NSArray0、__NSSingleObjectArrayI
 
 iOS11之前：arr@[]  调用的是[__NSArrayI objectAtIndexed]
 iOS11之后：arr@[]  调用的是[__NSArrayI objectAtIndexedSubscript]
 
 arr为空数组
 *** -[__NSArray0 objectAtIndex:]: index 12 beyond bounds for empty NSArray
 
 arr只有一个元素
 *** -[__NSSingleObjectArrayI objectAtIndex:]: index 12 beyond bounds [0 .. 0]
 
 */

#import "NSArray+HLLUSafeCrash.h"
#import "NSObject+HLLUSwizzle.h"

@implementation NSArray (HLLUSafeCrash)

/**
 enableMethodMap:
 
 {"enable":1},
 */
+ (void)_safecrash_enableArrayProtector:(NSDictionary* _Nonnull) enableMethodMap {

    if (enableMethodMap == nil ||
        ![enableMethodMap isKindOfClass:NSDictionary.class] ||
        enableMethodMap.count <1 ) {
        
        HLLSafetyLog(@"未检测到开关参数，NSArray防护将不开启. 示例参考: {'enable':1}");
        return;
    }
    
    // 如果当前组件总开关关闭，直接中断后续流程.
    if (![enableMethodMap[@"enable"] boolValue]) {
        HLLSafetyLog(@"检测到开关值为0，NSArray防护将不开启. %@", enableMethodMap);
        return;
    }

    HLLSafetyLog(@">>> %@防护将开启.",NSStringFromClass([self class]));
    
    Class __NSArray  = objc_getClass("NSArray");
    Class __NSArrayI = objc_getClass("__NSArrayI");
    Class __NSArray0 = objc_getClass("__NSArray0");
    Class __NSSingleObjectArrayI = objc_getClass("__NSSingleObjectArrayI");
    
    //__NSArray@arrayWithObjects:count:
    [self hllu_classSwizzleMethodWithClass:__NSArray
                           orginalMethod:@selector(arrayWithObjects:count:)
                           replaceMethod:@selector(hllu_arrayWithObjects:count:)];
    
    // __NSArrayI@objectAtIndex:
    /* 数组count >= 2 */
    [self hllu_instanceSwizzleMethodWithClass:__NSArrayI orginalMethod:@selector(objectAtIndex:) replaceMethod:@selector(hllu_objectAtIndex:)];//[arr objectAtIndex:];
    
    // __NSArrayI@objectAtIndexedSubscript:
    [self hllu_instanceSwizzleMethodWithClass:__NSArrayI orginalMethod:@selector(objectAtIndexedSubscript:) replaceMethod:@selector(hllu_objectAtIndexedSubscript:)];//arr[];
    
    // __NSArray0@objectAtIndex:
    /* 数组为空 */
    [self hllu_instanceSwizzleMethodWithClass:__NSArray0 orginalMethod:@selector(objectAtIndex:) replaceMethod:@selector(hllu_objectAtIndexedNullarray:)];
    
    // __NSSingleObjectArrayI@objectAtIndex:
    /* 数组count == 1 */
    [self hllu_instanceSwizzleMethodWithClass:__NSSingleObjectArrayI orginalMethod:@selector(objectAtIndex:) replaceMethod:@selector(hllu_objectAtIndexedArrayCountOnlyOne:)];
    
    // __NSArray@objectsAtIndexes:
    [self hllu_instanceSwizzleMethodWithClass:__NSArray orginalMethod:@selector(objectsAtIndexes:) replaceMethod:@selector(hllu_objectsAtIndexes:)];
    
    // 以下方法调用频繁，替换可能会影响性能
    /*
    // getObjects:range:
    [self hllu_instanceSwizzleMethodWithClass:__NSArray orginalMethod:@selector(getObjects:range:) replaceMethod:@selector(hllu_getObjectsNSArray:range:)];
     
    [self hllu_instanceSwizzleMethodWithClass:__NSSingleObjectArrayI orginalMethod:@selector(getObjects:range:) replaceMethod:@selector(hllu_getObjectsNSSingleObjectArrayI:range:)];
     
    [self hllu_instanceSwizzleMethodWithClass:__NSArrayI orginalMethod:@selector(getObjects:range:) replaceMethod:@selector(hllu_getObjectsNSArrayI:range:)];
    */
}

#pragma mark - instance array
+ (instancetype)hllu_arrayWithObjects:(const id  _Nonnull __unsafe_unretained *)objects 
                                count:(NSUInteger)cnt {
    
    id instance = nil;
    
    @try {
        instance = [self hllu_arrayWithObjects:objects count:cnt];
    }
    @catch (NSException *exception) {
        
        NSString *crashName = @"NSArray#arrayWithObjects:count:";
        
        [HLLUSafeCrashLog hllu_noteErrorWithException:exception
                                            crashName:crashName
                                         attachedTODO:nil];

        //以下是对错误数据的处理，把为nil的数据去掉,然后初始化数组
        NSInteger newObjsIndex = 0;
        id  _Nonnull __unsafe_unretained newObjects[cnt];
        
        for (int i = 0; i < cnt; i++) {
            if (objects[i] != nil) {
                newObjects[newObjsIndex] = objects[i];
                newObjsIndex++;
            }
        }
        instance = [self hllu_arrayWithObjects:newObjects count:newObjsIndex];
    }
    @finally {
        return instance;
    }
}

- (id)hllu_objectAtIndex:(NSUInteger)index {

    id object = nil;
    @try {
        object = [self hllu_objectAtIndex:index];
    }
    @catch (NSException *exception) {
        NSString *crashName = @"NSArray#objectAtIndex:";
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
        object = [self hllu_objectAtIndexedSubscript:index];
    }
    @catch (NSException *exception) {
        NSString *crashName = @"NSArray#objectAtIndexedSubscript:";
        [HLLUSafeCrashLog hllu_noteErrorWithException:exception
                                            crashName:crashName
                                         attachedTODO:@""];
    }
    @finally {
        return object;
    }
}

- (id)hllu_objectAtIndexedNullarray:(NSUInteger)index {
    id object = nil;
    @try {
        object = [self hllu_objectAtIndexedNullarray:index];
    }
    @catch (NSException *exception) {
        NSString *crashName = @"NSArray#objectAtIndexedNullarray:";
        [HLLUSafeCrashLog hllu_noteErrorWithException:exception
                                            crashName:crashName
                                         attachedTODO:@""];
    }
    @finally {
        return object;
    }
}

- (id)hllu_objectAtIndexedArrayCountOnlyOne:(NSUInteger)index {
    id object = nil;
    @try {
        object = [self hllu_objectAtIndexedArrayCountOnlyOne:index];
    }
    @catch (NSException *exception) {
        NSString *crashName = @"NSArray#objectAtIndexedArrayCountOnlyOne:";
        [HLLUSafeCrashLog hllu_noteErrorWithException:exception
                                            crashName:crashName
                                         attachedTODO:@""];
    }
    @finally {
        return object;
    }
}

- (NSArray *)hllu_objectsAtIndexes:(NSIndexSet *)indexes {
    NSArray *returnArray = nil;
    @try {
        returnArray = [self hllu_objectsAtIndexes:indexes];
    } @catch (NSException *exception) {
        NSString *crashName = @"NSArray#objectsAtIndexes:";
        [HLLUSafeCrashLog hllu_noteErrorWithException:exception
                                            crashName:crashName
                                         attachedTODO:@""];
    } @finally {
        return returnArray;
    }
}

#pragma mark getObjects:range:
- (void)hllu_getObjectsNSArray:(__unsafe_unretained id  _Nonnull *)objects
                         range:(NSRange)range {
    @try {
        [self hllu_getObjectsNSArray:objects range:range];
    } @catch (NSException *exception) {
        NSString *crashName = @"NSArray#getObjectsNSArray:range:";
        [HLLUSafeCrashLog hllu_noteErrorWithException:exception
                                            crashName:crashName
                                         attachedTODO:@""];
    } @finally {}
}

- (void)hllu_getObjectsNSSingleObjectArrayI:(__unsafe_unretained id  _Nonnull *)objects
                                      range:(NSRange)range {
    @try {
        [self hllu_getObjectsNSSingleObjectArrayI:objects range:range];
    } @catch (NSException *exception) {
        NSString *crashName = @"NSArray#getObjectsNSSingleObjectArrayI:range:";
        [HLLUSafeCrashLog hllu_noteErrorWithException:exception
                                            crashName:crashName
                                         attachedTODO:@""];
    } @finally {}
}

- (void)hllu_getObjectsNSArrayI:(__unsafe_unretained id  _Nonnull *)objects
                          range:(NSRange)range {
    @try {
        [self hllu_getObjectsNSArrayI:objects range:range];
    } @catch (NSException *exception) {
        NSString *crashName = @"NSArray#getObjectsNSArrayI:range:";
        [HLLUSafeCrashLog hllu_noteErrorWithException:exception
                                            crashName:crashName
                                         attachedTODO:@""];
    } @finally {}
}

@end
