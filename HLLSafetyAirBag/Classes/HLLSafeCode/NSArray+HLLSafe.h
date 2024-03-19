//
//  NSArray+HLLSafe.h
//  HLLSafetyAirBag
//
//  Created by Xiaozf  on 2021/2/20.
//  Update  By Sherwin on 2021/6/7

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSArray <ObjectType> (HLLUSafe)

/// 安全访问数组元素
/// - Parameter index: 索引位置
- (ObjectType)hllsafe_objectAtIndex:(NSInteger)index;

@end

@interface NSMutableArray <ObjectType> (HLLUSafe)

/// 安全增加数组元素,加入判断判空
/// - Parameter object: 加入的对象
- (void)hllsafe_addObject:(ObjectType)object;

@end

NS_ASSUME_NONNULL_END
