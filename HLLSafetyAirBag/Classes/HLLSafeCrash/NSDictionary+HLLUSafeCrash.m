//
//  NSDictionary+HLLUSafeCrash.m
//  HLLSafetyAirBag
//
//  Created by sherwin chen on 2021/6/9.
//

#import "NSDictionary+HLLUSafeCrash.h"
#import "NSObject+HLLUSwizzle.h"

@implementation NSDictionary (HLLUSafeCrash)

+ (void)_safecrash_enableDictionaryProtector:(NSDictionary* _Nonnull) enableMethodMap {
    
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

    [self hllu_classSwizzleMethodWithClass:self 
                             orginalMethod:@selector(dictionaryWithObjects:forKeys:count:)
                             replaceMethod:@selector(hllu_dictionaryWithObjects:forKeys:count:)];
}

+ (instancetype)hllu_dictionaryWithObjects:(const id  _Nonnull __unsafe_unretained *)objects
                                   forKeys:(const id<NSCopying>  _Nonnull __unsafe_unretained *)keys
                                     count:(NSUInteger)cnt {
    
    id instance = nil;
    @try {
        instance = [self hllu_dictionaryWithObjects:objects forKeys:keys count:cnt];
    }
    @catch (NSException *exception) {
        
        NSString *crashName = @"NSDictionary#dictionaryWithObjects:forKeys:count:";
        [HLLUSafeCrashLog hllu_noteErrorWithException:exception
                                            crashName:crashName
                                         attachedTODO:@""];
        
        //处理错误的数据，然后重新初始化一个字典
        NSUInteger index = 0;
        id  _Nonnull __unsafe_unretained newObjects[cnt];
        id  _Nonnull __unsafe_unretained newkeys[cnt];
        
        for (int i = 0; i < cnt; i++) {
            if (objects[i] && keys[i]) {
                newObjects[index] = objects[i];
                newkeys[index] = keys[i];
                index++;
            }
        }
        instance = [self hllu_dictionaryWithObjects:newObjects forKeys:newkeys count:index];
    }
    @finally {
        return instance;
    }
}

@end
