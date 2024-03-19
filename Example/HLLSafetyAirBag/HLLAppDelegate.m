//
//  HLLAppDelegate.m
//  HLLSafetyAirBag
//
//  Created by chensheng12330 on 09/26/2021.
//  Copyright (c) 2021 chensheng12330. All rights reserved.
//

#import "HLLAppDelegate.h"

#import <HLLSafetyAirBag/HLLUSafeCrashManager.h>

#import <HLLSafetyAirBag/HLLThreadSafeArray.h>
#import <HLLSafetyAirBag/HLLThreadSafeDictionary.h>
#import <HLLSafetyAirBag/NSArray+HLLSafe.h>
#import <HLLSafetyAirBag/NSDictionary+HLLSafe.h>
#import <Bugly/Bugly.h>

//# 神策
//# 实时日志
//# bugly

@implementation HLLAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Override point for customization after application launch.
    
    [Bugly startWithAppId:@"com.huolala.user"]; //bugly Demo id
    
    CGFloat beg = CFAbsoluteTimeGetCurrent();
    
    //1. 初使化配置数据. 可以MDAP配置SDK读取. 首次可使用缓存机制.
    NSDictionary *info = @{
        @"enable" : @1,         //安全气囊总开关, 如果为0, module_map下的防护将不会开启.
        @"version": @"0.1.0",   //当前配置数据版本号，非必须
        @"time" : @"2021-06-10",//当前配置数据的时间,非必须
        @"module_map": @{
           @"NSArray"        : @{@"enable":@1}, //NSArray防护开关
           @"NSMutableArray" : @{@"enable":@1}, //NSMutableArray防护开关
           @"NSDictionary"   : @{@"enable":@1}, //NSDictionary防护开关
           @"NSMutableDictionary" : @{@"enable":@1}, //NSMutableDictionary防护开关
           @"NSAttributedString" : @{@"enable":@1}, //NSAttributedString防护开关
           @"NSMutableAttributedString" : @{@"enable":@1}, //NSMutableAttributedString防护开关
           @"UnrecognizedSelector" : @{@"enable":@1,@"defendClass":@[@"HLLMeVC",@"HLLSetingVC",@"HLLViewController"]}
           }
    };
    
    [HLLUSafeCrashManager.sharedInstance initWithAppId:@"com.huolala.user"
                                             enableLog:YES];
    
    //传入配置参数,启动防护组件
    [HLLUSafeCrashManager.sharedInstance startSafeCrashProtectorWithConfig:info
                                                             crashCallBack:^(NSString * _Nonnull crashName, 
                                                                             NSString * _Nonnull crashMsg,
                                                                             NSException * _Nonnull exception) {
        
        NSLog(@">>>> \ncrashName:%@  \ncrashMsg:%@  \nexception:  %@",crashName, crashMsg,exception);
        
        /**bugly上报
         上报自定义Objective-C异常
         */
        [Bugly reportException:exception];
        
        //实时日志上报
        //LogW(@"");
        
        //神策上报
        /*
        [[SensorsAnalyticsSDK sharedInstance] track:@"SafetyAirBag"
                                     withProperties:@{
             @"crashName":crashName
             @"crashMsg" :crashMsg
         }];
         */
    }];
    
    CGFloat end = CFAbsoluteTimeGetCurrent();
    
    //统计耗时时间
    NSLog(@"初使化耗时 %lf 毫秒.", (end-beg)*1000);
    return YES;
}

@end
