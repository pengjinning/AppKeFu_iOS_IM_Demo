//
//  DemoViewController.m
//  IMSDKDemo
//
//  Created by jack on 13-11-28.
//  Copyright (c) 2013年 appkefu.com. All rights reserved.
//

#import "DemoViewController.h"
#import "AppKeFuIMSDK.h"
#import "LoginViewController.h"
#import "RegisterViewController.h"
#import "SendVoiceViewController.h"
#import "AddFriendViewController.h"
#import "HistoryViewController.h"
#import "ProfileViewController.h"
#import "FriendProfileViewController.h"
#import "RosterViewController.h"
#import "BlackListViewController.h"
#import "MUCViewController.h"
#import "WTStatusBar.h"

@interface DemoViewController ()<UIAlertViewDelegate,UIActionSheetDelegate,
            UIImagePickerControllerDelegate,UINavigationControllerDelegate>

@property (nonatomic, strong) NSString *loginLabelText;

@end

@implementation DemoViewController

@synthesize loginLabelText;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    self.title = @"微客服(IM Demo)";

    self.loginLabelText = @"1.登录";

}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(messageReceived:)
                                                 name:APPKEFU_NOTIFICATION_MESSAGE
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(notifyMUCMessage:)
                                                 name:APPKEFU_NOTIFICATION_MUC_MESSAGE object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(isConnected:)
                                                 name:APPKEFU_IS_LOGIN_SUCCEED_NOTIFICATION
                                               object:nil];
    
    //
    if ([[AppKeFuIMSDK sharedInstance] isConnected]) {
        //登录成功
        self.title = @"微客服(登录成功)";
        
        loginLabelText = [NSString stringWithFormat:@"1.已登录(%@)",[[NSUserDefaults standardUserDefaults] stringForKey:USERNAME]];
        [self.tableView reloadData];
    }
    
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];

    [[NSNotificationCenter defaultCenter] removeObserver:self name:APPKEFU_NOTIFICATION_MESSAGE object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:APPKEFU_NOTIFICATION_MUC_MESSAGE object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:APPKEFU_IS_LOGIN_SUCCEED_NOTIFICATION object:nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
//#warning Potentially incomplete method implementation.
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
//#warning Incomplete method implementation.
    // Return the number of rows in the section.
    return 14;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    // Configure the cell...
    if (!cell){
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    
    if (indexPath.row == 0) {
        cell.textLabel.text = loginLabelText;
    }
    else if (indexPath.row == 1) {
        cell.textLabel.text = @"2.注册";
    }
    else if (indexPath.row == 2) {
        cell.textLabel.text = @"3.聊天会话";
    }
    else if (indexPath.row == 3) {
        cell.textLabel.text = @"4.发送自定义消息";
    }
    else if (indexPath.row == 4) {
        cell.textLabel.text = @"5.发送图片";
    }
    else if (indexPath.row == 5) {
        cell.textLabel.text = @"6.发送语音";
    }
    else if (indexPath.row == 6) {
        cell.textLabel.text = @"7.添加好友";
    }
    else if (indexPath.row == 7) {
        cell.textLabel.text = @"8.历史消息记录";
    }
    else if (indexPath.row == 8) {
        cell.textLabel.text = @"9.个人资料";
    }
    else if (indexPath.row == 9) {
        cell.textLabel.text = @"10.好友个人资料";
    }
    else if (indexPath.row == 10) {
        cell.textLabel.text = @"11.黑名单";
    }
    else if (indexPath.row == 11) {
        cell.textLabel.text = @"12.好友列表";
    }
    else if (indexPath.row == 12) {
        cell.textLabel.text = @"13.群聊";
    }
    else if (indexPath.row == 13) {
        cell.textLabel.text = @"14.退出登录";
    }
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (indexPath.row == 0) {
        
        LoginViewController *loginVC = [[LoginViewController alloc] initWithStyle:UITableViewStyleGrouped];
        [self.navigationController pushViewController:loginVC animated:YES];
        
    }
    else if(indexPath.row == 1) {
        
        RegisterViewController *registerVC = [[RegisterViewController alloc] initWithStyle:UITableViewStyleGrouped];
        [self.navigationController pushViewController:registerVC animated:YES];

    }
    else if (indexPath.row == 2) {
        
        if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7) {
            
            [[AppKeFuIMSDK sharedInstance]
             showChatViewController:self.navigationController
             withUsername:@"admin"
             withBubbleStyle:KFMessageStyleFlat
             withAvatarStyle:KFMessageAvatarStyleCircle
             withBackgroundImage:nil
             hidesBottomBarWhenPushed:YES
             withTitle:@"与admin聊天中"];
        }
        else
        {
            [[AppKeFuIMSDK sharedInstance]
             showChatViewController:self.navigationController
             withUsername:@"admin"
             withBubbleStyle:KFMessageStyleDefault
             withAvatarStyle:KFMessageAvatarStyleCircle
             withBackgroundImage:nil
             hidesBottomBarWhenPushed:YES
             withTitle:@"与admin聊天中"];
        }
    }
    else if (indexPath.row == 3) {
        
        UIAlertView *alertview = [[UIAlertView alloc] initWithTitle:@"提示" message:@"确定要发送自定义消息？" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
        alertview.tag = 3;
        [alertview show];
        
    }
    else if (indexPath.row == 4) {
    
        UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"发送图片" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"相册",@"拍照", nil];
        [actionSheet showInView:self.view];
        
    }
    else if (indexPath.row == 5) {
    
        SendVoiceViewController *voiceVC = [[SendVoiceViewController alloc] init];
        [self.navigationController pushViewController:voiceVC animated:YES];
        
    }
    else if (indexPath.row == 6) {
        
        AddFriendViewController *addFriendVC = [[AddFriendViewController alloc] initWithStyle:UITableViewStyleGrouped];
        [self.navigationController pushViewController:addFriendVC animated:YES];
        
    }
    else if (indexPath.row == 7) {
        
        HistoryViewController *historyVC = [[HistoryViewController alloc] init];
        [self.navigationController pushViewController:historyVC animated:YES];
        
    }
    else if (indexPath.row == 8) {
        
        ProfileViewController *profileVC = [[ProfileViewController alloc] initWithStyle:UITableViewStyleGrouped];
        [self.navigationController pushViewController:profileVC animated:YES];
        
    }
    else if (indexPath.row == 9) {
        
        FriendProfileViewController *friendProfileVC = [[FriendProfileViewController alloc] initWithStyle:UITableViewStyleGrouped];
        [self.navigationController pushViewController:friendProfileVC animated:YES];
        
    }
    else if (indexPath.row == 10) {
        
        BlackListViewController *blackVC = [[BlackListViewController alloc] init];
        [self.navigationController pushViewController:blackVC animated:YES];
    }
    else if (indexPath.row == 11) {
        
        RosterViewController *rosterVC = [[RosterViewController alloc] init];
        [self.navigationController pushViewController:rosterVC animated:YES];
    }
    else if (indexPath.row == 12) {
        
        MUCViewController *mucVC = [[MUCViewController alloc] init];
        [self.navigationController pushViewController:mucVC animated:YES];
        
    }
    else if (indexPath.row == 13) {
        
        UIAlertView *alertview = [[UIAlertView alloc] initWithTitle:@"提示" message:@"确定要退出登录?" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
        alertview.tag = 12;
        [alertview show];
        
    }
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == 3) {
        
        if (buttonIndex == 1) {
            [[AppKeFuIMSDK sharedInstance] sendTextMessage:@"发送自定义消息_im_ios" to:@"admin"];
        }
        
    }
    else if (alertView.tag == 12) {
        if (buttonIndex == 1) {
            [[AppKeFuIMSDK sharedInstance] logout];
            
            self.title = @"已经登出";
            
            loginLabelText = @"1.登录";
            
            [self.tableView reloadData];
        }
    }
}

#pragma mark UIActionSheetDelegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    NSLog(@"%s, buttonIndex=%d",__FUNCTION__, buttonIndex);
    
    if (buttonIndex == 0) {
        [self pickPhoto];
    }
    else if (buttonIndex == 1) {
        [self takePhoto];
    }
    
}

#pragma mark 相册
- (void)pickPhoto
{
    NSLog(@"%s",__FUNCTION__);
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
	picker.delegate = self;
	picker.allowsEditing = YES;
    
    [self presentViewController:picker animated:YES completion:^{
    }];

}

- (void)takePhoto
{
    NSLog(@"%s",__FUNCTION__);
    UIImagePickerController *camera = [[UIImagePickerController alloc] init];
	camera.delegate = self;
	camera.allowsEditing = YES;
	
	//检查摄像头是否支持摄像机模式
	if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
	{
		camera.sourceType = UIImagePickerControllerSourceTypeCamera;
		camera.mediaTypes = [UIImagePickerController availableMediaTypesForSourceType:UIImagePickerControllerSourceTypeCamera];
	}
	else
	{
		NSLog(@"Camera not exist");
		return;
	}
	
    [self presentViewController:camera animated:YES completion:^{
        
    }];
}

#pragma mark UIImagePickerControllerDelegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    NSLog(@"%s",__FUNCTION__);
    
    [picker dismissViewControllerAnimated:YES completion:^{}];
	NSString *mediaType = [info objectForKey:UIImagePickerControllerMediaType];
    
	if([mediaType isEqualToString:@"public.movie"])			//被选中的是视频
	{
        
	}
	else if([mediaType isEqualToString:@"public.image"])	//被选中的是图片
	{
        //获取照片实例
		UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];

        //请将“admin”替换为实际的对方的用户名
        [[AppKeFuIMSDK sharedInstance] sendImageMessage:UIImageJPEGRepresentation(image, 0) to:@"admin"];
	}
	else
	{
		NSLog(@"Error media type");
		return;
	}
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    NSLog(@"%s",__FUNCTION__);
    [picker dismissViewControllerAnimated:YES completion:^{}];
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
            //例如：实际发送的图片消息的格式为：<img src="http://appkefu.com/Upload/testim2_to_admin_1386727189.png">
            //     SDK处理后，广播收到图片消息的格式为：http://appkefu.com/Upload/testim2_to_admin_1386727189.png
            //     实际处理的时候按照后一种格式处理即可
            break;
        case KFMessageSoundHTTPURL:
            NSLog(@"消息类型：语音(地址)");//
            break;
        default:
            break;
    }
    
    [WTStatusBar setStatusText:[NSString stringWithFormat:@"来自%@的消息",msgItem.username] timeout:2 animated:YES];

}

//接收来自群的消息
- (void)notifyMUCMessage:(NSNotification *)nofication
{
    KFMessageItem *msgItem = [nofication object];
    
    [WTStatusBar setStatusText:[NSString stringWithFormat:@"来自群%@的消息",msgItem.roomName] timeout:2 animated:YES];
}

//接收是否登录成功通知
- (void)isConnected:(NSNotification*)notification
{
    NSNumber *isConnected = [notification object];
    if ([isConnected boolValue])
    {
        //登录成功
        self.title = @"微客服(登录成功)";
        
        loginLabelText = [NSString stringWithFormat:@"1.已登录(%@)",[[NSUserDefaults standardUserDefaults] stringForKey:USERNAME]];
        [self.tableView reloadData];
    }
    else
    {
        //登录失败
        self.title = @"微客服(登录失败)";
    }
}


@end








