//
//  DMPDiseaseDetailIIVC.m
//  PocketKitchenGod
//
//  Created by Damon's on 14-2-18.
//  Copyright (c) 2014年 yxx. All rights reserved.
//

#import "DMPDiseaseDetailIIVC.h"
#import "DMPDiseaseModel.h"
#import "DMPDiseaseDetailView.h"
#import "DMPFoodCell.h"
#import "DMPFoodModel.h"
#import "UIImageView+WebCache.h"
#import "UIButton+KitButton.h"
#import "LLCVideoViewController.h"
#import "LLCFacilityHUD.h"
@interface DMPDiseaseDetailIIVC ()
@property (weak, nonatomic) IBOutlet UIButton *ImgBtn;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;

@end

@implementation DMPDiseaseDetailIIVC
{
    DMPTwoTwoView * _twotwoView;
    NSMutableArray * _dataArray;
    NSInteger _currentPage;
    DMPDiseaseDetailView * _diseaseDetailView;
    BOOL _isLoading;
}

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
    [self dataInit];
    [self uiConfig];
}
- (void) dataInit {
    _currentPage = 1;
    _dataArray = [[NSMutableArray alloc] init];
    [self getDataWithPage:_currentPage];
}
#pragma mark- 数据请求
- (void)getDataWithPage:(NSInteger)page {
    _isLoading = YES;
    [LLCFacilityHUD hudLoadingAppearOnView:self.view];
    [DMPHttpRequest requestWithUrlString:[NSString stringWithFormat:kTblo_Third_Url,self.model.diseaseId,_currentPage] isRefresh:NO delegate:self tag:1];
}
- (void) naviInit {
    //设置导航栏标题
     [self.dmpNavigationBar setDMPNaviBarTitleViewWithTitle:self.model.diseaseName
                                              signImageName:nil];
    UIButton * button = [UIButton createKitButtonWithBackgroundImageNameForNormal:@"home"
                                                                                                                    highlight:@"home-selected"
                                                                                                                    bottomTitle:nil];
    [button addTarget:self action:@selector(homeBtnPress:) forControlEvents:UIControlEventTouchUpInside];
    [self.dmpNavigationBar setDMPNaviBarItemsWithArray:@[button] isLeft:NO];
    
}
- (void) uiConfig {
    NSInteger height = 0;
    if (kIsIOS7) {
        height = 64;
    }
    UIImageView * bgView = [[UIImageView alloc] initWithFrame:CGRectMake(0,height,kScreenWidth, kScreenHeight - 64)];
    bgView.image = [UIImage imageNamed:@"背景图"];
    [self.view addSubview:bgView];
    [self.view sendSubviewToBack:bgView];
    
    self.ImgBtn.frame = CGRectMake(3, 5 + height, 315, 65);
    [self.ImgBtn setBackgroundImage:[UIImage imageNamed:@"详细疾病-详情-选"] forState:UIControlStateHighlighted];
    [self.ImgBtn setBackgroundImage:[UIImage imageNamed:@"详细疾病-详情-选"] forState:UIControlStateSelected];
    [self.ImgBtn addTarget:self action:@selector(imgBtnPressed:) forControlEvents:UIControlEventTouchUpInside];
    self.titleLabel.frame = CGRectMake(12, 11 + height, 61, 19);
    self.contentLabel.frame = CGRectMake(75, 11 + height, 170, 46);
    self.contentLabel.text =self.model.diseaseDescribe;
    
    [self naviInit];
    
    CGFloat pointY = self.ImgBtn.frame.origin.y + self.ImgBtn.frame.size.height;
    CGFloat heightY = kScreenHeight - pointY;
    _twotwoView = [[DMPTwoTwoView alloc] initWithFrame:CGRectMake(0, pointY, kScreenWidth, heightY) style:DMPTwoTwoStyleDependent autoAdjust:NO];
    _twotwoView.delegate = self;
    [self.view addSubview:_twotwoView];
    
    [self createDiseaseDetailView];
}
#pragma mark- 创建控件
- (void) createDiseaseDetailView {
    _diseaseDetailView = [[[NSBundle mainBundle] loadNibNamed:@"DMPDiseaseDetailView" owner:self options:nil] lastObject];
    [_diseaseDetailView.DiseaseCloseBtn addTarget:self action:@selector(diseaseViewCloseBtnPress:) forControlEvents:UIControlEventTouchUpInside];
    _diseaseDetailView.center = CGPointMake(kScreenWidth/2, kScreenHeight/2);
    _diseaseDetailView.alpha = 0;
    [self.view addSubview:_diseaseDetailView];
}
#pragma mark- 响应点击
- (void) imgBtnPressed:(UIButton *)btn {
    btn.selected = YES;
    [_diseaseDetailView resizeViewWithTextWithTitleText:self.model.diseaseName introText:self.model.diseaseDescribe fitEatText:self.model.fitEat lifeSuitText:self.model.lifeSuit];
    _diseaseDetailView.alpha = 1;
}
- (void) diseaseViewCloseBtnPress:(UIButton *)btn {
    self.ImgBtn.selected = NO;
    _diseaseDetailView.alpha = 0;
}
- (void) homeBtnPress:(UIButton *)btn {
    [self.navigationController popToRootViewControllerAnimated:YES];
}
#pragma mark- DMPHttpRequestDelegate
- (void)dmpHttpRequestDidFinished:(DMPHttpRequest *)request {
    if (request.downloadData) {
        id result = [NSJSONSerialization JSONObjectWithData:request.downloadData options:NSJSONReadingMutableContainers error:nil];
        if ([result isKindOfClass:[NSDictionary class]]) {
            NSDictionary * dict = result;
            NSArray * dataArray = dict[@"data"];
            for (NSDictionary * dic in dataArray) {
                DMPFoodModel * model = [[DMPFoodModel alloc] init];
                [model setValuesForKeysWithDictionary:dic];
                [_dataArray addObject:model];
            }
        }
    }
    [_twotwoView reloadDataBoth];
    _isLoading = NO;
    [LLCFacilityHUD hudSuccessAppearOnView:self.view];
}
- (void)dmpHttpRequest:(DMPHttpRequest *)request DidFailWithError:(NSError *)error {
    [LLCFacilityHUD hudFailAppearOnView:self.view];
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
        DMPFoodModel * model = _dataArray[indexInArray];
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
  
  DMPFoodModel *foodModel = [_dataArray objectAtIndex:indexInArray];
  
  LLCVideoViewController *vVC = [[LLCVideoViewController alloc] init];
  vVC.currentIndex = 0;
  [vVC loadSingleFoodWithVegetableID:foodModel.vegetableId];
  [self.navigationController pushViewController:vVC animated:YES];
}
- (BOOL)dmpTwoTwoView:(DMPTwoTwoView *)view needToLoadMoreIsLeft:(BOOL)isLeft {
    if (!_isLoading) {
        _currentPage ++;
        [self getDataWithPage:_currentPage];
    }
    return NO;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
