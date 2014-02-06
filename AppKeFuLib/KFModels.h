//
//  KFModels.h
//  AppKeFuIMSDK
//
//  Created by jack on 13-9-25.
//  Copyright (c) 2013年 appkefu.com. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum {
    KFMessageText = 0,              //文本消息
    KFMessageImageHTTPURL,          //图片消息
    KFMessageSoundHTTPURL           //语音消息
} KFMessageType;

typedef enum {
    KFMessageStyleDefault = 0,      //默认气泡形式
    KFMessageStyleSquare,           //正方形气泡
    KFMessageStyleDefaultGreen,     //绿色气泡
    KFMessageStyleFlat              //扁平气泡
} KFMessageStyle;

typedef enum {
    KFMessageAvatarStyleCircle = 0, //显示圆形头像
    KFMessageAvatarStyleSquare,     //显示正方形头像
    KFMessageAvatarStyleNone        //不显示头像
} KFMessageAvatarStyle;


@interface KFMessageItem : NSObject


@property (nonatomic, strong) NSString      *username;
@property (nonatomic, strong) NSDate        *timestamp;
@property (nonatomic, strong) NSString      *messageContent;
@property (nonatomic, assign) KFMessageType messageType;
@property (nonatomic, assign) BOOL          isSendFromMe;
@property (nonatomic, strong) NSString      *roomName;//群聊消息专用

@end

////////////////////////////
@interface KFConversationItem : NSObject

@property (nonatomic, strong) NSString * username;
@property (nonatomic, strong) NSString * domain;

@property (nonatomic, strong) NSDate   * mostRecentMessageTimestamp;
@property (nonatomic, strong) NSString * mostRecentMessageBody;
@property (nonatomic, strong) NSNumber * mostRecentMessageOutgoing;
@property (nonatomic, strong) NSNumber * unreadMessagesCount;

@end

////////////////////////////
@interface KFFriendItem : NSObject

@property (nonatomic, strong) NSString *username;
@property (nonatomic, strong) NSString *relation;

@end

////////////////////////////
@interface KFFollowedItem : NSObject

@property (nonatomic, strong) NSString *username;
@property (nonatomic, strong) NSString *relation;

@end

////////////////////////////
@interface KFFanItem : NSObject

@property (nonatomic, strong) NSString *username;
@property (nonatomic, strong) NSString *relation;

@end


////////////////////////////
@interface KFModels : NSObject

@end























