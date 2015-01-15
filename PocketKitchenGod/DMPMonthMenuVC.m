//
//  DMPMonthMenuVC.m
//  PocketKitchenGod
//
//  Created by Damon's on 14-2-20.
//  Copyright (c) 2014年 yxx. All rights reserved.
//

#import "DMPMonthMenuVC.h"
#import "DMPToolsManager.h"
#import "DMPTwoTwoView.h"
#import "DMPFoodModel.h"
#import "DMPFoodCell.h"
#import "LLCVideoViewController.h"
#import "UIImageView+WebCache.h"
#import "LLCUserInfoManager.h"
#import "LLCFacilityHUD.h"
#import "LLCMainModel.h"

@interface DMPMonthMenuVC (){
    DMPTwoTwoView * _twotwoView;
    NSMutableArray * _dataArray;
    NSInteger _currentPage;
    BOOL _isLoading;

}
@property (nonatomic, copy) NSString * year;
@property (nonatomic, copy) NSString * month;
@end

@implementation DMPMonthMenuVC

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
    [self dateDataInit];
    [self uiCreate];
    [self dataInit];
}
- (void) dateDataInit {
    NSDate * date = [NSDate date];
    NSDateFormatter * formatForYear = [[NSDateFormatter alloc] init];
    formatForYear.dateFormat = @"yyyy";
    NSDateFormatter * formatForMonth = [[NSDateFormatter alloc] init];
    formatForMonth.dateFormat = @"MM";
    self.month = [formatForMonth stringFromDate:date];
    self.year = [formatForYear stringFromDate:date];
}
- (void) dataInit {
    _currentPage = 1;
    _isLoading = NO;
    _dataArray = [[NSMutableArray alloc] init];
    [self getDataWithPage:_currentPage];
}
#pragma mark- 数据请求
- (void)getDataWithPage:(NSInteger)page {
    _isLoading = YES;
    //HUD
    [LLCFacilityHUD hudLoadingAppearOnView:self.view];
    LLCUserInfoManager * userManger = [LLCUserInfoManager sharedUserInfo];
    [DMPHttpRequest requestWithUrlString:[NSString stringWithFormat:kMonthMenu,self.year,self.month,_currentPage,userManger.userID] isRefresh:YES delegate:self tag:1];
}
- (void) uiCreate {
    //设置导航栏标题
    [self.dmpNavigationBar setDMPNaviBarTitleViewWithTitle:[NSString stringWithFormat:@"%@月菜单",self.month] signImageName:@"每月菜单"];
    [self.dmpNavigationBar setDMPNaviBarTitleViewSignImageViewSize:CGSizeMake(30, 25)];
    //创建背景
    NSInteger height = [[DMPToolsManager shareToolsManager] getFitHeightForOS];
    UIImageView * bgView = [[UIImageView alloc] initWithFrame:CGRectMake(0,height, kScreenWidth,kScreenHeight - 64)];
    bgView.image = [UIImage imageNamed:@"背景图"];
    [self.view addSubview:bgView];
    
    //设置DMPTwoTwoView
    _twotwoView = [[DMPTwoTwoView alloc] initWithFrame:CGRectMake(0,height, kScreenWidth, kScreenHeight - 64) style:DMPTwoTwoStyleDependent autoAdjust:YES];
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

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
