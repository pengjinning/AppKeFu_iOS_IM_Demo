//
//  PersonalProfileViewController.m
//  IMSDKDemo
//
//  Created by jack on 13-11-28.
//  Copyright (c) 2013年 appkefu.com. All rights reserved.
//

#import "FriendProfileViewController.h"
#import "WTStatusBar.h"

@interface FriendProfileViewController ()

@property (nonatomic, strong) NSMutableArray *contentData;
@property (nonatomic, strong) NSString *username;

@end

@implementation FriendProfileViewController

@synthesize username;

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
    self.title = @"好友个人资料";
    self.username = @"admin";
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
    
    [WTStatusBar setStatusText:[NSString stringWithFormat:@"来自%@的消息",msgItem.roomName] timeout:2 animated:YES];
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
            
            cell.textLabel.text = self.username;
            
            UIImage *avatar = [[AppKeFuIMSDK sharedInstance] getAVatarOf:self.username];
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
            
            
            NSString *avatarURL = [[AppKeFuIMSDK sharedInstance] getAvatarURL:self.username];
            
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
            cell.detailTextLabel.text = [[AppKeFuIMSDK sharedInstance] getNickname:self.username];
        }

        
    }
    else if (indexPath.section == 1) {
        
        if (indexPath.row == 0) {
            
            static NSString *CellIdentifier = @"SignatureCell";
            cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
            
            if (cell == nil) {
                // Create a cell to display an ingredient.
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier];
            }
            else
            {
                // the cell is being recycled, remove old embedded controls
                UIView *viewToRemove = nil;
                viewToRemove = [cell.contentView viewWithTag:1];
                if (viewToRemove)
                    [viewToRemove removeFromSuperview];
            }
            
            cell.textLabel.text = @"个性签名";
            cell.detailTextLabel.text = [[AppKeFuIMSDK sharedInstance] getMSignatureOf:username];
            
        } else if(indexPath.row == 1) {
            
            static NSString *CellIdentifier = @"JobCell";
            cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
            if (cell == nil) {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier];
            }
            
            cell.textLabel.text = @"职业";
            cell.detailTextLabel.text = [[AppKeFuIMSDK sharedInstance] getJobFor:username];
            
        } else if (indexPath.row == 2) {
            
            static NSString *CellIdentifier = @"CompanyCell";
            cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
            if (cell == nil) {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier];
            }
            
            cell.textLabel.text = @"公司";
            cell.detailTextLabel.text = [[AppKeFuIMSDK sharedInstance] getCompanyOf:username];
            
        } else if (indexPath.row == 3) {
            
            static NSString *CellIdentifier = @"JobCell";
            cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
            if (cell == nil) {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier];
            }
            
            cell.textLabel.text = @"学校";
            cell.detailTextLabel.text = [[AppKeFuIMSDK sharedInstance] getSchoolOf:username];
        }
    }
    else if (indexPath.section == 2) {
        
        if (indexPath.row == 0) {
            
            static NSString *CellIdentifier = @"InterestCell";
            cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
            if (cell == nil) {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier];
            }
            
            cell.textLabel.text = @"兴趣爱好";
            cell.detailTextLabel.text = [[AppKeFuIMSDK sharedInstance] getInterestOf:username];
            
        } else if (indexPath.row == 1) {
            
            static NSString *CellIdentifier = @"DailyplaceCell";
            cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
            if (cell == nil) {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier];
            }
            
            cell.textLabel.text = @"常出没的地方";
            cell.detailTextLabel.text = [[AppKeFuIMSDK sharedInstance] getDailyLocationOf:username];
            
        } else if (indexPath.row == 2) {
            
            static NSString *CellIdentifier = @"PersonalCell";
            cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
            if (cell == nil) {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier];
            }
            
            cell.textLabel.text = @"个人说明";
            cell.detailTextLabel.text = [[AppKeFuIMSDK sharedInstance] getPersonalNoteOf:username];
        }
    }
    
    cell.accessoryType = UITableViewCellAccessoryNone;
    
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44;
}

@end
