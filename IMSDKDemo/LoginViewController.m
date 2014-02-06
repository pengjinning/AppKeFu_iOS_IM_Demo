//
//  LoginViewController.m
//  IMSDKDemo
//
//  Created by jack on 13-11-28.
//  Copyright (c) 2013年 appkefu.com. All rights reserved.
//

#import "LoginViewController.h"
#import "RegisterViewController.h"

@interface LoginViewController ()<UITextFieldDelegate>


@end

@implementation LoginViewController

@synthesize usernameTextField, passwordTextField;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
        self.title = @"登录";
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
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(isConnected:) name:APPKEFU_IS_LOGIN_SUCCEED_NOTIFICATION object:nil];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
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
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
//#warning Incomplete method implementation.
    // Return the number of rows in the section.
    return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    // Configure the cell...
    if (!cell){
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    if (indexPath.section == 0)
    {
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
            usernameTextField.text = [[NSUserDefaults standardUserDefaults] stringForKey:USERNAME];
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
            passwordTextField.returnKeyType = UIReturnKeyGo;
            passwordTextField.text = [[NSUserDefaults standardUserDefaults] stringForKey:PASSWORD];
            [cell.contentView addSubview:passwordTextField];
        }
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    else if (indexPath.section == 1)
    {
        if (indexPath.row == 0)
        {
            cell.textLabel.text = @"登录";
            cell.textLabel.textAlignment = NSTextAlignmentCenter;
        }
        else
        {
            cell.textLabel.text = @"注册";
            cell.textLabel.textAlignment = NSTextAlignmentCenter;
        }
    }
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 1) {
        
        if (indexPath.row == 0) {
            
            if ([usernameTextField.text length] && [passwordTextField.text length]) {
                
                if ([[AppKeFuIMSDK sharedInstance] isConnected]) {
                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示"
                                                                    message:@"已经登录,无需重复登录"
                                                                   delegate:nil
                                                          cancelButtonTitle:@"确定"
                                                          otherButtonTitles: nil];
                    [alert show];
                    return;
                }
                //登录
                [[AppKeFuIMSDK sharedInstance] loginWithUsername:usernameTextField.text
                                                        password:passwordTextField.text
                                                          inView:self.view];
            }
            else
            {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"用户名或密码不能为空" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
                [alert show];
            }
            
            [self.view endEditing:YES];
            
        }
        else
        {
            RegisterViewController *registerVC = [[RegisterViewController alloc] initWithStyle:UITableViewStyleGrouped];
            [self.navigationController pushViewController:registerVC animated:YES];
        }
    }
}

#pragma mark UITextFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    
    if (textField == usernameTextField) {
        [passwordTextField becomeFirstResponder];
    }
    
    if (textField == passwordTextField) {
        [passwordTextField resignFirstResponder];
        
        if ([usernameTextField.text length] && [passwordTextField.text length]) {
            
            if ([[AppKeFuIMSDK sharedInstance] isConnected]) {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"已经登录,无需重复登录" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
                [alert show];
                return FALSE;
            }
            
            //登录
            [[AppKeFuIMSDK sharedInstance] loginWithUsername:usernameTextField.text password:passwordTextField.text inView:self.view];
            
        }
    }
    
    return YES;
}


#pragma mark 登录成功/失败通知
- (void)isConnected:(NSNotification*)notification
{
    NSNumber *isConnected = [notification object];
    if ([isConnected boolValue])
    {
        NSLog(@"%s login succeed", __FUNCTION__);
        
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:IS_USERNAME_SET];
        [[NSUserDefaults standardUserDefaults] setValue:[usernameTextField text] forKey:USERNAME];
        [[NSUserDefaults standardUserDefaults] setValue:[passwordTextField text] forKey:PASSWORD];
        
        //
        [self dismissViewControllerAnimated:YES completion:^{
            
        }];
        
        [self.navigationController popViewControllerAnimated:YES];
    }
    else
    {
        NSLog(@"%s login failed", __FUNCTION__);
        
        [[NSUserDefaults standardUserDefaults] setBool:FALSE forKey:IS_USERNAME_SET];
        
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"用户名或密码错误" delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil];
        [alert show];
    }
}

@end
