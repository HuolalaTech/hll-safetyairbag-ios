//
//  HLLMacroTools.h
//  opensource-scaffolding-ios_Example
//
//  Created by shanghai090.yang on 2022/12/13.
//  Copyright © 2022 shanghai090.yang. All rights reserved.
//

#ifndef HLLMacroTools_h
#define HLLMacroTools_h

/// 货拉拉橙色
#define OrangeColor         [UIColor colorWithRed:255/255.0f green:102/255.0 blue:0/255.0 alpha:1.0]
/// 浅橙色
#define LightOrangeColor    [UIColor colorWithRed:254/255.0f green:243/255.0 blue:235/255.0 alpha:1.0]
/// 红色
#define RedColor            [UIColor colorWithRed:255/255.0f green:59/255.0 blue:48/255.0 alpha:1.0]
/// 蓝色
#define BlueColor           [UIColor colorWithRed:53/255.0f green:113/255.0 blue:230/255.0 alpha:1.0]
/// 浅蓝色
#define LightBlueColor      [UIColor colorWithRed:242/255.0f green:247/255.0 blue:255/255.0 alpha:1.0]


/// 设计图的黑色透明度<0.1
#define BackgroundColor     [UIColor colorWithRed:240/255.0f green:241/255.0 blue:242/255.0 alpha:1.0]
/// 设计图的黑色透明度0.1
#define LightGrayColor      [UIColor colorWithRed:229/255.0f green:229/255.0 blue:229/255.0 alpha:1.0]
/// 设计图的黑色透明度0.25
#define GrayColor           [UIColor colorWithRed:191/255.0f green:191/255.0 blue:191/255.0 alpha:1.0]
/// 设计图的黑色透明度0.45
#define DarkGrayColor       [UIColor colorWithRed:140/255.0f green:140/255.0 blue:140/255.0 alpha:1.0]
/// 设计图的黑色透明度0.65
#define LightBlackColor     [UIColor colorWithRed:89/255.0f green:89/255.0 blue:89/255.0 alpha:1.0]
/// 设计图的黑色透明度0.85
#define BlackColor          [UIColor colorWithRed:51/255.0f green:51/255.0 blue:51/255.0 alpha:1.0]


// 字符串拼接
#define FormatString(fmt, ...) [NSString stringWithFormat:fmt, ##__VA_ARGS__]

#endif /* HLLMacroTools_h */
