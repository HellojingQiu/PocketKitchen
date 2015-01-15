//
//  LLCVideoDetailViewController.m
//  PocketKitchenGod
//
//  Created by yxx on 14-2-17.
//  Copyright (c) 2014年 yxx. All rights reserved.
//

#import "LLCVideoDetailViewController.h"

#import "LLCMaterialCell.h"
#import "LLCMateMaterialCell.h"
#import "LLCCookMethodCell.h"
#import "LLCFittingCell.h"
#import "LLCFittingFoodCell.h"
#import "LLCNousView.h"
#import "LLCSTScrollView.h"
#import "LLCFacilityHUD.h"

#import "DMPHttpRequest.h"

#import "LLCMainModel.h"
#import "LLCMaterialModel.h"
#import "LLCMateMaterialModel.h"
#import "LLCCookMethodModel.h"
#import "LLCNousModel.h"
#import "LLCFittingModel.h"

#import "UIImageView+WebCache.h"

#define kHUD_Tag 388

/** 展示烹饪详细信息的视图控制器 */
@interface LLCVideoDetailViewController ()
<LLCSTScrollViewDelegate,
DMPHttpRequestDelegate,
UITableViewDataSource,
UITableViewDelegate>
{
  NSMutableArray *_subViews; // 子视图数组
  NSMutableArray *_dataArrays; // 数据源
  
  LLCSTScrollView *_scrollView; // 滚动视图
  
  NSString *_fittingShowImageName; // 图片
  NSString *_fittingShowName; // 名字
}
@end

@implementation LLCVideoDetailViewController

const int kSubViewsConut = 4; // 子视图个数

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
  self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
  if (self) {
    [self initMember];
  }
  return self;
}

- (void)viewDidLoad
{
  [super viewDidLoad];
  
  self.view.backgroundColor = [UIColor blackColor];
  self.automaticallyAdjustsScrollViewInsets = NO;
  
  [self scrollViewConfig];
  [self subViewsConfig];
  _scrollView.contentOffset = CGPointMake(self.currentIndex*kScreenWidth, 0);
  _scrollView.currentPage = self.currentIndex;
  [self llcSTScrollView:_scrollView changeItemWithPage:self.currentIndex];
}

#pragma mark - UITabelView Delegate
#pragma mark cell高度
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
  switch ([_subViews indexOfObject:tableView]) {
    case 0:
    {
#pragma mark  自适应问题
      if (indexPath.row == 0) {
        NSDictionary *attribute = @{NSFontAttributeName: [UIFont systemFontOfSize:13]};
        CGSize size;
        CGSize subSize;
        if (kIsIOS7) {
          size = [self.mainModel.fittingRestriction boundingRectWithSize:CGSizeMake(212, MAXFLOAT)
                                                                 options: NSStringDrawingUsesLineFragmentOrigin
                                                              attributes:attribute
                                                                 context:nil].size;
          
          subSize = [self.mainModel.method boundingRectWithSize:CGSizeMake(212, MAXFLOAT) options: NSStringDrawingUsesLineFragmentOrigin attributes:attribute context:nil].size;
        } else {
          size = [self.mainModel.fittingRestriction sizeWithFont:[UIFont systemFontOfSize:13]
                                               constrainedToSize:CGSizeMake(212, 999)
                                                   lineBreakMode:NSLineBreakByCharWrapping];
          subSize = [self.mainModel.method sizeWithFont:[UIFont systemFontOfSize:13]
                                      constrainedToSize:CGSizeMake(212, 999)
                                          lineBreakMode:NSLineBreakByCharWrapping];
        }
        
        return 13+size.height+10+184+10+subSize.height+10;
      } else {
        return 184;
      }
    } break;
    case 1:
    {
      return 200;
    } break;
    case 3:
    {
      NSArray *tempArr = [_dataArrays objectAtIndex:3];
      NSInteger count = [[tempArr objectAtIndex:0] count];
      
      if (indexPath.row != count+1) {
        return 51;
      } else { // 虚线cell
        return 25;
      }
    } break;
      
    default:
      break;
  }
  
  return 0;
}

#pragma mark - UITableView DataSource
#pragma mark 行数
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
  
  NSInteger index = [_subViews indexOfObject:tableView];
  if (index == 3) {
    NSArray *theArr = [_dataArrays objectAtIndex:index];
    if (theArr.count == 0) {
      return 0;
    } else {
      if ([[theArr objectAtIndex:0] count] == 0) {
        return 0;
      } else {
        return [[theArr objectAtIndex:0] count] + [[theArr objectAtIndex:1] count] + 3;
      }
    }
  } else {
    return [[_dataArrays objectAtIndex:index] count];
  }
}

#pragma mark cell
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  static NSString *LLCMaterialCellIdentifier = @"MaterialCell";
  static NSString *LLCMateMaterialCellIdentifier = @"MateMaterialCell";
  static NSString *LLCCookMethodCellIdentifier = @"CookMethodCell";
  static NSString *LLCFittingCellIdentifier = @"FittingCell";
  static NSString *LLCFittingFoodCellIdentifier = @"FittingFoodCell";
  static NSString *CellIdentifier = @"CellIdentifier";
  
  NSInteger index = [_subViews indexOfObject:tableView];
  NSArray *dataArr = [_dataArrays objectAtIndex:index];
  switch (index) {
    case 0: // 材料cell
    {
      if (indexPath.row == 0) {
        LLCMaterialModel *materialModel = [dataArr objectAtIndex:0];
        
        LLCMaterialCell *cell = [tableView dequeueReusableCellWithIdentifier:LLCMaterialCellIdentifier];
        if (cell == nil) {
          cell = [[[NSBundle mainBundle] loadNibNamed:@"LLCMaterialCell"
                                                owner:self
                                              options:nil] lastObject];
          // 原料label
          cell.materiaLabel.text = self.mainModel.fittingRestriction;
          [cell.materiaLabel sizeToFit];
          cell.mateMateriaLabel.text = self.mainModel.method;
          [cell.mateMateriaLabel sizeToFit];
          [cell.pictureView setImageWithURL:[NSURL URLWithString:materialModel.imagePath]];
          cell.materiaLabel.frame = CGRectMake(
                                               73,
                                               17,
                                               cell.materiaLabel.frame.size.width,
                                               cell.materiaLabel.frame.size.height);
          // 原料背景
          UIImageView *tempBackView = [[UIImageView alloc] initWithFrame:CGRectMake(
                                                                                    35,
                                                                                    cell.materiaLabel.frame.origin.y+cell.materiaLabel.frame.size.height+10,
                                                                                    250,
                                                                                    184)];
          tempBackView.image =[UIImage imageNamed:@"详情页-材料背景.png"];
          cell.tempBackView = tempBackView;
          [cell.contentView insertSubview:tempBackView belowSubview:cell.pictureView];
          cell.pictureView.center = tempBackView.center;
          
          // 配料label
          cell.subTitleLabel.frame = CGRectMake(35,
                                                cell.tempBackView.frame.origin.y+184+10,
                                                cell.subTitleLabel.bounds.size.width,
                                                cell.subTitleLabel.bounds.size.height);
          cell.mateMateriaLabel.frame = CGRectMake(73,
                                                   cell.subTitleLabel.frame.origin.y,
                                                   cell.mateMateriaLabel.frame.size.width,
                                                   cell.mateMateriaLabel.frame.size.height);
        }
        return cell;
      } else { // 配料cell
        LLCMateMaterialModel *mateModel = [dataArr objectAtIndex:indexPath.row];
        
        LLCMateMaterialCell *cell = [tableView dequeueReusableCellWithIdentifier:LLCMateMaterialCellIdentifier];
        if (cell == nil) {
          cell = [[[NSBundle mainBundle] loadNibNamed:@"LLCMateMaterialCell"
                                                owner:self
                                              options:nil] lastObject];
        }
        
        cell.titleLabel.text = mateModel.name;
        [cell.pictureView setImageWithURL:[NSURL URLWithString:mateModel.imagePath]];
        
        return cell;
      }
    } break;
    case 1: // 做法
    {
      LLCCookMethodCell *cell = [tableView dequeueReusableCellWithIdentifier:LLCCookMethodCellIdentifier];
      if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"LLCCookMethodCell"
                                              owner:self
                                            options:nil] lastObject];
      }
      
      LLCCookMethodModel *model = [dataArr objectAtIndex:indexPath.row];
      cell.stepLabel.text = model.order_id;
      [cell.pictureView setImageWithURL:[NSURL URLWithString:model.imagePath]];
      cell.contentLabel.text = model.describe;
      
      return cell;
    } break;
    case 3: // 相宜相克
    {
      NSArray *theGood = [dataArr objectAtIndex:0];
      NSArray *theBad = [dataArr objectAtIndex:1];
      
      // 相宜 第一个cell
      if (indexPath.row == 0) {
        LLCFittingCell *cell = [tableView dequeueReusableCellWithIdentifier:LLCFittingCellIdentifier];
        if (cell == nil) {
          cell = [[[NSBundle mainBundle] loadNibNamed:@"LLCFittingCell"
                                                owner:self
                                              options:nil] lastObject];
        }
        
        cell.titleLabel.text = [NSString stringWithFormat:@"%@与下列食物相宜", _fittingShowName];
        cell.englishLabe.text = @"promoting and constraining mutu...";
        cell.isFittingLabel.text = @"相宜";
        cell.titleLabel.textColor = cell.englishLabe.textColor = cell.labelBackgroundView.backgroundColor = kColorWithRGBA(30, 89, 25, 1);
        [cell.pictureView setImageWithURL:[NSURL URLWithString:_fittingShowImageName]];
        
        return cell;
      }
      
      // 相克 相宜之后的第二个cell
      else if (indexPath.row == theGood.count+2) {
        LLCFittingCell *cell = [tableView dequeueReusableCellWithIdentifier:LLCFittingCellIdentifier];
        if (cell == nil) {
          cell = [[[NSBundle mainBundle] loadNibNamed:@"LLCFittingCell"
                                                owner:self
                                              options:nil] lastObject];
        }
        
        cell.titleLabel.text = [NSString stringWithFormat:@"%@与下列食物相克", _fittingShowName];
        cell.englishLabe.text = @"promoting and constraining mutu...";
        cell.isFittingLabel.text = @"相克";
        cell.titleLabel.textColor = cell.englishLabe.textColor = cell.labelBackgroundView.backgroundColor = kColorWithRGBA(178, 70, 80, 1);
        [cell.pictureView setImageWithURL:[NSURL URLWithString:_fittingShowImageName]];
        
        return cell;
      }
      
      // 虚线 相宜之后的第一个cell
      else if (indexPath.row == theGood.count+1) {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell == nil) {
          cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
          UIImageView *lineView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 16, 300, 1)];
          lineView.image = [UIImage imageNamed:@"详情-虚线1.png"];
          cell.contentView.backgroundColor = [UIColor clearColor];
          cell.backgroundColor = [UIColor clearColor];
          [cell.contentView addSubview:lineView];
          cell.selected = NO;
          cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        
        return cell;
      }
      
      // 食材展示cell
      LLCFittingFoodCell *cell = [tableView dequeueReusableCellWithIdentifier:LLCFittingFoodCellIdentifier];
      if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"LLCFittingFoodCell"
                                              owner:self
                                            options:nil] lastObject];
        cell.contentBackgroundView.backgroundColor = kColorWithRGBA(233, 220, 194, 1);
        cell.titleLabel.textColor = kColorWithRGBA(109, 79, 43, 1);
      }
      
      LLCFittingModel *model = nil;
      if (indexPath.row <= theGood.count+1) {
        model = [theGood objectAtIndex:indexPath.row-1];
      }
      
      if (indexPath.row > theGood.count+2) {
        
        model = [theBad objectAtIndex:indexPath.row-theGood.count-3];
      }
      
      cell.titleLabel.text = model.materialName;
      cell.contentLabel.text = model.contentDescription;
      [cell.pictureView setImageWithURL:[NSURL URLWithString:model.imageName]];
      
      return cell;
    } break;
      
    default:
      break;
  }
  
  return nil;
}

#pragma mark - LLCScrollView Delegate
#pragma mark 滚动视图 翻页
- (void)llcSTScrollView:(LLCSTScrollView *)scrollView
     changeItemWithPage:(NSInteger)page {
  
  NSArray *titles = @[@"材料", @"做法", @"相关常识", @"相宜相克"];
  NSArray *imageNames = @[@"材料.png", @"做法.png", @"相关常识.png", @"相生相克.png"];
  
  DetailRequestType aRequestType;
  if ([[_dataArrays objectAtIndex:page] count] == 0) {
    
    [LLCFacilityHUD hudLoadingAppearOnView:self.view];
    
    NSInteger aType = 0;
    switch (page) {
      case 0:
      {
        aType = 1;
        aRequestType = eMaterialRequest;
      } break;
      case 1:
      {
        aType = 2;
        aRequestType = eCookMehtodRequest;
      } break;
      case 2:
      {
        aType = 4;
        aRequestType = eNousRequest;
      } break;
      case 3:
      {
        aType = 3;
        aRequestType = eFittingRequest;
      } break;
    }
    NSString *path = [NSString stringWithFormat:kTblo_Video_Material, self.mainModel.vegetable_id, aType];
    
    [DMPHttpRequest requestWithUrlString:path isRefresh:NO delegate:self tag:aRequestType];
  }
  
  [self.dmpNavigationBar setDMPNaviBarTitleViewWithTitle:[titles objectAtIndex:page] signImageName:[imageNames objectAtIndex:page]];
  [self.dmpNavigationBar setDMPNaviBarTitleViewSignImageViewSize:CGSizeMake(26, 26)];
}

#pragma mark - DMPHttpRequest Delegate
#pragma mark 数据请求成功
- (void)dmpHttpRequestDidFinished:(DMPHttpRequest *)request {
  if (request.downloadData) {
    switch (request.tag) {
      case eMaterialRequest:
      {
        [self loadMaterialData:request.downloadData];
      } break;
      case eCookMehtodRequest:
      {
        [self loadCookMethodData:request.downloadData];
      } break;
      case eNousRequest:
      {
        [self loadNousData:request.downloadData];
      } break;
      case eFittingRequest:
      {
        [self loadFittingData:request.downloadData];
      } break;
        
      default:
        break;
    }

    [LLCFacilityHUD hudSuccessAppearOnView:self.view];
  }
}

#pragma mark 数据请求失败
- (void)dmpHttpRequest:(DMPHttpRequest *)request DidFailWithError:(NSError *)error {
  [LLCFacilityHUD hudFailAppearOnView:self.view];
}

#pragma mark - 解析界面数据
#pragma mark 材料界面
- (void)loadMaterialData:(NSData *)downloadData {
  id result = [NSJSONSerialization JSONObjectWithData:downloadData
                                              options:NSJSONReadingMutableContainers
                                                error:nil];
  if ([result isKindOfClass:[NSDictionary class]]) {
    NSDictionary *theResult = (NSDictionary *)result;
    
    NSArray *materialArray = [theResult objectForKey:@"data"];
    NSMutableArray *theMaterilArray = [_dataArrays objectAtIndex:0];
    
    for (NSDictionary *aMaterial in materialArray) {
      LLCMaterialModel *model = [[LLCMaterialModel alloc] init];
      [model setValuesForKeysWithDictionary:aMaterial];
      
      if (model.TblSeasoning.count > 0) {
        [theMaterilArray addObject:model];
        for (NSDictionary *aMateDic in model.TblSeasoning) {
          LLCMateMaterialModel *aMateModel = [[LLCMateMaterialModel alloc] init];
          [aMateModel setValuesForKeysWithDictionary:aMateDic];
          [theMaterilArray addObject:aMateModel];
        }
        break;
      }
    }
    
    UITableView *materialTableView = (UITableView *)[_subViews objectAtIndex:0];
    [materialTableView reloadData];
  }
}

#pragma mark 做法界面
- (void)loadCookMethodData:(NSData *)downloadData {
  id result = [NSJSONSerialization JSONObjectWithData:downloadData
                                              options:NSJSONReadingMutableContainers
                                                error:nil];
  
  NSMutableArray *dataArray = [_dataArrays objectAtIndex:1];
  if ([result isKindOfClass:[NSDictionary class]]) {
    NSDictionary *theResult = (NSDictionary *)result;
    
    NSArray *cookMethodArray = [theResult objectForKey:@"data"];
    for (NSDictionary *aDict in cookMethodArray) {
      LLCCookMethodModel *model = [[LLCCookMethodModel alloc] init];
      [model setValuesForKeysWithDictionary:aDict];
      [dataArray addObject:model];
    }
  }
  
  UITableView *materialTableView = (UITableView *)[_subViews objectAtIndex:1];
  [materialTableView reloadData];
}

#pragma mark 相关常识界面
- (void)loadNousData:(NSData *)downloadData {
  id result = [NSJSONSerialization JSONObjectWithData:downloadData
                                              options:NSJSONReadingMutableContainers
                                                error:nil];
  
  NSMutableArray *nousDataArr = [_dataArrays objectAtIndex:2];
  if ([result isKindOfClass:[NSDictionary class]]) {
    NSDictionary *theResult = (NSDictionary *)result;
    
    NSArray *cookMethodArray = [theResult objectForKey:@"data"];
    for (NSDictionary *aDict in cookMethodArray) {
      LLCNousModel *model = [[LLCNousModel alloc] init];
      [model setValuesForKeysWithDictionary:aDict];
      [nousDataArr addObject:model];
      
      LLCNousView *nousView = (LLCNousView *)[_subViews objectAtIndex:2];
      
      // 图片
      [nousView.pictureView setImageWithURL:[NSURL URLWithString:model.imagePath]];
      
      // 花
      NSString *singleBig = [model.nutritionAnalysis substringToIndex:1];
      nousView.bigSingleLabel.text = singleBig;
      nousView.bigSingleLabel.textColor = kColorWithRGBA(101, 39, 8, 1);
      
      // 剩下的字
      NSString *content = [model.nutritionAnalysis substringFromIndex:1];
      nousView.moveLabel.text = [NSString stringWithFormat:@"            %@",content];
      nousView.moveLabel.textColor = kColorWithRGBA(101, 39, 8, 1);
      
      [nousView.moveLabel sizeToFit];
      nousView.moveLabel.frame = CGRectMake(
                                            18,
                                            207,
                                            nousView.moveLabel.bounds.size.width,
                                            nousView.moveLabel.bounds.size.height);
      // 虚线
      nousView.lineImageView.center = CGPointMake(160, nousView.moveLabel.frame.origin.y+nousView.moveLabel.frame.size.height+10+2);
      
      // "制作指导"
      nousView.cookGuideLabel.frame = CGRectMake(
                                                 27,
                                                 nousView.lineImageView.frame.origin.y+nousView.lineImageView.frame.size.height+10,
                                                 nousView.cookGuideLabel.frame.size.width,
                                                 nousView.cookGuideLabel.frame.size.height);
      nousView.cookGuideLabel.text = @"制作指导";
      nousView.cookGuideLabel.textColor = kColorWithRGBA(101, 39, 8, 1);
      nousView.cookGuideLabel.backgroundColor = kColorWithRGBA(254, 190, 154, 1);
      
      // 制作指导方法
      nousView.guideContentLabel.text = [NSString stringWithFormat:@"        %@", model.productionDirection];
      [nousView.guideContentLabel sizeToFit];
      nousView.guideContentLabel.frame = CGRectMake(
                                                    20,
                                                    nousView.cookGuideLabel.frame.origin.y+nousView.cookGuideLabel.frame.size.height+10,
                                                    nousView.guideContentLabel.bounds.size.width,
                                                    nousView.guideContentLabel.bounds.size.height);
      nousView.guideContentLabel.textColor = kColorWithRGBA(101, 39, 8, 1);
      
    }
  }
}

#pragma mark 相宜相克界面
- (void)loadFittingData:(NSData *)downloadData {
  id result = [NSJSONSerialization JSONObjectWithData:downloadData
                                              options:NSJSONReadingMutableContainers
                                                error:nil];
  
  NSMutableArray *fittingDataArr = [_dataArrays objectAtIndex:3];
  NSMutableArray *theGoodArray = [[NSMutableArray alloc] init];
  NSMutableArray *theBadArray = [[NSMutableArray alloc] init];
  [fittingDataArr addObject:theGoodArray];
  [fittingDataArr addObject:theBadArray];
  if ([result isKindOfClass:[NSDictionary class]]) {
    NSDictionary *theResult = (NSDictionary *)result;
    
    NSArray *fittingMethodArray = [theResult objectForKey:@"data"];
    NSDictionary *good = [fittingMethodArray objectAtIndex:0];
    
    NSDictionary *bad = nil;
    if (fittingMethodArray.count == 2) {
      bad = [fittingMethodArray objectAtIndex:1];
    }
    
    _fittingShowImageName = [good objectForKey:@"imageName"];
    _fittingShowName = [good objectForKey:@"materialName"];
    
    // 相宜
    NSArray *goodArray = [good objectForKey:@"Fitting"];
    for (NSDictionary *aDict in goodArray) {
      LLCFittingModel *model = [[LLCFittingModel alloc] init];
      [model setValuesForKeysWithDictionary:aDict];
      [theGoodArray addObject:model];
    }
    
    // 相克
    NSArray *badArray = [bad objectForKey:@"Gram"];
    for (NSDictionary *aDic in badArray) {
      LLCFittingModel *model = [[LLCFittingModel alloc] init];
      [model setValuesForKeysWithDictionary:aDic];
      [theBadArray addObject:model];
    }
  }
  
  UITableView *materialTableView = (UITableView *)[_subViews objectAtIndex:3];
  [materialTableView reloadData];
}

#pragma mark - Private
#pragma mark 初始化成员变量
- (void)initMember {
  _subViews = [[NSMutableArray alloc] init];
  _dataArrays = [[NSMutableArray alloc] init];
  
  for (int i = 0; i < kSubViewsConut; i++) {
    NSMutableArray *aArray = [[NSMutableArray alloc] init];
    [_dataArrays addObject:aArray];
  }
}

#pragma mark 滚动视图布局
- (void)scrollViewConfig {
  
  // 背景
  UIImageView *backView = [[UIImageView alloc] initWithFrame:CGRectMake(0,
                                                                        20+44,
                                                                        kScreenWidth,
                                                                        kScreenHeight-20-44)];
  backView.image = [UIImage imageNamed:@"背景图.png"];
  [self.view addSubview:backView];
  
  // 滚动视图
  _scrollView = [[LLCSTScrollView alloc] initWithFrame:backView.frame SubviewsCount:kSubViewsConut];
  [self.view addSubview:_scrollView];
  
  _scrollView.llcSTscrollViewDelegate = self;
  _scrollView.backgroundColor = [UIColor clearColor];
  
}

#pragma mark 子视图布局
- (void)subViewsConfig {
  
  // 0.1.3是表视图
  for (int i = 0; i < 3; i++) {
    NSInteger offset = i == 2 ? 3 : i;
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(offset*kScreenWidth,
                                                                           0,
                                                                           kScreenWidth,
                                                                           _scrollView.frame.size.height)
                                                          style:UITableViewStylePlain];
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.separatorColor = [UIColor clearColor];
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    tableView.backgroundColor = [UIColor clearColor];
    [_subViews addObject:tableView];
  }
  
  // 2不是
  LLCNousView *nousView = [[[NSBundle mainBundle] loadNibNamed:@"LLCNousView"
                                                         owner:self
                                                       options:nil] lastObject];
  CGPoint center = nousView.center;
  center.x = 2*kScreenWidth+kScreenWidth/2;
  nousView.center = center;
  [_subViews insertObject:nousView atIndex:2];
  
  [_scrollView setSubViewsArray:_subViews];
}

#pragma mark -
- (void)didReceiveMemoryWarning
{
  [super didReceiveMemoryWarning];
}

@end
