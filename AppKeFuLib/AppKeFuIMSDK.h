//
//  AppKeFuIMSDK.h
//  AppKeFuIMSDK
//
//  Created by jack on 13-9-20.
//  Copyright (c) 2013年 appkefu.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "KFModels.h"

#define XMPPUSERNAME                                @"appkefu_username"
#define XMPPPASSWORD                                @"appkefu_password"

//消息通知
#define APPKEFU_NOTIFICATION_MESSAGE                @"appkefu_notification_message"

//群聊消息通知
#define APPKEFU_NOTIFICATION_MUC_MESSAGE            @"appkefu_notification_muc_message"

//登录成功通知
#define APPKEFU_IS_LOGIN_SUCCEED_NOTIFICATION       @"is_appkefu_login_succeed_notification"

//注册成功通知
#define APPKEFU_IS_REGISTER_SUCCEED_NOTIFICATION    @"is_appkefu_register_succeed_notification"

//如果要禁止发送消息时播放声音，请设置此值为整数2，
//如：[[NSUserDefaults standardUserDefaults] setInteger:2 forKey:APPKEFU_SHOULD_PLAY_SEND_MESSAGE_SOUND];
#define APPKEFU_SHOULD_PLAY_SEND_MESSAGE_SOUND      @"appkefu_should_play_send_message_sound"

//如果要禁止收到消息时播放声音，请设置此值为整数2，
//如：[[NSUserDefaults standardUserDefaults] setInteger:2 forKey:APPKEFU_SHOULD_PLAY_RECEIVE_MESSAGE_SOUND];
#define APPKEFU_SHOULD_PLAY_RECEIVE_MESSAGE_SOUND   @"appkefu_should_play_receive_message_sound"

//如果要禁止收到消息时震动，请设置此值为整数2，
//如：[[NSUserDefaults standardUserDefaults] setInteger:2 forKey:APPKEFU_SHOULD_VIBRATE_ON_RECEIVE_MESSAGE];
#define APPKEFU_SHOULD_VIBRATE_ON_RECEIVE_MESSAGE   @"appkefu_should_vibrate_on_receiving_message"



@interface AppKeFuIMSDK : NSObject

/*
 配置说明：
 选中target中的Build Settings:
 1. Other Linker Flags 添加 -all_load -lstdc++
 2. (可选）Header Search Paths 添加 “/usr/include/libxml2”
 3. 如果出现[DDXMLElement compactXMLString]:unrecognized selector的情况，请在Build Settings的Other Linker Flags选项中添加-all_load

 4. 国际化具体设置步骤请参见：http://blog.csdn.net/xyz_lmn/article/details/8968191
 */

+(AppKeFuIMSDK*)sharedInstance;

//初始化
-(BOOL) initWithAppkey:(NSString*)appkey;

//注册
-(void) registerWithUsername:(NSString*)username password:(NSString*)password error:(NSError*)error;

//带有HUD提示的注册
-(void) registerWithUsername:(NSString *)username password:(NSString *)password inView:(UIView *)view;

//登录
-(void) loginWithUsername:(NSString*)username password:(NSString*)password error:(NSError*)error;

//带有HUD提示的登录
-(void) loginWithUsername:(NSString *)username password:(NSString *)password inView:(UIView *)view;

//获取当前用户的用户名
- (NSString*) getUsername;

//判断连接是否正常
-(BOOL) isConnected;

//上线
-(void) goOnline;

//离线
-(void) goOffline;

//发送自定义文字消息
-(void) sendTextMessage:(NSString*)content to:(NSString*)username;

//发送图片
-(void) sendImageMessage:(NSData*)imageData to:(NSString*)username;

//发送语音
-(void) sendVoiceMessage:(NSData*)voiceData
               soundName:(NSString *)soundName
             voiceLength:(NSString *)voiceLength
                      to:(NSString*)username;

//开始录音
-(void) beginRecordingVoiceTo:(NSString*)username inView:(UIView *)inView;

//停止录音并发送语音
//返回 -400001: 长度太短(小于3秒); -400002：长度太长(大于60秒)；-400003: 语音转换失败; 0：发送成功
-(NSInteger) stopRecordingAndSendVoiceTo:(NSString*)username;

//取消录音
-(void) cancelRecording;

//首先现在urlPath上面的amr文件，然后转换为wav文件，再播放wav语音
-(void) playSoundWithPath:(NSString*)urlPath;

//转换wav文件为amr文件，如果转换成功返回TRUE, 否则返回FALSE
//其中：pathToWAV为wav文件的路径, pathToAMR为amr文件的保存路径
-(BOOL) convertWAVToAMR:(NSString *)pathToWAV to:(NSString *)pathToAMR;

//转换amr文件为wav文件，如果转换成功返回TRUE, 否则返回FALSE
//其中：pathToAMR为amr文件的路径, pathToWAV为wav文件的保存路径
-(BOOL) convertAMRToWAV:(NSString *)pathToAMR to:(NSString *)pathToWAV;

//打开会话窗口
- (void) showChatViewController:(UINavigationController *)navController
                  withUsername:(NSString *)username
               withBubbleStyle:(KFMessageStyle)style
               withAvatarStyle:(KFMessageAvatarStyle)avatarStyle
           withBackgroundImage:(UIImage *)backgroundImage
      hidesBottomBarWhenPushed:(BOOL)hide
                     withTitle:(NSString*)windowTitle;

//打开个人资料窗口
- (void) showProfileViewController:(UINavigationController *)navController
                     withUsername:(NSString *)username
         hidesBottomBarWhenPushed:(BOOL)hide
                        withTitle:(NSString*)windowTitle;

//添加好友
- (void) addFriend:(NSString*)username withNickname:(NSString*)nickname;

//设置好友昵称
- (void) setNickname:(NSString*)nickname forFriend:(NSString*)username;

//判断是否已经添加关注
- (BOOL) isFollowed:(NSString*)username;

//删除好友
- (void) removeFriend:(NSString*)username;

//好友列表
- (NSMutableArray*) getFriendsList;

//获取关注列表
- (NSMutableArray*) getFollowedsList;

//获取粉丝列表
- (NSMutableArray*) getFansList;

//历史消息记录
- (NSMutableArray*) getConversationList;

//将与username的未读消息数清零
- (void) clearConversationUnreadnumWith:(NSString *)username;

//删除与username的会话
- (void) deleteConversationWith:(NSString*)username;

//获取与username的所有消息记录
- (NSMutableArray*) getMessageWith:(NSString*)username;

//清空与username的所有聊天信息
- (void) deleteMessageWith:(NSString*)username;

//删除单条消息，以timestamp为唯一标示; 删除与username的时间戳为timestamp的聊天信息
- (void) deleteMessageWith:(NSString *)username timeStamp:(NSDate *)timestamp;

//设置个人昵称
- (void) setNickName:(NSString*)nickname;

//获取自己的昵称
- (NSString *)myNickname;

//获取其他用户昵称
- (NSString *)getNickname:(NSString *)username;

//设置URL头像，如果你的应用中用户已经存在URL头像，可以将已有头像的URL地址传入，用于设置头像
- (void) setAvatar:(NSString *)url;

//与 - (void) setAvatar:(NSString *)url; 想匹配使用：如果通过上述函数设置的头像，要通过此函数获取头像，否则会失败
- (NSString *) getAvatarURL;

//获取他人的URL头像地址
- (NSString *) getAvatarURL:(NSString *)username;

//测试中，存在bug
- (void) setAvatar:(UIImage*)image suffix:(NSString*)suffix;

//获取当前用户的头像
- (UIImage *) getAVatar;

//获取username的头像
- (UIImage *) getAVatarOf:(NSString *)username;

//获取当前登录用户的心情
- (NSString*) getMood;

//获取当前登录用户的状态
- (NSString*) getStatus;

//获取当前登录用户的个性签名
- (NSString*) getMSignature;

//获取当前登录用户的工作
- (NSString*) getJob;

//获取当前登录用户的公司
- (NSString*) getCompany;

//获取当前登录用户的学校
- (NSString*) getSchool;

//获取当前登录用户的兴趣爱好
- (NSString*) getInterest;

//获取当前登录用户的常去的地方
- (NSString*) getDailyLocation;

//获取当前登录用户的个人说明
- (NSString*) getPersonalNote;

//设置当前登录用户的心情
- (void) setMood:(NSString *)mood;

//设置当前登录用户的状态
- (void) setStatus:(NSString*)status;

//设置当前登录用户的签名
- (void) setMSignature:(NSString*)signature;

//设置当前登录用户的工作
- (void) setJob:(NSString*)job;

//设置当前登录用户的公司
- (void) setCompany:(NSString*)company;

//设置当前登录用户的学校
- (void) setSchool:(NSString*)school;

//设置当前登录用户的兴趣爱好
- (void) setInterest:(NSString*)interest;

//设置当前登录用户的常去的地方
- (void) setDailyLocation:(NSString*)dailyLocation;

//设置当前登录用户的个人说明
- (void) setPersonalNote:(NSString*)personalnote;

//设置自定义个人资料字段
- (void) setProfileField:(NSString *)key withValue:(NSString *)value;

//获取好友的心情
- (NSString*) getMoodOf:(NSString *)username;

//获取好友的状态
- (NSString*) getStatusOf:(NSString*)username;

//获取好友的个性签名
- (NSString*) getMSignatureOf:(NSString*)username;

//获取好友的工作
- (NSString*) getJobFor:(NSString*)username;

//获取好友的公司
- (NSString*) getCompanyOf:(NSString*)username;

//获取好友的学校
- (NSString*) getSchoolOf:(NSString*)username;

//获取好友的兴趣爱好
- (NSString*) getInterestOf:(NSString*)username;

//获取好友的常去的地方
- (NSString*) getDailyLocationOf:(NSString*)username;

//获取好友的个人说明
- (NSString*) getPersonalNoteOf:(NSString*)username;

//获取他人的自定义个人资料字段
- (NSString*)getOtherProfileField:(NSString*)key ofUsername:(NSString *)username;

//拉黑
-(void) blockUser:(NSString*)username;

//黑名单列表
-(NSArray*)getBlockedUsers;

//判断username是否已经在黑名单
-(BOOL)isBlocked:(NSString*)username;

//将username从黑名单中释放
-(void)unBlockUser:(NSString*)username;

//群聊(稍后放出)

//判断是否已经加入群
-(BOOL)isRoomJoined:(NSString *)roomName;

//首先尝试加入群roomName，如果roomName不存在则创建群roomName
-(void)joinRoom:(NSString *)roomName withNickname:(NSString *)nickname;

//邀请userName加入群roomName
-(void)inviteUser:(NSString *)userName withRoomName:(NSString *)roomName withReason:(NSString *)reason;

//获取群roomName的设置资料，需要群管理员权限
-(void)getSettingsFormOf:(NSString *)roomName;

//发送群文字消息
-(void)sendMucTextMessage:(NSString *)content withRoomName:(NSString *)roomName;

//发送群图片消息
-(void)sendMUCImageMessage:(NSData*)imageData to:(NSString*)username;

//发送群语音消息
-(void)sendMUCVoiceMessage:(NSData*)voiceData
                 soundName:(NSString *)soundName
               voiceLength:(NSString *)voiceLength
                        to:(NSString*)username;

//获取被禁止的群成员列表，需要群管理员权限
- (void)getBanListOf:(NSString *)roomName;

//获取群成员列表，需要群管理员权限
- (void)getMembersListOf:(NSString *)roomName;

//获取群管理员列表，需要群管理员权限
- (void)getModeratorsListOf:(NSString *)roomName;

//离开群
-(void)leaveRoom:(NSString *)roomName;

//打开群会话窗口
- (void)showMUCChatViewController:(UINavigationController *)navController
                     withRoomName:(NSString *)roomName
                  withBubbleStyle:(KFMessageStyle)style
                  withAvatarStyle:(KFMessageAvatarStyle)avatarStyle
              withBackgroundImage:(UIImage *)backgroundImage
         hidesBottomBarWhenPushed:(BOOL)hide
                        withTitle:(NSString*)windowTitle;

//获取群消息列表
-(NSMutableArray *) getMUCMessageWith:(NSString *)roomName;

//获取群成员列表
-(NSMutableArray *) getMUCOccupantWith:(NSString *)roomName;

//判断kefuUsername是否在线
- (BOOL)isKefuOnlineSync:(NSString*) kefuUsername;

//登出
- (void)logout;

//工具函数
- (void) showHUDMessage:(NSString *)msg inView:(UIView *)vm;

@end










































