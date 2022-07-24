//
//  ViewController.m
//  AWSDKDemo
//
//  Created by admin on 2020/12/1.
//

#import "ViewController.h"
#import "AWSDKApi.h"
#import "GGGLabel.h"
#import "NSAttributedString+GGGText.h"
#import "HGHShowBall.h"
#import "AWViewManager.h"
#import "AWHTTPRequest.h"
#import "AWDeviceInfo.h"

#import "XXTEA.h"
#import "AWSaveImage.h"

#import "AWDataReport.h"
//#import "AWAdReportModel.h"
//#import "AWRoleInfoModel.h"
//#import "WXApi.h"

//测试
#import "RadioButton.h"
#import "AWLocalFile.h"
#import "AWTestConfig.h"
#import "HGHNetWork.h"

#import "AWLoginActiveManager.h"
#import "AWAppleLogin.h"

#import "AWHttpResult.h"

#import "AWBindWechat.h"
#import "AWGoogleLoginManager.h"


@interface ViewController ()<AWSDKDelegate>
@property(nonatomic, strong)UIView *showView;
@property(nonatomic, strong)UIView *testView;
@property(nonatomic, strong)UIView *selectView;

@property(nonatomic, strong)NSArray *configArr;
@property(nonatomic, strong)NSDictionary *configDict;
//
//
//@property(nonatomic, strong)UITextField *testTF;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
//    [AWDataReport removeAllReportData];
    self.view.backgroundColor = [UIColor orangeColor];
    [AWSDKApi shareInstance].delegate = self;
    [self createSwitchUI];
    [self whatFuck];
//    [self begin];
}

-(void)createSwitchUI
{
   
    self.selectView= [[UIView alloc]initWithFrame:[UIScreen mainScreen].bounds];
    self.selectView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.selectView];
    
//    RadioButton *btn = [[RadioButton alloc]initWithFrame:CGRectMake(100, 100, 200, 200)];
//    btn.backgroundColor = [UIColor redColor];
////    [selectedView addSubview:btn];
//
//    NSMutableArray* buttons = [NSMutableArray arrayWithCapacity:1];
//    CGRect btnRect = CGRectMake(25, 100, 100, 30);
//    for (NSString* optionTitle in @[@"测试环境"]) {
//        RadioButton* btn = [[RadioButton alloc] initWithFrame:btnRect];
//        [btn addTarget:self action:@selector(onRadioButtonValueChanged:) forControlEvents:UIControlEventValueChanged];
//        btnRect.origin.y += 40;
//        [btn setTitle:optionTitle forState:UIControlStateNormal];
//        [btn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
//        btn.titleLabel.font = [UIFont boldSystemFontOfSize:17];
//        [btn setImage:[UIImage imageNamed:@"unchecked.png"] forState:UIControlStateNormal];
//        [btn setImage:[UIImage imageNamed:@"checked.png"] forState:UIControlStateSelected];
//        btn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
//        btn.titleEdgeInsets = UIEdgeInsetsMake(0, 6, 0, 0);
//        [self.selectView addSubview:btn];
//        [buttons addObject:btn];
//    }
//    [buttons[0] setGroupButtons:buttons]; // Setting buttons into the group
//    [buttons[0] setSelected:YES];
    /*
     
     public final static String[] ZSZL = {"真神之路", "bdz83pnzenvqjr7l", "xeeHPvzXCmiIHJfMmGJmqPgQdUJACeIj", "sdk0010100100"};
     public final static String[] WZJH = {"我在江湖", "ebg8krwm2n2yxdmp", "eZSVMZqVGxpccUEkFxRJwXHOtfHzvdPJ", "sdk00401001"};
     public final static String[] DSDL = {"斗神大陆", "326xqzwgqnpd85lo", "esKhKHNkfasBWkOFahzyGWwtFuxxDehY", "sdk00501001"};
     public final static String[] WDTX = {"武道天下", "j7g2bpnk4wdmrxz5", "RmhOaNtsFCvAvzUdZEehWEdpTqsuhJQZ", "sdk00601001"};
     public final static String[] MDJY = {"漫斗纪元", "52zpeqw6kax4drk6", "KpdZvGxGaxpUVepYAGMftmJLyyQRzQCZ", "sdk00701001"};
     public final static String[] JZBHL = {"九州八荒录", "beoz2ywqva8rk5pv", "LAXxWbVBKGZxKFLtQOYnuHpJhdUTvCxk", "sdk00801001"};
     public final static String[] XMQY = {"仙梦奇缘", "d52o7vn4pngkx86m", "ayUKcqRIXbZEMeEHyGwuUyRmRQONhwwv", "sdk00901001"};
     public final static String[] HYTG = {"荒野特工", "6g98k7ajyaboq4zr", "JMRzxbzGVqStUCcuzpFxAZABTXYgNWzB", "sdk01001001"};
     public final static String[] MLQY = {"魔力契约", "oqvx3w3ryrw4mpey", "avPQhunOqvzPJrFOzVrKNUctRaPJnZAP", "sdk01101001"};
     public final static String[] TCSSCC = {"贪吃蛇蛇冲刺", "lbd9k3w8mazx6epg", "RUhYPXZxTFvNVsSbpyTeuDrweJNwDCvL", "sdk01201001"};
     */
    
    NSMutableArray* buttons2 = [NSMutableArray array];
    NSArray *gameArr = @[@"测试游戏",@"真神之路",@"我在江湖",@"斗神大陆",@"武道天下",@"漫斗纪元",@"九州八荒录",@"仙梦奇缘",@"荒野特工",@"魔力契约",@"贪吃蛇蛇冲刺",@"远航斗地主",@"梦幻纸牌",@"战玲珑",@"珍珠分类"];
    CGRect btnRect2 = CGRectMake(25, 200, 150, 30);
    if ([AWTools DeviceOrientation] !=3) {
        btnRect2 = CGRectMake(50, 20, 150, 30);
    }
    
    
    int i =0;
    for (NSString* optionTitle in gameArr) {
        RadioButton* btn = [[RadioButton alloc] initWithFrame:btnRect2];
        [btn addTarget:self action:@selector(onRadioButtonValueChanged2:) forControlEvents:UIControlEventValueChanged];
        btnRect2.origin.y += 40;
        btn.tag = 900+i;
        i +=1;
        [btn setTitle:optionTitle forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
        btn.titleLabel.font = [UIFont boldSystemFontOfSize:17];
        [btn setImage:[UIImage imageNamed:@"unchecked.png"] forState:UIControlStateNormal];
        [btn setImage:[UIImage imageNamed:@"checked.png"] forState:UIControlStateSelected];
        btn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        btn.titleEdgeInsets = UIEdgeInsetsMake(0, 6, 0, 0);
        [self.selectView addSubview:btn];
        [buttons2 addObject:btn];
    }
    [buttons2[0] setGroupButtons:buttons2]; // Setting buttons into the group
    [buttons2[0] setSelected:YES];
    NSDictionary *dict =@{@"appID":@"d52o7vn49pwgkx86",@"appkey":@"KPsChEWtqQNNHcTNnemszchpLtZRNJGv",@"channelID":@"sdk99954"};
//    [config setdict:dict];
    self.configDict = dict;
    
    
    UIButton *beginBtn = [[UIButton alloc]initWithFrame:CGRectMake(250, 100, 80, 40)];
    beginBtn.backgroundColor = [UIColor orangeColor];
    [beginBtn setTitle:@"开始测试" forState:UIControlStateNormal];
    [self.selectView addSubview:beginBtn];
    [beginBtn addTarget:self action:@selector(clickBegin:) forControlEvents:UIControlEventTouchUpInside];
    
    
    UIButton *clearBtn = [[UIButton alloc]initWithFrame:CGRectMake(230, 200, 120, 40)];
    clearBtn.backgroundColor = [UIColor greenColor];
    [clearBtn setTitle:@"清除本地数据" forState:UIControlStateNormal];
    [self.selectView addSubview:clearBtn];
    [clearBtn addTarget:self action:@selector(clickClear) forControlEvents:UIControlEventTouchUpInside];
    
    
    UIButton *testBtn = [[UIButton alloc]initWithFrame:CGRectMake(230, 260, 90, 90)];
//    [self.selectView addSubview:testBtn];
//    [testBtn setImage:[UIImage imageNamed:@"login_account.png"] forState:UIControlStateNormal];
    [testBtn setBackgroundImage:[UIImage imageNamed:@"login_account.png"] forState:UIControlStateNormal];
    
}
/*
 //存储目录
 #define  LOCALUSERINFO    @"test_AW_userinfo"
 #define  LOCALREPORTINFO  @"test_AW_reportinfo"
 #define  LOCALSDKCONFIGINFO  @"test_AW_configinfo"
 #define  LOCALLOGINACCOUNT  @"test_AW_loginAccount"
 #define  LOCALORDERINFO     @"test_AW_orderinfo"
 #define  LOGINSTATUS      @"loginstatus"
 
 */
-(void)clickClear
{
    [AWLocalFile removeDocumentDataAtPath:LOCALUSERINFO];
    [AWLocalFile removeDocumentDataAtPath:LOCALREPORTINFO];
    [AWLocalFile removeDocumentDataAtPath:LOCALSDKCONFIGINFO];
    [AWLocalFile removeDocumentDataAtPath:LOCALLOGINACCOUNT];
    [AWLocalFile removeDocumentDataAtPath:LOCALORDERINFO];
    [AWLocalFile removeDocumentDataAtPath:LOGINSTATUS];
    [AWTools makeToastWithText:@"清除数据成功"];
    
}

-(void)clickBegin:(UIButton *)sender
{
    [self.selectView removeFromSuperview];
    [self begin];
}

-(void)onRadioButtonValueChanged:(RadioButton*)sender
{
    if(sender.selected) {
        NSLog(@"Selected env: %@", sender.titleLabel.text);
       
    }
}

/*
 NSString *appID = dict[@"appID"];
 NSString *appkey = dict[@"appkey"];
 NSString *channelID = dict[@"channelID"];
 
 public final static String[] ZSZL = {"真神之路", "bdz83pnzenvqjr7l", "xeeHPvzXCmiIHJfMmGJmqPgQdUJACeIj", "sdk0010100100"};
 public final static String[] WZJH = {"我在江湖", "ebg8krwm2n2yxdmp", "eZSVMZqVGxpccUEkFxRJwXHOtfHzvdPJ", "sdk00401001"};
 public final static String[] DSDL = {"斗神大陆", "326xqzwgqnpd85lo", "esKhKHNkfasBWkOFahzyGWwtFuxxDehY", "sdk00501001"};
 public final static String[] WDTX = {"武道天下", "j7g2bpnk4wdmrxz5", "RmhOaNtsFCvAvzUdZEehWEdpTqsuhJQZ", "sdk00601001"};
 public final static String[] MDJY = {"漫斗纪元", "52zpeqw6kax4drk6", "KpdZvGxGaxpUVepYAGMftmJLyyQRzQCZ", "sdk00701001"};
 public final static String[] JZBHL = {"九州八荒录", "beoz2ywqva8rk5pv", "LAXxWbVBKGZxKFLtQOYnuHpJhdUTvCxk", "sdk00801001"};
 public final static String[] XMQY = {"仙梦奇缘", "d52o7vn4pngkx86m", "ayUKcqRIXbZEMeEHyGwuUyRmRQONhwwv", "sdk00901001"};
 public final static String[] HYTG = {"荒野特工", "6g98k7ajyaboq4zr", "JMRzxbzGVqStUCcuzpFxAZABTXYgNWzB", "sdk01001001"};
 public final static String[] MLQY = {"魔力契约", "oqvx3w3ryrw4mpey", "avPQhunOqvzPJrFOzVrKNUctRaPJnZAP", "sdk01101001"};
 public final static String[] TCSSCC = {"贪吃蛇蛇冲刺", "lbd9k3w8mazx6epg", "RUhYPXZxTFvNVsSbpyTeuDrweJNwDCvL", "sdk01201001"};
 "测试游戏", "d52o7vn49pwgkx86", "KPsChEWtqQNNHcTNnemszchpLtZRNJGv", "sdk99904"
 */

-(void) onRadioButtonValueChanged2:(RadioButton*)sender
{

    NSArray *arr = @[@{@"appID":@"d52o7vn49pwgkx86",@"appkey":@"KPsChEWtqQNNHcTNnemszchpLtZRNJGv",@"channelID":@"sdk99904"},
                     @{@"appID":@"bdz83pnzenvqjr7l",@"appkey":@"xeeHPvzXCmiIHJfMmGJmqPgQdUJACeIj",@"channelID":@"sdk0010100100"},
                     @{@"appID":@"ebg8krwm2n2yxdmp",@"appkey":@"eZSVMZqVGxpccUEkFxRJwXHOtfHzvdPJ",@"channelID":@"sdk00401001"},
                     @{@"appID":@"326xqzwgqnpd85lo",@"appkey":@"esKhKHNkfasBWkOFahzyGWwtFuxxDehY",@"channelID":@"sdk00501001"},
                     @{@"appID":@"j7g2bpnk4wdmrxz5",@"appkey":@"RmhOaNtsFCvAvzUdZEehWEdpTqsuhJQZ",@"channelID":@"sdk00601001"},
                     @{@"appID":@"52zpeqw6kax4drk6",@"appkey":@"KpdZvGxGaxpUVepYAGMftmJLyyQRzQCZ",@"channelID":@"sdk00701001"},
                     @{@"appID":@"beoz2ywqva8rk5pv",@"appkey":@"LAXxWbVBKGZxKFLtQOYnuHpJhdUTvCxk",@"channelID":@"sdk00801001"},
                     @{@"appID":@"d52o7vn4pngkx86m",@"appkey":@"ayUKcqRIXbZEMeEHyGwuUyRmRQONhwwv",@"channelID":@"sdk00901001"},
                     @{@"appID":@"6g98k7ajyaboq4zr",@"appkey":@"JMRzxbzGVqStUCcuzpFxAZABTXYgNWzB",@"channelID":@"sdk01001001"},
                     @{@"appID":@"oqvx3w3ryrw4mpey",@"appkey":@"avPQhunOqvzPJrFOzVrKNUctRaPJnZAP",@"channelID":@"sdk0010100100"},
                     @{@"appID":@"lbd9k3w8mazx6epg",@"appkey":@"RUhYPXZxTFvNVsSbpyTeuDrweJNwDCvL",@"channelID":@"sdk01201001"},
                     @{@"appID":@"j7g2bpnkg4wdmrxz",@"appkey":@"JNYTLusdFewbgGtEhKXQdMDnIkKFmSNW",@"channelID":@"sdk03154"},
                     @{@"appID":@"beoz2ywqevw8rk5p",@"appkey":@"gUNQObQrSVKrBNcvckxYMwVfFZgbRStF",@"channelID":@"sdk03054"},
                     @{@"appID":@"4vx3poalreayle2z",@"appkey":@"MmePsIxCXeEqeSzFfGdygAKctwFHMVQE",@"channelID":@"sdk03354"},
                     @{@"appID":@"bdz83pnzdewvqjr7",@"appkey":@"sSaDfmuzguGPOhAqCVyOgUtkZccDsmak",@"channelID":@"sdk03454"},
                     

    ];

    self.configArr = arr;
    if(sender.selected) {
        NSLog(@"tag==%ld",(long)sender.tag);
//        AWTestConfig *config = [AWTestConfig shareInstance];
        NSDictionary *dict = arr[sender.tag-900];
        self.configDict = dict;
//        [config setdict:dict];
    }
}


-(void)begin
{
    
    NSString *appID = self.configDict[@"appID"];
    NSString *appKey = self.configDict[@"appkey"];
    NSString *channelID = self.configDict[@"channelID"];
    
    [AWConfig setSDKTEST:YES];
    [AWConfig setCurrentAppID:appID];
    [AWConfig setCurrentAppKey:appKey];
    [AWConfig setCurrentChannelID:channelID];
    [AWSDKApi shareInstance].delegate = self;
    [AWSDKApi initSDK];
    [self createUI];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//        [self testLogin];
    });
    [self addruler];
}

-(void)addruler
{
    UIView *rulerView = [[UIView alloc]initWithFrame:CGRectMake(SCREENWIDTH-100, SCREENHEIGHT/2.0, 100, SCREENHEIGHT/2.0)];
    [self.view addSubview:rulerView];
    rulerView.backgroundColor = [UIColor greenColor];
    
    CGFloat heightx = SCREENHEIGHT/2.0;
    int num = heightx / 50;
    for (int i=0; i<num; i++) {
        UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(0, 50 * i, 100, 1)];
        lineView.backgroundColor = [UIColor blackColor];
        [rulerView addSubview:lineView];
    }
    
}


-(void)getLogoutResult:(NSDictionary *)userInfo
{
    NSLog(@"logout success");
}

-(void)createUI
{
    NSArray *testArr = @[@"登录",@"注册",@"测试",@"注销",@"支付"];
    for (int i=0; i<5; i++) {
        AWHGHALLButton *btn = [[AWHGHALLButton alloc]initWithFrame:CGRectMake(50, 60+60*i, 60, 40)];
        [self.view addSubview:btn];
        btn.backgroundColor = [UIColor yellowColor];
        [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [btn setTitle:testArr[i] forState:UIControlStateNormal];
        btn.tag = 100+i;
        [btn addTarget:self action:@selector(click:) forControlEvents:UIControlEventTouchUpInside];
    }
    
    self.showView = [[UIView alloc]initWithFrame:CGRectMake(200, 50, 200, 0)];
    [self.view addSubview:self.showView];
    self.showView.hidden = YES;
    self.showView.backgroundColor = [UIColor greenColor];
    
//    self.testTF = [[UITextField alloc]initWithFrame:CGRectMake(100, 400, 100, 50)];
////    [self.view addSubview:self.testTF];
//    self.testTF.backgroundColor = [UIColor whiteColor];
    
    NSArray *socketArr = @[@"202",@"203",@"204",@"205",@"206",@"207"];
    for (int i=0; i<socketArr.count; i++) {
        UIButton *btn = [[UIButton alloc]initWithFrame:CGRectMake(220, 60+60*i, 60, 40)];
        [self.view addSubview:btn];
        btn.backgroundColor = [UIColor yellowColor];
        [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [btn setTitle:socketArr[i] forState:UIControlStateNormal];
        btn.tag = 202+i;
        [btn addTarget:self action:@selector(clickSocket:) forControlEvents:UIControlEventTouchUpInside];
    }
    
    
}

-(void)testLogin
{
    AWLog(@"login");
    [AWSDKApi login];
}

-(void)testRegister
{
    AWLog(@"register");
//    [self hiddenview];
//    [self disConnect];
    [AWLoginViewManager showAccountRegist];
}

-(void)switchAccountx
{
    [self switchAccount];
}

-(void)testpay
{
//        [AWLocalFile removeDocumentDataAtPath:SOCKETDATA];
//    return;
    
    AWOrderModel *orderModel = [[AWOrderModel alloc]init];
    orderModel.amount = 0.01;
    orderModel.amount_unit = @"CNY";
//    orderModel.ext = @{@"test":@"xxxxx"};
    orderModel.item_id = @"xxxx.oooo";
    orderModel.item_name = @"iOS测试";
    orderModel.notify_url = @"https://apicn-sdk.jxywl.cn/index/notify";
    orderModel.site_uid = [AWUserInfoManager shareinstance].account;
    orderModel.timeStr = [AWTools getCurrentTimeString];
    orderModel.out_trade_no = [AWTools getCurrentTimeString];
    orderModel.server_id = @"9999";
    orderModel.role_id = @"8888888";
    [AWSDKApi maimaimaiWithOrderInfo:orderModel];
}

-(void)testApplePay
{
    AWOrderModel *orderModel = [[AWOrderModel alloc]init];
    orderModel.amount = 6.00;
    orderModel.amount_unit = @"CNY";
//    orderModel.ext = @{@"test":@"xxxxx"};
    orderModel.item_id = @"xxxx.oooo";
    orderModel.item_name = @"iOS测试内购";
//    orderModel.notify_url = @"https://www.okjson.com/paytest/notify.php";//https://apicn-sdk.jxywl.cn/index/notify
    orderModel.notify_url = @"https://apicn-sdk.jxywl.cn/index/notify";
    orderModel.site_uid = [AWUserInfoManager shareinstance].account;
    orderModel.timeStr = [AWTools getCurrentTimeString];
    orderModel.out_trade_no = [AWTools getCurrentTimeString];
    orderModel.server_id = @"9999";
    orderModel.role_id = @"8888888";
    orderModel.productID = @"com.awsdk.demo.product.6";
    [AWSDKApi maimaimaiWithOrderInfo:orderModel];
}


-(void)testFunction
{
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(bindWebintoaw:) name:NOTIFICATIONWEIXINBIND object:nil];
    AWLog(@"function");
//    [self animation];
//    [self showFloating];
//    [self testremove];
//    [self makeToast];
//    [self testShowAdView];
//    [self testTF];
//    [self testHttpRequest];
//    [self testDeviceInfo];
//    [self testSaveImage];
//    [self xxteajiemi];
//    [self clearUserinfo];
//    [self switchAccount];
//    [self changePwd];
//    [self showUserPrortocol];
//    [self jumptoOtherAPP];
//    [self testReport];
//    [self testClearReport];
//    [self testReportad];
//    [self testCheckVersion];
//    [self testRoleReport];
//    [self showGif];
//    [self testWechat];
//    [self searchOrder];
//    [self showTestView];
//    [self showRednevelope];
//    [self testToutiaoNet];
//    [self testNonetWork];
//    [self testException];
//    [self telx];
//    [self connect];
//    [self testAdreport];
//    [self testRoleReportxx];
//    [self testBlock];
//    [self testOrder];
//    [self getDeviceID];
//    [self testActiveScreen];
//    [self testHttP];
//    [self testSignInWithApple];
//    [self showUI];
//    [self testShare];
//    [self testAnnounceView];
//    [self testShareWechat];
//    [self testBanner];
//    [self testDocking];
    
//    [self showProtocoleAgree];
//    [self showRealName];
//    [self showchangerPWD];
    [self testLange];
}

-(void)testLange
{
    [AWGoogleLoginManager googleSignOut];
//    NSString *testStr = NSLocalizedString(@"tt", nil);
    NSLog(@"testStr=%@",GUOJIHUA(@"tt"));
}

-(void)showchangerPWD
{
    [AWLoginViewManager showChangePwd];
}

-(void)showProtocoleAgree
{
    [AWLoginViewManager showProtocolAgreeView];
}

-(void)testWeixinBind
{
    [AWGlobalDataManage shareinstance].isWeixinLogin = NO;
    [AWBindWechat bindWeiChat];
}

-(void)testDocking
{
    [AWLoginViewManager showRightFloat];
}


-(void)testBanner
{
    [AWSDKApi enterGame];
    [AWHttpResult bannerRankResultWithUserinfo:@{}];
}

-(void)testShareWechat
{
    [AWLoginViewManager showAccountLogin];
    UIImage *shareImage = [UIImage imageNamed:@"5.png"];
    NSString *shareStr = @"我是分享的文字";
    NSString *shareLink = @"https://www.baidu.com";
    
//    [AWShareWeixinManager shareImageToWein:shareImage];
//    [AWShareWeixinManager shareTextToWeixin:shareStr];
//    [AWShareWeixinManager sharLinkToWeixin:shareLink];
}

-(void)testAnnounceView
{
    
    [AWHTTPRequest AWNoticeInfoRequestIfSuccess:^(id  _Nonnull response) {
        NSLog(@"notice info=%@",response);
    } failure:^(NSError * _Nonnull error) {
        //
    }];
    NSString *title = @"关机公告";
    NSString *content = @"内容内内容内容内容内容内容内容内容内容内容内容内容内容内容内容内容内容内容内容内容内容内容内容内容内容内容内容内容内容内容内容内容内容内容内容内容内容内容内容内容内容内容内容内容内容内容内容内容内容内容内容内容内容内容内容内容内容内容内容内容内容内容内容内容内容内容内容内容内容内容内容内容内容内容内容内容内容内容内容内容内容内容内容内容内容内容内容内容内容内容内容内容内容内容内容内容内容内容内容内容内容内容内容内容内容内容内容内容内容内容内容内容内容内容内容内容内容内容内容内容内容内容内容内容内容内容内容内容内容内容内容内容内容内容内容内容内容内容内容内容内容内容内容内容内容容";
//    [AWLoginViewManager showAnnounceView:title content:content isClose:NO];
    
}

-(void)testShare
{
    NSString *content = @"测试code111111";

}

-(void)showUI
{

    
    
    
}

-(void)testSignInWithApple
{

    [[AWAppleLogin shareInstance] signinWithApple];

}

-(void)whatFuck
{

}

-(void)testHttP
{
    [AWHTTPRequest AWCheckCanpayWithAmount:10 ifSuccess:^(id  _Nonnull response) {
        NSLog(@"respppp==%@",response);
        NSLog(@"end");
    } failure:^(NSError * _Nonnull error) {
        //
    }];
}

-(void)testActiveScreen
{
    NSLog(@"%s",__func__);

    AWLoginActiveManager *manager = [AWLoginActiveManager shareInstance];
    [manager showLoginActive];
}

-(void)getDeviceID
{
    if ([AWTools isIPhoneX]) {
        NSLog(@"iphonex");
    }else{
        NSLog(@"not iphonex");
    }
    NSString *idfa= [AWTools getIdfa];
    NSLog(@"i get idfa=%@",idfa);
}

-(void)testOrder
{
    AWOrderModel *orderModel = [[AWOrderModel alloc]init];
    orderModel.amount = 0.01;
    orderModel.amount_unit = @"CNY";
    orderModel.ext = @{@"ext":@"xxxxx",@"ext_game_id":@"xxxaaaaaa"};
    orderModel.item_id = @"xxxx.oooo";
    orderModel.item_name = @"iOS测试";
    orderModel.notify_url = @"https://www.okjson.com/paytest/notify.php";
    orderModel.timeStr = [AWTools getCurrentTimeString];
    orderModel.out_trade_no = [AWTools getCurrentTimeString];
    orderModel.server_id = @"2222";
    orderModel.role_id = @"33333";
    [AWSDKApi maimaimaiWithOrderInfo:orderModel];
}

-(void)testBlock
{
    
}

-(void)testSaveuserinfo
{
    NSDictionary *dict = @{@"userid":@"77775",
                           @"level":@123432,
                           @"xxx":@"rrrrrr"
    };
    
    NSString *jsonStrxx = [AWTools dicttojsonWithdict:dict];
    
    NSDictionary *newDict = @{@"key":@"testkey",@"value":jsonStrxx};
    NSString *jsonStr = [AWTools dicttojsonWithdict:newDict];
    AWLog(@"jsonStr==%@",jsonStrxx);
    int cmd = 205;

//    [AWSDKApi getjson_gameinfoWithKey:@"testkey"];
    
}

-(void)disConnect
{
    
}

-(void)testRoleReportxx
{
    //角色信息上报
//    AWRoleInfoModel *roleInfo = [[AWRoleInfoModel alloc]init];
//    roleInfo.reportType = @"entersvr";          //进入游戏和角色升级必传
//    roleInfo.nickName = @"testname是是是";       //SDK account(可不传)
//    roleInfo.level = 400;                       //关卡ID(接口更改不是角色等级)
//    roleInfo.serverId = @"222";
//    roleInfo.roleId = @"321";                   //SDK account(可不传)
//    roleInfo.time = [AWTools getCurrentTimeString];
//    roleInfo.regTime = [AWTools getCurrentTimeString];
//    roleInfo.ext = @{@"server_name":@"bbb",@"power":@789};
//    [AWSDKApi roleInfoReport:roleInfo];
}

-(void)testAdreport
{
    //广告数据上报
    AWAdReportModel *adinfo = [AWAdReportModel new];
    adinfo.ad_id = [AWTools getCurrentTimeString];
    adinfo.ad_type = 1;
    adinfo.ad_platform = @"GDT";
    adinfo.status = 0;
    adinfo.ad_place = @"bottom";
    //下面非必传
    adinfo.ad_time = 30;
    adinfo.action_type = @"show";
    adinfo.ad_data = @"test";
    [AWSDKApi adreportWithAdinfo:adinfo];
    
//    //非必传
//    [AWSDKApi gameCustonReportevent:@"pentaKill" extension:@{}];        //游戏自定义埋点数据上报
}


-(void)connect
{
    [AWLoginViewManager showCustomer];
}

-(void)telx
{
    //tel
    NSMutableString* str=[[NSMutableString alloc] initWithFormat:@"telprompt://%@",@"18553637289"];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str] options:@{} completionHandler:^(BOOL success) {
            if (success) {
                //
            }
    }];
}
-(void)testException
{
    NSObject *nilobj = nil;
    NSDictionary *testexc = @{@"test":nilobj};
}

-(void)testNonetWork
{
    [AWLoginViewManager showNonetworkView];
}

-(void)testToutiaoNet
{
    [HGHNetWork POSTToutiaoReportRequest];
}

-(void)showRednevelope
{
    [AWLoginViewManager showRedNevelopeView];
}
-(void)showTestView
{
    [self.view addSubview:self.testView];
    self.testView.frame = CGRectMake(200, 100, 200, 200);
    self.testView.hidden = NO;
    UIButton *closeBtn = [[UIButton alloc]initWithFrame:CGRectMake(170, 10, 30, 30)];
    [self.testView addSubview:closeBtn];
    [closeBtn addTarget:self action:@selector(clickCloseTest) forControlEvents:UIControlEventTouchUpInside];
    
}

-(void)clickCloseTest
{
    [UIView animateWithDuration:2.0 animations:^{
            CGRect floatingFrame = [AWGlobalDataManage shareinstance].floadtingFrame;
            self.testView.frame = floatingFrame;
        } completion:^(BOOL finished) {
            self.testView.hidden = YES;
        }];
}

-(void)bindWebintoaw:(NSNotification *)notice
{
    
}

-(void)searchOrder
{
    NSString *orderID = @"1608694834";
    orderID = @"zszl20201223095218v6umya4n";
    [AWHTTPRequest AWSearchOrderRequestwithorderID:orderID IfSuccess:^(id  _Nonnull response) {
        NSLog(@"response pay====%@",response);
        NSLog(@"end search");
    } failure:^(NSError * _Nonnull error) {
        NSLog(@"error");
    }];
}

-(void)testWechat
{

}



-(void)showGif
{
    [AWLoginViewManager showGif];
}
-(void)testRoleReport
{

    
    
    AWRoleInfoModel *roleInfo = [[AWRoleInfoModel alloc]init];
    roleInfo.reportType = @"entersvr";

    roleInfo.level = 999;
//    roleInfo.serverId = @"222";
//    roleInfo.roleId = @"321";
    roleInfo.time = [AWTools getCurrentTimeString];
    roleInfo.regTime = [AWTools getCurrentTimeString];
    roleInfo.ext = @{@"server_name三生三世":@"bbb",@"power":@789};
    [AWSDKApi roleInfoReport:roleInfo];
    
}

-(void)testCheckVersion
{
    NSDictionary *dict = @{@"update_info":@"1.更新了少时诵诗书所所所所所所所所\n2.大家都记得记得记得记得记得记得记得",
                           @"update_type":@"2",
                           @"update_url":@"https://wwww.baidu.com",
                           @"version_name":@"V3.3.3"
    };
    [AWLoginViewManager showVersionUpdateWithUpdateInfo:dict];
    
    
    [AWHTTPRequest AWCheckVersionRequestIfSuccess:^(id  _Nonnull response) {
        //
    } failure:^(NSError * _Nonnull error) {
        //
    }];
}

-(void)testReportad
{
    AWAdReportModel *adinfo = [AWAdReportModel new];
    adinfo.ad_id = [AWTools getCurrentTimeString];
    adinfo.ad_type = 1;
    adinfo.ad_platform = @"GDT";
    adinfo.status = 0;
    adinfo.ad_place = @"bottom";
    
    adinfo.ad_time = 30;
    adinfo.action_type = @"show";
    adinfo.ad_data = @"test";
    [AWSDKApi adreportWithAdinfo:adinfo];
}

-(void)testClearReport
{
//    [AWDataReport removeAllReportData];
    NSMutableArray *mutableArr = [AWDataReport loadReportData];
    AWLog(@"arrrrrr=%@",mutableArr);
}
-(void)testReport
{
    [AWHTTPRequest testReport];
}

-(void)jumptoOtherAPP
{
    
    NSString *appstore = @"itms://itunes.apple.com/gb/app/yi-dong-cai-bian/id391945719?mt=8";

    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:appstore] options:@{} completionHandler:^(BOOL success) {
            if (success) {
                AWLog(@"success");
            }else{
                AWLog(@"fail");
            }
    }];
}

-(void)showUserPrortocol
{
    [AWLoginViewManager showUserProtocol];
}

-(void)changePwd
{
    [AWLoginViewManager showChangePwd];
}

-(void)switchAccount
{
//    [AWSDKApi switchAccount];
    [AWSDKApi logout];
}

-(void)clearUserinfo
{
    [AWConfig clearLocalUserinfo];
}

-(void)xxteajiemi
{
    NSString *str = @"shkv7guyv/u/TmSA";
    
    NSString *result = [XXTEA decryptBase64StringToString:str stringKey:[AWConfig CurrentAppKey]];
    AWLog(@"result=%@",result);
}

//截屏
-(void)testSaveImage
{
//    [AWSaveImage testScreen];
}

-(void)testDeviceInfo
{
//    [AWDeviceInfo isInChina];
}


-(void)testHttpRequest
{
    [AWHTTPRequest testRequest];
}

-(void)testShowAdView
{
    
    NSArray *arr = @[@"顶顶顶顶",@"dddddd",@"jj极大京东卡加大科技",@"oowowowowsj可素可素"];
    [[AWViewManager shareInstance] showAdLabWithArr:arr];
}

-(void)testTF
{
    UITextField *testTTFF = [[UITextField alloc]initWithFrame:CGRectMake(30, 200, 200, 40)];
    [self.view addSubview:testTTFF];
    testTTFF.backgroundColor = [UIColor grayColor];
    AWTextField *xxtf = [AWTextField factoryBtnWithLeftWidth:TFLEFTWIDTH marginY:AdaptWidth(110)];
    UIView *rightView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 100, 40)];
    rightView.backgroundColor = [UIColor redColor];
    xxtf.rightView = rightView;
    xxtf.rightViewMode = UITextFieldViewModeAlways;
    [self.view addSubview:xxtf];
    
}

-(void)makeToast
{
    [AWTools makeToastWithText:@"哒哒哒哒哒哒多"];
}

-(void)testremove
{
    [self.testView removeFromSuperview];
}

-(void)showFloating
{
    [HGHShowBall showFloatingball];
}

-(void)animation
{
    [UIView animateWithDuration:2.0 animations:^{
        CGRect frame = self.showView.frame;
        frame.size.height = 100;
        self.showView.hidden = NO;
        self.showView.frame = frame;
    }];
}

-(void)hiddenview
{
    [UIView animateWithDuration:1.0 animations:^{
        CGRect frame = self.showView.frame;
        frame.size.height = 0;
        self.showView.frame = frame;
    } completion:^(BOOL finished) {
        self.showView.hidden = YES;
    }];
}

-(void)testYYlab
{
    GGGLabel *lab = [[GGGLabel alloc]initWithFrame:CGRectMake(100, 100, 200, 100)];
    [self.view addSubview:lab];
    
    NSMutableAttributedString *text  = [[NSMutableAttributedString alloc] initWithString: @"接下来，请您咨询阅读《xxx协议》！点击以下同意按钮，即表示您已阅读且完全知悉《xxx协议》约定事项并表示同意！同意后您将正式拥有xxxxxx身份。"];
     text.yy_lineSpacing = 5;
     text.yy_font = [UIFont systemFontOfSize:14];
     text.yy_color = BLACKCOLOR;
     [text yy_setTextHighlightRange:NSMakeRange(10, 7) color:[UIColor orangeColor] backgroundColor:[UIColor clearColor] tapAction:^(UIView * _Nonnull containerView, NSAttributedString * _Nonnull text, NSRange range, CGRect rect) {
         AWLog(@"xxx协议被点击了");

     }];
     lab.numberOfLines = 0;  //设置多行显示
     lab.preferredMaxLayoutWidth = 200; //设置最大的宽度
     lab.attributedText = text;  //设置富文本
}


-(void)click:(AWHGHALLButton *)sender
{
    switch (sender.tag) {
        case 100:
            [self testLogin];
            break;
        case 101:
            [self testRegister];
            break;
        case 102:
            [self testFunction];
            break;
        case 103:
            [self switchAccountx];
            break;
        case 104:
            [self testpay];
            break;
        case 105:
            [self testApplePay];
            break;
        
            
            
        default:
            break;
    }
}

-(void)clickSocket:(UIButton *)sender
{
    switch (sender.tag) {
        case 202:
        {
            [self testRoleReportxx];
        }
            break;
        case 203:
        {
            [self testAdreport];
        }
            break;
        case 204:
        {
            [self test204];
        }
            break;
        case 205:
        {
            [self test205];
        }
            break;
        case 206:
        {
            [self test206];
        }
            break;
        case 207:
        {
            [self test207];
        }
            break;

            
        default:
            break;
    }
}


-(void)testSocketWithType:(short)type
{
    NSDictionary *dict = @{@"userid":@"77775",
                           @"level":@123432,
                           @"xxx":@"rrrrrr"
    };
    
    NSString *jsonStrxx = [AWTools dicttojsonWithdict:dict];
    
    NSDictionary *newDict = @{@"key":@"testkey",@"value":jsonStrxx};
    NSString *jsonStr = [AWTools dicttojsonWithdict:newDict];
    AWLog(@"jsonStr==%@",jsonStrxx);

}
//204
-(void)test204
{
    NSDictionary *dict = @{@"userid":@"77775",
                           @"level":@123432,
                           @"xxx":@"rrrrrr"
    };
//    dict = @{@"empty":false,
//             @"params":
//    }
    
    NSString *jsonStrxx = [AWTools dicttojsonWithdict:dict];
    jsonStrxx = @"{\"empty\":false,\"params\":{\"role_name\":\"263163\",\"third_order_id\":\"119_1611051338_263163_sdk_sdk00106001_Hb\",\"amount\":\"600\",\"sign\":\"8AD0872CC89BA6CDE539394E1DAD9E04\",\"callback\":\"http://iwan.dldl.fygame.com/iwan/sdk_pay.php\",\"method_version\":\"v2\",\"area_id\":\"119\",\"title\":\"60钻石\"}}";
    jsonStrxx = @"{\"Power\":5.0,\"GroupDataStr\":\"{{['unlock']=true,['group']=1},{['unlock']=false,['group']=3},{['unlock']=false,['group']=2},{['unlock']=false,['group']=5},{['unlock']=false,['group']=7},{['unlock']=false,['group']=9},{['unlock']=false,['group']=6},{['unlock']=false,['group']=4},{['unlock']=false,['group']=8}}\",\"LastLoginSeconds\":1620421361.0,\"SelectLevel\":0.0,\"SignedDayData\":\"{}\",\"TaskData\":\"{{['id']=10001,['isComplete']=true,['isReward']=false}}\",\"Fragment\":0.0,\"EndlessDis\":0.0,\"SignDay\":1.0,\"SelectGroup\":0.0,\"LevelData\":\"{{['star']=0,['level']=1,['unlock']=true,['group']=1},{['star']=3,['level']=0,['unlock']=true,['group']=0}}\",\"EquipData\":\"{{['isSelect']=true,['id']=1001},{['isSelect']=true,['id']=2001},{['id']=3007,['level']=1,['isSelect']=true,['rare']=0},{['id']=6004,['count']=1,['rare']=0},{['id']=5002,['count']=1,['rare']=3}}\",\"UserData\":\"{['level']=1,['heart']=1,['atk']=1,['exp']=0,['speed']=20}\",\"Jewel\":1.0,\"Stone\":0.0,\"QiLing\":0.0,\"Characters\":\"{{['isSelect']=true,['index']=1}}\",\"RefreshCount\":3.0,\"Coin\":717.0}";
    jsonStrxx = @"{\"app_id\":\"jezpova2z4a68dmb\",\"data\":\"\",\"openid\":\"114778382211\",\"token\":\"NwDeZnfzMiTE0Nzc4MzhfMTYyMDYyMDExNV9zZGswMzYwNAO0O0OO0O0O\"}";
    [AWSDKApi saveUserInfo:jsonStrxx];
}

//205
-(void)test205
{
    [AWSDKApi getjson_UserInfoResult:^(NSString * _Nonnull resultjson) {
        NSLog(@"userInfo=%@",resultjson);
    }];
}

//206
-(void)test206
{
    NSDictionary *dict = @{@"userid":@"77775",
                           @"level":@123432,
                           @"xxx":@"rrrrrr"
    };
    
    NSString *jsonStrxx = [AWTools dicttojsonWithdict:dict];
    
//    NSDictionary *newDict = @{@"key":@"testkey",@"value":jsonStrxx};
//    NSString *jsonStr = [AWTools dicttojsonWithdict:newDict];
    [AWSDKApi saveGameInfo:jsonStrxx andKey:@"abckey"];
}
//207
-(void)test207
{
    [AWSDKApi getjson_gameinfoWithKey:@"abckey" result:^(NSString * _Nonnull resultjson) {
        NSLog(@"gameresult=%@",resultjson);
    }];
}


-(UIView *)testView
{
    if (!_testView) {
        _testView = [[UIView alloc]initWithFrame:CGRectMake(200, 100, 200, 200)];
        _testView.backgroundColor = [UIColor redColor];
    }
    return _testView;
}


#pragma mark SDKdelegate
-(void)getLoginResult:(NSDictionary *)userInfo
{
    NSLog(@"login success =%@",userInfo);
}
-(void)getLoginOutResult:(NSDictionary *)userInfo
{
    NSLog(@"logout successs");
}
-(void)getMaimaimaiResult:(NSDictionary *)maiInfo
{
    NSLog(@"maimaimai result==%@",maiInfo);
}

-(void)getRealNameCertificationResult:(NSDictionary *)nameAuthInfo
{
    NSLog(@"isAdultxxxx=%@",nameAuthInfo);
}
@end
