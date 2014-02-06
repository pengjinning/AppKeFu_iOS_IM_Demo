//
//  RegisterViewController.m
//  IMSDKDemo
//
//  Created by jack on 13-11-28.
//  Copyright (c) 2013年 appkefu.com. All rights reserved.
//

#import "RegisterViewController.h"

@interface RegisterViewController ()<UITextFieldDelegate>

@end

@implementation RegisterViewController

@synthesize usernameTextField, passwordTextField, repasswordTextField;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
        self.title = @"注册";
        
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
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(isRegistered:) name:APPKEFU_IS_REGISTER_SUCCEED_NOTIFICATION object:nil];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:APPKEFU_IS_REGISTER_SUCCEED_NOTIFICATION object:nil];
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
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
//#warning Incomplete method implementation.
    // Return the number of rows in the section.
    if (section == 0) {
        return 3;
    }
    
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    // Configure the cell...
    if (!cell){
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    if (indexPath.section == 0) {
        
        if (indexPath.row == 0)
        {
            usernameTextField = [[UITextField alloc] initWithFrame:CGRectMake(10, 7, 290, 30)];
            usernameTextField.placeholder = @"请输入用户名";
            usernameTextField.borderStyle = UITextBorderStyleNone;
            usernameTextField.clearButtonMode = UITextFieldViewModeAlways;
            usernameTextField.keyboardType = UIKeyboardTypeASCIICapable;
            usernameTextField.autocapitalizationType = UITextAutocapitalizationTypeNone;
            usernameTextField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
            usernameTextField.delegate = self;
            usernameTextField.returnKeyType = UIReturnKeyNext;
            [cell.contentView addSubview:usernameTextField];
        }
        else if(indexPath.row == 1)
        {
            passwordTextField = [[UITextField alloc] initWithFrame:CGRectMake(10, 7, 290, 30)];
            passwordTextField.placeholder = @"请输入密码";
            passwordTextField.borderStyle = UITextBorderStyleNone;
            passwordTextField.clearButtonMode = UITextFieldViewModeAlways;
            passwordTextField.keyboardType = UIKeyboardTypeASCIICapable;
            passwordTextField.autocapitalizationType = UITextAutocapitalizationTypeNone;
            passwordTextField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
            passwordTextField.secureTextEntry = TRUE;
            passwordTextField.delegate = self;
            passwordTextField.returnKeyType = UIReturnKeyNext;
            [cell.contentView addSubview:passwordTextField];
        }
        else
        {
            repasswordTextField = [[UITextField alloc] initWithFrame:CGRectMake(10, 7, 290, 30)];
            repasswordTextField.placeholder = @"请输入确认密码";
            repasswordTextField.borderStyle = UITextBorderStyleNone;
            repasswordTextField.clearButtonMode = UITextFieldViewModeAlways;
            repasswordTextField.keyboardType = UIKeyboardTypeASCIICapable;
            repasswordTextField.autocapitalizationType = UITextAutocapitalizationTypeNone;
            repasswordTextField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
            repasswordTextField.secureTextEntry = TRUE;
            repasswordTextField.delegate = self;
            repasswordTextField.returnKeyType = UIReturnKeyGo;
            [cell.contentView addSubview:repasswordTextField];
        }
    }
    else
    {
        cell.textLabel.text = @"注册";
        cell.textLabel.textAlignment = NSTextAlignmentCenter;
    }
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 1) {
        
        if ([[[usernameTextField text] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] length] < 6 || [[[passwordTextField text] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] length] < 6)
        {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"用户名或密码的长度至少为6" delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil];
            [alert show];
            
            [tableView deselectRowAtIndexPath:indexPath animated:YES];

            return;
        }
        
        if (![[passwordTextField text] isEqualToString:[repasswordTextField text]]) {
            
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"输入的两次密码不统一" delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil];
            [alert show];
            
            [tableView deselectRowAtIndexPath:indexPath animated:YES];

            return;
        }
        
        if ([[AppKeFuIMSDK sharedInstance] isConnected]) {
            
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"目前已经登录，请先退出登录，再注册新用户" delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil];
            [alert show];
            
            return;
        }
        
        [[AppKeFuIMSDK sharedInstance] registerWithUsername:[usernameTextField text] password:[passwordTextField text] inView:self.view];
    }
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark UITextFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    
    if (textField == usernameTextField) {
        [passwordTextField becomeFirstResponder];
        return FALSE;
    }
    else if (textField == passwordTextField) {
        [repasswordTextField becomeFirstResponder];
        return FALSE;
    }
    
    if ([[[usernameTextField text] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] length] < 6 || [[[passwordTextField text] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] length] < 6)
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"用户名或密码的长度至少为6" delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil];
        [alert show];
        
        return FALSE;
    }
    
    if (![[passwordTextField text] isEqualToString:[repasswordTextField text]]) {
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"输入的两次密码不统一" delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil];
        [alert show];
        
        return FALSE;
    }
    
    if ([[AppKeFuIMSDK sharedInstance] isConnected]) {
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"目前已经登录，请先退出登录，再注册新用户" delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil];
        [alert show];
        
        return FALSE;
    }
    
    [[AppKeFuIMSDK sharedInstance] registerWithUsername:[usernameTextField text] password:[passwordTextField text] inView:self.view];
    
    return YES;
}

#pragma mark APPKEFU_IS_REGISTER_SUCCEED_NOTIFICATION
- (void)isRegistered:(NSNotification*)notification
{
    NSNumber *isConnected = [notification object];
    if ([isConnected boolValue])
    {
        NSLog(@"%s register succeed", __FUNCTION__);
        //
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:IS_USERNAME_SET];
        [[NSUserDefaults standardUserDefaults] setValue:[usernameTextField text] forKey:USERNAME];
        [[NSUserDefaults standardUserDefaults] setValue:[passwordTextField text] forKey:PASSWORD];
 
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"注册成功" delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil];
        [alert show];
        
        [self.navigationController popViewControllerAnimated:YES];
    }
    else
    {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"注册失败" delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil];
        [alert show];
    }
}


@end
