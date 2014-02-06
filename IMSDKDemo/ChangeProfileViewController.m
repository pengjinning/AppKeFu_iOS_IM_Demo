//
//  ChangeProfileViewController.m
//  IMSDKDemo
//
//  Created by jack on 13-11-28.
//  Copyright (c) 2013年 appkefu.com. All rights reserved.
//

#import "ChangeProfileViewController.h"
#import "WTStatusBar.h"

@interface ChangeProfileViewController ()<UITextFieldDelegate>

@property(nonatomic,strong) UITextField *myTextField;

@end

@implementation ChangeProfileViewController

@synthesize fieldTitle,fieldCont, myTextField;

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
    
    self.tableView.allowsSelection = NO;
	self.tableView.allowsSelectionDuringEditing = NO;
    
    self.title = fieldTitle;
    
    UITapGestureRecognizer *singleFingerTap =
    [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleSingleTap:)];
    [self.view addGestureRecognizer:singleFingerTap];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(notifyMessage:) name:APPKEFU_NOTIFICATION_MESSAGE object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(notifyMUCMessage:) name:APPKEFU_NOTIFICATION_MUC_MESSAGE object:nil];
    
    if (myTextField != nil) {
        [myTextField becomeFirstResponder];
    }
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
    // Configure the cell...
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    else
    {
        // the cell is being recycled, remove old embedded controls
        UIView *viewToRemove = nil;
        viewToRemove = [cell.contentView viewWithTag:5];
        if (viewToRemove)
            [viewToRemove removeFromSuperview];
    }
    
    
    myTextField = [[UITextField alloc] initWithFrame:CGRectMake(10, 7, 290, 30)];
    myTextField.placeholder = fieldTitle;
    if (![fieldCont isEqualToString:@"暂未设置"]) {
        myTextField.text = fieldCont;
    }
    
    myTextField.tag = 5;
    myTextField.borderStyle = UITextBorderStyleNone;
    myTextField.clearButtonMode = UITextFieldViewModeAlways;
    myTextField.keyboardType = UIKeyboardTypeDefault;
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
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"内容不能为空哦" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
        
        return FALSE;
    }
    
    NSString *fieldContent = [myTextField text];
    if ([fieldTitle isEqualToString:@"我的昵称"]) {
        
        [[AppKeFuIMSDK sharedInstance] setNickName: fieldContent];
    }
    else if ([fieldTitle isEqualToString:@"个性签名"]) {
        
        [[AppKeFuIMSDK sharedInstance] setMSignature: fieldContent];
    }
    else if ([fieldTitle isEqualToString:@"职业"])
    {
        [[AppKeFuIMSDK sharedInstance] setJob:fieldContent];
    }
    else if ([fieldTitle isEqualToString:@"公司"])
    {
        [[AppKeFuIMSDK sharedInstance] setCompany:fieldContent];
    }
    else if ([fieldTitle isEqualToString:@"学校"])
    {
        [[AppKeFuIMSDK sharedInstance] setSchool:fieldContent];
    }
    else if ([fieldTitle isEqualToString:@"兴趣爱好"])
    {
        [[AppKeFuIMSDK sharedInstance] setInterest:fieldContent];
    }
    else if ([fieldTitle isEqualToString:@"常出没的地方"])
    {
        [[AppKeFuIMSDK sharedInstance] setDailyLocation:fieldContent];
    }
    else if ([fieldTitle isEqualToString:@"个人说明"])
    {
        [[AppKeFuIMSDK sharedInstance] setPersonalNote:fieldContent];
    }
    
    [myTextField resignFirstResponder];
    [self.navigationController popViewControllerAnimated:YES];
    
    return YES;
}

#pragma mark
- (void)handleSingleTap:(UIGestureRecognizer *)gestureRecognizer
{
    [self.view endEditing:YES];
}


@end
