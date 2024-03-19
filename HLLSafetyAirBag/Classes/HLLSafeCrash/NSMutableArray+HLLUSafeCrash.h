//
//  NSMutableArray+HLLUSafeCrash.h
//  HLLSafetyAirBag
//
//  Created by sherwin chen on 2021/6/9.
//

/**
 *  对NSMutableArray常用方法作Crash安全防护.
 *
 *  1. - (id)objectAtIndex:(NSUInteger)index
 *  2. - (void)setObject:(id)obj atIndexedSubscript:(NSUInteger)idx
 *  3. - (void)removeObjectAtIndex:(NSUInteger)index
 *  4. - (void)insertObject:(id)anObject atIndex:(NSUInteger)index
 *  5. - (void)getObjects:(__unsafe_unretained id  _Nonnull *)objects range:(NSRange)range
 */
#import <Foundation/Foundation.h>

@interface NSMutableArray (HLLUSafeCrash)

+ (void)_safecrash_enableMutableArrayProtector:(NSDictionary* _Nonnull) enableMethodMap;

@end
