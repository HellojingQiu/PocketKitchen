//
//  LLCSinaShareViewController.m
//  PocketKitchenGod
//
//  Created by yxx on 14-2-21.
//  Copyright (c) 2014年 yxx. All rights reserved.
//

#import "LLCSinaShareViewController.h"
#import "QFShareEngine.h"

//新浪的授权服务器会通过这三个值，来确定是哪一个客户端
#define SINA_APP_KEY @"1699663396"
#define SINA_APP_SECRET @"aaa6d5dd83f2e5206d83f998599fb907"
#define SINA_CALLBACK @"http://swfsky.com"

@interface LLCSinaShareViewController ()
{
  UIImageView *_imageView; // 要发送的图片
  UITextView *_textView;  // 要发送的文字
  
  UIButton *_sendBtn; // 发送按钮
}
@end

@implementation LLCSinaShareViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
  self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
  if (self) {
    [self initShareEngine];
  }
  return self;
}

//初始化分享引擎
- (void)initShareEngine{
  [QFShareEngine connectSinaWeiboWithAppKey:SINA_APP_KEY appSecret:SINA_APP_SECRET redirectUri:SINA_CALLBACK];
}

- (void)viewDidLoad
{
  [super viewDidLoad];
  // 1. 向调用新浪发送微博的功能, 必须保证用户登陆新浪微博, 客户端得到新浪服务器的授权
  
  UIImageView *backgroundView = [[UIImageView alloc] initWithFrame:CGRectMake(0, kIsIOS7 ? 20+44 : 44, kScreenWidth, kScreenHeight- kIsIOS7 ? 20 + 44 : 44)];
  backgroundView.image = [UIImage imageNamed:@"背景图.png.png"];
  [self.view addSubview:backgroundView];
  
//  UIBarButtonItem *loginItem = [[UIBarButtonItem alloc] initWithTitle:@"登陆" style:UIBarButtonItemStylePlain target:self action:@selector(loginSina)];
//  self.navigationItem.rightBarButtonItem = loginItem;
  
  UIButton *loginButton = [UIButton buttonWithType:UIButtonTypeCustom];
  [loginButton setTitle:@"登录" forState:UIControlStateNormal];
  [loginButton setBackgroundImage:[UIImage imageNamed:@"我的-按钮.png"] forState:UIControlStateNormal];
  [loginButton setBackgroundImage:[UIImage imageNamed:@"我的-按钮-选.png"] forState:UIControlStateHighlighted];
  loginButton.bounds = CGRectMake(0, 0, 45, 40);
  [loginButton addTarget:self action:@selector(loginSina) forControlEvents:UIControlEventTouchUpInside];
  [self.dmpNavigationBar setDMPNaviBarItemsWithArray:@[loginButton] isLeft:NO];
  
  _textView = [[UITextView alloc] initWithFrame:CGRectMake(10, 70, 300, 100)];
  _textView.text = @"测试分享到新浪微博";
  [self.view addSubview:_textView];
  
  _imageView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 180, 150, 150)];
  _imageView.image = [UIImage imageNamed:@"0.png"];
  [self.view addSubview:_imageView];
  
  _sendBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
  [_sendBtn setTitle:@"分享到新浪" forState:UIControlStateNormal];
  _sendBtn.frame = CGRectMake(10, 340, 300, 50);
  [_sendBtn addTarget:self action:@selector(sendToSina) forControlEvents:UIControlEventTouchUpInside];
  
  [self.view addSubview:_sendBtn];
}

/** 发送新浪微博 */
- (void)sendToSina {
  // 先判断是否已经登陆了
  if ([QFShareEngine hasAlreadyLogin:ShareTypeSinaWeibo]) {
    [QFShareEngine shareImage:_imageView.image content:_textView.text type:ShareTypeSinaWeibo statusBarTips:YES result:^(ShareType type, ShareStatus status, NSError *error, NSData *data, BOOL end) {
      // 当客户端与新浪的服务器交互完毕后, 调到此block中
      // ShareStatus (分享的状态吗)
      
      NSLog(@"分享成功");
    }];
  } else {
    NSLog(@"还没有登陆");
  }
}

- (void)loginSina {
  [self.navigationController.navigationBar setHidden:!self.navigationController.navigationBar.hidden];
  // 会弹出一个网页 (用于用户的登陆新浪微博账号, 并给客户端授权)
  // 最终 客户端会得到一个AccessToken (授权字符串)
    
  // 弹出登陆新浪微博, 并授权的界面 (一个导航控制器, 视图中有一个WebView)
  [QFShareEngine showLoginInterface:ShareTypeSinaWeibo];
  
  // 设置授权导航控制器界面的文字
  [QFShareEngine setTopViewTitle:@"登陆界面"];
  [QFShareEngine setTopViewCancelTitle:@"取消"];
}

- (void)viewWillAppear:(BOOL)animated {
  [super viewWillAppear:animated];
  
  self.navigationController.navigationBar.hidden = NO;
}

- (void)didReceiveMemoryWarning
{
  [super didReceiveMemoryWarning];
  // Dispose of any resources that can be recreated.
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
  [_textView resignFirstResponder];
}

@end
