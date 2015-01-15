//
//  DMPUniversalSearchResultVC.m
//  PocketKitchenGod
//
//  Created by Damon's on 14-2-21.
//  Copyright (c) 2014年 yxx. All rights reserved.
//

#import "DMPUniversalSearchResultVC.h"
#import "DMPToolsManager.h"
#import "DMPTwoTwoView.h"
#import "DMPFoodModel.h"
#import "DMPFoodCell.h"
#import "LLCVideoViewController.h"
#import "UIImageView+WebCache.h"
#import "LLCUserInfoManager.h"
#import "LLCFacilityHUD.h"
#import "LLCMainModel.h"

#define kColorWithRGBA(r,g,b,a) [UIColor colorWithRed:r/255. green:g/255. blue:b/255. alpha:a]
#define kAbstractLabelBgColor kColorWithRGBA(222,218,210,1)
@interface DMPUniversalSearchResultVC (){
    DMPTwoTwoView * _twotwoView;
    NSMutableArray * _dataArray;
    NSInteger _currentPage;
    BOOL _isLoading;
}
@property (nonatomic, copy) NSString * abstract;
@property (nonatomic, copy) NSString * title;
@property (nonatomic, strong) id key;
@property (nonatomic, assign) DMPSearchType type;

@end

@implementation DMPUniversalSearchResultVC

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
- (id)initWithTitle:(NSString *)title
           abstract:(NSString *)abstrct
      initDataArray:(NSArray *)modelArray
         searchType:(DMPSearchType)type
          key:(id)key {
    
    if (self = [super init]) {
        self.title = title;
        self.abstract = abstrct;
        self.type = type;
        self.key = key;
        _dataArray = [[NSMutableArray alloc] init];
        [_dataArray addObjectsFromArray:modelArray];
    }
    return self;
}
- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    [self dataInit];
    [self uiCreate];
}

- (void) dataInit {
    _currentPage = 1;
    _isLoading = NO;
}

#pragma mark- 数据请求
- (void)getDataWithPage:(NSInteger)page {
    _isLoading = YES;
    //HUD
    [LLCFacilityHUD hudLoadingAppearOnView:self.view];
    
    LLCUserInfoManager * userManger = [LLCUserInfoManager sharedUserInfo];
    
    if (self.type == DMPSearchTypeAutoSearch) {
        //智能选菜不需要再请求页面数据
    }else if(self.type == DMPSearchTypeNormalSearch) {
        //正常搜索菜需要搜索信息关键字符串
        NSArray * array = self.key;
        [DMPHttpRequest requestWithUrlString:[NSString stringWithFormat:kSearch,array[0],array[1],array[2],array[3],array[4],array[5],_currentPage,@""] isRefresh:YES delegate:self tag:1];
    }
}
- (void) uiCreate {
//设置导航栏标题
    [self.dmpNavigationBar setDMPNaviBarTitleViewWithTitle:[NSString stringWithFormat:@"%@",self.title] signImageName:nil];
    
//创建背景
    NSInteger height = [[DMPToolsManager shareToolsManager] getFitHeightForOS];
    UIImageView * bgView = [[UIImageView alloc] initWithFrame:CGRectMake(0,height, kScreenWidth,kScreenHeight - 64)];
    bgView.image = [UIImage imageNamed:@"背景图"];
    [self.view addSubview:bgView];
    
//创建abstractLabel 可选
        NSInteger abstractHeight = 0;
if (self.type == DMPSearchTypeAutoSearch) {
        UILabel * abstractLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, height, kScreenWidth, 22)];
        abstractLabel.backgroundColor = kAbstractLabelBgColor;
        abstractLabel.text = [NSString stringWithFormat:@"  %@",self.abstract];
        abstractLabel.font = [UIFont systemFontOfSize:12];
        [self.view addSubview:abstractLabel];
    
        abstractHeight = abstractLabel.bounds.size.height;
}
  
    //设置DMPTwoTwoView
    _twotwoView = [[DMPTwoTwoView alloc] initWithFrame:CGRectMake(0,height + abstractHeight, kScreenWidth, kScreenHeight - 64 - abstractHeight) style:DMPTwoTwoStyleDependent autoAdjust:NO];
    _twotwoView.delegate = self;
    [self.view addSubview:_twotwoView];
}
#pragma mark- DMPHttpRequestDelegate
- (void)dmpHttpRequestDidFinished:(DMPHttpRequest *)request {
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
    }
    //HUD
    [LLCFacilityHUD hudSuccessAppearOnView:self.view];
    [_twotwoView reloadDataBoth];
    _isLoading = NO;
}
-(void)dmpHttpRequest:(DMPHttpRequest *)request DidFailWithError:(NSError *)error {
    [LLCFacilityHUD hudFailAppearOnView:self.view];
    _isLoading = NO;
}
#pragma mark- DMPTwoTwoViewDelegate
//此代理 确定cell的类型 标识字符identifier
- (Class) dmpTwoTwoView:(DMPTwoTwoView *)view classOfCellAndIdentifier:(NSString *)identifier  {
    identifier = @"foodCell";
    return [DMPFoodCell class];
}
//此代理 确定cell的布局
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
//cell的row值
- (NSInteger)dmpTwoTwoView:(DMPTwoTwoView *)view numberOfRowIsLeft:(BOOL)isLeft {
    if (!(_dataArray.count%2)) {
        return _dataArray.count/2;
    }else
        return _dataArray.count/2 + 1;
}
//cell的height
- (CGFloat)dmpTwoTwoView:(DMPTwoTwoView *)view HeightForIndex:(NSInteger)index isLeft:(BOOL)isLeft{
    return 120;
}
//cell的点击代理
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
    if(self.type == DMPSearchTypeNormalSearch) {
        if(!_isLoading) {
            _currentPage ++;
            [self getDataWithPage:_currentPage];
        }
    }
    return NO;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
