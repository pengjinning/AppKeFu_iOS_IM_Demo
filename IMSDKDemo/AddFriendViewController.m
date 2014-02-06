//
//  AddFriendViewController.m
//  IMSDKDemo
//
//  Created by jack on 13-11-28.
//  Copyright (c) 2013年 appkefu.com. All rights reserved.
//

#import "AddFriendViewController.h"
#import "WTStatusBar.h"

@interface AddFriendViewController ()<UITextFieldDelegate>

@property(nonatomic,strong) UITextField *myTextField;

@end

@implementation AddFriendViewController

@synthesize myTextField;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
        self.title = @"添加好友";
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
    self.tableView.allowsSelection = NO;
	self.tableView.allowsSelectionDuringEditing = NO;
    
    UITapGestureRecognizer *singleFingerTap =
    [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleSingleTap:)];
    [self.view addGestureRecognizer:singleFingerTap];
    
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
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    // Configure the cell...
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    myTextField = [[UITextField alloc] initWithFrame:CGRectMake(10, 7, 290, 30)];
    myTextField.placeholder = @"请输入对方用户名";
    myTextField.borderStyle = UITextBorderStyleNone;
    myTextField.clearButtonMode = UITextFieldViewModeAlways;
    myTextField.keyboardType = UIKeyboardTypeASCIICapable;
    myTextField.autocapitalizationType = UITextAutocapitalizationTypeNone;
    myTextField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    myTextField.returnKeyType = UIReturnKeyDone;
    [myTextField becomeFirstResponder];
    myTextField.delegate = self;
    [cell.contentView addSubview:myTextField];
    
    return cell;
}

#pragma mark UITextFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    
    if([[myTextField text] length] <= 0)
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"对方用户名不能为空哦" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
        
        return FALSE;
    }
    
    [[AppKeFuIMSDK sharedInstance] addFriend:[myTextField text] withNickname:[myTextField text]];
    
    UIAlertView *alertSend = [[UIAlertView alloc] initWithTitle:@"提示" message:@"添加好友请求已发送" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
    [alertSend show];
    
    return YES;
}

#pragma mark
- (void)handleSingleTap:(UIGestureRecognizer *)gestureRecognizer
{
    [self.view endEditing:YES];
}

@end
