//
//  NSObject+HLLUCrashDefend.m
//  HLLSafetyAirBag
//
//  Created by Kris on 2023/6/2.
//

#import "NSObject+UnrecognizedSelector.h"
#import "NSObject+HLLUSwizzle.h"

#define kCrashDynamicClassName @"CrachClass"

//保存需要进行防护的类名称白名单，不在白名单中的类不进行crash防护
static NSArray <NSString *>*kDefendClassWhiteList;
static NSString const *kCrashKindName = @"[unrecognized selector]";

@implementation NSObject (HLLUCrashDefend)

+ (void)_safecrash_enableCrashDefendProtector:(NSDictionary* _Nonnull) enableMethodMap {
    if (enableMethodMap == nil ||
        ![enableMethodMap isKindOfClass:NSDictionary.class] ||
        enableMethodMap.count <1 ) {
        HLLSafetyLog(@"未检测到开关参数，%@防护将不开启. 示例参考: {'enable':1}",kCrashKindName);
        return;
    }
    
    // 如果当前组件总开关关闭，直接中断后续流程.
    if (![enableMethodMap[@"enable"] boolValue]) {
        HLLSafetyLog(@"检测到开关值为0，%@防护将不开启. %@",kCrashKindName, enableMethodMap);
        return;
    }
    
    //为配置防护白名单不做防护处理
    NSArray *whiteList = [enableMethodMap valueForKey:@"defendClass"];
    if (![whiteList isKindOfClass:[NSArray class]] || whiteList.count < 1) {
        HLLSafetyLog(@"检测到防护白名单列表为空，%@防护将不开启. %@",kCrashKindName, enableMethodMap);
        return;
    }
    
    //防护白名单类
    kDefendClassWhiteList = whiteList;
    
    HLLSafetyLog(@">>> %@防护将开启.",kCrashKindName);
    
    [self openCrashDefenHook];

}

+ (void)openCrashDefenHook {
    // 拦截 `+forwardingTargetForSelector:` 类方法，替换自定义实现
    [NSObject hllu_classSwizzleMethodWithClass:[NSObject class]
                                 orginalMethod:@selector(forwardingTargetForSelector:)
                                 replaceMethod:@selector(hll_forwardingTargetForSelector:)];
    
    // 拦截 `-forwardingTargetForSelector:` 实例方法，替换自定义实现
    [NSObject hllu_instanceSwizzleMethodWithClass:[NSObject class]
                                    orginalMethod:@selector(forwardingTargetForSelector:)
                                    replaceMethod:@selector(hll_forwardingTargetForSelector:)];
}

+ (id)hll_forwardingTargetForSelector:(SEL)aSelector {
    
    NSString *currentClassName = NSStringFromClass([self class]);
    //非白名单类名不进行防护处理调回原hook方法
    if (![self hll_CheckWihteList:currentClassName]) {
        return [self hll_forwardingTargetForSelector:aSelector];
    }
    
    SEL forwarding_sel = @selector(forwardingTargetForSelector:);
    Method root_forwarding_method = class_getClassMethod([NSObject class], forwarding_sel);
    Method current_forwarding_method = class_getClassMethod([self class], forwarding_sel);
    
    //判断运行时当前的类是否自己实现了快速转发的方法
    BOOL realize = method_getImplementation(current_forwarding_method) != method_getImplementation(root_forwarding_method);
    
    //如果没有实现快速转发的方法则进行防护
    if (!realize) {
        SEL methodSignature_sel = @selector(methodSignatureForSelector:);
        Method root_methodSignature_method = class_getClassMethod([NSObject class], methodSignature_sel);
        
        Method current_methodSignature_method = class_getClassMethod([self class], methodSignature_sel);
        
        //判断运行时当前的类是否自己实现了消息转发的第三步消息重定向函数
        realize = method_getImplementation(current_methodSignature_method) != method_getImplementation(root_methodSignature_method);
        
        //如果没有则进行防护
        if (!realize) {
            //crash 日志上报
            [NSObject hll_crashLogUploadWithSelector:aSelector className:currentClassName];
            
            //运行时动态创建一个类来充当方法的接受者
            NSString *className = kCrashDynamicClassName;
            Class cls = NSClassFromString(className);
            
            if (!cls) {
                //通过runtime在运行时动态注册一个类
                Class superClsss = [NSObject class];
                cls = objc_allocateClassPair(superClsss, className.UTF8String, 0);
                objc_registerClassPair(cls);
            }
            //如果该类未实现方法，动态添加一个方法
            if (!class_getInstanceMethod(NSClassFromString(className), aSelector)) {
                class_addMethod(cls, aSelector, (IMP)Hll_dynamic_crash_receive_method, "v@:@");
            }
            //将消息转发到该提到类中进行处理
            return [[cls alloc] init];
        }
    }
    return [self hll_forwardingTargetForSelector:aSelector];
}

- (id)hll_forwardingTargetForSelector:(SEL)aSelector {
    
    NSString *currentClassName = NSStringFromClass([self class]);
    //非白名单类名不进行防护处理调回原hook方法
    if (![NSObject hll_CheckWihteList:currentClassName]) {
        return [self hll_forwardingTargetForSelector:aSelector];
    }

    SEL forwarding_sel = @selector(forwardingTargetForSelector:);
    
    Method root_forwarding_method = class_getInstanceMethod([NSObject class], forwarding_sel);
    Method current_forwarding_method = class_getInstanceMethod([self class], forwarding_sel);
    
    //判断运行时当前的类是否自己实现了快速转发的方法
    BOOL realize = method_getImplementation(current_forwarding_method) != method_getImplementation(root_forwarding_method);
    
    //如果没有实现快速转发的方法则进行防护
    if (!realize) {
        SEL methodSignature_sel = @selector(methodSignatureForSelector:);
        Method root_methodSignature_method = class_getInstanceMethod([NSObject class], methodSignature_sel);
        
        Method current_methodSignature_method = class_getInstanceMethod([self class], methodSignature_sel);
        
        //判断运行时当前的类是否自己实现了消息转发的第三步消息重定向函数
        realize = method_getImplementation(current_methodSignature_method) != method_getImplementation(root_methodSignature_method);
        
        //如果没有则进行防护
        if (!realize) {
            
            //crash 日志上报
            [NSObject hll_crashLogUploadWithSelector:aSelector 
                                           className:currentClassName];
            
            //运行时动态创建一个类来充当方法的接受者
            NSString *className = kCrashDynamicClassName;
            Class cls = NSClassFromString(className);
            
            if (!cls) {
                //通过runtime在运行时动态注册一个类
                Class superClsss = [NSObject class];
                cls = objc_allocateClassPair(superClsss, className.UTF8String, 0);
                objc_registerClassPair(cls);
            }
            //如果该类未实现方法，动态添加一个方法
            if (!class_getInstanceMethod(NSClassFromString(className), aSelector)) {
                class_addMethod(cls, aSelector, (IMP)Hll_dynamic_crash_receive_method, "v@:@");
            }
            //将消息转发到该提到类中进行处理
            return [[cls alloc] init];
        }
    }
    return [self hll_forwardingTargetForSelector:aSelector];
}

//校验如果在白名单的类中才会进行防护
+ (BOOL)hll_CheckWihteList:(NSString *)currentClassName {
    if (!currentClassName || currentClassName.length < 1) {
        return NO;
    }
    for (NSString *item in kDefendClassWhiteList) {
        if ([item isEqualToString:currentClassName]) {
            return YES;
        }
    }
    return NO;
}

+ (void)hll_crashLogUploadWithSelector:(SEL)selector 
                             className:(NSString *)className {
    
    NSString *errSel = NSStringFromSelector(selector);
    NSString *errMsg = [NSString stringWithFormat:@"*** Crash Message: -[%@ %@]: unrecognized selector sent to instance %p ***",className, errSel, self];
    NSString *crashName = [NSString stringWithFormat:@"[UnSelCrash][%@ %@]",className, errSel];
    
    @try {
        NSException *logException = [NSException exceptionWithName:crashName
                                                            reason:errMsg 
                                                          userInfo:nil];
        @throw logException;
        
    } @catch (NSException *exception) {
        [HLLUSafeCrashLog hllu_noteErrorWithException:exception
                                            crashName:crashName
                                         attachedTODO:@""];
    }
    return;
}

//动态添加的空方法
static void Hll_dynamic_crash_receive_method(id slf, SEL selector) {
    //方法未找到的Crash被拦截了
    return ;
}
       
@end
