//
//  AWSDKConfigManager.m
//  AWSDKDemo
//
//  Created by admin on 2020/12/8.
//

#import "AWSDKConfigManager.h"

@implementation AWSDKConfigManager
+(instancetype)shareinstance
{
    static AWSDKConfigManager *configManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        configManager = [[AWSDKConfigManager alloc]init];
    });
    return configManager;
}

-(void)setinitDataWithConfigInfo:(NSDictionary *)configInfo
{
    NSDictionary *adv = configInfo[@"adv"];
    BOOL isnull = [adv isKindOfClass:[NSNull class]] || [adv isEqual:[NSNull null]];
    if (!isnull) {
        self.adv_img_full = adv[@"img_full"];
        self.adv_img_normal = adv[@"img_normal"];
        self.adv_is_show = [adv[@"is_show"] intValue];
        self.adv_jump_url = adv[@"jump_url"];
        self.adv_package_name = adv[@"package_name"];
    }

    
    NSDictionary *broadcast = configInfo[@"broadcast"];
    self.broadcast_is_open = [broadcast[@"is_open"] intValue];
    
    self.brand = configInfo[@"brand"];
    
    NSDictionary *dc = configInfo[@"dc"];
    BOOL dcisnull = [dc isKindOfClass:[NSNull class]] || [dc isEqual:[NSNull null]];
    if (!dcisnull) {
        self.dc_alias = dc[@"alias"];
        self.dc_key = dc[@"key"];
    }

    
    NSDictionary *domain = configInfo[@"domain"];
    self.API_BASE_URL_GO = domain[@"API_BASE_URL_GO"];
    self.API_BASE_URL_PHP = domain[@"API_BASE_URL_PHP"];
    self.CHANNEL_REPORT = domain[@"CHANNEL_REPORT"];
    self.EVENT_URL = domain[@"EVENT_URL"];
    self.PAY_URL = domain[@"PAY_URL"];
    
    NSDictionary *float_ballDict = configInfo[@"float_ball"];
    if (float_ballDict) {
        self.float_ball_type = float_ballDict[@"type"];
        self.float_ball_type = @"gift_pack";
        self.float_ball_is_float = [float_ballDict[@"is_float"] intValue];
        self.float_ball_is_show_banner = [float_ballDict[@"is_show_banner"] intValue];
    }
    
    id kefu = configInfo[@"kefu"];
    if ([kefu isKindOfClass:[NSDictionary class]]) {
        if (kefu) {
            self.kefu_phone = kefu[@"phone"];
            self.kefu_fb = kefu[@"fb"];
            self.kefu_email = kefu[@"email"];
        }
    }


    
    self.link = configInfo[@"link"];
    
    self.login_type1 = configInfo[@"login_type1"];
    self.login_type2 = configInfo[@"login_type2"];
    
    self.login_type = configInfo[@"login_type"];
    
    self.menu = configInfo[@"menu"];
    
    /*
     "name_auth" =         {
         "exp_limit" = 10800;
         "expire_guide" = 5400;
         "holiday_limit" = 18000;
         "is_holiday" = 0;
         "name_auth_strategy" = NORMAL;
         "workday_limit" = 18000;
     };
     */
    NSDictionary *name_auth = configInfo[@"name_auth"];
    
    self.name_auth_is_open = !![name_auth[@"is_open"] intValue];
    self.name_auth_is_holiday = !![name_auth[@"is_holiday"] intValue];
    self.name_auth_exp_limit = [name_auth[@"exp_limit"] integerValue];
    self.name_auth_expire_guide = [name_auth[@"expire_guide"] intValue];
    self.name_auth_strategy = name_auth[@"name_auth_strategy"];
    self.name_auth_holiday_limit = [name_auth[@"holiday_limit"] intValue];
    self.name_auth_workday_limit = [name_auth[@"workday_limit"] intValue];
    self.name_auth_msg = name_auth[@"msg"];
    self.name_auth_change_type = name_auth[@"change_type"];
    self.name_auth_gift_img = name_auth[@"gift_img"];
    self.name_auth_gift_code = name_auth[@"gift_code"];
    
    self.name_auth_menu = configInfo[@"name_auth_menu"];
    
    self.pay_type = configInfo[@"pay_type"];
    
    NSDictionary *switch_data = configInfo[@"switch_data"];
    self.switch_data_is_fast_login = !![switch_data[@"is_fast_login"] intValue];
//    self.switch_data_is_float = !![switch_data[@"is_float"] intValue];
    self.switch_data_is_indulge = !![switch_data[@"is_indulge"] intValue];
    self.switch_data_is_sleep = !![switch_data[@"is_sleep"] intValue];
//    self.switch_data_is_show_bannel = !![switch_data[@"is_show_banner"] intValue];
    self.switch_data_is_show_login = !![switch_data[@"is_show_login"] intValue];
    self.switch_data_is_bind_visitor = !![switch_data[@"is_bind_visitor"] intValue];
    
    NSDictionary *arderDict = configInfo[@"arder"];
    if (arderDict) {
        self.arder_is_arder = [arderDict[@"is_arder"] intValue];
        self.arder_no_newwork = [arderDict[@"no_network"] integerValue];
    }
    
    NSDictionary *floatDict = configInfo[@"float_ball"];
    if (floatDict) {
        self.switch_data_is_float = [floatDict[@"is_float"] intValue];
        self.switch_data_is_show_bannel = [floatDict[@"is_show_banner"] intValue];
    }
    
    NSDictionary *tcpdict = configInfo[@"tcp"];
    if ([tcpdict count]>1) {
        self.tcp_host = tcpdict[@"host"];
        self.tcp_port = [NSString stringWithFormat:@"%@",tcpdict[@"port"]];
    }
    
    self.is_socket_log = !![configInfo[@"is_socket_log"] intValue];
    self.is_role_report = !![configInfo[@"is_role_report"] intValue];
    self.is_client_ad_report = !![configInfo[@"is_client_ad_report"] intValue];
    self.is_no_network = !![configInfo[@"is_no_network"] intValue];
    self.is_crash_log = !![configInfo[@"is_crash_log"] intValue];
    
    self.is_docking = !![configInfo[@"is_docking"] intValue];
    
    id pay_no = configInfo[@"pay_no"];
    if ([pay_no isKindOfClass:[NSDictionary class]]) {
        self.apple_pay_no = [NSString stringWithFormat:@"%@",pay_no[@"apple"]];
    }
    
    
    self.is_privacy_modal = !![configInfo[@"is_privacy_modal"] intValue];
    
    NSDictionary *reportDict = configInfo[@"report"];
    self.report_activate = [reportDict[@"activate"] integerValue];
    self.report_reg = [reportDict[@"reg"] integerValue];
    self.report_pay = [reportDict[@"pay"] integerValue];
    self.report_pay_return_period = [reportDict[@"pay_return_period"] integerValue];
    
    NSDictionary *iconDict = configInfo[@"icon"];
    self.icon_left = iconDict[@"left"];
    self.icon_middle = iconDict[@"middle"];
    self.icon_right = iconDict[@"right"];
    self.icon_scale = [iconDict[@"scale"] integerValue];
    
    self.isLeft = NO;
    self.isRight = NO;
    self.isMiddle = NO;
    
    if (self.icon_left && self.icon_left.length>1) {
        self.isLeft = YES;
        self.leftImage = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:self.icon_left]]];
    }
    if (self.icon_middle && self.icon_middle.length>1) {
        self.isMiddle = YES;
        self.middleImage = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:self.icon_middle]]];
    }
    if (self.icon_right && self.icon_right.length>1) {
        self.isRight = YES;
        self.rightImage = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:self.icon_right]]];
    }
    
    if (!(self.isLeft && self.isRight && self.isMiddle)) {
        [HGHShowBall closeFloatingBall]; //三种图片只要有一个没有就不显示
    }
    
    self.channelID =configInfo[@"channel_id"];
    
    id adjust = configInfo[@"adjust"];
    id client = adjust[@"client"];
    if ([client isKindOfClass:[NSDictionary class]]) {
        self.adjust_AppToken = client[@"AppToken"];
        self.adjust_reg = client[@"reg"];
        self.adjust_login = client[@"login"];
        self.adjust_bootstrap = client[@"bootstrap"];
        self.adjust_charge_page = client[@"charge_page"];
        self.adjust_charge_ok = client[@"charge_ok"];
    }
    
    self.adjust_dc = adjust[@"dc"];
    NSDictionary *login_param = configInfo[@"login_param"];
    self.googleID = login_param[@"googleServerClientId_ios"];
    
    
    
}




@end
