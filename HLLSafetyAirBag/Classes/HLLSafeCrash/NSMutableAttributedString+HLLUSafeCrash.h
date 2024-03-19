//
//  NSMutableAttributedString+HLLUSafeCrash.h
//  HLLSafetyAirBag
//
//  Created by sherwin chen on 2022/3/30.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSMutableAttributedString (HLLUSafeCrash)

+ (void)_safecrash_enableMutAttributedStringProtector:(NSDictionary* _Nonnull) enableMethodMap;

@end

NS_ASSUME_NONNULL_END
