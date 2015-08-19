//
//  AppDelegate.m
//  TestShareLogin
//
//  Created by wsliang on 15/4/29.
//  Copyright (c) 2015年 wsliang. All rights reserved.
//

#import "AppDelegate.h"

#import <ShareSDK/ShareSDK.h>
//#import "WeiboApi.h"
#import "WeiboSDK.h"
#import <TencentOpenAPI/QQApiInterface.h>
#import <TencentOpenAPI/TencentOAuth.h>
#import "WXApi.h"
//#import <RennSDK/RennSDK.h>


@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    [ShareSDK registerApp:@"71a4a20e221e"];
    
    //2. 初始化社交平台
    
    //2.1 代码初始化社交平台的方法
    
    [self initializePlat];
    
    return YES;
}

// 需要依赖客户端分享或者要支持SSO授权（可以理解成跳到客户端授权）的平台都需要配置平台的URL Scheme（应用分享到社交平台后通过识别URL Scheme返回应用）。具体配置URL Scheme请参考iOS配置SSO授权
// http://wiki.mob.com/%E9%85%8D%E7%BD%AEsso%E6%8E%88%E6%9D%83-2/

- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url
{
    return [ShareSDK handleOpenURL:url wxDelegate:self];
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation
{
    return [ShareSDK handleOpenURL:url sourceApplication:sourceApplication annotation:annotation wxDelegate:self];
}

- (void)initializePlat
{
    /**
     连接新浪微博
     **/
    [ShareSDK connectSinaWeiboWithAppKey:@"568898243"
                               appSecret:@"38a4f8204cc784f81f9f0daaf31e02e3"
                             redirectUri:@"http://www.sharesdk.cn"];
    

    /**
     连接QQ空间应用
     **/
    [ShareSDK connectQZoneWithAppKey:@"100371282"
                           appSecret:@"aed9b0303e3ed1e27bae87c33761161d"
                   qqApiInterfaceCls:[QQApiInterface class]
                     tencentOAuthCls:[TencentOAuth class]];
    
    /**
     连接微信应用
     **/
    [ShareSDK connectWeChatWithAppId:@"wx4868b35061f87885"
                           appSecret:@"64020361b8ec4c99936c0e3999a9f249"
                           wechatCls:[WXApi class]];
    
    /**
     连接QQ应用
     **/
    [ShareSDK connectQQWithQZoneAppKey:@"100371282"
                     qqApiInterfaceCls:[QQApiInterface class]
                       tencentOAuthCls:[TencentOAuth class]];
    

}

/**
 * @brief  托管模式下的初始化平台
 */
- (void)initializePlatForTrusteeship
{
    
    //导入QQ互联和QQ好友分享需要的外部库类型
    [ShareSDK importQQClass:[QQApiInterface class] tencentOAuthCls:[TencentOAuth class]];
    
//    //导入腾讯微博需要的外部库类型
//    [ShareSDK importTencentWeiboClass:[WeiboApi class]];
    
    //导入微信需要的外部库类型
    [ShareSDK importWeChatClass:[WXApi class]];

}

@end
