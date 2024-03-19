//
//  HLLViewController.m
//  opensource-scaffolding-ios
//
//  Created by shanghai090.yang on 04/03/2023.
//  Copyright (c) 2023 shanghai090.yang. All rights reserved.
//

#import "HLLViewController.h"
#import "HLLDemoViewController.h"
#import "HLLMacroTools.h"
#import <Masonry.h>
#import <MBProgressHUD/MBProgressHUD.h>

@interface HLLViewController ()

@end

@implementation HLLViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    [self setupView];
}

- (void)setupView
{
    UIImageView *backgroundImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"img_background"]];
    backgroundImageView.frame = self.view.bounds;
    [self.view addSubview:backgroundImageView];

    UIImageView *logoImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"ic_logo"]];
    [self.view addSubview:logoImageView];
    [logoImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(64, 64));
        make.centerX.mas_equalTo(self.view);
        make.top.mas_equalTo(self.view).mas_offset(100);
    }];

    UIImageView *nameImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"ic_logo_title"]];
    [self.view addSubview:nameImageView];
    [nameImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(138, 40));
        make.centerX.mas_equalTo(self.view);
        make.top.mas_equalTo(logoImageView.mas_bottom).mas_offset(10);
    }];

    
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.text = @"货拉拉开源脚手架";
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.textColor = UIColor.whiteColor;
    titleLabel.font = [UIFont boldSystemFontOfSize:26];
    [self.view addSubview:titleLabel];
    [titleLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(nameImageView.mas_bottom).mas_offset(20);
        make.left.right.mas_equalTo(self.view);
    }];

    UIButton *exampleButton1 = [[UIButton alloc] init];
    [exampleButton1 setTitle:@"主线程开启测试" forState:UIControlStateNormal];
    [exampleButton1 setTitleColor:UIColor.whiteColor forState:UIControlStateNormal];
    exampleButton1.backgroundColor = OrangeColor;
    exampleButton1.layer.cornerRadius = 8;
    [exampleButton1 addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    exampleButton1.tag = 1001;
    [self.view addSubview:exampleButton1];
    [exampleButton1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(titleLabel.mas_bottom).mas_offset(50);
        make.left.mas_equalTo(self.view).mas_offset(16);
        make.right.mas_equalTo(self.view).mas_offset(-16);
        make.height.mas_equalTo(54);
    }];

    UIButton *exampleButton2 = [[UIButton alloc] init];
    [exampleButton2 setTitle:@"多线程开启测试" forState:UIControlStateNormal];
    exampleButton2.titleLabel.font =  [UIFont boldSystemFontOfSize:16];
    [exampleButton2 setTitleColor:UIColor.whiteColor forState:UIControlStateNormal];
    exampleButton2.backgroundColor = OrangeColor;
    exampleButton2.layer.cornerRadius = 8;
    [exampleButton2 addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    exampleButton2.tag = 1002;
    [self.view addSubview:exampleButton2];
    [exampleButton2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(exampleButton1.mas_bottom).mas_offset(50);
        make.left.mas_equalTo(self.view).mas_offset(16);
        make.right.mas_equalTo(self.view).mas_offset(-16);
        make.height.mas_equalTo(54);
    }];
    
    [self.view addSubview:self.switchControl];
    [self.switchControl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(exampleButton2.mas_bottom).mas_offset(30);
        make.centerX.equalTo(exampleButton2);
        //make.right.mas_equalTo(self.view).mas_offset(-16);
    }];
    
}


- (UISwitch *)switchControl{
    
    if (!_switchControl) {
        _switchControl = [[UISwitch alloc] init];
        _switchControl.onTintColor = kColorValueAlpha(0xff6600, 1.0);
        _switchControl.tintColor   = kColorValueAlpha(0xe5e5e5, 1.0f);
        _switchControl.layer.cornerRadius = 15.5f;
        _switchControl.on = YES;
        _switchControl.layer.masksToBounds = YES;
        [_switchControl addTarget:self action:@selector(switchChange:) forControlEvents:UIControlEventValueChanged];
    }
    
    return _switchControl;
}


UIColor* kColorValueAlpha(int rgbValue,float alphaValue){
    return [UIColor colorWithRed: ((rgbValue >> 16) & 0xFF)/255.f
                           green:((rgbValue >> 8) & 0xFF)/255.f
                            blue:(rgbValue & 0xFF)/255.f
                           alpha:alphaValue];
}


#pragma mark - 按钮事件
- (void)buttonClick:(UIButton *)sender {

    if(!self.switchControl.on){
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
        // Set the text mode to show only text.
        hud.mode = MBProgressHUDModeText;
        hud.label.text = @"您还未开启安全防护.";
        [hud hideAnimated:YES afterDelay:2.f];
        return;
    }
    
    if(sender.tag == 1001){
        [self executeTestMethods];
    }
    else if(sender.tag == 1002){
        [self onMuThreadTest];
    }
}

- (void)switchChange:(UISwitch *)switchControl{
    
    NSString *hubStr = nil;
    if(switchControl.on ){
        hubStr = @"您已开启防护";
    }
    else {
        hubStr = @"您已关闭防护";
    }
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
    // Set the text mode to show only text.
    hud.mode = MBProgressHUDModeText;
    hud.label.text = hubStr;
    [hud hideAnimated:YES afterDelay:2.f];
}

#pragma mark - 测试用例

- (void)staticSafeCode {
    
    NSString *nullObj = nil;
    NSMutableArray *ary = [[NSMutableArray alloc] init];
    [ary hllsafe_addObject:nullObj]; //加入空对象
    [ary hllsafe_objectAtIndex:NSNotFound]; //获取越界对象
    
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
    [dic hllsafe_boolValueForKey:nullObj];
    [dic hllsafe_setObject:nullObj forKey:@"TestKey"];
    [dic hllsafe_dictionaryValueForKey:nullObj];
    //......Value: ForKey:
    return;
}

- (void)executeTestMethods {
    
    [self NSAttributedString_Test_InitWithString];
    [self NSAttributedString_Test_InitWithAttributedString];
    [self NSAttributedString_Test_InitWithStringAttributes];
    [self NSAttributedString_Test_attributedSubstringFromRange];
    
    
    [self NSMutableAttributedString_Test_InitWithString];
    [self NSMutableAttributedString_Test_InitWithStringAttributes];
    [self NSMutableAttributedString_Test_attributedSubstringFromRange];
    
    [self NSArray_Test_InstanceArray];
    [self NSArray_Test_ObjectAtIndex];
    [self NSArray_Test_objectsAtIndexes];
    //[self NSArray_Test_getObjectsRange];


    [self NSMutableArray_Test_ObjectAtIndex];
    [self NSMutableArray_Test_SetObjectAtIndex];
    [self NSMutableArray_Test_RemoveObjectAtIndex];
    [self NSMutableArray_Test_InsertObjectAtIndex];
    [self NSMutableArray_Test_GetObjectsRange];


    [self NSDictionary_Test_InstanceDictionary];
    [self NSMutableDictionary_Test_SetObjectForKey];
    [self NSMutableDictionary_Test_RemoveObjectForKey];

    return;
    [self NSString_Test_CharacterAtIndex];
    [self NSString_Test_SubstringFromIndex];
    [self NSString_Test_SubstringToIndex];
    [self NSString_Test_SubstringWithRange];
    
    [self testNoSelectorCrash];
}

- (void)onMuThreadTest {
    
    for (int  i=0; i<50; i++) {
    
        for (int j=0; j<10; j++) {
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                [self executeTestMethods];
            });
        }
        
        for (int j=0; j<10; j++) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [self executeTestMethods];
            });
        }
    }
}

//=================================================================
//              unrecognized selector sent to instance
//=================================================================
#pragma mark - unrecognized selector sent to instance
/**
 测试没有selector的crash
 */
- (void)testNoSelectorCrash {
    //测试
    [self performSelector:@selector(testCrash)];
    return;
}

//=================================================================
//                         NSArray_Test
//=================================================================
#pragma mark - NSArray_Test

- (void)NSArray_Test_InstanceArray {
    NSString *nilStr = nil;
    NSArray *array = @[@"Sherwin", nilStr, @"iOSDeveloper"];
    NSLog(@"%@",array);
}

- (void)NSArray_Test_ObjectAtIndex {
    NSArray *arr = @[@"Sherwin", @"iOSDeveloper"];
    
    NSObject *object = arr[100];
    //    NSObject *object = [arr objectAtIndex:100];
    
    NSLog(@"object = %@",object);
}

- (void)NSArray_Test_objectsAtIndexes {
    NSArray *array = @[@"Sherwin"];
    
    NSIndexSet *indexSet = [NSIndexSet indexSetWithIndex:100];
    [array objectsAtIndexes:indexSet];
    
}

- (void)NSArray_Test_getObjectsRange {
    
    NSArray *array = @[@"1", @"2", @"3"];//__NSArrayI
    
    //NSArray *array = @[@"1"];//__NSSingleObjectArrayI
    
    //NSArray *array = @[];//NSArray
    
    NSRange range = NSMakeRange(0, 11);
    __unsafe_unretained id cArray[range.length];
    
    
    [array getObjects:cArray range:range];
    
}


//=================================================================
//                       NSMutableArray_Test
//=================================================================
#pragma mark - NSMutableArray_Test

- (void)NSMutableArray_Test_ObjectAtIndex {
    NSMutableArray *array = @[@"Sherwin"].mutableCopy;
    NSObject *object = array[2];
    //NSObject *object = [array objectAtIndex:20];
    NSLog(@"object = %@",object);
}

- (void)NSMutableArray_Test_SetObjectAtIndex {
    NSMutableArray *array = @[@"Sherwin"].mutableCopy;
    array[3] = @"iOS";
}

- (void)NSMutableArray_Test_RemoveObjectAtIndex {
    NSMutableArray *array = @[@"Sherwin", @"iOSDeveloper"].mutableCopy;
    [array removeObjectAtIndex:5];
}

- (void)NSMutableArray_Test_InsertObjectAtIndex {
    
    NSMutableArray *array = @[@"Sherwin"].mutableCopy;
    
    //test1    beyond bounds
    [array insertObject:@"cool" atIndex:5];
    
    
    //test2    insert nil obj
    
    //[array insertObject:nil atIndex:0];
    
    //test3    insert nil obj
    
    //NSString *nilStr = nil;
    //[array addObject:nilStr]; //其本质是调用insertObject:
}

- (void)NSMutableArray_Test_GetObjectsRange {
    NSMutableArray *array = @[@"Sherwin", @"iOSDeveloper"].mutableCopy;
    
    NSRange range = NSMakeRange(0, 11);
    __unsafe_unretained id cArray[range.length];
    
    
    [array getObjects:cArray range:range];
}


//=================================================================
//                       NSDictionary_Test
//=================================================================
#pragma mark - NSDictionary_Test

- (void)NSDictionary_Test_InstanceDictionary {
    NSString *nilStr = nil;
    NSDictionary *dict = @{
                           @"name" : @"Sherwin",
                           @"age" : nilStr
                           };
    NSLog(@"%@",dict);
}

//=================================================================
//                       NSMutableDictionary_Test
//=================================================================
#pragma mark - NSMutableDictionary_Test

- (void)NSMutableDictionary_Test_SetObjectForKey {
    
    NSMutableDictionary *dict = @{
                                  @"name" : @"Sherwin"
                                  
                                  }.mutableCopy;
    NSString *ageKey = nil;
    //dict[ageKey] = @(25);
    NSLog(@"%@",dict);
}

- (void)NSMutableDictionary_Test_RemoveObjectForKey {
    
    NSMutableDictionary *dict = @{
                                  @"name" : @"Sherwin",
                                  @"age" : @(25)
                                  
                                  }.mutableCopy;
    NSString *key = nil;
    [dict removeObjectForKey:key];
    
    NSLog(@"%@",dict);
}

//=================================================================
//                       NSString_Test
//=================================================================
#pragma mark - NSString_Test

- (void)NSString_Test_CharacterAtIndex {
    NSString *str = @"Sherwin";
    
    unichar characteristic = [str characterAtIndex:100];
    NSLog(@"--%c--",characteristic);
}

- (void)NSString_Test_SubstringFromIndex {
    NSString *str = @"Sherwin";
    
    NSString *subStr = [str substringFromIndex:100];
    NSLog(@"%@",subStr);
}

- (void)NSString_Test_SubstringToIndex {
    NSString *str = @"Sherwin";
    
    NSString *subStr = [str substringToIndex:100];
    NSLog(@"%@",subStr);
}

- (void)NSString_Test_SubstringWithRange {
    NSString *str = @"Sherwin";
    
    NSRange range = NSMakeRange(0, 100);
    NSString *subStr = [str substringWithRange:range];
    NSLog(@"%@",subStr);
}

- (void)NSString_Test_StringByReplacingOccurrencesOfString {
    NSString *str = @"Sherwin";
    
    NSString *nilStr = nil;
    str = [str stringByReplacingOccurrencesOfString:nilStr withString:nilStr];
    NSLog(@"1 %@",str);
}

- (void)NSString_Test_StringByReplacingOccurrencesOfStringRange {
    NSString *str = @"Sherwin";
    
    NSRange range = NSMakeRange(0, 1000);
    str = [str stringByReplacingOccurrencesOfString:@"j" withString:@"" options:NSCaseInsensitiveSearch range:range];
    NSLog(@"2 %@",str);
}

- (void)NSString_Test_stringByReplacingCharactersInRangeWithString {
    NSString *str = @"Sherwin";
    
    NSRange range = NSMakeRange(0, 1000);
    str = [str stringByReplacingCharactersInRange:range withString:@"cff"];
    NSLog(@"3 %@",str);
}


//=================================================================
//                       NSMutableString_Test
//=================================================================
#pragma mark - NSMutableString_Test

- (void)NSMutableString_Test_ReplaceCharactersInRange {
    NSMutableString *strM = [NSMutableString stringWithFormat:@"Sherwin"];
    NSRange range = NSMakeRange(0, 1000);
    [strM replaceCharactersInRange:range withString:@"--"];
}

- (void)NSMutableString_Test_InsertStringAtIndex{
    NSMutableString *strM = [NSMutableString stringWithFormat:@"Sherwin"];
    [strM insertString:@"cool" atIndex:1000];
}


- (void)NSMutableString_TestDeleteCharactersInRange{
    NSMutableString *strM = [NSMutableString stringWithFormat:@"Sherwin"];
    NSRange range = NSMakeRange(0, 1000);
    [strM deleteCharactersInRange:range];
}

//=================================================================
//                      NSAttributedString_Test
//=================================================================
#pragma mark - NSAttributedString_Test

- (void)NSAttributedString_Test_InitWithString {
    NSString *str = nil;
    NSAttributedString *attributeStr = [[NSAttributedString alloc] initWithString:str];
    NSLog(@"%@",attributeStr);
}

- (void)NSAttributedString_Test_InitWithAttributedString {
    NSAttributedString *nilAttributedStr = nil;
    NSAttributedString *attributedStr = [[NSAttributedString alloc] initWithAttributedString:nilAttributedStr];
    NSLog(@"%@",attributedStr);
    
    
}

- (void)NSAttributedString_Test_InitWithStringAttributes {
    NSDictionary *attributes = @{
                                 NSForegroundColorAttributeName : [UIColor redColor]
                                 };
    NSString *nilStr = nil;
    NSAttributedString *attributedStr = [[NSAttributedString alloc] initWithString:nilStr attributes:attributes];
    NSLog(@"%@",attributedStr);
}

- (void)NSAttributedString_Test_attributedSubstringFromRange {
    NSDictionary *attributes = @{
                                 NSForegroundColorAttributeName : [UIColor redColor]
                                 };
    NSString *nilStr = @"123456";
    NSAttributedString *attributedStr = [[NSAttributedString alloc] initWithString:nilStr attributes:attributes];
    
    NSRange range = NSMakeRange(5, 10); //error range
    NSAttributedString *rangeStr = [attributedStr attributedSubstringFromRange:range];
    
    //返回空.
    NSLog(@"%s 返回空：%@",__func__, rangeStr);
}

- (void)NSMutableAttributedString_Test_attributedSubstringFromRange{
    NSDictionary *attributes = @{
                                 NSForegroundColorAttributeName : [UIColor redColor]
                                 };
    NSString *nilStr = @"123456";
    NSMutableAttributedString *attributedStr = [[NSMutableAttributedString alloc] initWithString:nilStr attributes:attributes];
    
    NSRange range = NSMakeRange(5, 10); //error range
    NSAttributedString *rangeStr = [attributedStr attributedSubstringFromRange:range];
    
    //返回空.
    NSLog(@"%s 返回空：%@",__func__, rangeStr);
}

//=================================================================
//                   NSMutableAttributedString_Test
//=================================================================
#pragma mark - NSMutableAttributedString_Test

- (void)NSMutableAttributedString_Test_InitWithString {
    
    NSString *nilStr = nil;
    NSMutableAttributedString *attrStrM = [[NSMutableAttributedString alloc] initWithString:nilStr];
    NSLog(@"%@",attrStrM);
}

- (void)NSMutableAttributedString_Test_InitWithStringAttributes {
    
    NSDictionary *attributes = @{
                                 NSForegroundColorAttributeName : [UIColor redColor]
                                 };
    NSString *nilStr = nil;
    NSMutableAttributedString *attrStrM = [[NSMutableAttributedString alloc] initWithString:nilStr attributes:attributes];
    NSLog(@"%@",attrStrM);
}

-(void)testLog
{
    NSLog(@"Test time:%s %d",__func__,1);
}


@end
