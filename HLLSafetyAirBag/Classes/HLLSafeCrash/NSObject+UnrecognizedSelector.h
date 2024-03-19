//
//  NSObject+HLLUCrashDefend.h
//  HLLSafetyAirBag
//
//  Created by Kris on 2023/6/2.
//

/*
 该类目前只针对防护【unrecognized selector ...】类型的错误，原理则是通过runtime的消息转发做防护。
 */

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSObject (HLLUUnrecognizedSelector)
+ (void)_safecrash_enableCrashDefendProtector:(NSDictionary* _Nonnull) enableMethodMap;
@end

NS_ASSUME_NONNULL_END
