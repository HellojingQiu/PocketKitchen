//
//  DMPHotFoodVC.m
//  PocketKitchenGod
//
//  Created by Damon's on 14-2-20.
//  Copyright (c) 2014年 yxx. All rights reserved.
//

#import "DMPHotFoodVC.h"
#import "DMPToolsManager.h"
#import "DMPTwoTwoView.h"
#import "DMPFoodModel.h"
#import "DMPFoodCell.h"
#import "LLCVideoViewController.h"
#import "UIImageView+WebCache.h"
#import "LLCUserInfoManager.h"
#import "LLCMainModel.h"
#import "LLCFacilityHUD.h"
#define kBottomViewHeight 45

typedef enum {
    kTypeNew = 789,
    kTypeHot
}kType;

@interface DMPHotFoodVC (){
    DMPTwoTwoView * _twotwoView;
    NSMutableArray * _dataArrayNew;
    NSMutableArray * _dataArrayHot;
    NSInteger _currentPageNew;
    NSInteger _currentPageHot;
    BOOL _newIsLoading;
    BOOL _hotIsLoading;
    BOOL _isliving;                     //记录HUD是否已显现
    BOOL _isFirstInit;
}

@end

@implementation DMPHotFoodVC

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
	// Do any additional setup after loading the view.
    [self uiCreate];
    [self dataInit];
    
}

- (void) dataInit {
    _newIsLoading = NO;
    _hotIsLoading = NO;
    _isliving = NO;
    _isFirstInit = YES;
    _currentPageNew = 1;
    _currentPageHot = 1;
    _dataArrayHot = [[NSMutableArray alloc] init];
    _dataArrayNew = [[NSMutableArray alloc] init];
    
    [self getDataWithPage:_currentPageNew dataType:kTypeNew];
    [self getDataWithPage:_currentPageHot dataType:kTypeHot];
    
}
#pragma mark- 数据请求
- (void)getDataWithPage:(NSInteger)page dataType:(kType)type {
    //HUD
    if(!_isliving) {
        _isliving = YES;
        [LLCFacilityHUD hudLoadingAppearOnView:self.view];
    }
    //User数据
    LLCUserInfoManager * userManger = [LLCUserInfoManager sharedUserInfo];
    if (type == kTypeNew) {
        //最受推荐
        _newIsLoading = YES;  // 状态改变
        [DMPHttpRequest requestWithUrlString:[NSString stringWithFormat:kNewTblVegetable,_currentPageNew,userManger.userID] isRefresh:YES delegate:self tag:kTypeNew];
    }else {
        //最受欢迎
        _hotIsLoading = YES;   // 状态改变
        [DMPHttpRequest requestWithUrlString:[NSString stringWithFormat:kHotTblVegetable,_currentPageHot,userManger.userID] isRefresh:YES delegate:self tag:kTypeHot];
    }
    
}

- (void) uiCreate {
    //设置导航栏标题
    [self.dmpNavigationBar setDMPNaviBarTitleViewWithTitle:@"热门推荐" signImageName:@"推荐"];
    [self.dmpNavigationBar setDMPNaviBarTitleViewSignImageViewSize:CGSizeMake(40, 35)];
    //创建背景
    NSInteger height = [[DMPToolsManager shareToolsManager] getFitHeightForOS];
    UIImageView * bgView = [[UIImageView alloc] initWithFrame:CGRectMake(0,height, kScreenWidth,kScreenHeight - 64 - kBottomViewHeight)];
    bgView.image = [UIImage imageNamed:@"背景图"];
    [self.view addSubview:bgView];
    //设置 顶部说明Label
    UILabel * label = [[UILabel alloc] init];
    label.text = @"  全球中文最大的掌上同步视频厨房";
    label.font = [UIFont systemFontOfSize:13];
    [label sizeToFit];
    label.frame = CGRectMake(2, 5 + height, label.frame.size.width, label.frame.size.height);
    [self.view addSubview:label];
    
    //设置DMPTwoTwoView
    _twotwoView = [[DMPTwoTwoView alloc] initWithFrame:CGRectMake(0, 20 +height, kScreenWidth, kScreenHeight - 64 - kBottomViewHeight - 20) style:DMPTwoTwoStyleInDependent autoAdjust:YES];
    _twotwoView.delegate = self;
    [_twotwoView setTwoTwoViewDivisionWithImageName:@"首页-热门推荐虚线"];
    [self.view addSubview:_twotwoView];
    
    //创建Bottom
    UIView * bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, kScreenHeight - kBottomViewHeight, kScreenWidth, kBottomViewHeight)];
    [self.view addSubview:bottomView];
    NSArray * bottomImageNameAndTitle = @[@"首页-最新推出",@"首页-最受欢迎",@"最新推出",@"最受欢迎"];
    for (int i = 0; i < 2; i ++) {
        UIImageView * imageView = [[UIImageView alloc] initWithFrame:CGRectMake(i * bottomView.bounds.size.width/2, 0, bottomView.bounds.size.width/2, bottomView.bounds.size.height)];
        imageView.image = [UIImage imageNamed:bottomImageNameAndTitle[i]];
        [bottomView addSubview:imageView];
        
        UILabel * titleLabel = [[UILabel alloc] init];
        titleLabel.text = bottomImageNameAndTitle[i + 2];
        titleLabel.font = [UIFont systemFontOfSize:11];
        titleLabel.textColor = [UIColor whiteColor];
        [titleLabel sizeToFit];
        titleLabel.center = CGPointMake(imageView.bounds.size.width/2, imageView.bounds.size.height - 10);
        [imageView addSubview:titleLabel];
    }
}
#pragma mark- 响应点击


#pragma mark- DMPHttpRequestDelegate
- (void)dmpHttpRequestDidFinished:(DMPHttpRequest *)request {
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        if (request.downloadData) {
            id result = [NSJSONSerialization JSONObjectWithData:request.downloadData options:NSJSONReadingMutableContainers error:nil];
            if ([result isKindOfClass:[NSDictionary class]]) {
                NSDictionary * dict = result;
                NSArray * dataArray = dict[@"data"];
                for (NSDictionary * dic in dataArray) {
                    LLCMainModel * model = [[LLCMainModel alloc] init];
                    [model setValuesForKeysWithDictionary:dic];
                    if (request.tag == kTypeNew) {
                        [_dataArrayNew addObject:model];
                    }else
                        [_dataArrayHot addObject:model];
                }
            }
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            
            //reload 当都有数据时再一起重置
            if(_dataArrayHot.count && _dataArrayNew.count)
                [_twotwoView reloadDataBoth];
            
            //改变状态
            if (request.tag == kTypeNew) {
                _newIsLoading = NO;
            }else
                _hotIsLoading = NO;
            
            
            
          
        });
    });
    
    if (_isFirstInit) {
         [self performSelector:@selector(hudSuccess) withObject:nil afterDelay:1.2];
    }else {
        if (_isliving) {
            _isliving = NO;
            //HUD
            [LLCFacilityHUD hudSuccessAppearOnView:self.view];
        }
    }
    
  

}
- (void)hudSuccess {
   [LLCFacilityHUD hudSuccessAppearOnView:self.view];
    _isFirstInit = NO;
    _isliving = NO;
}
-(void)dmpHttpRequest:(DMPHttpRequest *)request DidFailWithError:(NSError *)error {
    if (_isliving) {
        _isliving = NO;
        [LLCFacilityHUD hudFailAppearOnView:self.view];
    }
    
    if (request.tag == kTypeNew) {
        _newIsLoading = NO;
    }else
        _hotIsLoading = NO;
}
#pragma mark- DMPTwoTwoViewDelegate

- (Class) dmpTwoTwoView:(DMPTwoTwoView *)view classOfCellAndIdentifier:(NSString *)identifier  {
    identifier = @"foodCell";
    return [DMPFoodCell class];
}
- (void) dmpTwoTwoView:(DMPTwoTwoView *)view Cell:(id)cell ForRowIndex:(NSInteger)index isLeft:(BOOL)isLeft {
    DMPFoodCell * foodCell = cell;
    foodCell.selectionStyle = UITableViewCellSelectionStyleNone;
    LLCMainModel *model;
    if (isLeft) {
        model = [_dataArrayNew objectAtIndex:index];
    }else
        model = [_dataArrayHot objectAtIndex:index];
    
    [foodCell.foodImgView setImageWithURL:[NSURL URLWithString:model.imagePathThumbnails] placeholderImage:[UIImage imageNamed:@"sdefaultImage"]];
    foodCell.foodFavourteNumLabel.text = model.clickCount;
    foodCell.foodNameLabel.text = model.name;
    foodCell.foodNameLabel.adjustsFontSizeToFitWidth = YES;
    [foodCell foodCellSetAllImgViewAppear];
    
}
- (NSInteger)dmpTwoTwoView:(DMPTwoTwoView *)view numberOfRowIsLeft:(BOOL)isLeft {
    if (isLeft) {
        return _dataArrayNew.count;
    }else
        return _dataArrayHot.count;
}
- (CGFloat)dmpTwoTwoView:(DMPTwoTwoView *)view HeightForIndex:(NSInteger)index isLeft:(BOOL)isLeft{
    return 120;
}
- (void)dmpTwoTwoView:(DMPTwoTwoView *)view DidSeletedAtIndex:(NSInteger)index isLeft:(BOOL)isLeft {
    LLCMainModel *foodModel;
    if (isLeft) {
        foodModel = [_dataArrayNew objectAtIndex:index];
    }else
        foodModel = [_dataArrayHot objectAtIndex:index];
    
    
    
    LLCVideoViewController *vVC = [[LLCVideoViewController alloc] init];
    vVC.currentIndex = 0;
    [vVC loadSingleFoodWithVegetableID:foodModel.vegetable_id];
    [self.navigationController pushViewController:vVC animated:YES];
}
- (BOOL)dmpTwoTwoView:(DMPTwoTwoView *)view needToLoadMoreIsLeft:(BOOL)isLeft {
    if (isLeft && !_newIsLoading) {
        _currentPageNew ++;
        [self getDataWithPage:_currentPageNew dataType:kTypeNew];
    }else if (!isLeft && !_hotIsLoading){
        _currentPageHot ++;
        [self getDataWithPage:_currentPageHot dataType:kTypeHot];
    }
    return NO;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
