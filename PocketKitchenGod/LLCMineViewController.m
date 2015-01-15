//
//  LLCMineViewController.m
//  PocketKitchenGod
//
//  Created by yxx on 14-2-20.
//  Copyright (c) 2014年 yxx. All rights reserved.
//

#import "LLCMineViewController.h"
#import "LLCLoginAndRegisterViewController.h"
#import "LLCStoreViewController.h"

#import "LLCMineModel.h"

#import "LLCMineCell.h"

#import "LLCUserInfoManager.h"

#define kNavItem_Tag 777 // 导航条按钮 tag

/** "我的"内容类型枚举 */
typedef enum {
  eMineStore        =     0,
  eMinebought       =     1,
  eMineRecommond    =     2,
  eMineFeedBack     =     3,
  eMineAbout        =     4,
}MineType;

/** "我的" 界面 */
@interface LLCMineViewController ()
<UITableViewDelegate,
UITableViewDataSource,
LLCLoginAndRegisterViewDelegate>
{
  NSMutableArray *_dataArray; // 数据源
  
  UITableView *_tableView;    // 表示图
}
@end

@implementation LLCMineViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
  self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
  if (self) {
    _dataArray = [[NSMutableArray alloc] init];
  }
  return self;
}

- (void)viewDidLoad
{
  [super viewDidLoad];
  
  [self uiConfig];
  [self navBarConfig];
  [self loadData];
}

#pragma mark - UITableView Delegate
#pragma mark 进入各分类 收藏/购买/......
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
  switch (indexPath.row) {
    case eMineStore:      // 我的收藏
    {
      if (![[LLCUserInfoManager sharedUserInfo] hasLogin]) {
        LLCLoginAndRegisterViewController *loginFirst = [[LLCLoginAndRegisterViewController alloc] initWithIsLogin:YES isStore:NO];
        loginFirst.llcLoginAndRegisterDelegate = self;
        [self.navigationController pushViewController:loginFirst animated:YES];
        return;
      }
      
      LLCStoreViewController *storeVC = [[LLCStoreViewController alloc] init];
      [self.navigationController pushViewController:storeVC animated:YES];
    }
      break;
    case eMinebought:     // 我已购买
      
      break;
    case eMineRecommond:  // 软件推荐
      
      break;
    case eMineFeedBack:   // 意见反馈
      
      break;
    case eMineAbout:      // 关于我们
      
      break;
    default:
      break;
  }
}

#pragma mark - UITableView DataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
  return _dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  static NSString *MineCellIdentifier = @"MineCell";
  LLCMineCell *cell = [tableView dequeueReusableCellWithIdentifier:MineCellIdentifier];
  if (cell == nil) {
    cell = [[[NSBundle mainBundle] loadNibNamed:@"LLCMineCell" owner:self options:nil] lastObject];
  }
  
  LLCMineModel *model = [_dataArray objectAtIndex:indexPath.row];
  cell.titleLabel.text = model.title;
  cell.pictureImageView.image = [UIImage imageNamed:model.imageName];
  
  return cell;
}

#pragma mark - Private
#pragma mark 读取数据
- (void)loadData {
  NSArray *data = [NSArray arrayWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"MinePlist" ofType:@"plist"]];
  
  for (NSDictionary *aDic in data) {
    LLCMineModel *model = [[LLCMineModel alloc] init];
    [model setValuesForKeysWithDictionary:aDic];
    [_dataArray addObject:model];
  }
  
  [_tableView reloadData];
}

#pragma makr 布局
- (void)uiConfig {
  
  _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 20+44, kScreenWidth, kScreenHeight-20-44) style:UITableViewStylePlain];
  _tableView.delegate = self;
  _tableView.dataSource = self;
  _tableView.showsVerticalScrollIndicator = NO;
  [self.view addSubview:_tableView];
}

#pragma mark 导航条布局
- (void)navBarConfig {
  
  // 根据是否登陆 设置导航条按钮的属性
  // hasLogin: YES:已登录/ NO:未登录
  BOOL hasLogin = [[LLCUserInfoManager sharedUserInfo] hasLogin];
  UIButton *loginButton = [UIButton buttonWithType:UIButtonTypeCustom];
  [loginButton setTitle:hasLogin ? @"退出登录" : @"登录" forState:UIControlStateNormal];
  [loginButton setBackgroundImage:[UIImage imageNamed:@"我的-按钮.png"] forState:UIControlStateNormal];
  [loginButton setBackgroundImage:[UIImage imageNamed:@"我的-按钮-选.png"] forState:UIControlStateHighlighted];
  loginButton.tag = kNavItem_Tag;
  loginButton.bounds = hasLogin ? CGRectMake(0, 0, 90, 40) : CGRectMake(0, 0, 45, 40);
  [loginButton addTarget:self action:@selector(loginOrUnLogin:) forControlEvents:UIControlEventTouchUpInside];
  [self.dmpNavigationBar setDMPNaviBarItemsWithArray:@[loginButton] isLeft:NO];
  
   [self linkToUser];
}

#pragma mark 导航条按钮响应事件
- (void)loginOrUnLogin:(UIButton *)btn {
  if ([btn.titleLabel.text isEqualToString:@"登录"]) { // 点击登录
    LLCLoginAndRegisterViewController *loginView = [[LLCLoginAndRegisterViewController alloc] initWithIsLogin:YES isStore:NO];
    loginView.llcLoginAndRegisterDelegate = self;
    [self.navigationController pushViewController:loginView animated:YES];
  } else { // 点击 退出登录
    [[LLCUserInfoManager sharedUserInfo] setHasLogin:NO];
    [[LLCUserInfoManager sharedUserInfo] setDisplayName:@""];
    [self linkToUser];
    [btn setTitle:@"登录" forState:UIControlStateNormal];
    btn.bounds = CGRectMake(0, 0, 45, 40);
    [self.dmpNavigationBar setDMPNaviBarItemsWithArray:@[btn] isLeft:NO];
  }
}

#pragma mark - LLCLoginAndRegisterView Delegate
- (void)llcLoginSuccessedWithName:(NSString *)userName {
  [self linkToUser];
}

#pragma mark 衔接用户信息
- (void)linkToUser {
  // 如果已登录, 改变导航条上 按钮和标题属性
  if ([[LLCUserInfoManager sharedUserInfo] hasLogin]) {
    [self.dmpNavigationBar setDMPNaviBarTitleViewWithTitle:[[LLCUserInfoManager sharedUserInfo] displayName] signImageName:nil];
    
    UIButton *btn = (UIButton *)[self.dmpNavigationBar viewWithTag:kNavItem_Tag];
    [btn setTitle:@"退出登录" forState:UIControlStateNormal];
    btn.bounds = CGRectMake(0, 0, 90, 40);
    [self.dmpNavigationBar setDMPNaviBarItemsWithArray:@[btn] isLeft:NO];

  } else {
    [self.dmpNavigationBar setDMPNaviBarTitleViewWithTitle:nil signImageName:nil];
  }
}

- (void)didReceiveMemoryWarning
{
  [super didReceiveMemoryWarning];
}

@end
