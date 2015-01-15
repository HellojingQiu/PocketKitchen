//
//  LLCLoginAndRegisterViewController.m
//  PocketKitchenGod
//
//  Created by yxx on 14-2-20.
//  Copyright (c) 2014年 yxx. All rights reserved.
//

#import "LLCLoginAndRegisterViewController.h"
#import "LLCLoginWidget.h"
#import "LLCRegisterWidget.h"
#import "DMPHttpRequest.h"
#import "LLCFacilityHUD.h"

#import "LLCUserInfoManager.h"

#import "LLCPasswordBox.h"

#define kNavItem_Tag 454          // 导航条按钮  tag
#define kPasswordBox_Tag 455      // 账号展示框1 tag
#define kOtherPasswordBox_Tag 456 // 账号展示框2 tag
#define kLoginSccessed_Tag 457    // 登陆成功    tag

/** 按钮类别 */
typedef enum {
  eLogin = 345,
  eRegister = 346,
}LoginViewButtonType;

/** 请求类别 */
typedef enum {
  eLoginRequest = 347,
  eRegisterRequest = 348,
}LoginViewRequestType;

@interface LLCLoginAndRegisterViewController ()
<DMPHttpRequestDelegate, UITextFieldDelegate, UIAlertViewDelegate>
{
  LLCLoginWidget *_loginView;         // 登陆view
  LLCRegisterWidget *_registerView;   // 注册view
  
  BOOL _isStore;
}
@end

@implementation LLCLoginAndRegisterViewController

- (id)initWithIsLogin:(BOOL)isLogin isStore:(BOOL)isStore {
  if (self = [super init]) {
    self.isLogin = isLogin;
    _isStore = isStore;
    _isStore = NO;
  }
  return self;
}

- (void)viewDidLoad
{
  [super viewDidLoad];
  
  UIImageView *backgroudView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 20+44, kScreenWidth, kScreenHeight)];
  backgroudView.image =[UIImage imageNamed:@"背景图.png"];
  [self.view addSubview:backgroudView];
  
  [self navBarConfig];
  [self viewConfig];
}

#pragma mark - Private
#pragma mark 导航条布局
- (void)navBarConfig {
  
  UIButton *registerBtn = [UIButton buttonWithType:UIButtonTypeCustom];
  [registerBtn setTitle:self.isLogin ? @"注册" : @"登录" forState:UIControlStateNormal];
  [registerBtn setBackgroundImage:[UIImage imageNamed:@"我的-按钮.png"] forState:UIControlStateNormal];
  [registerBtn setBackgroundImage:[UIImage imageNamed:@"我的-按钮-选.png"] forState:UIControlStateHighlighted];
  registerBtn.tag = kNavItem_Tag;
  registerBtn.bounds = CGRectMake(0, 0, 45, 40);
  [registerBtn addTarget:self action:@selector(loginOrRegister:) forControlEvents:UIControlEventTouchUpInside];
  [self.dmpNavigationBar setDMPNaviBarItemsWithArray:@[registerBtn] isLeft:NO];
}

#pragma mark 加载界面
- (void)viewConfig {
  // 加载登陆界面
  _loginView = [[[NSBundle mainBundle] loadNibNamed:@"LLCLoginWidget" owner:self options:nil] lastObject];
  
  _loginView.center = CGPointMake(kScreenWidth/2, 20+44+_loginView.bounds.size.height/2);
  [self.view addSubview:_loginView];
  
  _loginView.loginButton.tag = eLogin;
  [_loginView.loginButton addTarget:self action:@selector(loginOrRegisterButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
  _loginView.userNameTextField.delegate = self;
  
  // 如果选中了记住密码, 则自动填充
  if (_loginView.isRemmberPwd) {
    _loginView.userNameTextField.text = [[LLCUserInfoManager sharedUserInfo] userName];
    _loginView.userPwdTextField.text = [[LLCUserInfoManager sharedUserInfo] userPasswd];
  }
}

#pragma mark 切换登陆/注册界面
- (void)loginOrRegister:(UIButton *)button {
  
  if (self.isLogin) {
    // 前往注册界面
    if (_registerView == nil) {
      _registerView = [[[NSBundle mainBundle] loadNibNamed:@"LLCRegisterWidget" owner:self options:nil] lastObject];
      _registerView.center = CGPointMake(kScreenWidth/2, 20+44+_registerView.bounds.size.height/2);
      
      _registerView.registerButton.tag = eRegister;
      [_registerView.registerButton addTarget:self action:@selector(loginOrRegisterButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    }
    
    // 更改按钮标题
    [button setTitle:@"登录" forState:UIControlStateNormal];
    [self.view addSubview:_registerView];
    [_loginView removeFromSuperview];
    
  } else {
    // 前往登陆界面
    [button setTitle:@"注册" forState:UIControlStateNormal];
    [self.view addSubview:_loginView];
    [_registerView removeFromSuperview];
  }
  self.isLogin = !self.isLogin;
}

#pragma mark 登陆/注册按钮 响应事件
- (void)loginOrRegisterButtonPressed:(UIButton *)button {
  [self allResign];
  
  if (button.tag == eLogin) { // 登陆
    if (_loginView.userPwdTextField.text.length == 0 || _loginView.userPwdTextField.text.length == 0) {
      [self showAlertWithTitle:@"温馨提示" Message:@"所有输入不能为空"];
      return;
    }
    
    // 暂时记住密码
    if (_loginView.isRemmberPwd) {
      [[LLCUserInfoManager sharedUserInfo] setTempUserName:_loginView.userNameTextField.text andTempUserPwd:_loginView.userPwdTextField.text];
    }
    
    [LLCFacilityHUD hudLoadingAppearOnView:self.view];
    NSString *loginStr = [NSString stringWithFormat:kLogin, _loginView.userNameTextField.text, _loginView.userPwdTextField.text];
    [DMPHttpRequest requestWithUrlString:loginStr isRefresh:YES delegate:self tag:eLoginRequest];
    
  } else { // 注册
    if (_registerView.userPwdTextField.text.length == 0 || _registerView.userNaemTextField.text.length == 0 || _registerView.repeatPwdTextField.text == 0 || _registerView.emailTextField.text.length == 0) {
      [self showAlertWithTitle:@"温馨提示" Message:@"所有输入不能为空"];
      return;
    }
    
    if (![self validateEmail:_registerView.emailTextField.text]) {
      [self showAlertWithTitle:@"温馨提示" Message:@"请输入正确的邮箱"];
      return;
    }
    
    if (![_registerView.userPwdTextField.text isEqualToString:_registerView.repeatPwdTextField.text]) {
      [self showAlertWithTitle:@"温馨提示" Message:@"确认密码与密码不同"];
      return;
    }
    
    [[LLCUserInfoManager sharedUserInfo] setTempUserName:_registerView.emailTextField.text
                                          andTempUserPwd:_registerView.userPwdTextField.text];
    
    [LLCFacilityHUD hudLoadingAppearOnView:self.view];
    NSString *registerUrl = [NSString stringWithFormat:kRegister, _registerView.userNaemTextField.text, _registerView.userPwdTextField.text, _registerView.emailTextField.text];
    [DMPHttpRequest requestWithUrlString:registerUrl isRefresh:YES delegate:self tag:eRegisterRequest];
  }
}

#pragma mark 判断邮箱输入是否正确
- (BOOL)validateEmail:(NSString *)candidate {
  NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
  NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
  return [emailTest evaluateWithObject:candidate];
}

#pragma mark - UITextFied Delegate
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
  
  // 点中登陆输入账号输入框时
  if (textField == _loginView.userNameTextField) {
    
    // 如果plist中有用户存储的账号
    NSDictionary *passwors = [NSDictionary dictionaryWithContentsOfFile:kRecord_Plist_Path];
    NSArray *pwds = [passwors objectForKey:@"passwordBox"];
    // 弹出账号提示框
    if (pwds.count > 0) {
      int i = 0;
      for (NSArray *aAccount in pwds) {
        LLCPasswordBox *aBox = [[[NSBundle mainBundle] loadNibNamed:@"LLCPasswordBox" owner:self options:nil] lastObject];
        aBox.tag = i == 0 ? kPasswordBox_Tag : kOtherPasswordBox_Tag;
        [_loginView addSubview:aBox];
        aBox.center = CGPointMake(textField.center.x, textField.frame.origin.y + textField.frame.size.height+aBox.frame.size.height/2+i*aBox.frame.size.height);
        [aBox.firstButton addTarget:self
                             action:@selector(accountPressed:)
                   forControlEvents:UIControlEventTouchUpInside];
        [aBox.firstButton setTitle:[aAccount objectAtIndex:0]
                          forState:UIControlStateNormal];
        aBox.hideLabel.text = [aAccount objectAtIndex:1];
        i++;
      }
    }
  }
  
  return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
  [self allResign];
  return YES;
}

#pragma mark -

#pragma mark 选中账号
- (void)accountPressed:(UIButton *)btn {
  
  // 将选中的账号填入
  LLCPasswordBox *aBox = (LLCPasswordBox *)btn.superview;
  _loginView.userNameTextField.text = btn.titleLabel.text;
  _loginView.userPwdTextField.text = aBox.hideLabel.text;
  
  for (int i = kPasswordBox_Tag; i < kOtherPasswordBox_Tag+1; i++) {
    UIView *aView = [_loginView viewWithTag:i];
    [aView removeFromSuperview];
  }
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
  [self allResign];
}

#pragma mark - 所有放弃响应权
- (void)allResign {
  if (_loginView.superview != nil) {
    [_loginView.userNameTextField resignFirstResponder];
    [_loginView.userPwdTextField resignFirstResponder];
  }
  
  if (_registerView.superview != nil) {
    [_registerView.userPwdTextField resignFirstResponder];
    [_registerView.userNaemTextField resignFirstResponder];
    [_registerView.repeatPwdTextField resignFirstResponder];
    [_registerView.emailTextField resignFirstResponder];
  }
  
  for (int i = kPasswordBox_Tag; i < kOtherPasswordBox_Tag+1; i++) {
    UIView *aView = [_loginView viewWithTag:i];
    if (aView != nil) {
      [aView removeFromSuperview];
    }
  }
}

#pragma mark - DMPHttpRequest Delegate
- (void)dmpHttpRequestDidFinished:(DMPHttpRequest *)request {
  // hud
  [LLCFacilityHUD hudDismissedOnView:self.view];
  
  if (request.downloadData) {
    id result = [NSJSONSerialization JSONObjectWithData:request.downloadData options:NSJSONReadingMutableContainers error:nil];
    NSDictionary *theResult  = nil;
    if ([result isKindOfClass:[NSDictionary class]]) {
      theResult = (NSDictionary *)result;
    }
    
    // 读取状态码
    NSString *status = [theResult objectForKey:@"status"];
    if (request.tag == eRegisterRequest) { // 注册
      // 判断注册成功/失败
      if ([status integerValue] == 1) { // 注册失败
        [self showAlertWithTitle:@"温馨提示" Message:[theResult objectForKey:@"message"]];
      } else { // 注册成功
        // 跳转到登陆界面, 并将账号密码自动填充
        UIButton *navItem = (UIButton *)[self.dmpNavigationBar viewWithTag:kNavItem_Tag];
        [navItem setTitle:@"注册" forState:UIControlStateNormal];
        [self.view addSubview:_loginView];
        [_registerView removeFromSuperview];
        _loginView.userNameTextField.text = [[LLCUserInfoManager sharedUserInfo] tempUserName];
        _loginView.userPwdTextField.text = [[LLCUserInfoManager sharedUserInfo] tempUserPwd];
      }
      
    } else { // 登陆
      [self showAlertWithTitle:@"温馨提示" Message:[theResult objectForKey:@"message"]];
      // 登陆成功
      if ([status integerValue] == 0) {
        NSDictionary *userInfoData = [[theResult objectForKey:@"data"] firstObject];
        // 将信息交给单例处理
        // 用户名
        [[LLCUserInfoManager sharedUserInfo] setDisplayName:[userInfoData objectForKey:@"userName"]];
        // 用户ID
        [[LLCUserInfoManager sharedUserInfo] setUserID:[userInfoData objectForKey:@"userId"]];
        // 更新用户账号密码
        [[LLCUserInfoManager sharedUserInfo] updateUserInfo];
        // 更新登录状态
        [[LLCUserInfoManager sharedUserInfo] setHasLogin:YES];
      }
    }
  }
}

#pragma mark - 弹出警告框
- (void)showAlertWithTitle:(NSString *)title Message:(NSString *)message {
  UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:title message:message delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
  // 为登陆成功的警告框设置tag值
  if ([message isEqualToString:@"登录成功"]) {
    alertView.tag = kLoginSccessed_Tag;
  }
  [alertView show];
}

#pragma mark - 登陆成功警告框点选
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
  if (alertView.tag == kLoginSccessed_Tag) {
    
    // pop并调用代理方法
    [self.navigationController popViewControllerAnimated:YES];
    if ([self.llcLoginAndRegisterDelegate respondsToSelector:@selector(llcLoginSuccessedWithName:)]) {
      [self.llcLoginAndRegisterDelegate llcLoginSuccessedWithName:[[LLCUserInfoManager sharedUserInfo] displayName]];
    }
  }
}

- (void)dmpHttpRequest:(DMPHttpRequest *)request DidFailWithError:(NSError *)error {
  [LLCFacilityHUD hudFailAppearOnView:self.view];
}

- (void)didReceiveMemoryWarning
{
  [super didReceiveMemoryWarning];
}

@end
