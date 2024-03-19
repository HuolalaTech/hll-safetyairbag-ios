//
//  NSMutableAttributedString+HLLUSafeCrash.m
//  HLLSafetyAirBag
//
//  Created by sherwin chen on 2022/3/30.
//

#import "NSMutableAttributedString+HLLUSafeCrash.h"
#import "NSObject+HLLUSwizzle.h"

@implementation NSMutableAttributedString (HLLUSafeCrash)

+ (void)_safecrash_enableMutAttributedStringProtector:(NSDictionary* _Nonnull) enableMethodMap {
    if (enableMethodMap == nil ||
        ![enableMethodMap isKindOfClass:NSDictionary.class] ||
        enableMethodMap.count <1 ) {
        
        HLLSafetyLog(@"未检测到开关参数，NSMutableAttributedString防护将不开启. 示例参考: {'enable':1}");
        return;
    }
    
    // 如果当前组件总开关关闭，直接中断后续流程.
    if (![enableMethodMap[@"enable"] boolValue]) {
        HLLSafetyLog(@"检测到开关值为0，NSMutableAttributedString防护将不开启. %@", enableMethodMap);
        return;
    }
    
    HLLSafetyLog(@">>> %@防护将开启.",NSStringFromClass([self class]));
    Class NSConcreteMutableAttributedString = NSClassFromString(@"NSConcreteMutableAttributedString");
    
    //initWithString:
    [self hllu_instanceSwizzleMethodWithClass:NSConcreteMutableAttributedString orginalMethod:@selector(initWithString:) replaceMethod:@selector(hllu_initWithString:)];

    //initWithString:attributes:
    [self hllu_instanceSwizzleMethodWithClass:NSConcreteMutableAttributedString orginalMethod:@selector(initWithString:attributes:) replaceMethod:@selector(hllu_initWithString:attributes:)];
    
    /* 普通方法 */
    [self hllu_instanceSwizzleMethodWithClass:NSConcreteMutableAttributedString
                                orginalMethod:@selector(attributedSubstringFromRange:) replaceMethod:@selector(hllu_attributedSubstringFromRange:)];
    
    return;
}


- (instancetype)hllu_initWithString:(NSString *)str {
    id object = nil;
    
    @try {
        object = [self hllu_initWithString:str];
    }
    @catch (NSException *exception) {
        NSString *crashName = @"NSMutableAttributedString#initWithString:";
        [HLLUSafeCrashLog hllu_noteErrorWithException:exception
                                            crashName:crashName
                                         attachedTODO:@""];
    }
    @finally {
        return object;
    }
}

- (instancetype)hllu_initWithString:(NSString *)str 
                         attributes:(NSDictionary<NSString *,id> *)attrs {
    id object = nil;
    
    @try {
        object = [self hllu_initWithString:str
                                attributes:attrs];
    }
    @catch (NSException *exception) {
        NSString *crashName = @"NSMutableAttributedString#initWithString:attributes:";
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
        
        NSString *crashName = @"NSMutableAttributedString#attributedSubstringFromRange:";
        [HLLUSafeCrashLog hllu_noteErrorWithException:exception
                                            crashName:crashName
                                         attachedTODO:@""];
    }
    @finally {
        return object;
    }
}

@end
