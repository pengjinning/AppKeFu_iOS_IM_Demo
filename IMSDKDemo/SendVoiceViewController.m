//
//  SendVoiceViewController.m
//  IMSDKDemo
//
//  Created by jack on 13-12-11.
//  Copyright (c) 2013年 appkefu.com. All rights reserved.
//

#import "SendVoiceViewController.h"
#import "WTStatusBar.h"

@interface SendVoiceViewController ()

@property (nonatomic, strong) UIButton *sendVoicebutton;

@end

@implementation SendVoiceViewController

@synthesize sendVoicebutton;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    self.title = @"发送语音";
    self.view.backgroundColor = [UIColor whiteColor];
    
    sendVoicebutton = [UIButton buttonWithType:UIButtonTypeCustom];
	[sendVoicebutton setBackgroundImage:[[UIImage imageNamed:@"AppKeFuResources.bundle/custom-button-normal.png"] stretchableImageWithLeftCapWidth:8 topCapHeight:0]
					  forState:UIControlStateNormal];
	sendVoicebutton.titleLabel.font = [UIFont boldSystemFontOfSize:14];
	sendVoicebutton.frame = CGRectMake(85, 380, 143, 44);
	sendVoicebutton.autoresizingMask = 45;
    [sendVoicebutton setTitle:@"按住开始录音" forState:UIControlStateNormal];
    
    //按下按钮开始录音
    [sendVoicebutton addTarget:self action:@selector(recordStart) forControlEvents:UIControlEventTouchDown];
    //松开按钮发送语音
    [sendVoicebutton addTarget:self action:@selector(recordEndAndSendVoiceMessage) forControlEvents:UIControlEventTouchUpInside];
    //划出按钮取消发送语音
    [sendVoicebutton addTarget:self action:@selector(recordCancel) forControlEvents:UIControlEventTouchUpOutside];
    
    
	[self.view addSubview:sendVoicebutton];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(notifyMessage:) name:APPKEFU_NOTIFICATION_MESSAGE object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(notifyMUCMessage:) name:APPKEFU_NOTIFICATION_MUC_MESSAGE object:nil];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:APPKEFU_NOTIFICATION_MESSAGE object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:APPKEFU_NOTIFICATION_MUC_MESSAGE object:nil];
    
}

- (void)notifyMessage:(NSNotification *)nofication
{
    KFMessageItem *msgItem = [nofication object];

    [WTStatusBar setStatusText:[NSString stringWithFormat:@"来自%@的消息",msgItem.username] timeout:2 animated:YES];
}

- (void)notifyMUCMessage:(NSNotification *)nofication
{
    KFMessageItem *msgItem = [nofication object];
    
    [WTStatusBar setStatusText:[NSString stringWithFormat:@"来自群%@的消息",msgItem.roomName] timeout:2 animated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)recordStart
{
    sendVoicebutton.titleLabel.text = @"松开发送语音";
    
    //
    [[AppKeFuIMSDK sharedInstance] beginRecordingVoiceTo:@"admin" inView:self.view];
}

-(void)recordEndAndSendVoiceMessage
{
    sendVoicebutton.titleLabel.text = @"按住开始录音";
    
    NSInteger result = [[AppKeFuIMSDK sharedInstance] stopRecordingAndSendVoiceTo:@"admin"];
    if (result == -400001)
    {
        NSLog(@"录音长度太短(小于3秒)");
        [[AppKeFuIMSDK sharedInstance] showHUDMessage:@"录音长度太短(小于3秒)" inView:self.view];
    }
    else if (result == -400002)
    {
        NSLog(@"录音长度太长(大于60秒)");
        [[AppKeFuIMSDK sharedInstance] showHUDMessage:@"录音长度太长(大于60秒)" inView:self.view];
    }
    else if (result == -400003)
    {
        NSLog(@"语音转换失败");
        [[AppKeFuIMSDK sharedInstance] showHUDMessage:@"语音转换失败" inView:self.view];
    }
    else if (result == 0)
    {
        NSLog(@"语音发送成功");
    }
}

-(void)recordCancel
{
    sendVoicebutton.titleLabel.text = @"按住开始录音";
    
    [[AppKeFuIMSDK sharedInstance] cancelRecording];
}


@end






















