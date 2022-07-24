//
//  HGHChangePassword.m
//  haiwaiSDK
//
//  Created by Lucas on 2019/4/23.
//  Copyright © 2019 Lucas. All rights reserved.
//

#import "HGHChangePassword.h"
#import "HGHTools.h"
#import "HGHUIFrame.h"
#import "HGHLogin.h"
#import "HGHHttprequest.h"
#import "HGHAccessApi.h"
#import "HGHAlertview.h"
#import "HGHEmailLogin.h"

@implementation HGHChangePassword
+(instancetype)shareinstance
{
    static HGHChangePassword *change = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        change = [[HGHChangePassword alloc]init];
    });
    return change;
}

-(void)gotoChangePassword
{
    self.isFirst = YES;
    UIViewController *currentVC = [HGHTools getCurrentViewcontronller];
    self.imageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, VIEWWIDTH, VIEWHEIGHT)];
    [self.imageView setImage:[UIImage imageNamed:@"outSea.bundle/bgwhite.png"]];
    self.imageView.userInteractionEnabled = YES;
//    [currentVC.view addSubview:self.imageView];
    [[HGHLogin shareinstance].baseView addSubview:self.imageView];
    CGFloat labX = (VIEWWIDTH-[HGHUIFrame adapterWidth:360])/2;
    CGFloat labY = [HGHUIFrame adapterWidth:15];
    CGFloat labWidth = [HGHUIFrame adapterWidth:360];
    UILabel *titleLab = [[UILabel alloc]initWithFrame:CGRectMake(labX, labY, labWidth, 25)];
    titleLab.text = GuoJiHua(@"修改密码");
    titleLab.font = [UIFont systemFontOfSize:25];
    titleLab.textAlignment = NSTextAlignmentCenter;
    [self.imageView addSubview:titleLab];
    
    UIButton *backBtn = [[UIButton alloc]initWithFrame:CGRectMake(15, labY, 20, 30)];
    [self.imageView addSubview:backBtn];
    [backBtn setImage:[UIImage imageNamed:@"outSea.bundle/back.png"] forState:UIControlStateNormal];
    [backBtn addTarget:self action:@selector(goback:) forControlEvents:UIControlEventTouchUpInside];
    
    CGFloat  textFTY = labY + 25+[HGHUIFrame adapterWidth:10];
    CGFloat textFieldWidth = [HGHUIFrame adapterWidth:362];
    CGFloat textFieldX = (VIEWWIDTH-textFieldWidth)/2;
    CGFloat heightAndxxx = 40+[HGHUIFrame adapterHeight:8];
    NSArray *arrName = @[GuoJiHua(@"Account"),GuoJiHua(@"Oldpwd"),GuoJiHua(@"Newpwd"),GuoJiHua(@"Confirmpwd")];
    for (int i=0; i<4; i++) {
        UITextField *textFT = [[UITextField alloc]initWithFrame:CGRectMake(textFieldX, textFTY+heightAndxxx*i, textFieldWidth, 40)];
        [textFT.layer setCornerRadius:20];
        textFT.layer.masksToBounds = YES;
        textFT.backgroundColor = [UIColor whiteColor];
        switch (i) {
            case 0:
                NSLog(@"0");
                self.accountTF = textFT;
                self.accountTF.placeholder = GuoJiHua(@"请输入邮箱地址");
                break;
            case 1:
                NSLog(@"1");
                self.oldPwdTF = textFT;
//                self.oldPwdTF.placeholder = GuoJiHua(@"密码的长度必须在8到25之间");
                break;
            case 2:
                NSLog(@"2");
                self.newsPwdTF = textFT;
//                self.newsPwdTF.placeholder = GuoJiHua(@"密码的长度必须在8到25之间");
                break;
            case 3:
                NSLog(@"3");
                self.confirmPwdTF = textFT;
//                self.confirmPwdTF.placeholder = GuoJiHua(@"密码的长度必须在8到25之间");
                break;
                
            default:
                break;
        }
        
        UILabel *label = [[UILabel alloc] init];
        label.text  = arrName[i];
//        label.backgroundColor = [UIColor greenColor];
        UIFont *fnt = [UIFont systemFontOfSize:20];
        label.font = fnt;
        CGSize size = [label.text sizeWithAttributes:[NSDictionary dictionaryWithObjectsAndKeys:fnt,NSFontAttributeName, nil]];
        label.frame = CGRectMake(0, 0, size.width, size.height);
        label.textColor = [UIColor blueColor];
        
        UIView *leftView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 50, 40)];
        leftView.backgroundColor = [UIColor redColor];
        textFT.leftViewMode = UITextFieldViewModeAlways;
        textFT.leftView = label;
        

        
        [self.imageView addSubview:textFT];
    }
    
    CGFloat sureBtnY = textFTY +heightAndxxx*4+[HGHUIFrame adapterWidth:10];
    CGFloat sureBtnW = [HGHUIFrame adapterWidth:200];
    
    UIButton *sureBtn = [[UIButton alloc]initWithFrame:CGRectMake((VIEWWIDTH-sureBtnW)/2, sureBtnY, sureBtnW, 50)];
    
    [sureBtn.layer setCornerRadius:25];
    sureBtn.layer.masksToBounds = YES;
    sureBtn.backgroundColor = [UIColor blueColor];
    [self.imageView addSubview:sureBtn];
    [sureBtn setTitle:GuoJiHua(@"确认") forState:UIControlStateNormal];
    [sureBtn addTarget:self action:@selector(changePwd:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)repeatShowTime:(NSTimer *)tempTimer {
    
    self.isFirst = NO;
    [self.timer invalidate];
    self.timer = nil;
    
}

-(void)changePwd:(UIButton *)sender
{
    
    

    self.timer = [NSTimer scheduledTimerWithTimeInterval:5.0f target:self selector:@selector(repeatShowTime:) userInfo:@"admin" repeats:YES];
    NSLog(@"sure btn");
    NSString *account = self.accountTF.text;
    NSString *oldpwd = self.oldPwdTF.text;
    NSString *newpwd = self.newsPwdTF.text;
    NSString *confirm = self.confirmPwdTF.text;
    if ([account isEqualToString:@""]) {
        [HGHAlertview showAlertViewWithMessage:GuoJiHua(@"账号不能为空")];
        return;
    }else if ([oldpwd isEqualToString:@""]){
        [HGHAlertview showAlertViewWithMessage:GuoJiHua(@"密码不能为空")];
        return;
        
    }else if ([newpwd isEqualToString:@""])
    {
        [HGHAlertview showAlertViewWithMessage:GuoJiHua(@"密码不能为空")];
        return;
        
    }else if ([confirm isEqualToString:@""])
    {
        [HGHAlertview showAlertViewWithMessage:GuoJiHua(@"密码不能为空")];
        return;
    }else if (![HGHTools checkEmail:account])
    {
        [HGHAlertview showAlertViewWithMessage:GuoJiHua(@"邮箱格式不匹配")];
        return;
    }else if ([oldpwd length]<8||[oldpwd length]>25)
    {
        [HGHAlertview showAlertViewWithMessage:GuoJiHua(@"密码的长度必须在8到25之间")];
        return;
    }else if ([newpwd length]<8||[newpwd length]>25)
    {
        [HGHAlertview showAlertViewWithMessage:GuoJiHua(@"密码的长度必须在8到25之间")];
        return;
    }else if ([confirm length]<8||[confirm length]>25)
    {
        [HGHAlertview showAlertViewWithMessage:GuoJiHua(@"密码的长度必须在8到25之间")];
        return;
    }
    if (!self.isFirst) {
        return;
    }
    self.isFirst = NO;
    [[HGHHttprequest shareinstance] changePwdWithusername:account oldPassword:oldpwd confirmPwd:confirm pwd:newpwd ifSuccess:^(id  _Nonnull response) {
        NSLog(@"修改密码成功--%@",response);
        NSDictionary *userInfo = response;
        self.isFirst = YES;
        if ([userInfo[@"code"]intValue]!=1) {
            NSLog(@"错误=%@",userInfo[@"msg"]);
            //            [HGHAlertview showAlertViewWithMessage:GuoJiHua(@"修改密码失败")];
            [HGHAlertview showAlertViewWithMessage:userInfo[@"msg"]];
        }else{
            NSLog(@"success");
            NSDictionary *userDict = userInfo[@"data"];
            [HGHTools removeViews:[HGHLogin shareinstance].baseView];
            [HGHLogin shareinstance].baseView = [[UIView alloc]initWithFrame:CGRectMake(XPOINT, YPOINT, VIEWWIDTH, VIEWHEIGHT)];
            UIViewController *currentVC = [HGHTools getCurrentViewcontronller];
            [currentVC.view addSubview:[HGHLogin shareinstance].baseView];
            [[HGHEmailLogin shareInstance] emailLogin];
            [HGHAlertview showAlertViewWithMessage:GuoJiHua(@"修改密码成功")];

            
        }
    } failure:^(NSError * _Nonnull error) {
        self.isFirst = YES;
        NSLog(@"error=%@",error);
    }];
    NSLog(@"account=%@",account);
}


-(void)goback:(UIButton *)sender
{
    [self.imageView removeFromSuperview];
}

@end
