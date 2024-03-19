//
//  NSMutableDictionary+HLLUSafeCrash.h
//  HLLSafetyAirBag
//
//  Created by sherwin chen on 2021/6/9.
//

/**
 * setValue forKey 的值可设置nil，不会crash
 *
 *  Can avoid crash method
 *
 *  1. - (void)setObject:(id)anObject forKey:(id<NSCopying>)aKey
 *  2. - (void)removeObjectForKey:(id)aKey
 *
 */

#import <Foundation/Foundation.h>

@interface NSMutableDictionary (HLLUSafeCrash)

+ (void)_safecrash_enableMutableDictionaryProtector:(NSDictionary* _Nonnull) enableMethodMap;

@end
