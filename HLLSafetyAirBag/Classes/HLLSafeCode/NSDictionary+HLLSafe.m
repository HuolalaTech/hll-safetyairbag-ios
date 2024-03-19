//
//  NSDictionary+HLLSafe.m
//  HLLSafetyAirBag
//
//  Created by Xiaozf on 2021/2/20.
//  Update By Sherwin on 2021/6/7.

#import "NSDictionary+HLLSafe.h"

@implementation NSDictionary (HLLUSafe)

- (id)hllsafe_dataForKey:(NSString *)key {
    return key ? [self objectForKey:key] : nil;
}

- (id)hllsafe_dataForKey:(NSString *)key
               dataClass:(Class)dataClass {
    id data = [self hllsafe_dataForKey:key];
    NSAssert((data == nil || [data isKindOfClass:dataClass] || [data isKindOfClass:[NSNull class]]), @"字典取值的类型不对!!!");
    return [data isKindOfClass:dataClass] ? data : nil;
}

- (NSString *)hllsafe_stringValueForKey:(NSString *)key {
    return [self hllsafe_dataForKey:key dataClass:[NSString class]];
}

- (NSArray *)hllsafe_arrayValueForKey:(NSString *)key {
    return [self hllsafe_dataForKey:key dataClass:[NSArray class]];
}

- (NSDictionary *)hllsafe_dictionaryValueForKey:(NSString *)key {
    return [self hllsafe_dataForKey:key dataClass:[NSDictionary class]];
}

- (NSNumber *)hllsafe_numberValueForKey:(NSString *)key {
    return [self hllsafe_dataForKey:key dataClass:[NSNumber class]];
}

- (BOOL)hllsafe_boolValueForKey:(NSString *)key {
    id data = [self hllsafe_dataForKey:key];
    NSAssert(data == nil || [data respondsToSelector:@selector(boolValue)] || [data isKindOfClass:[NSNull class]], @"字典取值的类型不对!!!");
    if ([data respondsToSelector:@selector(boolValue)])
    {
        return [data boolValue];
    }
    return NO;
}

- (int)hllsafe_intValueForKey:(NSString *)key {
    id data = [self hllsafe_dataForKey:key];
    NSAssert(data == nil || [data respondsToSelector:@selector(intValue)] || [data isKindOfClass:[NSNull class]], @"字典取值的类型不对!!!");
    if ([data respondsToSelector:@selector(intValue)])
    {
        return [data intValue];
    }
    return 0;
}

- (double)hllsafe_doubleValueForKey:(NSString *)key {
    id data = [self hllsafe_dataForKey:key];
    NSAssert(data == nil || [data respondsToSelector:@selector(doubleValue)] || [data isKindOfClass:[NSNull class]], @"字典取值的类型不对!!!");
    if ([data respondsToSelector:@selector(doubleValue)])
    {
        return [data doubleValue];
    }
    return 0.f;
}

- (NSInteger)hllsafe_integerValueForKey:(NSString *)key {
    id data = [self hllsafe_dataForKey:key];
    NSAssert(data == nil || [data respondsToSelector:@selector(integerValue)] || [data isKindOfClass:[NSNull class]], @"字典取值的类型不对!!!");
    if ([data respondsToSelector:@selector(integerValue)])
    {
        return [data integerValue];
    }
    return 0;
}

- (long long)hllsafe_longlongValueForKey:(NSString *)key {
    id data = [self hllsafe_dataForKey:key];
    NSAssert(data == nil || [data respondsToSelector:@selector(longLongValue)] || [data isKindOfClass:[NSNull class]], @"字典取值的类型不对!!!");
    if ([data respondsToSelector:@selector(longLongValue)])
    {
        return [data longLongValue];
    }
    return 0;
}

- (NSDecimalNumber *)hllsafe_decimalNumberForKey:(NSString *)key {
    id data = [self hllsafe_dataForKey:key];
    NSAssert(data == nil || [data isKindOfClass:[NSString class]] || [data isKindOfClass:[NSNumber class]] || [data isKindOfClass:[NSNull class]], @"字典取值的类型不对!!!");
    if ([data isKindOfClass:[NSString class]] || [data isKindOfClass:[NSNumber class]])
    {
        return [NSDecimalNumber decimalNumberWithString:[data description]];
    }
    return nil;
}

@end

@implementation NSMutableDictionary (HLLUSafe)

- (void)hllsafe_setObject:(id)object
                   forKey:(id<NSCopying>)key {
    NSAssert(object, @"往字典里添加了nil元素!!!");
    if (object)
    {
        [self setObject:object forKey:key];
    }
}

@end
