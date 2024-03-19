//
//  NSDictionary+HLLUSafeCrash.h
//  HLLSafetyAirBag
//
//  Created by sherwin chen on 2021/6/9.
//

/**
 *  对NSDictionary常用方法作Crash安全防护.
 */

#import <Foundation/Foundation.h>

@interface NSDictionary (HLLUSafeCrash)

+ (void)_safecrash_enableDictionaryProtector:(NSDictionary* _Nonnull) enableMethodMap;

@end
