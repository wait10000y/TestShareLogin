//
//  ViewController.m
//  TestShareLogin
//
//  Created by wsliang on 15/4/29.
//  Copyright (c) 2015年 wsliang. All rights reserved.
//

#import "ViewController.h"

#import <ShareSDK/ShareSDK.h>

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}



// 开始分享内容
- (IBAction)actionShareContent:(UIButton*)sender
{
    NSString *imagePath = [[NSBundle mainBundle] pathForResource:@"shareImg" ofType:@"png"];
    
    //1、构造分享内容
    id<ISSContent> publishContent = [ShareSDK content:@"测试分享内容1" // 111
                                       defaultContent:@"默认内容2"
                                                image:[ShareSDK imageWithPath:imagePath]
                                                title:@"分享内容标题4"
                                                  url:@"http://www.test.com"
                                          description:@"这是一条演示信息6"
                                            mediaType:SSPublishContentMediaTypeNews];
    
    //1+创建弹出菜单容器（iPad必要）
    id<ISSContainer> container = [ShareSDK container];
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
        [container setIPhoneContainerWithViewController:self];
    }else{
        [container setIPadContainerWithView:sender arrowDirect:UIPopoverArrowDirectionUp];
    }
    //2、弹出分享菜单
    [ShareSDK showShareActionSheet:container
                         shareList:nil
                           content:publishContent
                     statusBarTips:YES
                       authOptions:nil
                      shareOptions:nil
                            result:^(ShareType type, SSResponseState state, id<ISSPlatformShareInfo> statusInfo, id<ICMErrorInfo> error, BOOL end) {
                                
                                //可以根据回调提示用户。
                                if (state == SSResponseStateSuccess)
                                {
                                    NSLog(@"分享成功.");
                                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"文章分享成功"
                                                                                    message:nil
                                                                                   delegate:self
                                                                          cancelButtonTitle:@"确  定"
                                                                          otherButtonTitles:nil, nil];
                                    [alert show];
                                }
                                else if (state == SSResponseStateFail)
                                {
                                    NSLog(@"分享失败.");
                                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"文章分享失败"
                                                                                    message:[NSString stringWithFormat:@"失败描述：%@",[error errorDescription]]
                                                                                   delegate:self
                                                                          cancelButtonTitle:@"确  定"
                                                                          otherButtonTitles:nil, nil];
                                    [alert show];
                                }else if (state == SSResponseStateBegan){
                                    NSLog(@"正在提交分享中...");
                                }else if (state == SSResponseStateCancel){
                                    NSLog(@"分享取消");
                                    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"文章分享失败" message:@"已取消分享" delegate:self cancelButtonTitle:@"确  定" otherButtonTitles:nil];
                                    [alert show];
                                }
                                
                            }];
}



// 授权登录 1:新浪微博; 2:qq; 3:微信;
- (IBAction)actionAuthLogin:(UIButton*)sender {
    ShareType type = 0;
    switch (sender.tag) {
        case 1:
            type = ShareTypeSinaWeibo;
            break;
        case 2:
            type = ShareTypeQQSpace;
            break;
        case 3:
            type = ShareTypeWeixiSession;
            break;
        default:
            break;
    }
    [ShareSDK getUserInfoWithType:type authOptions:nil result:^(BOOL result, id<ISSPlatformUser> userInfo, id<ICMErrorInfo> error) {
        if (result) {
            NSLog(@"授权登陆成功，已获取用户信息");
            NSString *uid = [userInfo uid];
            NSString *nickname = [userInfo nickname];
            NSString *profileImage = [userInfo profileImage];
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"授权登陆成功:" message:[NSString stringWithFormat:@"授权登陆成功,用户ID:%@,昵称:%@,头像:%@",uid,nickname,profileImage] delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alert show];
            NSLog(@"source:%@",[userInfo sourceData]);
            NSLog(@"uid:%@",[userInfo uid]);
            
        }else{
            NSLog(@"分享失败,错误码:%ld,错误描述%@",(long)[error errorCode],[error errorDescription]);

            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"授权失败:" message:[error errorDescription] delegate:self cancelButtonTitle:@"确  定" otherButtonTitles:nil];
            [alert show];
        }
    }];
    
}

// 取消授权
- (IBAction)actionCancelAuthWithAll:(UIButton *)sender {
    [ShareSDK cancelAuthWithType:ShareTypeSinaWeibo];
    [ShareSDK cancelAuthWithType:ShareTypeQQSpace];
    [ShareSDK cancelAuthWithType:ShareTypeWeixiSession];
}


@end
