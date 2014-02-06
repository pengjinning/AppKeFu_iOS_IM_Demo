//
//  ViewController.m
//  IMSDKDemo
//
//  Created by jack on 13-9-24.
//  Copyright (c) 2013年 appkefu.com. All rights reserved.
//

#import "ViewController.h"

#import "AppKeFuIMSDK.h"

#define UIViewAutoresizingFlexibleMargins 45

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    self.title = @"登录中...";
    
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
	[button setBackgroundImage:[[UIImage imageNamed:@"AppKeFuResources.bundle/custom-button-normal.png"] stretchableImageWithLeftCapWidth:8 topCapHeight:0]
					  forState:UIControlStateNormal];
	button.titleLabel.font = [UIFont boldSystemFontOfSize:14];
	button.frame = CGRectMake(85, 125, 143, 44);
	button.autoresizingMask = UIViewAutoresizingFlexibleMargins;
    [button setTitle:@"与admin聊天(在线)" forState:UIControlStateNormal];

	
	[button addTarget:self action:@selector(buttonWasPressed:) forControlEvents:UIControlEventTouchUpInside];
	[self.view addSubview:button];

    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(messageReceived:)
                                                 name:APPKEFU_NOTIFICATION_MESSAGE
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(isConnected:)
                                                 name:APPKEFU_IS_LOGIN_SUCCEED_NOTIFICATION
                                               object:nil];
    
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)buttonWasPressed:(id)sender
{
    NSString *friendUsername = @"admin";
    [[AppKeFuIMSDK sharedInstance] showChatViewController:self.navigationController withKefuUsername:friendUsername hidesBottomBarWhenPushed:YES withTitle:friendUsername];
    
    //[[AppKeFuIMSDK sharedInstance] sendTextMessage:@"发送自定义消息_ios" to:@"admin"];

    //设置昵称，请将其放在合适的位置
    //[[AppKeFuIMSDK sharedInstance] setNickName:@"我的昵称"];
    
    
}


#pragma mark 接收消息通知
- (void)messageReceived:(NSNotification *)notification
{
    KFMessageItem *msgItem = [notification object];
    
    if (msgItem.isSendFromMe)
    {
        NSLog(@"消息发送给: %@, 消息内容：%@, 发送时间：%@",msgItem.username, msgItem.messageContent, msgItem.timestamp);
    }
    else
    {
        NSLog(@"消息来自于: %@, 消息内容：%@, 发送时间：%@",msgItem.username, msgItem.messageContent, msgItem.timestamp);
    }
    
    switch (msgItem.messageType) {
        case KFMessageText:
            NSLog(@"消息类型：文本");
            break;
        case KFMessageImageHTTPURL:
            NSLog(@"消息类型：图片(地址)");
            break;
        case KFMessageSoundHTTPURL:
            NSLog(@"消息类型：语音(地址)");
            break;
        default:
            break;
    }
}

//接收是否登录成功通知
- (void)isConnected:(NSNotification*)notification
{
    NSNumber *isConnected = [notification object];
    if ([isConnected boolValue])
    {
        //登录成功
        self.title = @"登录成功";
    }
    else
    {
        //登录失败
        self.title = @"登录失败";
    }
}

@end






