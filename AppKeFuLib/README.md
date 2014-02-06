


# AppKeFu_sdk 使用说明

具体参考：http://appkefu.com/AppKeFu/tutorial-iOS.html

一：添加库文件
    libxml2.dylib
    libresolve.dylib
    SystemConfiguration.framework
    CoreLocation.framework
    CoreData.framework
    AVFundation.framework
    AudioToolbox.framework
    ImageIO.framework
    

二：
 选中target中的Build Settings:
1. Other Linker Flags 添加 -all_load  -lstdc++
2(可选).Header Search Paths 添加 “/usr/include/libxml2”


三：上述两步骤后，如报错可尝试添加如下framework
(根据具体情况添加：Security.framework，CFNetwork.framework，QuartzCore.framework)


四、在模拟器上测试要 添加 libiconv.dylib， 注意：模拟器上不能测试语音


五 说明：
libAppKeFuIMSDK_device.a 只能在真机上测试运行，体积小，用于发布应用到app store
libAppKeFuIMSDK_both.a 可以在真机和模拟器上面运行，体积较大，不适于发布到app store


六 国际化：
具体设置步骤请参见：
http://blog.csdn.net/xyz_lmn/article/details/8968191


升级日志：
20140107: 1.增加设置网络头像接口；2.增加获取昵称接口；3.增加显示/清空未读消息数目，完善历史消息记录接口
20131220: 客服SDK：1、增加扁平气泡样式；2、可自行显示/隐藏/自定义客服/访客头像；3、可停止播放语音；
          IM SDK：1、增加扁平气泡样式；2、增加头像样式设置接口；3、可停止播放语音；4、增加群聊测试接口；5、增加国际化






















