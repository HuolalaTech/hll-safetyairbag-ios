//
//  NSDictionary+HLLSafe.h
//  HLLSafetyAirBag
//
//  Created by Xiaozf on 2021/2/20.
//  Update By Sherwin on 2021/6/7

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSDictionary (HLLUSafe)

- (NSString *_Nullable)hllsafe_stringValueForKey:(NSString *)key;
- (NSArray *_Nullable)hllsafe_arrayValueForKey:(NSString *)key;
- (NSDictionary *_Nullable)hllsafe_dictionaryValueForKey:(NSString *)key;
- (NSNumber *_Nullable)hllsafe_numberValueForKey:(NSString *)key;

- (BOOL)hllsafe_boolValueForKey:(NSString *)key;
- (double)hllsafe_doubleValueForKey:(NSString *)key;
- (NSInteger)hllsafe_integerValueForKey:(NSString *)key;
- (long long)hllsafe_longlongValueForKey:(NSString *)key;
- (int)hllsafe_intValueForKey:(NSString *)key;
- (NSDecimalNumber * _Nullable)hllsafe_decimalNumberForKey:(NSString *)key;

@end

@interface NSMutableDictionary (HLLUSafe)

- (void)hllsafe_setObject:(id)object forKey:(id<NSCopying>)key;

@end

NS_ASSUME_NONNULL_END

