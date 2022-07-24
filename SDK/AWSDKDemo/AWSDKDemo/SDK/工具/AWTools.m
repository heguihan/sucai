//
//  AWTools.m
//  AWSDKDemo
//
//  Created by admin on 2020/12/1.
//

#import "AWTools.h"
#import <CommonCrypto/CommonDigest.h>
#import <AdSupport/AdSupport.h>
#import "DSToast.h"
#define  KEYCHAIN @"hghawsdkios"
#define  DEVICETAG      @{@"device":bundleID}
#define  IDFAAWSDK  @"awsdkidfa"

#import "AWSaveImage.h"
#import "XXTEA.h"
#import "AWLocalFile.h"
#import "QWERReachability.h"

#import <AppTrackingTransparency/AppTrackingTransparency.h>

@implementation AWTools
// 刘海适配

#define IS_IPHONE (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
#define IS_IOS_11  ([[[UIDevice currentDevice] systemVersion] floatValue] >= 11.f)
#define IS_IPHONE_X (IS_IOS_11 && IS_IPHONE && (MIN([UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height) >= 375 && MAX([UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height) >= 812))

+ (BOOL)isIPhoneX
{
    return IS_IPHONE_X;
    return (CGSizeEqualToSize([UIScreen mainScreen].bounds.size, CGSizeMake(375, 812)) ||
            CGSizeEqualToSize([UIScreen mainScreen].bounds.size, CGSizeMake(812, 375)) ||
            CGSizeEqualToSize([UIScreen mainScreen].bounds.size, CGSizeMake(414, 896)) ||
            CGSizeEqualToSize([UIScreen mainScreen].bounds.size, CGSizeMake(896, 414)));
}






//IDFA
+(NSString *)getIdfa
{
//    return [[[ASIdentifierManager sharedManager] advertisingIdentifier] UUIDString];
    NSString *realIdfa = [[[ASIdentifierManager sharedManager] advertisingIdentifier] UUIDString];
    if (![realIdfa isEqualToString:@"00000000-0000-0000-0000-000000000000"]) {
        return realIdfa;
    }
    
    if (![staticIdfa isEqualToString:@""]) {
        return staticIdfa;
    }else{
        //获取其他的设备标识
        NSString *localIdfa = (NSString *)[self load:IDFAAWSDK];
        if (!localIdfa) {
            localIdfa = @"";
            if ([AWGlobalDataManage shareinstance].isShowedSetting) {
                return localIdfa;
            }
            [AWGlobalDataManage shareinstance].isNeedCallSetting = YES;
            [AWLoginViewManager showgotoSetting];
        }
        return localIdfa;
    }
    return @"";
}

static NSString *staticIdfa = @"";
+(void)setIDFA
{
    NSString *localIdfa = [[ASIdentifierManager sharedManager].advertisingIdentifier UUIDString];
    if (![localIdfa isEqualToString:@"00000000-0000-0000-0000-000000000000"]) {
//        [AWLocalFile saveToLocalWithPath:IDFAAWSDK withData:localIdfa];
        [self save:IDFAAWSDK data:localIdfa];
    }
    
    if (@available(iOS 14, *)) {
            // iOS14及以上版本需要先请求权限
            [ATTrackingManager requestTrackingAuthorizationWithCompletionHandler:^(ATTrackingManagerAuthorizationStatus status) {
                [AWConfig configRequest];
                // 获取到权限后，依然使用老方法获取idfa
                if (status == ATTrackingManagerAuthorizationStatusAuthorized) {
                    NSString *idfa = [[ASIdentifierManager sharedManager].advertisingIdentifier UUIDString];
                    staticIdfa = idfa;
                    NSLog(@"%@",idfa);
                } else {
                    NSString *idfa = [[ASIdentifierManager sharedManager].advertisingIdentifier UUIDString];
                         NSLog(@"请在设置-隐私-跟踪中允许App请求跟踪,idfa===%@",idfa);
                    
                }
                
            }];
        } else {
            // iOS14以下版本依然使用老方法
            // 判断在设置-隐私里用户是否打开了广告跟踪
            [AWConfig configRequest];
            if ([[ASIdentifierManager sharedManager] isAdvertisingTrackingEnabled]) {
                NSString *idfa = [[ASIdentifierManager sharedManager].advertisingIdentifier UUIDString];
                NSLog(@"%@",idfa);
                staticIdfa = idfa;
            } else {
                NSLog(@"请在设置-隐私-广告中打开广告跟踪功能");
            }
        }
}


+(BOOL)isFirstInstall
{
    NSString *bundleID = [self getCurrentBundleID];
    bundleID = [NSString stringWithFormat:@"%@_aw_active",bundleID];
    NSString *device = [AWLocalFile loadLocalCache:bundleID];
    if (!device) {
        [AWLocalFile saveToLocalWithPath:bundleID withData:DEVICETAG];
        return YES;
    }
    return NO;
}

//有两个地方要激活上报， 这个判断只能用一次，所以多写一个
+(BOOL)isFirstInstall_socket
{
    NSString *bundleID = [self getCurrentBundleID];
    bundleID = [NSString stringWithFormat:@"%@_aw_socket_active",bundleID];
    NSString *device = [AWLocalFile loadLocalCache:bundleID];
    if (!device) {
        [AWLocalFile saveToLocalWithPath:bundleID withData:DEVICETAG];
        return YES;
    }
    return NO;
}

+(BOOL)isFirstInstallShowRebNevelope
{
    NSString *bundleID = [self getCurrentBundleID];
    bundleID = [NSString stringWithFormat:@"%@_rednevelope",bundleID];
    NSString *deviceTag = [AWLocalFile loadLocalCache:bundleID];
    if (!deviceTag) {
        [AWLocalFile saveToLocalWithPath:bundleID withData:DEVICETAG];
        return YES;
    }
    return NO;
}

// UUID
+(NSString *)getUUID
{
    NSString * strUUID = (NSString *)[self load:KEYCHAIN];
    if ([strUUID isEqualToString:@""] || !strUUID)
    {
        //生成一个uuid的方法
        CFUUIDRef uuidRef = CFUUIDCreate(kCFAllocatorDefault);
        
        strUUID = (NSString *)CFBridgingRelease(CFUUIDCreateString (kCFAllocatorDefault,uuidRef));
        
        //将该uuid保存到keychain
        [self save:KEYCHAIN data:strUUID];
    }
    return strUUID;
}

+ (NSMutableDictionary *)getKeychainQuery:(NSString *)service {
    return [NSMutableDictionary dictionaryWithObjectsAndKeys:
            (id)kSecClassGenericPassword,(id)kSecClass,
            service, (id)kSecAttrService,
            service, (id)kSecAttrAccount,
            (id)kSecAttrAccessibleAfterFirstUnlock,(id)kSecAttrAccessible,
            nil];
}

+ (void)save:(NSString *)service data:(id)data {
    //Get search dictionary
    NSMutableDictionary *keychainQuery = [self getKeychainQuery:service];
    //Delete old item before add new item
    SecItemDelete((CFDictionaryRef)keychainQuery);
    //Add new object to search dictionary(Attention:the data format)
    [keychainQuery setObject:[NSKeyedArchiver archivedDataWithRootObject:data] forKey:(id)kSecValueData];
    //Add item to keychain with the search dictionary
    SecItemAdd((CFDictionaryRef)keychainQuery, NULL);
}

+ (id)load:(NSString *)service {
    id ret = nil;
    NSMutableDictionary *keychainQuery = [self getKeychainQuery:service];
    
    [keychainQuery setObject:(id)kCFBooleanTrue forKey:(id)kSecReturnData];
    [keychainQuery setObject:(id)kSecMatchLimitOne forKey:(id)kSecMatchLimit];
    CFDataRef keyData = NULL;
    if (SecItemCopyMatching((CFDictionaryRef)keychainQuery, (CFTypeRef *)&keyData) == noErr) {
        @try {
            ret = [NSKeyedUnarchiver unarchiveObjectWithData:(__bridge NSData *)keyData];
        } @catch (NSException *e) {
            ////AWLog(@"Unarchive of %@ failed: %@", service, e);
        } @finally {
        }
    }
    if (keyData)
        CFRelease(keyData);
    return ret;
}

+ (void)deleteKeyData:(NSString *)service {
    NSMutableDictionary *keychainQuery = [self getKeychainQuery:service];
    SecItemDelete((CFDictionaryRef)keychainQuery);
}

//当前控制器
+(UIViewController *)getCurrentVC
{
    UIViewController *result = nil;
    
    UIWindow * window = [[UIApplication sharedApplication] keyWindow];
    if (window.windowLevel != UIWindowLevelNormal)
    {
        NSArray *windows = [[UIApplication sharedApplication] windows];
        for(UIWindow * tmpWin in windows)
        {
            if (tmpWin.windowLevel == UIWindowLevelNormal)
            {
                window = tmpWin;
                break;
            }
        }
    }
    UIView *frontView = [[window subviews] objectAtIndex:0];
    id nextResponder = [frontView nextResponder];
    if ([nextResponder isKindOfClass:[UIViewController class]])
    result = nextResponder;
    else
    result = window.rootViewController;
    return result;
}
//时间戳
+(NSString *)getCurrentTimeString
{
    NSString *dateStr = [NSString stringWithFormat:@"%d", (int)[[NSDate date] timeIntervalSince1970]];
    return dateStr;
}
// md5
+(NSString *) md5String:(NSString *)str
{
    const char *original_str = [str UTF8String];
    unsigned char result[CC_MD5_DIGEST_LENGTH];
    CC_MD5(original_str, strlen(original_str), result);
    NSMutableString *hash = [NSMutableString string];
    for (int i = 0; i < 16; i++)
        [hash appendFormat:@"%02X", result[i]];
    return [hash lowercaseString];
}
// urlencode
+(NSString*)URLEncodeString:(NSString*)unencodedString
{
    
    //    NSString *encodedString=nil;
    //    if ([[[UIDevice currentDevice] systemVersion] floatValue] > 9.0f) {
    
    
    NSString *encodedString = (NSString *)
    CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault,
                                                              (CFStringRef)unencodedString,
                                                              NULL,
                                                              (CFStringRef)@"!*'(); :@&=+$,/?%#[]",
                                                              kCFStringEncodingUTF8));
    
    encodedString = [encodedString stringByReplacingOccurrencesOfString:@"%20" withString:@"+"];
    
    return encodedString;
}

// 时区
+(NSString *)getTimezone
{
    NSTimeZone *localZone = [NSTimeZone localTimeZone];
    NSString *strZoneAbbreviation = [localZone abbreviation];
    NSRegularExpression *regularExpression = [NSRegularExpression regularExpressionWithPattern:@"[a-zA-Z]" options:0 error:nil];
    strZoneAbbreviation = [regularExpression stringByReplacingMatchesInString:strZoneAbbreviation options:0 range:NSMakeRange(0, strZoneAbbreviation.length) withTemplate:@""];
    return strZoneAbbreviation;
}

// window
+ (UIWindow *)currentWindow
{
    UIWindow *window = [[UIApplication sharedApplication] keyWindow];
    if(window.windowLevel != UIWindowLevelNormal)
    {
        NSArray *windows = [[UIApplication sharedApplication] windows];
        for (UIWindow *tempWindow in windows)
        {
            if(tempWindow.windowLevel == UIWindowLevelNormal)
            {
                window = tempWindow;
                break;
            }
        }
    }
        
    return window;
}

/** 渐变色 */
+ (CAGradientLayer *)setGradualChangingColor:(UIView *)view fromColor:(UIColor *)fromHexColorStr toColor:(UIColor *)toHexColorStr{
    //    CAGradientLayer类对其绘制渐变背景颜色、填充层的形状(包括圆角)
    CAGradientLayer *gradientLayer = [CAGradientLayer layer];
    gradientLayer.frame = view.bounds;
    //  创建渐变色数组，需要转换为CGColor颜色
    gradientLayer.colors = @[(__bridge id)fromHexColorStr.CGColor,(__bridge id)toHexColorStr.CGColor];
    //  设置渐变颜色方向，左上点为(0,0), 右下点为(1,1)
    gradientLayer.startPoint = CGPointMake(0, 0);
    gradientLayer.endPoint = CGPointMake(1, 0);
    //  设置颜色变化点，取值范围 0.0~1.0
    gradientLayer.locations = @[@0,@1];
    
    return gradientLayer;
}

+ (void)removeViews:(UIView *)futherView
{
    dispatch_async(dispatch_get_main_queue(), ^{
        if (futherView.subviews.count>0) {
            for (UIView *view in futherView.subviews) {
            [self removeViews:view];
            [futherView removeFromSuperview];
            }
        }else{
            [futherView removeFromSuperview];
        }
    });
}

+(NSInteger)DeviceOrientation
{
    UIInterfaceOrientation orientation = [UIApplication sharedApplication].statusBarOrientation;
    if (orientation==UIInterfaceOrientationLandscapeLeft) {
        return 1;
    }else if (orientation==UIInterfaceOrientationLandscapeRight){
        return 2;
    }else{
        return 3;
    }
}

+(BOOL)isInLiuhai:(CGFloat)y
{
    if (y>38&&y<286) {
        return YES;
    }
    return NO;
}

+(void)makeToastWithText:(NSString *)text
{
    [[DSToast toastWithText:text] show];
    
}

+(void)makeToastWithText:(NSString *)text andTime:(CFTimeInterval)time
{
    DSToast *toast = [DSToast toastWithText:text];
    toast.waitAnimationDuration = time;
    [toast show];
}

+(void)saveFastaccountScreentWithView:(UIView *)view
{
    [AWSaveImage saveScreenWithView:view];
}
// 加解密
+ (NSString *) encryptStringToBase64String:(NSString *)data stringKey:(NSString *)key
{
    return [XXTEA encryptStringToBase64String:data stringKey:key];
}
+ (NSString *) decryptBase64StringToString:(NSString *)data stringKey:(NSString *)key
{
    return [XXTEA decryptBase64StringToString:data stringKey:key];
}

//类型转换  jsonstr转字典
+(NSDictionary *)jsonStrtodictWithStr:(NSString *)jsonStr
{
    if (jsonStr == nil) {
        return nil;
    }
    
    NSData *jsonData = [jsonStr dataUsingEncoding:NSUTF8StringEncoding];
    NSError *err;
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData
                                                        options:NSJSONReadingMutableContainers
                                                          error:&err];
    if(err) {
        AWLog(@"json解析失败：%@",err);
        return nil;
    }
    return dic;
}

+(NSString *)dicttojsonWithdict:(NSDictionary *)dict
{
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dict options:NSJSONWritingFragmentsAllowed error:&error];
    if (!jsonData) {
        AWLog(@"json解析失败");
        return @"";
    }
    NSString *jsonStr = [[NSString alloc]initWithData:jsonData encoding:NSUTF8StringEncoding];
    return jsonStr;
}

//包体版本
+(NSString *)getCurrentVersion
{
    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
    NSString *app_Version = [infoDictionary objectForKey:@"CFBundleShortVersionString"];
    return app_Version;
}

//包体bundleID
+(NSString*)getCurrentBundleID
{
    return [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleIdentifier"];
}

+(NSString *)convertToJsonData:(NSDictionary *)dict

{

    if ([dict isKindOfClass:[NSString class]]) {
        return (NSString *)dict;
    }
    
    NSError *error;

    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dict options:NSJSONWritingPrettyPrinted error:&error];

    NSString *jsonString;

    if (!jsonData) {

        AWLog(@"%@",error);

    }else{

        jsonString = [[NSString alloc]initWithData:jsonData encoding:NSUTF8StringEncoding];

    }

    NSMutableString *mutStr = [NSMutableString stringWithString:jsonString];

    NSRange range = {0,jsonString.length};

    //去掉字符串中的空格

    [mutStr replaceOccurrencesOfString:@" " withString:@"" options:NSLiteralSearch range:range];

    NSRange range2 = {0,mutStr.length};

    //去掉字符串中的换行符

    [mutStr replaceOccurrencesOfString:@"\n" withString:@"" options:NSLiteralSearch range:range2];
    return mutStr;

}

+ (void)customLogWithFunction:(const char *)function lineNumber:(int)lineNumber formatString:(NSString *)formatString
{
 
    if (![AWConfig getDebugLog]) {
        return;
    }
    NSLog(@"%s[%d]%@", function, lineNumber, formatString);
}
//检测当前网络
+(BOOL)checkNetwork
{
    NSString *remoteHostName = @"www.apple.com";
    QWERReachability *reachability = [QWERReachability reachabilityWithHostName:remoteHostName];
    NetworkStatus netStatus = [reachability currentReachabilityStatus];
    switch (netStatus)
    {
      case NotReachable:   {
        NSLog(@"没有网络！");
          return NO;
        break;
      }
      case ReachableViaWWAN: {
        NSLog(@"4G/3G");
          return YES;
        break;
      }
      case ReachableViaWiFi: {
        NSLog(@"WiFi");
          return YES;
        break;
      }
    }
}

//打电话
+(void)telWithPhoneNO:(NSString *)phoneNO
{
//    NSMutableString* str=[[NSMutableString alloc] initWithFormat:@"telprompt://%@",phoneNO];
    NSMutableString* str=[[NSMutableString alloc] initWithFormat:@"tel:%@",phoneNO];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str] options:@{} completionHandler:^(BOOL success) {
            if (success) {
                //
            }
    }];
}

+(CGFloat)getWidthWithText:(NSString *)text height:(CGFloat)height font:(UIFont *)font{
    

    CGRect rect = [text boundingRectWithSize:CGSizeMake(MAXFLOAT, height)

                                     options:NSStringDrawingUsesLineFragmentOrigin

                                  attributes:@{NSFontAttributeName:font}

                                     context:nil];

    return rect.size.width;

}

+(int)getTimerCont:(NSString *)time
{
    NSString *currentTime = [self getCurrentTimeString];
    int time1 = [time intValue];
    int time2 = [currentTime intValue];
    if (time.length>10) {
        time1 = time1/1000;
    }
    if (currentTime.length>10) {
        time2 = time2/1000;
    }
    int jiange = time2-time1;
    return jiange;
}

+(BOOL)getTimerIntertwoDays:(NSString *)time
{
    NSString *currentTime = [self getCurrentTimeString];
    return [self getTimeintervalWithbeginTime:time endTime:currentTime];
}

//计算时间间隔是否大于2天
+(BOOL)getTimeintervalWithbeginTime:(NSString *)timebegin endTime:(NSString *)endTime
{
    int dayCount = 2;//天数
    int time1 = [timebegin intValue];
    int time2 = [endTime intValue];
    if (timebegin.length>10) {
        time1 = time1/1000;
    }
    if (endTime.length>10) {
        time2 = time2/1000;
    }
    int jiange = time2-time1;
    int daytosec = 60 * 60 * 24 *dayCount;
    if (jiange>daytosec) {
        return YES;
    }
    return NO;
}

//给个闪退
+(void)leaveGame
{
    NSArray *arr = @[@1];
    NSNumber *num = arr[22];
}

//存当前的时间戳
+(void)saveCurrentTimeWithPath:(NSString *)path
{
    NSString *currentTimeStr = [AWTools getCurrentTimeString];
    NSDictionary *noticeTime = @{@"notice":currentTimeStr};
    [AWLocalFile saveToLocalWithPath:path withData:noticeTime];
}
//取上次的时间戳
+(NSString *)getLastTimeStrWithPath:(NSString *)path
{
    id timedict = [AWLocalFile loadLocalCache:path];
    if (!timedict || timedict == NULL) {
        return @"";
    }
    NSString *lastTime = timedict[@"notice"];
    return lastTime;
}
//存当前应用是否保存过（如：授权，激活等，显示一次的）
+(void)saveFlagWithPath:(NSString *)path
{
    NSDictionary *dataDict = @{@"bool":@"1"};
    [AWLocalFile saveToLocalWithPath:path withData:dataDict];
}
+(BOOL)getFlagWothPath:(NSString *)path
{
    id resultDict = [AWLocalFile loadLocalCache:path];
    if (!resultDict || resultDict == NULL) {
        return NO;
    }
    BOOL reslut = !![resultDict[@"bool"] intValue];
    return reslut;
}


//判断上次时间距离当前时间是否超过一天
+(BOOL)isOverOnyDayWithLastTime:(NSString *)lastTime
{
    NSString *currentTimeStr = [AWTools getCurrentTimeString];
    
    long timelast = [lastTime longLongValue];
    long  currentTime= [currentTimeStr longLongValue];
    //传入时间毫秒数
    NSDate *pDate1 = [NSDate dateWithTimeIntervalSince1970:timelast/1000];
    NSDate *pDate2 = [NSDate dateWithTimeIntervalSince1970:currentTime/1000];
    NSCalendar* calendar = [NSCalendar currentCalendar];
    unsigned unitFlags = NSCalendarUnitYear | NSCalendarUnitMonth |  NSCalendarUnitDay;
    NSDateComponents* comp1 = [calendar components:unitFlags fromDate:pDate1];
    NSDateComponents* comp2 = [calendar components:unitFlags fromDate:pDate2];
    
    return [comp1 day]   == [comp2 day] &&
    [comp1 month] == [comp2 month] &&
    [comp1 year]  == [comp2 year];

}

//返回一个随机数
+(NSInteger)getRandomNumWithMax:(NSInteger)maxNum
{
    NSInteger randomNum = arc4random() % maxNum;
    return randomNum;
}
//指定时间戳到当前时间是否超过 n天
+(BOOL)isOverTimeDay:(NSInteger)dayNum lastTimeStr:(NSString *)lastTimeStr
{
    NSString *currentTimeStr = [AWTools getCurrentTimeString];
    NSInteger sec = [currentTimeStr integerValue] - [lastTimeStr intValue];
    
    NSInteger oneDay = 60 * 60 * 24;
    
    return sec > (sec * oneDay);
    
}

//base64转UIimage
+(UIImage*)decodeBase64ToImage:(NSString*)strEncodeData
{
    NSData *data = [[NSData alloc]initWithBase64EncodedString:strEncodeData options:NSDataBase64DecodingIgnoreUnknownCharacters];
    return [UIImage imageWithData:data];
}
//UIimage转base64
+(NSString*)encodeToBase64String:(UIImage*)image
{
    return [UIImagePNGRepresentation(image) base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength];
}
//读取剪切板里面的内容
+(NSString *)getPastedContent
{
    UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
    NSString *pasteStr = pasteboard.string;
    return pasteStr;
}

@end
