//
//  NSAttributedString+HLLUSafeCrash.h
//  HLLSafetyAirBag
//
//  Created by sherwin chen on 2022/3/30.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSAttributedString (HLLUSafeCrash)

+ (void)_safecrash_enableAttributedStringProtector:(NSDictionary* _Nonnull) enableMethodMap;

@end

NS_ASSUME_NONNULL_END
