//
//  HistoryViewController.m
//  IMSDKDemo
//
//  Created by jack on 13-11-28.
//  Copyright (c) 2013年 appkefu.com. All rights reserved.
//

#import "HistoryViewController.h"
#import "WTStatusBar.h"
#import "KFModels.h"
#import "PrettyDrawing.h"
#import "PrettyTableViewCell.h"

#define start_color [UIColor colorWithHex:0xFEFEFE]
#define end_color [UIColor colorWithHex:0xEFEFEB]

#define UNREAD_DOT_IMAGE_VIEW_TAG              100
#define LAST_MESSAGE_TEXT_LABEL_TAG            101
#define LAST_MESSAGE_SENT_DATE_LABEL_TAG       102
#define USERS_NAMES_LABEL_TAG                  103
#define UNREAD_MESSAGE_COUNT_BADGE_TAG         104

#define LAST_MESSAGE_TEXT_FONT_SIZE            14
#define LAST_MESSAGE_SENT_DATE_FONT_SIZE       14
#define LAST_MESSAGE_SENT_DATE_AM_PM_FONT_SIZE 12
#define USERS_NAMES_FONT_SIZE                  17

@interface HistoryViewController ()<UIAlertViewDelegate>

@property (nonatomic, strong) NSMutableArray *contentData;
@property (nonatomic, strong) KFConversationItem *deleteConverItem;

@end

@implementation HistoryViewController

@synthesize contentData, deleteConverItem;

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
    
    self.title = @"历史消息记录";
    
    self.tableView.rowHeight = 64;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(messageReceived:) name:APPKEFU_NOTIFICATION_MESSAGE object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(notifyMUCMessage:) name:APPKEFU_NOTIFICATION_MUC_MESSAGE object:nil];
    
    contentData = [[AppKeFuIMSDK sharedInstance] getConversationList];
    
    [self.tableView reloadData];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:APPKEFU_NOTIFICATION_MESSAGE object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:APPKEFU_NOTIFICATION_MUC_MESSAGE object:nil];

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
    return [contentData count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    PrettyTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[PrettyTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        cell.tableViewBackgroundColor = tableView.backgroundColor;
        cell.gradientStartColor = start_color;
        cell.gradientEndColor = end_color;
        
        // Create lastMessageTextLabel.
        UILabel *lastMessageTextLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        lastMessageTextLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        lastMessageTextLabel.tag = LAST_MESSAGE_TEXT_LABEL_TAG;
        lastMessageTextLabel.backgroundColor = tableView.backgroundColor;     // speeds scrolling
        lastMessageTextLabel.textColor = [UIColor grayColor];
        lastMessageTextLabel.highlightedTextColor = [UIColor clearColor];
        lastMessageTextLabel.font = [UIFont systemFontOfSize:LAST_MESSAGE_TEXT_FONT_SIZE];
        lastMessageTextLabel.numberOfLines = 1;//2;
        [cell.contentView addSubview:lastMessageTextLabel];
        
        // Create lastMessageSentDateLabel.
        UILabel *lastMessageSentDateLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        lastMessageSentDateLabel.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin;
        lastMessageSentDateLabel.tag = LAST_MESSAGE_SENT_DATE_LABEL_TAG;
        lastMessageSentDateLabel.backgroundColor = tableView.backgroundColor; // speeds scrolling
        lastMessageSentDateLabel.textColor = [UIColor colorWithRed:52/255.0f green:111/255.0f blue:212/255.0f alpha:1];
        lastMessageSentDateLabel.highlightedTextColor = tableView.backgroundColor;
        lastMessageSentDateLabel.textAlignment = NSTextAlignmentRight;
        [cell.contentView addSubview:lastMessageSentDateLabel];
        
        // Create usersNamesLabel.
        UILabel *usersNamesLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        usersNamesLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        usersNamesLabel.tag = USERS_NAMES_LABEL_TAG;
        usersNamesLabel.backgroundColor = tableView.backgroundColor;          // speeds scrolling
        usersNamesLabel.highlightedTextColor = tableView.backgroundColor;
        usersNamesLabel.font = [UIFont boldSystemFontOfSize:USERS_NAMES_FONT_SIZE];
        [cell.contentView addSubview:usersNamesLabel];
        
        UILabel *badge = [[UILabel alloc]initWithFrame:CGRectZero];
        badge.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        badge.tag = UNREAD_MESSAGE_COUNT_BADGE_TAG;
        badge.backgroundColor = tableView.backgroundColor;
        badge.highlightedTextColor = tableView.backgroundColor;
        badge.font = [UIFont boldSystemFontOfSize:USERS_NAMES_FONT_SIZE];
        [cell.contentView addSubview:badge];
    }
    
    KFConversationItem *item = (KFConversationItem*)[contentData objectAtIndex:indexPath.row];
    UIImage *headImage = [[AppKeFuIMSDK sharedInstance] getAVatarOf:item.username];
    if (headImage != nil)
    {
        cell.imageView.image = headImage;
    }
    else
    {
        cell.imageView.image = [UIImage imageNamed:@"defaultHeader"];
    }
    
    //圆角
    cell.imageView.layer.cornerRadius = 9.0;
    cell.imageView.layer.masksToBounds = YES;
    cell.imageView.layer.borderColor = [UIColor colorWithWhite:0.0 alpha:0.2].CGColor;
    cell.imageView.layer.borderWidth = 1.0;
    
    //cell.textLabel.text = item.username;
    //cell.detailTextLabel.text = [NSString stringWithFormat:@"%@:%@",item.mostRecentMessageBody,item.mostRecentMessageTimestamp];
    
    [self configureCell:cell withConversation:item];
    
    return cell;
}


- (void)configureCell:(UITableViewCell *)cell withConversation:(KFConversationItem *)conversation {
    // Configure unreadDotImageView
    //未读消息数目
    UILabel *badge = (UILabel*)[cell viewWithTag:UNREAD_MESSAGE_COUNT_BADGE_TAG];
    CGSize badgeSize = [[conversation.unreadMessagesCount stringValue] sizeWithFont:[UIFont boldSystemFontOfSize: 11]];
    CGRect badgeframe = CGRectMake(cell.frame.size.width - (badgeSize.width + 25),
                                   25,
                                   badgeSize.width + 13,
                                   18);
    badge.frame = badgeframe;
    badge.text = [conversation.unreadMessagesCount stringValue];
    badge.backgroundColor = [UIColor clearColor];
    
    // Configure lastMessageTextLabel.
    //最新消息
    UILabel *lastMessageTextLabel = (UILabel *)[cell.contentView viewWithTag:LAST_MESSAGE_TEXT_LABEL_TAG];
    CGFloat lastMessageTextLabelWidth = cell.contentView.frame.size.width-120;
    lastMessageTextLabel.frame = CGRectMake(63, 25, lastMessageTextLabelWidth, (([conversation.mostRecentMessageBody sizeWithFont:lastMessageTextLabel.font].width > lastMessageTextLabelWidth) ? 36 : 18));
    lastMessageTextLabel.text = conversation.mostRecentMessageBody;
    lastMessageTextLabel.lineBreakMode = NSLineBreakByWordWrapping|NSLineBreakByTruncatingTail;
    lastMessageTextLabel.backgroundColor = [UIColor clearColor];
    
    // Configure lastMessageSentDateLabel.
    //最新消息日期
    UILabel *lastMessageSentDateLabel = (UILabel *)[cell.contentView viewWithTag:LAST_MESSAGE_SENT_DATE_LABEL_TAG];
    lastMessageSentDateLabel.backgroundColor = [UIColor clearColor];
    lastMessageSentDateLabel.font = [UIFont systemFontOfSize:LAST_MESSAGE_SENT_DATE_FONT_SIZE];//boldSystemFontOfSize
    
    //获取当前日期
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *dateComponents = [calendar components:(NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit) fromDate:[NSDate date]];
    [dateComponents setDay:dateComponents.day];
    NSDate *today = [calendar dateFromComponents:dateComponents];//今天
    [dateComponents setDay:dateComponents.day-1];
    NSDate *yesterday = [calendar dateFromComponents:dateComponents];//昨天
    [dateComponents setDay:dateComponents.day-1];
    NSDate *twoDaysAgo = [calendar dateFromComponents:dateComponents];//前天
    [dateComponents setDay:dateComponents.day-5];
    NSDate *lastWeek = [calendar dateFromComponents:dateComponents];//上星期
    
    //日期优化
    NSDate *lastMessageSentDate = conversation.mostRecentMessageTimestamp;
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setTimeZone:[NSTimeZone localTimeZone]];
    NSString *stringFromDate;
    
    if([lastMessageSentDate compare:today] == NSOrderedDescending)
    {
        [formatter setDateFormat:@"HH:mm"];
        stringFromDate = [formatter stringFromDate:lastMessageSentDate];
        lastMessageSentDateLabel.text = stringFromDate;
    }
    else if ([lastMessageSentDate compare:yesterday] == NSOrderedDescending)
    {
        lastMessageSentDateLabel.text = NSLocalizedString(@"昨天", nil);
    }
    else if([lastMessageSentDate compare:twoDaysAgo] == NSOrderedDescending)
    {
        lastMessageSentDateLabel.text = NSLocalizedString(@"前天", nil);
    }
    else if ([lastMessageSentDate compare:lastWeek] == NSOrderedDescending)
    {
        [formatter setDateFormat:@"cccc"];//显示星期
        stringFromDate = [formatter stringFromDate:lastMessageSentDate];
        lastMessageSentDateLabel.text = stringFromDate;
    }
    else
    {
        [formatter setDateFormat:@"yy-MM-dd"];
        stringFromDate = [formatter stringFromDate:lastMessageSentDate];
        lastMessageSentDateLabel.text = stringFromDate;
    }
    
    CGFloat lastMessageSentDateWidth = cell.contentView.frame.size.width-31-7;
    CGFloat lastMessageSentDateLabelWidth = [lastMessageSentDateLabel.text sizeWithFont:lastMessageSentDateLabel.font].width;
    lastMessageSentDateLabel.frame = CGRectMake(31+lastMessageSentDateWidth-lastMessageSentDateLabelWidth, (conversation.mostRecentMessageBody ? 5 : 19), lastMessageSentDateLabelWidth, LAST_MESSAGE_SENT_DATE_FONT_SIZE+4);
    
    // Configure usersNamesLabel.
    //用户昵称
    UILabel *usersNamesLabel = (UILabel *)[cell.contentView viewWithTag:USERS_NAMES_LABEL_TAG];
    usersNamesLabel.frame = CGRectMake(63, (conversation.mostRecentMessageBody ? 5 : 18), 120, 20);
    usersNamesLabel.lineBreakMode = NSLineBreakByWordWrapping|NSLineBreakByTruncatingTail;
    
    if ([conversation.username isEqualToString:@"admin"])
    {
        usersNamesLabel.text = @"微客服";
    }
    else if ([conversation.username length] == 0)
    {
        usersNamesLabel.text = @"系统通知";
    }
    else
        usersNamesLabel.text = conversation.username;
    
    usersNamesLabel.backgroundColor = [UIColor clearColor];
    
}

#pragma mark - Table view delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    KFConversationItem *item = [contentData objectAtIndex:indexPath.row];
    
    if ([item.domain isEqualToString:@"appkefu.com"]) {
        
        if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7) {
            
            [[AppKeFuIMSDK sharedInstance]
             showChatViewController:self.navigationController
             withUsername:item.username
             withBubbleStyle:KFMessageStyleFlat
             withAvatarStyle:KFMessageAvatarStyleCircle
             withBackgroundImage:nil
             hidesBottomBarWhenPushed:YES
             withTitle:item.username];
        }
        else
        {
            [[AppKeFuIMSDK sharedInstance]
             showChatViewController:self.navigationController
             withUsername:item.username
             withBubbleStyle:KFMessageStyleDefault
             withAvatarStyle:KFMessageAvatarStyleCircle
             withBackgroundImage:nil
             hidesBottomBarWhenPushed:YES
             withTitle:item.username];
        }
    }
    else if([item.domain isEqualToString:@"conference.appkefu.com"])
    {
        //
        if ([[AppKeFuIMSDK sharedInstance] isRoomJoined:item.username])
        {
            [[AppKeFuIMSDK sharedInstance] showMUCChatViewController:self.navigationController
                                                        withRoomName:item.username
                                                     withBubbleStyle:KFMessageStyleFlat
                                                     withAvatarStyle:KFMessageAvatarStyleCircle
                                                 withBackgroundImage:nil
                                            hidesBottomBarWhenPushed:YES
                                                           withTitle:@"群聊测试"];
        }
        else
        {
            //
            [[AppKeFuIMSDK sharedInstance] joinRoom:item.username withNickname:[[AppKeFuIMSDK sharedInstance] getUsername]];
        }
        
    }
    
    
}

// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete)
    {
        
        deleteConverItem = [contentData objectAtIndex:indexPath.row];
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"确定要删除会话记录?" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
        [alert show];
        
	}
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1) {
        
        [[AppKeFuIMSDK sharedInstance] deleteConversationWith:deleteConverItem.username];
        
        [contentData removeObject:deleteConverItem];
        
        [self.tableView reloadData];
    }
    
}

#pragma mark 接收消息通知
- (void)messageReceived:(NSNotification *)notification
{
    NSLog(@"%s",__FUNCTION__);
    
    KFMessageItem *msgItem = [notification object];
    
    BOOL flag = FALSE;
    for (int index = 0; index < [contentData count]; index++) {
        
        KFConversationItem *indItem = [contentData objectAtIndex:index];
        if ([indItem.username isEqualToString:msgItem.username]) {
            flag = TRUE;
        }
    }
    
    if (!flag) {
        KFConversationItem *converItem = [[KFConversationItem alloc] init];
        converItem.username = msgItem.username;
        converItem.mostRecentMessageBody = msgItem.messageContent;
        converItem.mostRecentMessageTimestamp = [NSDate date];
        converItem.mostRecentMessageOutgoing = FALSE;
        [contentData addObject:converItem];
    }
    
    [WTStatusBar setStatusText:[NSString stringWithFormat:@"来自%@的消息",msgItem.username] timeout:2 animated:YES];
    
    contentData = [[AppKeFuIMSDK sharedInstance] getConversationList];
    [self.tableView reloadData];
}

- (void)notifyMUCMessage:(NSNotification *)nofication
{
    KFMessageItem *msgItem = [nofication object];
    
    [WTStatusBar setStatusText:[NSString stringWithFormat:@"来自群%@的消息",msgItem.roomName] timeout:2 animated:YES];
}

@end
