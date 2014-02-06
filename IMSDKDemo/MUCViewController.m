//
//  MUCViewController.m
//  IMSDKDemo
//
//  Created by jack on 13-12-14.
//  Copyright (c) 2013年 appkefu.com. All rights reserved.
//

#import "MUCViewController.h"
#import "MUCJoinViewController.h"
#import "WTStatusBar.h"

@interface MUCViewController ()<UIAlertViewDelegate>

@end

@implementation MUCViewController

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
    self.title = @"群聊";
    
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
    //return 10;
    return 2;
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
        cell.textLabel.text = @"1.加入群";
    }
    else if (indexPath.row == 1) {
        cell.textLabel.text = @"2.微客服产品群";
    }
    /*
    else if (indexPath.row == 2) {
        cell.textLabel.text = @"3.邀请加入";
    }
    else if (indexPath.row == 3) {
        cell.textLabel.text = @"4.设置群资料";
    }
    else if (indexPath.row == 4) {
        cell.textLabel.text = @"5.发送群消息";
    }
    else if (indexPath.row == 5) {
        cell.textLabel.text = @"6.获取群黑名单";
    }
    else if (indexPath.row == 6) {
        cell.textLabel.text = @"7.获取群成员";
    }
    else if (indexPath.row == 7) {
        cell.textLabel.text = @"8.获取群管理员";
    }
    else if (indexPath.row == 8) {
        cell.textLabel.text = @"9.创建群";
    }
    else if (indexPath.row == 9) {
        cell.textLabel.text = @"10.退出群";
    }*/
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *testRoomName = @"weiyuroom";
    
    if (indexPath.row == 0) {
        
        MUCJoinViewController *joinMUC = [[MUCJoinViewController alloc] initWithStyle:UITableViewStyleGrouped];
        joinMUC.mKind = 2;
        [self.navigationController pushViewController:joinMUC animated:YES];
        
    }
    else if (indexPath.row == 1) {
        
        if ([[AppKeFuIMSDK sharedInstance] isRoomJoined:testRoomName])
        {
            if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7)
            {
                [[AppKeFuIMSDK sharedInstance] showMUCChatViewController:self.navigationController
                                                            withRoomName:testRoomName
                                                         withBubbleStyle:KFMessageStyleFlat
                                                         withAvatarStyle:KFMessageAvatarStyleCircle
                                                     withBackgroundImage:nil
                                                hidesBottomBarWhenPushed:YES
                                                               withTitle:@"群聊测试"];
            }
            else
            {
                [[AppKeFuIMSDK sharedInstance] showMUCChatViewController:self.navigationController
                                                            withRoomName:testRoomName
                                                         withBubbleStyle:KFMessageStyleDefault
                                                         withAvatarStyle:KFMessageAvatarStyleCircle
                                                     withBackgroundImage:nil
                                                hidesBottomBarWhenPushed:YES
                                                               withTitle:@"群聊测试"];
            }
        }
        else
        {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:[NSString stringWithFormat:@"请先加入群%@", testRoomName] delegate:self cancelButtonTitle:@"取消" otherButtonTitles: nil];
            [alert show];
        }
    }
    /*
    else if (indexPath.row == 2) {
        
        MUCJoinViewController *inviteMUC = [[MUCJoinViewController alloc] initWithStyle:UITableViewStyleGrouped];
        inviteMUC.mKind = 3;
        [self.navigationController pushViewController:inviteMUC animated:YES];
    }
    else if (indexPath.row == 3) {
        
        [[AppKeFuIMSDK sharedInstance] getSettingsFormOf:testRoomName];
        
    }
    else if (indexPath.row == 4) {
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"确定要发送群自定义消息" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
        [alert show];
        
    }
    else if (indexPath.row == 5)
    {
        [[AppKeFuIMSDK sharedInstance] getBanListOf:testRoomName];
    }
    else if (indexPath.row == 6)
    {
        [[AppKeFuIMSDK sharedInstance] getMembersListOf:testRoomName];
    }
    else if (indexPath.row == 7)
    {
        [[AppKeFuIMSDK sharedInstance] getModeratorsListOf:testRoomName];
    }
    else if (indexPath.row == 8)
    {
        MUCJoinViewController *createMUC = [[MUCJoinViewController alloc] initWithStyle:UITableViewStyleGrouped];
        createMUC.mKind = 1;
        [self.navigationController pushViewController:createMUC animated:YES];

    }
    else if (indexPath.row == 9)
    {
    
    }*/

}

#pragma mark UIAlertViewDelegate
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    NSString *testRoomName = @"weiyuroom";
    if (buttonIndex == 1)
    {
        [[AppKeFuIMSDK sharedInstance] sendMucTextMessage:@"muc test message"
                                             withRoomName:testRoomName];
    }
}

@end










