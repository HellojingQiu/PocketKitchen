//
//  LLCVideoViewController.m
//  PocketKitchenGod
//
//  Created by yxx on 14-2-17.
//  Copyright (c) 2014年 yxx. All rights reserved.
//

#import "ASIHTTPRequest.h"
#import <MediaPlayer/MediaPlayer.h>
#import "LLCVideoViewController.h"
#import "LLCVideoDetailViewController.h"
#import "LLCLoginAndRegisterViewController.h"
#import "LLCSinaShareViewController.h"

#import "LLCMainModel.h"
#import "LLCRequestModel.h"

#import "UIImageView+WebCache.h"
#import "UIButton+KitButton.h"

#import "LLCHeaderScrollView.h"
#import "LLCFoodIntroduceView.h"
#import "LLCVideoTabBar.h"
#import "LLCFacilityHUD.h"

#import "DMPHttpRequest.h"
#import "HTTPServer.h"
#import "DDLog.h"
#import "DDTTYLogger.h"
#import "LLCUserInfoManager.h"
#import "DMPToolsManager.h"
#import "DMPQREncodeViewController.h"
#define kMaterial_Request_Tag     99
#define kCookMethod_Request_Tag   98
#define kNous_Request_Tag         97
#define kFeat_Request_Tag         96

#define kSingle_Request_Tag       95

#define kLoginSccessed_Tag 457

/** 导航条按钮类型 */
typedef enum {
  eStoreItem = 199,
  eShareItem = 198,
}NavBarItemType;

@interface LLCVideoViewController ()
<LLCHeaderScrollViewDelegate,
DMPHttpRequestDelegate>
{
  HTTPServer *_httpServer; // http服务器
  LLCFoodIntroduceView *_foodIntroduceView; // 食物介绍vie
  
  BOOL _hasSupportServer; // 服务器是否已经开启
  
  ASIHTTPRequest *videoRequest; // 视频请求
  unsigned long long Recordull; // 下载字节
  BOOL isPlay;  // 是否正在播放
}
@end

@implementation LLCVideoViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
  self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
  if (self) {
    //视频播放结束通知
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(videoFinished)
                                                 name:MPMoviePlayerPlaybackDidFinishNotification
                                               object:nil];
  }
  return self;
}

- (void)viewDidLoad
{
  [super viewDidLoad];
  self.view.backgroundColor = [UIColor blackColor];
  [self uiConfig];
  
  if (self.dataArray.count > 0) {
    [self foodIntroduceWithModel:[self.dataArray objectAtIndex:self.currentIndex]];
  }
  
  dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_LOW, 0), ^{
    if (!_hasSupportServer) {
      [self launchServer];
    }
  });
}

#pragma mark - Public
#pragma mark 除主界面意外的界面调用读取食物信息
- (void)loadSingleFoodWithVegetableID:(NSString *)vegetableID {
  [DMPHttpRequest requestWithUrlString:[NSString stringWithFormat:kTblo_Video, vegetableID, [[LLCUserInfoManager sharedUserInfo] userID]] isRefresh:NO delegate:self tag:kSingle_Request_Tag];
}

#pragma mark - Private
#pragma mark 布局
- (void)uiConfig {
  [self headerScrollViewConfig];
  [self foodIntroduceViewConfig];
  [self videoTabBarConfig];
  [self navBarConfig];
  
  if (self.dataArray.count != 0) {
    [_tableView reloadData];
    [_tableView QFTableViewScrollToIndex:self.currentIndex animation:NO];
  } else {
    [_tableView setTheBounces:NO];
  }
  [self codebarConfig];
}

- (void)codebarConfig {
  UIButton *codeBarBtn = [UIButton buttonWithType:UIButtonTypeCustom];
  [codeBarBtn setBackgroundImage:[UIImage imageNamed:@"首页-二维码.png"] forState:UIControlStateNormal];
  [codeBarBtn setBackgroundImage:[UIImage imageNamed:@"首页-二维码-选.png"] forState:UIControlStateHighlighted];
  codeBarBtn.bounds = CGRectMake(0, 0, 141/3, 130/3.);
  codeBarBtn.center = CGPointMake(kScreenWidth-20-codeBarBtn.bounds.size.width/2+5, 20+44+codeBarBtn.frame.size.height+50);
  [codeBarBtn addTarget:self action:@selector(callZXingOut)
       forControlEvents:UIControlEventTouchUpInside];
  
  [self.view addSubview:codeBarBtn];
}
#pragma mark- 二维码按钮点击
- (void)callZXingOut {
  LLCMainModel *model = [_dataArray objectAtIndex:self.currentIndex];
  NSString *url = [NSString stringWithFormat:kTblo_Video, model.vegetable_id,@""];
    NSString * qrCodeString = [[DMPToolsManager shareToolsManager] getQRCodeStringWithUrl:url indexOfModel:self.currentIndex];
    DMPQREncodeViewController * qrEncodeVC = [[DMPQREncodeViewController alloc] initWithCodeString:qrCodeString title:model.name];
    [self.navigationController pushViewController:qrEncodeVC animated:YES];
    
}

/** 导航条布局 */
- (void)navBarConfig {
  
  NSMutableArray *items = [[NSMutableArray alloc] init];
  NSArray *titles = @[@"收藏", @"分享"];
  NSArray *normalImageNames = @[@"详情-收藏.png", @"详情-分享.png"];
  NSArray *selectedImageNames = @[@"详情-收藏-选.png", @"详情-分享-选.png"];
  for (int i = 0; i < titles.count; i++) {
    UIButton *btn = [UIButton createKitButtonWithBackgroundImageNameForNormal:[normalImageNames objectAtIndex:i] highlight:[selectedImageNames objectAtIndex:i] bottomTitle:[titles objectAtIndex:i]];
    btn.tag = i == 0 ? eStoreItem : eShareItem;
    [items addObject:btn];
    [btn addTarget:self action:@selector(navBarItemPressed:) forControlEvents:UIControlEventTouchUpInside];
  }
  
  [self.dmpNavigationBar setDMPNaviBarItemsWithArray:items isLeft:NO];
}

/** 视频tabBar布局 */
- (void)videoTabBarConfig {
  LLCVideoTabBar *tabBar = [[[NSBundle mainBundle] loadNibNamed:@"LLCVideoTabBar"
                                                          owner:self
                                                        options:nil] lastObject];
  [tabBar.prepareButton addTarget:self
                           action:@selector(prepareVideoPlay)
                 forControlEvents:UIControlEventTouchUpInside];
  [tabBar.cookMethodButton addTarget:self
                              action:@selector(cookVideoPlay)
                    forControlEvents:UIControlEventTouchUpInside];
  
  tabBar.center = CGPointMake(kScreenWidth/2, kScreenHeight-44-tabBar.frame.size.height/2);
  [self.view addSubview:tabBar];
}

/** scroll TabBar布局 */
- (void)headerScrollViewConfig {
  LLCHeaderScrollView *headerScrollView = [[LLCHeaderScrollView alloc] initWithFrame:CGRectMake(0, kScreenHeight-44, 320, 44) itemsNormalImageName:@[@"详情-材料.png", @"详情-做法.png", @"详情-相关常识.png", @"详情-相宜相克.png"] itemsSelectedImageName:@[@"详情-材料-选.png", @"详情-做法-选.png", @"详情-相关常识-选.png", @"详情-相宜相克-选.png"] titles:@[@"材料", @"做法", @"相关常识", @"相宜相克"]];
  headerScrollView.llcHeaderScrollViewDelegate = self;
  [self.view addSubview:headerScrollView];
}

/** 食物介绍控件布局 */
- (void)foodIntroduceViewConfig {
  _foodIntroduceView = [[[NSBundle mainBundle] loadNibNamed:@"LLCFoodIntroduceView"
                                                      owner:self
                                                    options:nil] lastObject];
  _foodIntroduceView.center = CGPointMake(_foodIntroduceView.frame.size.width/2,
                                          _foodIntroduceView.frame.size.height/2+44+20);
  [self.view addSubview:_foodIntroduceView];
}

#pragma mark 导航条按钮响应事件
- (void)navBarItemPressed:(UIButton *)item {
  
  if (item.tag == eStoreItem) {
    // 没登陆则跳转到登陆界面
    if (![[LLCUserInfoManager sharedUserInfo] hasLogin]) {
      LLCLoginAndRegisterViewController *login = [[LLCLoginAndRegisterViewController alloc] initWithIsLogin:YES isStore:YES];
      [self.navigationController pushViewController:login animated:YES];
    } else {
      // 已经登陆 执行收藏
      [LLCFacilityHUD hudLoadingAppearOnView:self.view];
      LLCMainModel *model = [self.dataArray objectAtIndex:self.currentIndex];
      NSString *path = [NSString stringWithFormat:kTblo_Video, model.vegetable_id, [[LLCUserInfoManager sharedUserInfo] userID]];
      
      NSDate *date = [NSDate date];
      NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
      [formatter setDateFormat:@"yyyy-MM--dd"];
      NSString *dateStr = [formatter stringFromDate:date];
      
      NSString *vegetableID = model.vegetable_id;

      // 所有信息
      NSMutableDictionary *storeInfo = [NSMutableDictionary dictionaryWithContentsOfFile:kStorePlist_Path];
      if (storeInfo == nil) {
        storeInfo = [[NSMutableDictionary alloc] init];
      }
      // 用户信息
      NSMutableDictionary *userStoreInfo = [storeInfo objectForKey:[[LLCUserInfoManager sharedUserInfo] userID]];
      if (userStoreInfo == nil || userStoreInfo.count == 0) {
        userStoreInfo = [[NSMutableDictionary alloc] init];
        [storeInfo setObject:userStoreInfo forKey:[[LLCUserInfoManager sharedUserInfo] userID]];
      }
      
      NSArray *newArr = @[path, dateStr, vegetableID];
      NSArray *allKeys = [userStoreInfo allKeys];
      if ([allKeys containsObject:vegetableID]) {
        [LLCFacilityHUD hudDismissedOnView:self.view];
        [self showAlertWithTitle:@"温馨提示" Message:@"该道菜您已经收藏过了"];
      } else {
        
        [userStoreInfo setObject:newArr forKey:vegetableID];

        [storeInfo writeToFile:kStorePlist_Path atomically:YES];
        [LLCFacilityHUD hudDismissedOnView:self.view];
        [self showAlertWithTitle:@"温馨提示" Message:@"收藏成功"];
      }
    }
  } else {
    
    // 新浪
    LLCSinaShareViewController *sina = [[LLCSinaShareViewController alloc] init];
    [self.navigationController pushViewController:sina animated:YES];
  }
}

#pragma mark - 弹出警告框
- (void)showAlertWithTitle:(NSString *)title Message:(NSString *)message {
  UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:title message:message delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
  if ([message isEqualToString:@"登录成功"]) {
    alertView.tag = kLoginSccessed_Tag;
  }
  [alertView show];
}

#pragma mark 播放材料准备视频
- (void)prepareVideoPlay {
  
  LLCMainModel *mainModel = [self.dataArray objectAtIndex:self.currentIndex];
  [self videoPlayWithPath:mainModel.materialVideoPath];
}

#pragma mark 播放制作方法视频
- (void)cookVideoPlay {
  LLCMainModel *mainModel = [self.dataArray objectAtIndex:self.currentIndex];
  [self videoPlayWithPath:mainModel.productionProcessPath];
}

#pragma mark 下载视频
- (void)videoPlayWithPath:(NSString *)path {
  
  // 两个缓存文件夹
  NSString *webPath = [NSHomeDirectory() stringByAppendingPathComponent:@"Library/Private Documents/Temp"];
  NSString *cachePath = [NSHomeDirectory() stringByAppendingPathComponent:@"Library/Private Documents/Cache"];
  
  NSFileManager *fileManager=[NSFileManager defaultManager];
  if(![fileManager fileExistsAtPath:cachePath])
  {
    [fileManager createDirectoryAtPath:cachePath
           withIntermediateDirectories:YES
                            attributes:nil
                                 error:nil];
  }
  
  // 如果文件已存在直接播放
  if ([fileManager fileExistsAtPath:[cachePath stringByAppendingPathComponent:
                                     [NSString stringWithFormat:@"%@", path]]]) {
    
    MPMoviePlayerViewController *playerViewController =
    [[MPMoviePlayerViewController alloc] initWithContentURL:
     [NSURL fileURLWithPath:
      [cachePath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@", path]]]];
    
    [self presentMoviePlayerViewControllerAnimated:playerViewController];
    videoRequest = nil;
  }
  
  else{ // 不存在则请求
    ASIHTTPRequest *request=
    [[ASIHTTPRequest alloc] initWithURL:
     [NSURL URLWithString:[NSString stringWithFormat:@"%@", path]]];
    
    [request setDownloadDestinationPath:[cachePath stringByAppendingPathComponent:
                                         [NSString stringWithFormat:@"%@", path]]];
    [request setTemporaryFileDownloadPath:[webPath stringByAppendingPathComponent:
                                           [NSString stringWithFormat:@"%@", path]]];
    
    [request setBytesReceivedBlock:^(unsigned long long size, unsigned long long total) {
      NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
      [userDefaults setDouble:total forKey:@"file_length"];
      Recordull += size;
      if (!isPlay&&Recordull > 400000) {
        isPlay = !isPlay;
        [self playVideoWithPath:path];
      }
    }];
    // 允许断点下载
    [request setAllowResumeForFileDownloads:YES];
    [request startAsynchronous];
    videoRequest = request;
  }
}

#pragma mark 播放视频
- (void)playVideoWithPath:(NSString *)path {
  MPMoviePlayerViewController *playerViewController =
  [[MPMoviePlayerViewController alloc]initWithContentURL:
   [NSURL URLWithString:[NSString stringWithFormat:@"%@", path]]];
  
  [self presentMoviePlayerViewControllerAnimated:playerViewController];
}

#pragma mark 结束视频播放
- (void)videoFinished{
  if (videoRequest) {
    isPlay = !isPlay;
    [videoRequest clearDelegatesAndCancel];
    videoRequest = nil;
  }
}

#pragma mark 启动服务器
- (void)launchServer {
  [DDLog addLogger:[DDTTYLogger sharedInstance]];
	
	_httpServer = [[HTTPServer alloc] init];
	[_httpServer setType:@"_http._tcp."];
  
  [_httpServer setPort:12345];
  
  NSString *webPath = [NSHomeDirectory() stringByAppendingPathComponent:@"Library/Private Documents/Temp"];
  NSFileManager *fileManager=[NSFileManager defaultManager];
  if(![fileManager fileExistsAtPath:webPath])
  {
    [fileManager createDirectoryAtPath:webPath
           withIntermediateDirectories:YES
                            attributes:nil
                                 error:nil];
  }
  
	[_httpServer setDocumentRoot:webPath];
  
  [self startServer];
}

- (void)startServer {
	NSError *error;
	if([_httpServer start:&error]) {
	}
	else	{
		NSLog(@"Error starting HTTP Server: %@", error);
	}
}

#pragma mark - 为食物介绍view赋值
- (void)foodIntroduceWithModel:(LLCMainModel *)mainModel {
  _foodIntroduceView.foodNameLabel.text = mainModel.name;
  _foodIntroduceView.foodPinYinNameLabel.text = mainModel.englishName;
  _foodIntroduceView.cookTimeLength.text = mainModel.timeLength;
  _foodIntroduceView.cookMethodLabel.text = mainModel.cookingMethod;
  _foodIntroduceView.tastLabel.text = mainModel.taste;
  _foodIntroduceView.effectLabel.text = mainModel.effect;
  _foodIntroduceView.fittingPeopleLabel.text = mainModel.fittingCrowd;
}

#pragma mark - DMPHttpRequest Delegate
- (void)dmpHttpRequestDidFinished:(DMPHttpRequest *)request {
  if (request.downloadData) {
    id result = [NSJSONSerialization JSONObjectWithData:request.downloadData options:NSJSONReadingMutableContainers error:nil];
    
    if ([result isKindOfClass:[NSDictionary class]]) {
      NSDictionary *theResult = (NSDictionary *)result;
      
      NSArray *singleArr = [theResult objectForKey:@"data"];
      LLCMainModel *mainModel = [[LLCMainModel alloc] init];
      for (NSDictionary *aDic in singleArr) {
        [mainModel setValuesForKeysWithDictionary:aDic];
      }
      [self foodIntroduceWithModel:mainModel];
      self.dataArray = @[mainModel];
    }
  }
  
  [_tableView reloadData];
}

#pragma mark - llcHeaderView Delegate
- (void)llcHeaderScrollViewDidSelectedItemAtIndex:(NSInteger)index {
  
  NSInteger aType = 0;
  NSInteger currentIndex = 0;
  DetailRequestType aRequestType;
  LLCMainModel *mainModel = [self.dataArray objectAtIndex:self.currentIndex];
  switch (index) {
    case 0:
    {
      aType = 1;
      currentIndex = 0;
      aRequestType = eMaterialRequest;
    } break;
    case 1:
    {
      aType = 2;
      currentIndex = 1;
      aRequestType = eCookMehtodRequest;
    } break;
    case 2:
    {
      aType = 4;
      currentIndex = 2;
      aRequestType = eNousRequest;
    } break;
    case 3:
    {
      aType = 3;
      currentIndex = 3;
      aRequestType = eFittingRequest;
    } break;
  }
  
  // 跳转到视频详细界面
  LLCVideoDetailViewController *detail = [[LLCVideoDetailViewController alloc] init];
  detail.type = aType;
  detail.currentIndex = currentIndex;
  detail.currentRequestType = aRequestType;
  detail.mainModel = mainModel;
  
  [self.navigationController pushViewController:detail animated:YES];
}

#pragma mark - QFTable View DataSource
- (CGFloat)QFTableView:(QFTableView *)fanView
         widthForIndex:(NSInteger)index {
  return 320;
}

- (NSInteger)numberOfIndexForQFTableView:(QFTableView *)fanView {
  return self.dataArray.count;
}

- (void)QFTableView:(QFTableView *)fanView
     setContentView:(UIView *)contentView
           ForIndex:(NSInteger)index {
  LLCMainModel *model = [self.dataArray objectAtIndex:index];
  UIImageView *pictureImageView = (UIImageView *)contentView;
  [pictureImageView setImageWithURL:[NSURL URLWithString:model.imagePathLandscape]
                   placeholderImage:[UIImage imageNamed:@"defaultImage.png"]];
}

- (UIView *)QFTableView:(QFTableView *)fanView
             targetRect:(CGRect)targetRect
               ForIndex:(NSInteger)index {
  UIImageView *pictureImageView = [[UIImageView alloc] initWithFrame:targetRect];
  return pictureImageView;
}

#pragma mark - QFTable View Delegate
- (void)QFTableView:(QFTableView *)fanView scrollToIndex:(NSInteger)index {
  
  if (index > self.dataArray.count-1) {
    return;
  }
  LLCMainModel *model = [self.dataArray objectAtIndex:index];
  [self foodIntroduceWithModel:model];
  
  BOOL isFree = YES;
  if ([model.price intValue] != 0) {
    isFree = NO;
  }
  
  _foodIntroduceView.redLabelView.hidden = !isFree;
  _foodIntroduceView.purchaseLabel.hidden = isFree;
  _foodIntroduceView.freeLabel.hidden = !isFree;
  _foodIntroduceView.purchaseLabel.hidden = isFree;
  
  self.currentIndex = index;
}

- (void)didReceiveMemoryWarning
{
  [super didReceiveMemoryWarning];
}


@end
