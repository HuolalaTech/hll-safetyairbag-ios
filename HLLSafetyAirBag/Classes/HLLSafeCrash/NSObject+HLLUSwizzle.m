//
//  NSObject+LASwizzle.m
//  HLLSafetyAirBag
//
//  Created by sherwin chen on 2021/6/9.
//


#import "NSObject+HLLUSwizzle.h"

/**
 
 struct objc_method {
 SEL method_name;        // 方法名称
 charchar *method_typesE;    // 参数和返回类型的描述字串
 IMP method_imp;         // 方法的具体的实现的指针，保存了方法地址
 }
 
 */

@implementation NSObject (HLLUSwizzle)

//TODO: 拦截并替换方法
+ (void)hllu_classSwizzleMethod:(SEL)originalSelector
                  replaceMethod:(SEL)replaceSelector {
    
    Class class = [self class];
    
    // Method中包含IMP函数指针，通过替换IMP，使SEL调用不同函数实现
    Method origMethod = class_getClassMethod(class, originalSelector);
    Method replaceMeathod = class_getClassMethod(class, replaceSelector);
    Class metaKlass = objc_getMetaClass(NSStringFromClass(class).UTF8String);

    // class_addMethod:如果发现方法已经存在，会失败返回，也可以用来做检查用,我们这里是为了避免源方法没有实现的情况;如果方法没有存在,我们则先尝试添加被替换的方法的实现
    BOOL didAddMethod = class_addMethod(metaKlass,
                                        originalSelector,
                                        method_getImplementation(replaceMeathod),
                                        method_getTypeEncoding(replaceMeathod));
    if (didAddMethod) {
        // 原方法未实现，则替换原方法防止crash
        class_replaceMethod(metaKlass,
                            replaceSelector,
                            method_getImplementation(origMethod),
                            method_getTypeEncoding(origMethod));
    }else {
        // 添加失败：说明源方法已经有实现，直接将两个方法的实现交换即
        method_exchangeImplementations(origMethod, replaceMeathod);
    }
}

- (void)hllu_instanceSwizzleMethod:(SEL _Nonnull )originalSelector
                     replaceMethod:(SEL _Nonnull )replaceSelector {
    
    Class class = [self class];
    Method origMethod = class_getInstanceMethod(class, originalSelector);
    Method replaceMeathod = class_getInstanceMethod(class, replaceSelector);
    
    // class_addMethod:如果发现方法已经存在，会失败返回，也可以用来做检查用,我们这里是为了避免源方法没有实现的情况;如果方法没有存在,我们则先尝试添加被替换的方法的实现
    BOOL didAddMethod = class_addMethod(class,
                                        originalSelector,
                                        method_getImplementation(replaceMeathod),
                                        method_getTypeEncoding(replaceMeathod));
    if (didAddMethod) {
        // 原方法未实现，则替换原方法防止crash
        class_replaceMethod(class,
                            replaceSelector,
                            method_getImplementation(origMethod),
                            method_getTypeEncoding(origMethod));
    }else {
        // 添加失败：说明源方法已经有实现，直接将两个方法的实现交换即
        method_exchangeImplementations(origMethod, replaceMeathod);
    }
}

+ (void)hllu_classSwizzleMethodWithClass:(Class _Nonnull )klass
                           orginalMethod:(SEL _Nonnull )originalSelector
                           replaceMethod:(SEL _Nonnull )replaceSelector {
    
    // Method中包含IMP函数指针，通过替换IMP，使SEL调用不同函数实现
    Method origMethod = class_getClassMethod(klass, originalSelector);
    Method replaceMeathod = class_getClassMethod(klass, replaceSelector);
    Class metaKlass = objc_getMetaClass(NSStringFromClass(klass).UTF8String);
    
    // class_addMethod:如果发现方法已经存在，会失败返回，也可以用来做检查用,我们这里是为了避免源方法没有实现的情况;如果方法没有存在,我们则先尝试添加被替换的方法的实现
    BOOL didAddMethod = class_addMethod(metaKlass,
                                        originalSelector,
                                        method_getImplementation(replaceMeathod),
                                        method_getTypeEncoding(replaceMeathod));
    if (didAddMethod) {
        // 原方法未实现，则替换原方法防止crash
        class_replaceMethod(metaKlass,
                            replaceSelector,
                            method_getImplementation(origMethod),
                            method_getTypeEncoding(origMethod));
    }else {
        // 添加失败：说明源方法已经有实现，直接将两个方法的实现交换即
        method_exchangeImplementations(origMethod, replaceMeathod);
    }
}

+ (void)hllu_instanceSwizzleMethodWithClass:(Class _Nonnull )klass
                              orginalMethod:(SEL _Nonnull )originalSelector
                              replaceMethod:(SEL _Nonnull )replaceSelector {
    
    Method origMethod = class_getInstanceMethod(klass, originalSelector);
    Method replaceMeathod = class_getInstanceMethod(klass, replaceSelector);

    // class_addMethod:如果发现方法已经存在，会失败返回，也可以用来做检查用,我们这里是为了避免源方法没有实现的情况;如果方法没有存在,我们则先尝试添加被替换的方法的实现
    BOOL didAddMethod = class_addMethod(klass,
                                        originalSelector,
                                        method_getImplementation(replaceMeathod),
                                        method_getTypeEncoding(replaceMeathod));
    if (didAddMethod) {
        // 原方法未实现，则替换原方法防止crash
        class_replaceMethod(klass,
                            replaceSelector,
                            method_getImplementation(origMethod),
                            method_getTypeEncoding(origMethod));
    }else {
        // 添加失败：说明源方法已经有实现，直接将两个方法的实现交换即
        method_exchangeImplementations(origMethod, replaceMeathod);
    }
}

@end
