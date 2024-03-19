//
//  NSAttributedString+HLLUSafeCrash.m
//  HLLSafetyAirBag
//
//  Created by sherwin chen on 2022/3/30.
//

#import "NSAttributedString+HLLUSafeCrash.h"
#import "NSObject+HLLUSwizzle.h"

@implementation NSAttributedString (HLLUSafeCrash)

+ (void)_safecrash_enableAttributedStringProtector:(NSDictionary* _Nonnull) enableMethodMap {
    if (enableMethodMap == nil ||
        ![enableMethodMap isKindOfClass:NSDictionary.class] ||
        enableMethodMap.count <1 ) {
        
        HLLSafetyLog(@"未检测到开关参数，NSAttributedString防护将不开启. 示例参考: {'enable':1}");
        return;
    }
    
    // 如果当前组件总开关关闭，直接中断后续流程.
    if (![enableMethodMap[@"enable"] boolValue]) {
        HLLSafetyLog(@"检测到开关值为0，NSAttributedString防护将不开启. %@", enableMethodMap);
        return;
    }
    
    HLLSafetyLog(@">>> %@防护将开启.",NSStringFromClass([self class]));
    Class NSConcreteAttributedString = NSClassFromString(@"NSConcreteAttributedString");
    
    /* init方法 */
    
    //initWithString:
    [self hllu_instanceSwizzleMethodWithClass:NSConcreteAttributedString
                                orginalMethod:@selector(initWithString:)
                                replaceMethod:@selector(hllu_initWithString:)];
    //initWithAttributedString
    [self hllu_instanceSwizzleMethodWithClass:NSConcreteAttributedString
                                orginalMethod:@selector(initWithAttributedString:)
                                replaceMethod:@selector(hllu_initWithAttributedString:)];

    //initWithString:attributes:
    [self hllu_instanceSwizzleMethodWithClass:NSConcreteAttributedString
                                orginalMethod:@selector(initWithString:attributes:) replaceMethod:@selector(hllu_initWithString:attributes:)];
    
    /* 普通方法 */
    [self hllu_instanceSwizzleMethodWithClass:NSConcreteAttributedString
                                orginalMethod:@selector(attributedSubstringFromRange:) replaceMethod:@selector(hllu_attributedSubstringFromRange:)];
    
    return;
}


- (instancetype)hllu_initWithString:(NSString *)str {
    id object = nil;
    
    @try {
        object = [self hllu_initWithString:str];
    }
    @catch (NSException *exception) {
        
        NSString *crashName = @"NSAttributedString#initWithString:";
        [HLLUSafeCrashLog hllu_noteErrorWithException:exception
                                            crashName:crashName
                                         attachedTODO:@""];
    }
    @finally {
        return object;
    }
}

#pragma mark - initWithAttributedString
- (instancetype)hllu_initWithAttributedString:(NSAttributedString *)attrStr {
    id object = nil;
    
    @try {
        object = [self hllu_initWithAttributedString:attrStr];
    }
    @catch (NSException *exception) {
        NSString *crashName = @"NSAttributedString#initWithAttributedString:";
        [HLLUSafeCrashLog hllu_noteErrorWithException:exception
                                            crashName:crashName
                                         attachedTODO:@""];
    }
    @finally {
        return object;
    }
}

#pragma mark - initWithString:attributes:

- (instancetype)hllu_initWithString:(NSString *)str
                         attributes:(NSDictionary<NSString *,id> *)attrs {
    id object = nil;
    
    @try {
        object = [self hllu_initWithString:str
                                attributes:attrs];
    }
    @catch (NSException *exception) {
        
        NSString *crashName = @"NSAttributedString#initWithString:attributes:";
        [HLLUSafeCrashLog hllu_noteErrorWithException:exception
                                            crashName:crashName
                                         attachedTODO:@""];
    }
    @finally {
        return object;
    }
}


- (NSAttributedString *)hllu_attributedSubstringFromRange:(NSRange)range {
    id object = nil;
    
    @try {
        object = [self hllu_attributedSubstringFromRange:range];
    }
    @catch (NSException *exception) {
        
        NSString *crashName = @"NSAttributedString#attributedSubstringFromRange:";
        [HLLUSafeCrashLog hllu_noteErrorWithException:exception
                                            crashName:crashName
                                         attachedTODO:@""];
    }
    @finally {
        return object;
    }
}
@end
