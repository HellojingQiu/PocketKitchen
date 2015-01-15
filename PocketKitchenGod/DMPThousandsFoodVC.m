//
//  DMPThousandsFoodVC.m
//  PocketKitchenGod
//
//  Created by Damon's on 14-2-20.
//  Copyright (c) 2014年 yxx. All rights reserved.
//

#import "DMPThousandsFoodVC.h"
#import "DMPToolsManager.h"
#import "DMPTwoTwoView.h"
#import "DMPFoodModel.h"
#import "DMPFoodCell.h"
#import "LLCVideoViewController.h"
#import "UIImageView+WebCache.h"
#import "LLCUserInfoManager.h"
#import "LLCFacilityHUD.h"
#import "LLCMainModel.h"
#import "LLCWoderlfulTabBar.h"
#import "LLCButtonModel.h"
#import "LLCSubButtonModel.h"

#define kBottomViewHeight 44

typedef enum {
  eButtonRequest = 239,
  eDataRequest = 238,
  eOtherCategoryRequest = 237,
}WonderfulRequestType;

@interface DMPThousandsFoodVC ()
<LLCWonderfulTabBarDelegate>
{
  DMPTwoTwoView * _twotwoView;
  NSMutableArray * _dataArray;
  NSInteger _currentPage;
  BOOL _isLoading;
  UILabel * _label;                   //标题Label 显示当前选择
  
  NSMutableArray *_buttonArray;
  
  NSString *_currentPath;
}

@end

@implementation DMPThousandsFoodVC

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
  self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
  if (self) {
    // Custom initialization
  
  }
  return self;
}

- (void)viewDidLoad
{
  [super viewDidLoad];
  
  _currentPath = kDelicious_Food;
  [self uiCreate];
  [self dataInit];
}
- (void) dataInit {
  _currentPage = 1;
  _isLoading = NO;
  _dataArray = [[NSMutableArray alloc] init];
  _buttonArray = [[NSMutableArray alloc] init];
  
  [self loadButtonData];
  [self getDataWithPage:_currentPage];
}
#pragma mark- 数据请求
- (void)loadButtonData {
  [DMPHttpRequest requestWithUrlString:kCategories_Url isRefresh:NO delegate:self tag:eButtonRequest];
}
- (void)getDataWithPage:(NSInteger)page {
  _isLoading = YES;
  //HUD
  [LLCFacilityHUD hudLoadingAppearOnView:self.view];
  LLCUserInfoManager * userManger = [LLCUserInfoManager sharedUserInfo];
  [DMPHttpRequest requestWithUrlString:[NSString stringWithFormat:_currentPath,_currentPage,userManger.userID] isRefresh:YES delegate:self tag:eDataRequest];
}
- (void) uiCreate {
  //设置导航栏标题
  [self.dmpNavigationBar setDMPNaviBarTitleViewWithTitle:@"掌厨-全球最大的视频厨房" signImageName:nil];
  
  //创建背景
  NSInteger height = [[DMPToolsManager shareToolsManager] getFitHeightForOS];
  UIImageView * bgView = [[UIImageView alloc] initWithFrame:CGRectMake(0,height, kScreenWidth,kScreenHeight - 64 - kBottomViewHeight)];
  bgView.image = [UIImage imageNamed:@"背景图"];
  [self.view addSubview:bgView];
  //设置 顶部说明Label
  _bigLabel = [[UILabel alloc] init];
  _bigLabel.text = @"全球中文最大的掌上同步视频厨房";
  _bigLabel.font = [UIFont systemFontOfSize:13];
  [_bigLabel sizeToFit];
  _bigLabel.frame = CGRectMake(2+5, 5 + height, _bigLabel.frame.size.width, _bigLabel.frame.size.height);
  _bigLabel.textColor = kColorWithRGBA(65, 54, 41, 1);
  [self.view addSubview:_bigLabel];
  _smallLabel = [[UILabel alloc] init];
  _smallLabel.text = @"";
  _smallLabel.font = [UIFont systemFontOfSize:10];
  _smallLabel.textColor = kColorWithRGBA(139, 127, 110, 1);
  [self.view addSubview:_smallLabel];
  
  //设置DMPTwoTwoView
  _twotwoView = [[DMPTwoTwoView alloc] initWithFrame:CGRectMake(0,
                                                                22 + height,
                                                                kScreenWidth,
                                                                kScreenHeight - 64 - kBottomViewHeight - 22)
                                               style:DMPTwoTwoStyleDependent autoAdjust:NO];
  _twotwoView.delegate = self;
  [self.view addSubview:_twotwoView];
}

#pragma mark - LLCWonderfulTabBar Delegate
- (void)selectedCategoryID:(NSString *)categoryID CategoryName:(NSString *)categoryName foodName:(NSString *)foodName {
  _bigLabel.text = categoryName;
  _smallLabel.text = [NSString stringWithFormat:@" > %@", foodName];
  [self resizeLabel];
  
  NSString *path = [NSString stringWithFormat:kKeepHealthy, categoryID, 1, [[LLCUserInfoManager sharedUserInfo] userID]];
  [_dataArray removeAllObjects];
  [LLCFacilityHUD hudLoadingAppearOnView:self.view];
  [DMPHttpRequest requestWithUrlString:path isRefresh:NO delegate:self tag:eOtherCategoryRequest];
  _currentPath = path;
  //NSLog(@"%@", path);
}

#pragma mark- DMPHttpRequestDelegate
- (void)dmpHttpRequestDidFinished:(DMPHttpRequest *)request {
  if (request.downloadData) {
    id result = [NSJSONSerialization JSONObjectWithData:request.downloadData options:NSJSONReadingMutableContainers error:nil];
    
    NSDictionary * dict = nil;
    if ([result isKindOfClass:[NSDictionary class]]) {
      dict = result;
    }
    if (request.tag == eDataRequest) {
      
      NSArray * dataArray = dict[@"data"];
      for (NSDictionary * dic in dataArray) {
        LLCMainModel * model = [[LLCMainModel alloc] init];
        [model setValuesForKeysWithDictionary:dic];
        [_dataArray addObject:model];
      }
      
      //HUD
      [LLCFacilityHUD hudSuccessAppearOnView:self.view];
      [_twotwoView reloadDataBoth];
      _isLoading = NO;
    }
    else if (request.tag == eButtonRequest) {
      NSArray *buttonModels = [dict objectForKey:@"data"];
      for (NSDictionary *aDict in buttonModels) {
        LLCButtonModel *buttonModel = [[LLCButtonModel alloc] init];
        [buttonModel setValuesForKeysWithDictionary:aDict];
        
        NSArray *subModels = [aDict objectForKey:@"TblVegetableChildCatalog"];
        for (NSDictionary *otherDict in subModels) {
          LLCSubButtonModel *subModel = [[LLCSubButtonModel alloc] init];
          [subModel setValuesForKeysWithDictionary:otherDict];
          [buttonModel.subCaralogArray addObject:subModel];
        }
        
        [_buttonArray addObject:buttonModel];
      }
      [self tabBarConfig];
    }
    
    else if (request.tag == eOtherCategoryRequest) {
      _currentPage = 1;
     // NSLog(@"%@", dict);
      NSArray * dataArray = dict[@"data"];
      for (NSDictionary * dic in dataArray) {
        LLCMainModel * model = [[LLCMainModel alloc] init];
        [model setValuesForKeysWithDictionary:dic];
        [_dataArray addObject:model];
      }
      
      //HUD
      [LLCFacilityHUD hudSuccessAppearOnView:self.view];
      [_twotwoView reloadDataBoth];
      _isLoading = NO;
    }
  }
}
-(void)dmpHttpRequest:(DMPHttpRequest *)request DidFailWithError:(NSError *)error {
  [LLCFacilityHUD hudFailAppearOnView:self.view];
  _isLoading = NO;
}
- (void)tabBarConfig {
  LLCWoderlfulTabBar *tabBar = [[LLCWoderlfulTabBar alloc] initWithFrame:CGRectMake(0, kScreenHeight-44, kScreenWidth, 140) buttonModels:_buttonArray];
  tabBar.llcWonderfulTabBarDelegate = self;
  [self.view addSubview:tabBar];
}

#pragma mark- DMPTwoTwoViewDelegate
- (Class) dmpTwoTwoView:(DMPTwoTwoView *)view classOfCellAndIdentifier:(NSString *)identifier  {
  identifier = @"foodCell";
  return [DMPFoodCell class];
}
- (void) dmpTwoTwoView:(DMPTwoTwoView *)view Cell:(id)cell ForRowIndex:(NSInteger)index isLeft:(BOOL)isLeft {
  DMPFoodCell * foodCell = cell;
  foodCell.selectionStyle = UITableViewCellSelectionStyleNone;
  NSInteger indexInArray;
  if (isLeft) {
    indexInArray = index * 2;
  }else
    indexInArray = index * 2 + 1;
  if (indexInArray <= _dataArray.count - 1) {
    LLCMainModel * model = _dataArray[indexInArray];
    [foodCell.foodImgView setImageWithURL:[NSURL URLWithString:model.imagePathThumbnails] placeholderImage:[UIImage imageNamed:@"sdefaultImage"]];
    foodCell.foodFavourteNumLabel.text = model.clickCount;
    foodCell.foodNameLabel.text = model.name;
    foodCell.foodNameLabel.adjustsFontSizeToFitWidth = YES;
    [foodCell foodCellSetAllImgViewAppear];
  }
}

- (NSInteger)dmpTwoTwoView:(DMPTwoTwoView *)view numberOfRowIsLeft:(BOOL)isLeft {
  if (!(_dataArray.count%2)) {
    return _dataArray.count/2;
  }else
    return _dataArray.count/2 + 1;
}

- (CGFloat)dmpTwoTwoView:(DMPTwoTwoView *)view HeightForIndex:(NSInteger)index isLeft:(BOOL)isLeft{
  return 120;
}

- (void)dmpTwoTwoView:(DMPTwoTwoView *)view DidSeletedAtIndex:(NSInteger)index isLeft:(BOOL)isLeft {
  NSInteger indexInArray;
  if (isLeft) {
    indexInArray = index * 2;
  }else
    indexInArray = index * 2 + 1;
  
  LLCMainModel *foodModel = [_dataArray objectAtIndex:indexInArray];
  
  LLCVideoViewController *vVC = [[LLCVideoViewController alloc] init];
  vVC.currentIndex = 0;
  [vVC loadSingleFoodWithVegetableID:foodModel.vegetable_id];
  [self.navigationController pushViewController:vVC animated:YES];
}
- (BOOL)dmpTwoTwoView:(DMPTwoTwoView *)view needToLoadMoreIsLeft:(BOOL)isLeft {
  if(!_isLoading) {
    _currentPage ++;
    [self getDataWithPage:_currentPage];
    return YES;
  }else
    return NO;
}

#pragma mark 调整Label
- (void)resizeLabel {
  [_bigLabel sizeToFit];
  _bigLabel.frame = CGRectMake(2+5, 5 + 20+44, _bigLabel.frame.size.width, _bigLabel.frame.size.height);
  
  [_smallLabel sizeToFit];
  _smallLabel.frame = CGRectMake(_bigLabel.frame.origin.x+_bigLabel.frame.size.width, _bigLabel.frame.origin.y+2, _smallLabel.bounds.size.width, _smallLabel.bounds.size.height);
}

- (void)didReceiveMemoryWarning
{
  [super didReceiveMemoryWarning];
}

@end
