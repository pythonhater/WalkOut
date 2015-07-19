//
//  GVUserDefaults+YH_Properties.m
//  Yohoboys
//
//  Created by redding on 14-9-18.
//  Copyright (c) 2014年 YOHO. All rights reserved.
//

#import "GVUserDefaults+YH_Properties.h"

@implementation GVUserDefaults (WK_Properties)

@dynamic appFirstLunched;
@dynamic openCount;
@dynamic haveDownloadMagazine;
@dynamic haveFeedBack;
@dynamic haveComment;
@dynamic thinking;
@dynamic isOK;
@dynamic lastCity;
@dynamic versionUpdate;
@dynamic downLoad,firstPushNotification;
@dynamic splashScreen,deviceTokenString;
@dynamic followedSina,followedShow,followedInstagram,followedFacebook;
@dynamic userLogged,nickName, avtar;
@dynamic openAPP;
@dynamic navigationData;
@dynamic yohoAccount;
@dynamic commentContent;
@dynamic readLabelData;
@dynamic shopListData;
@dynamic firstEnterDetail;
@dynamic autoDownloadMagazine;
@dynamic yohoId;
@dynamic updateURL;
@dynamic commentCID;
@dynamic showDownLoadTip;
@dynamic mapUpdateSymbol;
@dynamic magazineUpdateSymbol;
@dynamic isNotice;
@dynamic allowCms;
@dynamic allowMag;
@dynamic readedUpdateVersionInSetting;
@dynamic thirdLoginInfos;
#pragma mark - setup
//setup default value for key
- (NSDictionary *)setupDefaults {
    return @{
             @"appFirstLunched": @YES,
             @"openCount": @0,
             @"haveDownloadMagazine": @NO,
             @"autoDownloadMagazine" : @NO,
             @"haveFeedBack": @NO,
             @"haveComment": @NO,
             @"thinking": @YES,
             @"isOK" :    @NO,
             @"lastCity": @"",
             @"versionUpdate" : @"",
             @"downLoad" : @NO,
             @"firstPushNotification" : @NO,
             @"splashScreen" :@"",
             @"deviceTokenString" : @"",
             @"followedSina" : @NO,
             @"followedShow" : @YES,
             @"followedInstagram" : @YES,
             @"followedFacebook" : @YES,
             @"userLogged" : @NO,
             @"nickName" : @"",
             @"avtar" : @"",
             @"openApp" : @"YES",
             @"yohoAccount" : @"",
             @"yohoId" : @"",
             @"token" : @"",
             @"openId" : @"",
             @"expirationDate" : @"",
             @"commentContent" : @"",
             @"firstEnterDetail" : @YES,
             @"updateURL" : @"",
             @"commentCID" : @0,
             @"showDownLoadTip" : @YES,
             @"mapUpdateSymbol" : @"",
             @"magazineUpdateSymbol" : @"",
             @"isNotice":@YES,
             @"allowCms":@YES,
             @"allowMag":@YES,
             @"readedUpdateVersionInSetting":@"",
             @"thirdLoginInfos":[[NSDictionary alloc]init],
            };
}

#pragma mark - convert key
//convert key, eg: "selectedStartCity" -> "TNUserDefaultKeySelectedStartCity"
- (NSString *)transformKey:(NSString *)key {
    key = [key stringByReplacingCharactersInRange:NSMakeRange(0,1) withString:[[key substringToIndex:1] uppercaseString]];
    return [NSString stringWithFormat:@"YH_UserDefault%@", key];
}

@end