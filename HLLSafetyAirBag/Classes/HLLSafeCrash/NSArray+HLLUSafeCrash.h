//
//  NSArray+HLLUSafeCrash.h
//  HLLSafetyAirBag
//
//  Created by sherwin chen on 2021/6/9.
//

#import <Foundation/Foundation.h>

/**
 对NSArray常用方法作Crash安全防护.
 列表如下：
 1). __NSArray@arrayWithObjects:count:
 2). __NSArrayI@objectAtIndex:
 3). __NSArrayI@objectAtIndexedSubscript:
 4). __NSArray0@objectAtIndex:
 5). __NSSingleObjectArrayI@objectAtIndex:
 6). __NSArray@objectsAtIndexes:
 */

@interface NSArray (HLLUSafeCrash)

+ (void)_safecrash_enableArrayProtector:(NSDictionary* _Nonnull) enableMethodMap;

@end
