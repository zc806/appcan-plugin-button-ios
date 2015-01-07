//
//  EUExButton.m
//  EUExButton
//
//  Created by AppCan on 14-10-11.
//  Copyright (c) 2014年 AppCan. All rights reserved.
//

#import "EUExButton.h"
#import <UIKit/UIKit.h>
#import "JSON.h"
#import "EUtility.h"
#import "ACButton.h"
#import "EUExBaseDefine.h"

@interface EUExButton()

@property (nonatomic,retain) NSMutableDictionary * btnDic;

@end

@implementation EUExButton


- (id)initWithBrwView:(EBrowserView *)eInBrwView {
    if (self = [super initWithBrwView:eInBrwView]) {
        self.btnDic = [NSMutableDictionary dictionary];
    }
    return self;
}

-(void)dealloc {
    [super dealloc];
}

-(void)clean {
    for (ACButton * btn in [self.btnDic allValues]) {
        [btn removeFromSuperview];
    }
    [self.btnDic removeAllObjects];
    [self.btnDic release];
}

-(void)open:(NSMutableArray *)inArguments {
    NSString * idStr = [inArguments objectAtIndex:0];
    float x = [[inArguments objectAtIndex:1] floatValue];
    float y = [[inArguments objectAtIndex:2] floatValue];
    float w = [[inArguments objectAtIndex:3] floatValue];
    float h = [[inArguments objectAtIndex:4] floatValue];
    NSString * jsonStr = [inArguments objectAtIndex:5];
    NSMutableDictionary * jsDic = [jsonStr JSONValue];
    
    ACButton * btn = [[ACButton alloc]initWithFrame:CGRectMake(x, y, w, h)];
//    NSString * bgColor = [jsDic objectForKey:@"bgColor"];
    btn.backgroundColor=[UIColor clearColor];
    //
    NSString * bgImage = [jsDic objectForKey:@"bgImage"];
    if ([bgImage isKindOfClass:[NSString class]] && [bgImage length] > 0) {
        NSString * imagePath = [self absPath:bgImage];
        [btn setBackgroundImage:[UIImage imageWithContentsOfFile:imagePath] forState:UIControlStateNormal];
    }
    //
    NSString * title = [jsDic objectForKey:@"title"];
    if ([title isKindOfClass:[NSString class]] && [title length] > 0) {
        [btn setTitle:title forState:UIControlStateNormal];
    }
    //
    NSString * titleColor = [jsDic objectForKey:@"titleColor"];
    if ([titleColor isKindOfClass:[NSString class]] && [titleColor length]>0) {
        [btn setTitleColor:[self stringToColor:titleColor] forState:UIControlStateNormal];
    }
    //
    NSString * textSize = [jsDic objectForKey:@"textSize"];
    if ([textSize isKindOfClass:[NSString class]] && [titleColor length]>0) {
        float tSize = [textSize floatValue];
        btn.titleLabel.font=[UIFont systemFontOfSize:tSize];
    }
    //
    
    [EUtility brwView:meBrwView addSubview:btn];
    [btn.superview bringSubviewToFront:btn];
    btn.idStr = idStr;
    [self.btnDic setObject:btn forKey:idStr];
    [btn addTarget:self action:@selector(tap:) forControlEvents:UIControlEventTouchUpInside];
    [btn release];
}

-(void)tap:(id)sender{
    ACButton * btn = (ACButton *)sender;
    NSString *jsString = [NSString stringWithFormat:@"uexButton.onClick('%@');",btn.idStr];
    [self.meBrwView stringByEvaluatingJavaScriptFromString:jsString];
}

-(void)close:(NSMutableArray *)inArguments{
    NSString * idStr = [inArguments objectAtIndex:0];
    ACButton * btn = [self.btnDic objectForKey:idStr];
    [btn removeFromSuperview];
    [self.btnDic removeObjectForKey:idStr];
    idStr = nil;
}

- (UIColor *)stringToColor:(NSString *)aString{
    if ([aString isKindOfClass:[NSString class]] && aString.length > 0) {
        UIColor *color = [EUtility ColorFromString:aString];
        return color;
    }else{
        return nil;
    }
}

@end
