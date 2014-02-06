//
//  MUCJoinViewController.m
//  IMSDKDemo
//
//  Created by jack on 13-12-14.
//  Copyright (c) 2013年 appkefu.com. All rights reserved.
//

#import "MUCJoinViewController.h"
#import "WTStatusBar.h"

@interface MUCJoinViewController ()<UITextFieldDelegate>

@property(nonatomic, strong) UITextField *myTextField;
@property(nonatomic, strong) UIButton    *joinButton;

@end

@implementation MUCJoinViewController

@synthesize mKind;
@synthesize myTextField, joinButton;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
        
        mKind = 1;

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
    
    joinButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 44, 34)];
    [joinButton setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [joinButton addTarget:self
                   action:@selector(joinRoom:)
         forControlEvents:UIControlEventTouchUpInside];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:joinButton];
    
    if (mKind == 1) {
        
        self.title = @"创建群";
        
        [joinButton setTitle:@"创建" forState:UIControlStateNormal];
    }
    else if (mKind == 2) {
        self.title = @"加入群";
        
        [joinButton setTitle:@"加入" forState:UIControlStateNormal];
    }
    else if (mKind == 3) {
        self.title = @"邀请加入";
        
        [joinButton setTitle:@"邀请" forState:UIControlStateNormal];
    }
    
    
    //self.tableView.allowsSelection = NO;
	//self.tableView.allowsSelectionDuringEditing = NO;
    
    UITapGestureRecognizer *singleFingerTap =
    [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleSingleTap:)];
    [self.view addGestureRecognizer:singleFingerTap];
    
}

-(void)joinRoom:(UIButton *)sender
{
    
    if (mKind == 1) {
        
        [[AppKeFuIMSDK sharedInstance] joinRoom:[myTextField text] withNickname:[[AppKeFuIMSDK sharedInstance] getUsername]];
        
    }
    else if (mKind == 2) {
        
        [[AppKeFuIMSDK sharedInstance] joinRoom:[myTextField text] withNickname:[[AppKeFuIMSDK sharedInstance] getUsername]];
        
    }
    else if (mKind == 3) {
        
        //
        NSString *testRoomName = @"weiyuroom";
        [[AppKeFuIMSDK sharedInstance] inviteUser:[myTextField text] withRoomName:testRoomName withReason:@"邀请TA的理由"];
        
    }
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
    if (!cell){
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    
    myTextField = [[UITextField alloc] initWithFrame:CGRectMake(10, 7, 290, 30)];
    if (mKind == 1) {
        myTextField.placeholder = @"请输入要创建群名称";
    }
    else if (mKind == 2) {
        myTextField.placeholder = @"请输入要加入群名称";
        myTextField.text = @"weiyuroom";
    }
    else if (mKind == 3) {
        myTextField.placeholder = @"请输入要邀请人的用户名";
    }
    
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
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"不能为空哦" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
        
        return FALSE;
    }
    
    if (mKind == 1) {
        
        [[AppKeFuIMSDK sharedInstance] joinRoom:[myTextField text] withNickname:[[AppKeFuIMSDK sharedInstance] getUsername]];
        
    }
    else if (mKind == 2) {
        
        [[AppKeFuIMSDK sharedInstance] joinRoom:[myTextField text] withNickname:[[AppKeFuIMSDK sharedInstance] getUsername]];
        
    }
    else if (mKind == 3) {
        
        //
        NSString *testRoomName = @"weiyuroom";
        [[AppKeFuIMSDK sharedInstance] inviteUser:[myTextField text] withRoomName:testRoomName withReason:@"邀请TA的理由"];
        
    }

    
    return YES;
}

#pragma mark
- (void)handleSingleTap:(UIGestureRecognizer *)gestureRecognizer
{
    [self.view endEditing:YES];
}


@end



