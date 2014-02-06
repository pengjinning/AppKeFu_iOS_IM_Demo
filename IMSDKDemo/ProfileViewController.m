//
//  ProfileViewController.m
//  IMSDKDemo
//
//  Created by jack on 13-11-28.
//  Copyright (c) 2013年 appkefu.com. All rights reserved.
//

#import "ProfileViewController.h"
#import "ChangeProfileViewController.h"
#import "WTStatusBar.h"
#import "AppKeFuIMSDK.h"

@interface ProfileViewController ()<UIActionSheetDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate>

@end

@implementation ProfileViewController

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
    
    self.title = [[AppKeFuIMSDK sharedInstance] getUsername];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(notifyMessage:) name:APPKEFU_NOTIFICATION_MESSAGE object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(notifyMUCMessage:) name:APPKEFU_NOTIFICATION_MUC_MESSAGE object:nil];
    
    [self.tableView reloadData];
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

#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0)
    {
        return 3;
    }
    else if (section == 1)
    {
        return 4;
    }
    else if(section == 2)
    {
        return 3;
    }
    
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = nil;
    
    // Configure the cell...
    if (indexPath.section == 0) {
        
        if (indexPath.row == 0) {
            
            static NSString *CellIdentifier = @"avatarCell";
            cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
            
            if (cell == nil) {
                // Create a cell to display an ingredient.
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier];
                cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            }
            
            cell.textLabel.text = [[AppKeFuIMSDK sharedInstance] getUsername];
            
            UIImage *avatar = [[AppKeFuIMSDK sharedInstance] getAVatar];
            if (avatar == nil)
            {
                avatar = [UIImage imageNamed:@"AppKeFuResources.bundle/sharemore_friendcard"];
            }
            
            UIImageView *avatarView = [[UIImageView alloc] initWithImage:avatar];
            [avatarView setFrame:CGRectMake(0, 0, 34, 34)];
            cell.accessoryView = avatarView;

        }
        else if (indexPath.row == 1) {
        
#warning 有待优化 建议改为异步获取网络头像
            static NSString *CellIdentifier = @"urlavatarCell";
            cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
            
            if (cell == nil) {
                // Create a cell to display an ingredient.
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier];
                cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            }
            
            cell.textLabel.text = @"设置网络URL头像";
            
            
            NSString *avatarURL = [[AppKeFuIMSDK sharedInstance] getAvatarURL];
            
            UIImage *avatar = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:avatarURL]]];
            if (avatar == nil)
            {
                avatar = [UIImage imageNamed:@"AppKeFuResources.bundle/sharemore_friendcard"];
            }
            
            UIImageView *avatarView = [[UIImageView alloc] initWithImage:avatar];
            [avatarView setFrame:CGRectMake(0, 0, 34, 34)];
            cell.accessoryView = avatarView;
            
        }
        else if (indexPath.row == 2) {
            
            static NSString *CellIdentifier = @"nicknameCell";
            cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
            
            if (cell == nil) {
                // Create a cell to display an ingredient.
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier];
                cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            }
            
            cell.textLabel.text = @"我的昵称";
            cell.detailTextLabel.text = [[AppKeFuIMSDK sharedInstance] myNickname];
        }
        
    }
    else if (indexPath.section == 1) {
        
        if (indexPath.row == 0) {
            
            static NSString *CellIdentifier = @"SignatureCell";
            cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
            
            if (cell == nil) {
                // Create a cell to display an ingredient.
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier];
                cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            }
            
            cell.textLabel.text = @"个性签名";
            cell.detailTextLabel.text = [[AppKeFuIMSDK sharedInstance] getMSignature];
            
        } else if(indexPath.row == 1) {
            
            static NSString *CellIdentifier = @"JobCell";
            cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
            if (cell == nil) {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier];
                cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            }
            
            cell.textLabel.text = @"职业";
            cell.detailTextLabel.text = [[AppKeFuIMSDK sharedInstance] getJob];
            
        } else if (indexPath.row == 2) {
            
            static NSString *CellIdentifier = @"CompanyCell";
            cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
            if (cell == nil) {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier];
                cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            }
            
            cell.textLabel.text = @"公司";
            cell.detailTextLabel.text = [[AppKeFuIMSDK sharedInstance] getCompany];
            
        } else if (indexPath.row == 3) {
            
            static NSString *CellIdentifier = @"JobCell";
            cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
            if (cell == nil) {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier];
                cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            }
            
            cell.textLabel.text = @"学校";
            cell.detailTextLabel.text = [[AppKeFuIMSDK sharedInstance] getSchool];
        }
    }
    else if (indexPath.section == 2) {
        
        if (indexPath.row == 0) {
            
            static NSString *CellIdentifier = @"InterestCell";
            cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
            if (cell == nil) {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier];
                cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            }
            
            cell.textLabel.text = @"兴趣爱好";
            cell.detailTextLabel.text = [[AppKeFuIMSDK sharedInstance] getInterest];
            
        } else if (indexPath.row == 1) {
            
            static NSString *CellIdentifier = @"DailyplaceCell";
            cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
            if (cell == nil) {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier];
                cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            }
            
            cell.textLabel.text = @"常出没的地方";
            cell.detailTextLabel.text = [[AppKeFuIMSDK sharedInstance] getDailyLocation];
            
        } else if (indexPath.row == 2) {
            
            static NSString *CellIdentifier = @"PersonalCell";
            cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
            if (cell == nil) {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier];
                cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            }
            
            cell.textLabel.text = @"个人说明";
            cell.detailTextLabel.text = [[AppKeFuIMSDK sharedInstance] getPersonalNote];
        }
    }
    
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0)
    {
        if (indexPath.row == 0)
        {
            UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"设置头像" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"相册",@"拍照", nil];
            [actionSheet showInView:self.view];
        }
        else if (indexPath.row == 1)
        {
            //
            NSLog(@"通过URL设置头像");
            [[AppKeFuIMSDK sharedInstance] setAvatar:@"http://appkefu.com/AppKeFu/images/faces/appkefu_f000.png"];
            
            //设置完头像之后，刷新tableview
            [self.tableView reloadData];
        }
        else if (indexPath.row == 2)
        {
            UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
            
            ChangeProfileViewController *changeVC = [[ChangeProfileViewController alloc] initWithStyle:UITableViewStyleGrouped];
            changeVC.fieldTitle = cell.textLabel.text;
            changeVC.fieldCont = cell.detailTextLabel.text;
            [self.navigationController pushViewController:changeVC animated:YES];
            
            [tableView deselectRowAtIndexPath:indexPath animated:YES];
        }
        
    }
    else
    {
        UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    
        ChangeProfileViewController *changeVC = [[ChangeProfileViewController alloc] initWithStyle:UITableViewStyleGrouped];
        changeVC.fieldTitle = cell.textLabel.text;
        changeVC.fieldCont = cell.detailTextLabel.text;
        [self.navigationController pushViewController:changeVC animated:YES];
    
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
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
        
        NSString *fileName = [[info objectForKey:UIImagePickerControllerReferenceURL] absoluteString];
        NSArray *temp = [fileName componentsSeparatedByString:@"&ext="];
        NSString *suffix = [temp lastObject];
        
        NSLog(@"suffix:%@",suffix);
        
        [[AppKeFuIMSDK sharedInstance] setAvatar:image suffix:suffix];
        
	}
	else
	{
		NSLog(@"Error media type");
		return;
	}
    
    [self.tableView reloadData];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    NSLog(@"%s",__FUNCTION__);
    [picker dismissViewControllerAnimated:YES completion:^{}];
}

@end


