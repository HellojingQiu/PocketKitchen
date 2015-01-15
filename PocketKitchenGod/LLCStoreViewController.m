//
//  LLCStoreViewController.m
//  PocketKitchenGod
//
//  Created by yxx on 14-2-20.
//  Copyright (c) 2014年 yxx. All rights reserved.
//

#import "LLCStoreViewController.h"
#import "LLCVideoViewController.h"

#import "LLCMainModel.h"

#import "DMPHttpRequest.h"
#import "LLCUserInfoManager.h"
#import "UIImageView+WebCache.h"

#import "LLCFacilityHUD.h"
#import "LLCStoreCell.h"

#define kNavItem_Tag 666 // 导航条按钮tag

@interface LLCStoreViewController ()
<DMPHttpRequestDelegate,
UITableViewDataSource,
UITableViewDelegate>
{
  NSMutableArray *_dataArray;           // 数据源
  NSMutableDictionary *_dateArray;      // 收藏日期数据源
  NSMutableArray *_shadowImageViews;    // 遮盖层数组
  
  NSInteger _count;                     //
  
  UITableView *_tableView;
}
@end

@implementation LLCStoreViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
  self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
  if (self) {
  }
  return self;
}


- (void)viewDidLoad
{
  [super viewDidLoad];
  
  _shadowImageViews = [[NSMutableArray alloc] init];
  _dataArray = [[NSMutableArray alloc] init];
  _dateArray = [[NSMutableDictionary alloc] init];
  [self uiConfig];
  [self loadData];
  [self navBarConfig];
}

#pragma mark - 导航条布局
- (void)navBarConfig {
  UIButton *editBtn = [UIButton buttonWithType:UIButtonTypeCustom];
  [editBtn setTitle:@"编辑" forState:UIControlStateNormal];
  [editBtn setBackgroundImage:[UIImage imageNamed:@"我的-按钮.png"] forState:UIControlStateNormal];
  [editBtn setBackgroundImage:[UIImage imageNamed:@"我的-按钮-选.png"] forState:UIControlStateHighlighted];
  editBtn.tag = kNavItem_Tag;
  editBtn.bounds = CGRectMake(0, 0, 45, 40);
  [editBtn addTarget:self action:@selector(editIt:) forControlEvents:UIControlEventTouchUpInside];
  [self.dmpNavigationBar setDMPNaviBarItemsWithArray:@[editBtn] isLeft:NO];
}

#pragma mark - 读取数据
- (void)loadData {
  [LLCFacilityHUD hudLoadingAppearOnView:self.view];
  
  // 从plist中读取收藏信息
  NSDictionary *storeInfo = [NSDictionary dictionaryWithContentsOfFile:kStorePlist_Path];
  NSDictionary *userStoreInfo = [storeInfo objectForKey:[[LLCUserInfoManager sharedUserInfo] userID]];

  NSArray *dataArr = [NSMutableArray arrayWithArray:[userStoreInfo allValues]];
  
  _count = dataArr.count;
  for (NSArray *arr in dataArr) {
    [_dateArray setObject:[arr objectAtIndex:1] forKey:[arr objectAtIndex:2]];
    [DMPHttpRequest requestWithUrlString:[arr objectAtIndex:0] isRefresh:NO delegate:self tag:0];
  }
}

#pragma mark - 表视图布局
- (void)uiConfig {
  
  UIImageView *backgroundView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 64, kScreenWidth, kScreenHeight-64)];
  backgroundView.image = [UIImage imageNamed:@"背景图.png"];
  [self.view addSubview:backgroundView];
  
  _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 20+44, kScreenWidth, kScreenHeight-20-44) style:UITableViewStylePlain];
  _tableView.delegate = self;
  _tableView.dataSource = self;
  _tableView.backgroundColor = [UIColor clearColor];
  _tableView.showsVerticalScrollIndicator = NO;
  _tableView.separatorColor = [UIColor clearColor];
  _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
  _tableView.showsVerticalScrollIndicator = NO;
  [self.view addSubview:_tableView];
}

#pragma mark - DMPHttpRequest Delegate
- (void)dmpHttpRequestDidFinished:(DMPHttpRequest *)request {
  static int judge = 0;
  if (request.downloadData) {
    id result = [NSJSONSerialization JSONObjectWithData:request.downloadData options:NSJSONReadingMutableContainers error:nil];
    if ([result isKindOfClass:[NSDictionary class]]) {
      NSDictionary * dict = result;

      NSArray * dataArray = dict[@"data"];
      for (NSDictionary * dic in dataArray) {
        LLCMainModel * model = [[LLCMainModel alloc] init];
        [model setValuesForKeysWithDictionary:dic];
        [_dataArray addObject:model];
      }
    }
    judge++;
  }
  
  if (judge == _count) {
    [LLCFacilityHUD hudSuccessAppearOnView:self.view];
    [_tableView reloadData];
    judge = 0;
  }
}

- (void)dmpHttpRequest:(DMPHttpRequest *)request DidFailWithError:(NSError *)error {
  [LLCFacilityHUD hudFailAppearOnView:self.view];
}

#pragma mark - UITableView Delegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
  return 120;
}

#pragma mark - UITableView DataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
  NSInteger num = _dataArray.count;
  if (num % 2 == 0) {
    return num / 2;
  } else {
    return (num + 1) / 2;
  }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  
  static NSString *LLCStoreCellIdentifier = @"StoreCell";
  LLCStoreCell *cell = [tableView dequeueReusableCellWithIdentifier:LLCStoreCellIdentifier];
  if (cell == nil) {
    cell = [[[NSBundle mainBundle] loadNibNamed:@"LLCStoreCell" owner:self options:nil] lastObject];
  }
  
  if (indexPath.row*2 < _dataArray.count) {
    LLCMainModel *leftModel = [_dataArray objectAtIndex:indexPath.row*2];
    if (cell.pictureImageViewLeft.userInteractionEnabled == NO) {
      cell.pictureImageViewLeft.userInteractionEnabled = YES;
      cell.pictureImageViewLeft.tag = indexPath.row*2;
      cell.shadowViewLeft.tag = indexPath.row*2;
      UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapIt:)];
      [cell.pictureImageViewLeft addGestureRecognizer:tap];
      
      [_shadowImageViews addObject:cell.shadowViewLeft];
      cell.shadowViewLeft.userInteractionEnabled = YES;
      UITapGestureRecognizer *deleteTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(deleteTapped:)];
      [cell.shadowViewLeft addGestureRecognizer:deleteTap];
    }
    
    cell.redViewLeft.hidden = NO;
    [cell.pictureImageViewLeft setImageWithURL:[NSURL URLWithString:leftModel.imagePathLandscape] placeholderImage:[UIImage imageNamed:@"我的收藏-默认图片.png"]];
    cell.nameLabelLeft.text = leftModel.name;
    
    for (NSString *aKey in [_dateArray allKeys]) {
      if ([aKey isEqualToString:leftModel.vegetable_id]) {
        cell.dateLabelLeft.text = [_dateArray objectForKey:aKey];
        break;
      }
    }
    
    if ([leftModel.price integerValue] == 0) {
      cell.freeLabelLeft.text = @"免费";
    } else {
      cell.freeLabelLeft.text = @"购买";
    }
  }
  
  if (indexPath.row*2+1 < _dataArray.count) {
    LLCMainModel *rightModel = [_dataArray objectAtIndex:indexPath.row*2+1];
    if (cell.pictureImageViewRight.userInteractionEnabled == NO) {
      cell.pictureImageViewRight.userInteractionEnabled = YES;
      cell.pictureImageViewRight.tag = indexPath.row*2+1;
      cell.shadowViewRight.tag = indexPath.row*2+1;
      UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapIt:)];
      [cell.pictureImageViewRight addGestureRecognizer:tap];
      
      [_shadowImageViews addObject:cell.shadowViewRight];
      cell.shadowViewRight.userInteractionEnabled = YES;
      UITapGestureRecognizer *deleteTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(deleteTapped:)];
      [cell.shadowViewRight addGestureRecognizer:deleteTap];
    }
    
    cell.redViewRight.hidden = NO;
    cell.freeLabelRight.hidden = NO;
    [cell.pictureImageViewRight setImageWithURL:[NSURL URLWithString:rightModel.imagePathLandscape] placeholderImage:[UIImage imageNamed:@"我的收藏-默认图片.png"]];
    cell.nameLabelRight.text = rightModel.name;
    
    for (NSString *aKey in [_dateArray allKeys]) {
      if ([aKey isEqualToString:rightModel.vegetable_id]) {
        cell.dateLabelRight.text = [_dateArray objectForKey:aKey];
        break;
      }
    }
    
    if ([rightModel.price integerValue] == 0) {
      cell.freeLabelRight.text = @"免费";
    } else {
      cell.freeLabelRight.text = @"购买";
    }
  }
  
  return cell;
}

#pragma mark - 点击食物跳转
- (void)tapIt:(UITapGestureRecognizer *)tap {
  NSInteger index = tap.view.tag;
  LLCMainModel *model = [_dataArray objectAtIndex:index];
  
  LLCVideoViewController *vVC = [[LLCVideoViewController alloc] init];
  vVC.currentIndex = 0;
  [vVC loadSingleFoodWithVegetableID:model.vegetable_id];
  [self.navigationController pushViewController:vVC animated:YES];
}

#pragma mark - 编辑按钮响应事件
- (void)editIt:(UIButton *)btn {
  if ([btn.titleLabel.text isEqualToString:@"编辑"]) {
    [btn setTitle:@"完成" forState:UIControlStateNormal];
    for (UIImageView *aShadow in _shadowImageViews) {
      aShadow.hidden = NO;
    }
  } else {
    [btn setTitle:@"编辑" forState:UIControlStateNormal];
    for (UIImageView *aShadow in _shadowImageViews) {
      aShadow.hidden = YES;
    }
  }
}

#pragma mark 点击删除
- (void)deleteTapped:(UITapGestureRecognizer *)tap {
  NSInteger index = tap.view.tag;
  LLCMainModel *theModel = [_dataArray objectAtIndex:index];
  [self deleteStoreFoodFromPlistWithVegatableID:theModel.vegetable_id];
  [_dataArray removeObjectAtIndex:index];

  NSInteger theIndex = _dataArray.count+1;

  LLCStoreCell *cell = (LLCStoreCell *)[_tableView cellForRowAtIndexPath:[NSIndexPath indexPathForItem:theIndex % 2 == 0 ? theIndex/2-1: (theIndex+1)/2-1 inSection:0]];
  
  if (_dataArray.count % 2 == 1) {
    cell.pictureImageViewRight.hidden = YES;
    cell.redViewRight.hidden = YES;
    cell.dateLabelRight.hidden = YES;
    cell.nameLabelRight.hidden = YES;
    cell.shadowViewRight.hidden = YES;
  } else {
    cell.pictureImageViewLeft .hidden = YES;
    cell.redViewLeft.hidden = YES;
    cell.dateLabelLeft.hidden = YES;
    cell.nameLabelLeft.hidden = YES;
    cell.shadowViewLeft.hidden = YES;
  }
  
  [_tableView reloadData];
  
  
}

#pragma mark 从plist中将收藏食物删除
- (void)deleteStoreFoodFromPlistWithVegatableID:(NSString *)vegatableID {
  NSDictionary *storeInfo = [NSDictionary dictionaryWithContentsOfFile:kStorePlist_Path];
  NSMutableDictionary *userStoreInfo = [storeInfo objectForKey:[[LLCUserInfoManager sharedUserInfo] userID]];
  
  NSMutableArray *dataArr = [NSMutableArray arrayWithArray:[userStoreInfo allKeys]];
  
  for (NSString *aKey in dataArr) {
    if ([aKey isEqualToString:vegatableID]) {
      [userStoreInfo removeObjectForKey:aKey];
      break;
    }
  }
  
  [storeInfo writeToFile:kStorePlist_Path atomically:YES];
}

- (void)didReceiveMemoryWarning
{
  [super didReceiveMemoryWarning];
}

@end
