//
//  GVUserDefaults+YH_Properties.h
//  Yohoboys
//
//  Created by redding on 14-9-18.
//  Copyright (c) 2014年 YOHO. All rights reserved.
//

#import "GVUserDefaults.h"

@interface GVUserDefaults (WK_Properties)

//-------------------------------------------------------------------
//声明的 object 类型的 property，请使用 weak；非 object 类型，请使用 assign
//-------------------------------------------------------------------


@property (assign,nonatomic) BOOL appFirstLunched;              //是否首次启动应用
@property (assign,nonatomic) NSInteger  openCount;                    //打开次数
@property (assign,nonatomic) BOOL haveDownloadMagazine;         //已经下载过杂志
@property (assign,nonatomic) BOOL autoDownloadMagazine;         //自动下载杂志
@property (assign,nonatomic) BOOL haveFeedBack;                 //是否点击了意见反馈
@property (assign,nonatomic) BOOL haveComment;                  //是否评价过
@property (assign,nonatomic) BOOL thinking;                     //是否点击了想一想
@property (assign,nonatomic) BOOL isOK;                         //是否点击了OK

@property (weak,nonatomic)   NSString *lastCity;                //上次定位城市
@property (weak,nonatomic)   NSString *versionUpdate;           //版本号
@property (weak,nonatomic)   NSString *updateURL;               //版本URL
@property (assign,nonatomic) BOOL downLoad;                     //是否自动下载最新资讯
@property (assign,nonatomic) BOOL firstPushNotification;        //推送状态
@property (weak,nonatomic)   NSData *splashScreen;              //启动页
@property (weak,nonatomic)   NSString *deviceTokenString;       //token

@property (assign,nonatomic) BOOL followedSina;                 //关注新浪
@property (assign,nonatomic) BOOL followedShow;                 //关注Show
@property (assign,nonatomic) BOOL followedInstagram;            //关注Instagram
@property (assign,nonatomic) BOOL followedFacebook;             //关注Facebook

@property (nonatomic, assign) BOOL userLogged;                      //是否已登录
@property (nonatomic, weak) NSString *nickName;                 //登录昵称
@property (nonatomic, weak) NSString *avtar;                    //头像

@property (nonatomic, assign) NSDictionary *thirdLoginInfos;     //第三方平台登录信息

@property (assign,nonatomic) BOOL openAPP;        //是否程序打开

@property (nonatomic, weak) NSData *navigationData;             //导航信息
@property (nonatomic, weak) NSString *yohoAccount;              //yoho帐号
@property (nonatomic, weak) NSString *yohoId;                   //yoho id
@property (nonatomic, weak) NSString *commentContent;           //评论内容
@property (assign, nonatomic) NSInteger commentCID;             //评论的内容ID
@property (nonatomic, weak) NSData *readLabelData;              //浏览书签
@property (weak, nonatomic) NSData *shopListData;
@property (assign,nonatomic) BOOL firstEnterDetail;              //是否首次进入详情页

@property (assign,nonatomic) BOOL showDownLoadTip;               //显示自动下载提示

@property (weak, nonatomic) NSString *mapUpdateSymbol;          //map更新判断标志
@property (weak, nonatomic) NSString *magazineUpdateSymbol;     //magazine更新判断标志

@property (nonatomic, assign) BOOL isNotice;                    //是否推送消息
@property (nonatomic, assign) BOOL allowCms;                    //是否推送资讯
@property (nonatomic, assign) BOOL allowMag;                    //是否推送杂志
@property (nonatomic, weak) NSString *readedUpdateVersionInSetting;       //已经设置中读过的版本

@end
