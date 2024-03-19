//
//  NSArray+HLLSafe.m
//  HLLSafetyAirBag
//
//  Created by Xiaozf  on 2021/2/20.
//  Update  By Sherwin on 2021/6/7.

#import "NSArray+HLLSafe.h"

@implementation NSArray (HLLSafe)

- (id)hllsafe_objectAtIndex:(NSInteger)index {
    id object = nil;
    if (self.count > index)
    {
        object = [self objectAtIndex:index];
    }
    NSAssert(object, @"数组越界拉!!!");
    return object;
}

@end

@implementation NSMutableArray (HLLSafe)

- (void)hllsafe_addObject:(id)object {
    NSAssert(object, @"数组添加了nil元素!!!");
    if (object)
    {
        [self addObject:object];
    }
}

@end
