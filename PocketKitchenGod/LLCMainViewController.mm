//
//  LLCMainViewController.m
//  PocketKitchenGod
//
//  Created by yxx on 14-2-16.
//  Copyright (c) 2014年 yxx. All rights reserved.
//

#import "LLCMainViewController.h"
#import "LLCVideoViewController.h"
#import "LLCMineViewController.h"

#import "LLCPageControl.h"
#import "LLCDateIntroduceView.h"
#import "DMPBottomBar.h"
#import "LLCFacilityHUD.h"

#import "LLCRequestModel.h"
#import "LLCMainModel.h"
#import "LLCMainDateModel.h"
#import "DMPBottomModel.h"

#import "LLCWonderfulModel.h"
#import "DMPHttpRequest.h"

#import "UIImageView+WebCache.h"
#import "UIButton+KitButton.h"
#import "DMPToolsManager.h"

#import "DMPDietTherapyVC.h"
#import "DMPSearchFoodVC.h"
#import "DMPHotFoodVC.h"
#import "DMPThousandsFoodVC.h"
#import "DMPAutoSeletedFoodVC.h"
#import "DMPMonthMenuVC.h"
#import "DMPShakeVC.h"


#import <QRCodeReader.h>
#import <TwoDDecoderResult.h>
#define kHUD_Tag 222

typedef enum {
    eDateRequest = 100,
    eMainRequest = 101,
    eQRRequest = 102
}RequestType;

typedef enum {
    eBrainpowerSearchButton = 200,
    eSearchButton = 201,
    eMineButton = 202,
}ItemType;

typedef enum {
    eTarBarDiseaseDietButton = 300,
    eTarBarHotVButton,
    eTarBarMonthMenuButton,
    eTarBarShakeButton,
    eTarBarGreatFoodButton
}tarBarItemType;

@interface LLCMainViewController ()
<DMPHttpRequestDelegate>
{
    NSMutableArray    *_mainArray;
    NSMutableArray    *_dateArray;
    
    LLCDateIntroduceView  *_dateIntroduce;
    LLCPageControl    *_pageControl;
    
    LLCRequestModel *_requestModel;
    
    BOOL _isLoading;
}
@property (nonatomic, strong) LLCMainModel * qrResultModel;
@end
@implementation LLCMainViewController

const int kNumberOfButton = 3;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        [self initMember];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self uiConfig];
    [self loadData];
}

#pragma mark - QFTable View DataSource
- (CGFloat)QFTableView:(QFTableView *)fanView
         widthForIndex:(NSInteger)index {
    return 320;
}

- (NSInteger)numberOfIndexForQFTableView:(QFTableView *)fanView {
    return _mainArray.count;
}

- (void)QFTableView:(QFTableView *)fanView
     setContentView:(UIView *)contentView
           ForIndex:(NSInteger)index {
    LLCMainModel *model = [_mainArray objectAtIndex:index];
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

#pragma mark QFTable View Delegate
#pragma mark 点选cell, 弹入视频界面
- (void)QFTableView:(QFTableView *)fanView selectIndex:(NSInteger)index {
    
    LLCVideoViewController *vVC = [[LLCVideoViewController alloc] init];
    vVC.dataArray = _mainArray;
    vVC.currentIndex = index;
    [self.navigationController pushViewController:vVC animated:YES];
}

#pragma mark 翻页
- (void)QFTableView:(QFTableView *)fanView scrollToIndex:(NSInteger)index {
    
    if (index > _mainArray.count-1) {
        return;
    }
    
    if (_mainArray.count > 0 && index > -1) {
        LLCMainModel *model = [_mainArray objectAtIndex:index];
        _dateIntroduce.foodNameLabel.text = model.name;
        _dateIntroduce.foodPinYinName.text = model.englishName;
        
        [_pageControl lightPointBeforePage:index];
    }
}

#pragma mark 读取更多
- (void)llcTableViewLoadMoreData {
    if (_isLoading) {
        return;
    }
    
    // 加载hud
    UIView *oldHud = [self.view viewWithTag:kHUD_Tag];
    if (oldHud != nil) {
        [oldHud removeFromSuperview];
    }
    LLCFacilityHUD *hud = [[LLCFacilityHUD alloc] initWithPosition:self.view.center];
    hud.tag = kHUD_Tag;
    [self.view addSubview:hud];
    [hud loading];
    
    _isLoading = YES;
    _requestModel.page++;
    NSString *mainUrlString = [NSString stringWithFormat:kMain_Url, _requestModel.page, _requestModel.user_id];
    [DMPHttpRequest requestWithUrlString:mainUrlString
                               isRefresh:NO
                                delegate:self
                                     tag:eMainRequest];
}

#pragma mark - DMP HttpRequest Delegate
#pragma mark 数据请求完成
- (void)dmpHttpRequestDidFinished:(DMPHttpRequest *)request {
    if (request.downloadData) {
        switch (request.tag) {
            case eDateRequest:
                [self loadMainDateData:request.downloadData];
                _isLoading = NO;
                break;
            case eMainRequest:
            {
                if (_mainArray.count > 0) {
                    [self loadMainData:request.downloadData completion:^{
                        _pageControl.pageCount = _mainArray.count;
                        [_pageControl extinguishPointsAfterPage:_mainArray.count-8];
                        _isLoading = NO;
                    }];
                } else {
                    [self loadMainData:request.downloadData completion:^{
                        _isLoading = NO;
                    }];
                }
            }  break;
            case eQRRequest:
            {
                [self getQRResultDataWithDownloadData:request.downloadData];
                
                LLCVideoViewController *vVC = [[LLCVideoViewController alloc] init];
                vVC.currentIndex = 0;
                [vVC loadSingleFoodWithVegetableID:self.qrResultModel.vegetable_id];
                [self.navigationController pushViewController:vVC animated:YES];
                [LLCFacilityHUD hudSuccessAppearOnView:self.view];
            } break;
            default:
                break;
        }
    }
}

#pragma mark 数据请求失败
- (void)dmpHttpRequest:(DMPHttpRequest *)request DidFailWithError:(NSError *)error {
    LLCFacilityHUD *hudView = (LLCFacilityHUD *)[self.view viewWithTag:kHUD_Tag];
    if (hudView != nil) {
        [hudView failed];
    }
    _isLoading = NO;
}

#pragma mark - 读取数据
#pragma mark 日期数据
- (void)loadMainDateData:(NSData *)downloadData {
    
    id result = [NSJSONSerialization JSONObjectWithData:downloadData
                                                options:NSJSONReadingMutableContainers
                                                  error:nil];
    
    if ([result isKindOfClass:[NSDictionary class]]) {
        NSDictionary *theResults = (NSDictionary *)result;
        
        NSArray *datesIntroduce = [theResults objectForKey:@"data"];
        
        [_dateArray addObjectsFromArray:
         [LLCWonderfulModel achieveJSONModelsWithDataAndElementNames:datesIntroduce
                                     isNodeNamesEqualToPropertyNames:YES
                                         modelClassNameAndValueNames:@"LLCMainDateModel", @"alertInfoAvoid", @"alertInfoFitting", @"LunarCalendar", nil]];
        
        LLCMainDateModel *model = [_dateArray objectAtIndex:0];
        _dateIntroduce.ddLabel.text = _requestModel.day;
        _dateIntroduce.yyMMLabel.text = [NSString stringWithFormat:@"%@-%@", _requestModel.year, _requestModel.month];
        _dateIntroduce.avoidContent = model.alertInfoAvoid;
        _dateIntroduce.fittingContent = model.alertInfoFitting;
        _dateIntroduce.oldDateLabel.text = [NSString stringWithFormat:@"农历%@", model.LunarCalendar];
        
        [_dateIntroduce lanuchContent];
    }
}

#pragma mark 主界面数据
- (void)loadMainData:(NSData *)downloadData
          completion:(void (^) (void))completion{
    
    id result = [NSJSONSerialization JSONObjectWithData:downloadData
                                                options:NSJSONReadingMutableContainers
                                                  error:nil];
    
    if ([result isKindOfClass:[NSDictionary class]]) {
        NSDictionary *theResults = (NSDictionary *)result;
        
        NSArray *mainsArray = [theResults objectForKey:@"data"];
        
        for (NSDictionary *aDic in mainsArray) {
            LLCMainModel *model = [[LLCMainModel alloc] init];
            [model setValuesForKeysWithDictionary:aDic];
            [_mainArray addObject:model];
        }
    }
    
    if (_mainArray.count < 9) {
        LLCMainModel *model = [_mainArray objectAtIndex:0];
        _dateIntroduce.foodNameLabel.text = model.name;
        _dateIntroduce.foodPinYinName.text = model.englishName;
    }
    if (completion) {
        completion();
    }
    
    LLCFacilityHUD *hud = (LLCFacilityHUD *)[self.view viewWithTag:kHUD_Tag];
    [hud successed];
    [_tableView reloadData];
}

#pragma mark - Private
#pragma mark 读取数据
- (void)loadData {
    NSDate *today = [NSDate date];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    NSString *date = [formatter stringFromDate:today];
    NSArray *datesComponet = [date componentsSeparatedByString:@"-"];
    
    _requestModel = [[LLCRequestModel alloc] init];
    _requestModel.year = [datesComponet objectAtIndex:0];
    _requestModel.month = [datesComponet objectAtIndex:1];
    _requestModel.day = [datesComponet objectAtIndex:2];
    _requestModel.page = 1;
    
    NSString *dateUrlString = [NSString stringWithFormat:
                               kMainDate_Url,
                               _requestModel.year,
                               _requestModel.month,
                               _requestModel.day];
    
    [DMPHttpRequest requestWithUrlString:dateUrlString
                               isRefresh:NO
                                delegate:self
                                     tag:eDateRequest];
    
    NSString *mainUrlString = [NSString stringWithFormat:kMain_Url, _requestModel.page, _requestModel.user_id];
    [DMPHttpRequest requestWithUrlString:mainUrlString
                               isRefresh:NO
                                delegate:self
                                     tag:eMainRequest];
}

#pragma mark tabbar点击响应
- (void) tarBarItemPress:(UIButton *)btn {
    switch (btn.tag) {
        case eTarBarDiseaseDietButton: {
            DMPDietTherapyVC * dietVC = [[DMPDietTherapyVC alloc] init];
            [self.navigationController pushViewController:dietVC animated:YES];
        }
            break;
        case eTarBarHotVButton:{
            DMPHotFoodVC * hotVC = [[DMPHotFoodVC alloc] init];
            [self.navigationController pushViewController:hotVC animated:YES];
        }
            break;
        case eTarBarMonthMenuButton:{
            DMPMonthMenuVC * monthVC = [[DMPMonthMenuVC alloc] init];
            [self.navigationController pushViewController:monthVC animated:YES];
        }
            break;
        case eTarBarShakeButton:{
            DMPShakeVC * shakeVC = [[DMPShakeVC alloc ] init];
            [self.navigationController pushViewController:shakeVC animated:YES];
        }
            break;
        case eTarBarGreatFoodButton:{
            DMPThousandsFoodVC * thousandsFoodVC = [[DMPThousandsFoodVC alloc] init];
            [self.navigationController pushViewController:thousandsFoodVC animated:YES];
        }
        default:
            break;
    }
}
#pragma mark 导航条按钮响应函数
- (void)navItemPressed:(UIButton *)item {
    
    switch (item.tag) {
        case eBrainpowerSearchButton:
        {
            DMPAutoSeletedFoodVC * autoSelectVC = [[DMPAutoSeletedFoodVC alloc] init];
            [self.navigationController pushViewController:autoSelectVC animated:YES];
        } break;
        case eSearchButton:
        {
            DMPSearchFoodVC * searchVC = [[DMPSearchFoodVC alloc] init];
            [self.navigationController pushViewController:searchVC animated:YES];
        } break;
        case eMineButton:
        {
            LLCMineViewController *mineVC = [[LLCMineViewController alloc] init];
            [self.navigationController pushViewController:mineVC animated:YES];
        } break;
            
        default:
            break;
    }
}
#pragma mark- 二维码Zxing
- (void)callZXingOut {
    DMPQRViewController * qrVC = [[DMPQRViewController alloc] initWithDelegate:self showCancel:NO OneDMode:NO showLicense:NO];
    qrVC.dmpDelegate = self;
    NSMutableSet * readers = [[NSMutableSet alloc] init];
    QRCodeReader * reader = [[QRCodeReader alloc] init];
    [readers addObject:reader];
    qrVC.readers = readers;
    [self presentViewController:qrVC animated:YES completion:nil];
}
- (void) decodeImage:(UIImage *)image {
    NSMutableSet * qrReader = [[NSMutableSet alloc] init];
    QRCodeReader *qrcoderReader = [[QRCodeReader alloc] init];
    [qrReader addObject:qrcoderReader];
    
    Decoder * decoder = [[Decoder alloc] init];
    decoder.delegate = self;
    decoder.readers = qrReader;
    [decoder decodeImage:image];
}
#pragma mark- dmpQRViewControllerDelegate
- (void) dmpQRViewController:(DMPQRViewController *)qrVC didFinishPickingImage:(UIImage *)image {
    [qrVC dismissViewControllerAnimated:NO completion:^{
        [self decodeImage:image];
    }];
}
#pragma mark- DecoderDelegate
//相片解析二维码
- (void)decoder:(Decoder *)decoder didDecodeImage:(UIImage *)image usingSubset:(UIImage *)subset withResult:(TwoDDecoderResult *)result
{
    [self processQRCodeString:result.text];
}
//相片解析二维码失败
- (void)decoder:(Decoder *)decoder failedToDecodeImage:(UIImage *)image usingSubset:(UIImage *)subset reason:(NSString *)reason
{
    NSLog(@"%@",reason);
    [self processQRCodeString:@""];
}
#pragma mark- ZxingWidgetDelegate
- (void)zxingController:(ZXingWidgetController *)controller didScanResult:(NSString *)result {
    [controller dismissViewControllerAnimated:YES completion:^{
        [self processQRCodeString:result];
    }];
}
#pragma mark- 处理二维码解析出来的字符串
- (void) processQRCodeString:(NSString *)codeString {
    NSString * message;
    if ([[DMPToolsManager shareToolsManager] isQRCodeStringFitForApp:codeString]) {
        [self requestFromQRCodeString:codeString];
        return;
    }else if([codeString isEqualToString:@""]){
        message = @"相片识别失败,可能照片不够清晰或者不够正面居中";
    }else {
        message = @"这二维码不是掌厨菜品专用哦~";
    }
    UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"扫描结果" message:message delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
    [alert show];
}
- (void)zxingControllerDidCancel:(ZXingWidgetController *)controller {
    [controller dismissViewControllerAnimated:YES completion:nil];
}
- (void) requestFromQRCodeString:(NSString *)codeString {
    [LLCFacilityHUD hudLoadingAppearOnView:self.view];
    NSString * url = [[DMPToolsManager shareToolsManager] getUrlFromQRCodeString:codeString];
    
    [DMPHttpRequest requestWithUrlString:url isRefresh:NO delegate:self tag:eQRRequest];
}
- (void) getQRResultDataWithDownloadData:(NSData *)data {
    self.qrResultModel = nil;
    if (data) {
        id result = [NSJSONSerialization JSONObjectWithData:data
                                                    options:NSJSONReadingMutableContainers
                                                      error:nil];
        if ([result isKindOfClass:[NSDictionary class]]) {
            NSDictionary *theResults = (NSDictionary *)result;
            
            NSArray *mainsArray = [theResults objectForKey:@"data"];
            
            for (NSDictionary *aDic in mainsArray) {
                LLCMainModel *model = [[LLCMainModel alloc] init];
                [model setValuesForKeysWithDictionary:aDic];
                _qrResultModel = model;
            }
        }
        LLCFacilityHUD *hud = (LLCFacilityHUD *)[self.view viewWithTag:kHUD_Tag];
        [hud successed];
    }
}
#pragma mark 初始化成员变量
- (void)initMember {
    
    _isLoading = NO;
    _mainArray = [[NSMutableArray alloc] init];
    _dateArray = [[NSMutableArray alloc] init];
}

#pragma mark 布局
- (void)uiConfig {
    [self dateIntroduceConfig];
    [self navBarConfig];
    [self tabBarConfig];
    [self codeBarConfig];
    [self pageControlConfig];
}

/** 二维码布局 */
- (void)codeBarConfig {
    UIButton *codeBarBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [codeBarBtn setBackgroundImage:[UIImage imageNamed:@"首页-二维码.png"] forState:UIControlStateNormal];
    [codeBarBtn setBackgroundImage:[UIImage imageNamed:@"首页-二维码-选.png"] forState:UIControlStateHighlighted];
    codeBarBtn.bounds = CGRectMake(0, 0, 141/3, 130/3.);
    codeBarBtn.center = CGPointMake(kScreenWidth-20-codeBarBtn.bounds.size.width/2, _dateIntroduce.frame.size.height/2+44);
    [codeBarBtn addTarget:self action:@selector(callZXingOut) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:codeBarBtn];
}

/** 标签栏布局 */
- (void)tabBarConfig {
    DMPBottomBar * bar = [[[NSBundle mainBundle] loadNibNamed:@"DMPBottomBar" owner:self options:nil] lastObject];
    NSDictionary * dict = [[DMPToolsManager shareToolsManager] getRespondingDictionaryWithController:self];
    dict = dict[@"BottomBarItemsName"];
    
    NSArray * imageName = dict[@"ImageName"];
    NSArray * imageNameH = dict[@"ImageNameH"];
    
    NSMutableArray * models = [[NSMutableArray alloc] init];
    for (int i = 0; i < 5; i ++) {
        DMPBottomModel * model = [[DMPBottomModel alloc] initBottomModelWithNormalImageName:imageName[i] highlightImageName:imageNameH[i] target:self action:@selector(tarBarItemPress:) tag:i + eTarBarDiseaseDietButton];
        [models addObject:model];
    }
    [bar setItemsWithModels:models];
    bar.frame = CGRectMake(0, self.view.bounds.size.height - bar.bounds.size.height, bar.bounds.size.width, bar.bounds.size.height);
    [self.view addSubview:bar];
}

/** 导航条布局 */
- (void)navBarConfig {
    [_backBtn removeFromSuperview];
    CGSize size;
    NSDictionary * dict = [[DMPToolsManager shareToolsManager] getRespondingDictionaryWithController:self];
    NSDictionary * naviItemsDict = dict[@"RightItemsForNavi"];
    
    NSArray *titles = naviItemsDict[@"Title"];
    NSArray *buttonImageName = naviItemsDict[@"ImageName"];
    NSArray *buttonHightlightImageName = naviItemsDict[@"ImageNameH"];
    
    NSMutableArray *buttons = [[NSMutableArray alloc] init];
    for (int i = 0; i < kNumberOfButton; i++) {
        UIButton *btn = [UIButton createKitButtonWithBackgroundImageForNormal:[UIImage imageNamed:[buttonImageName objectAtIndex:i]] highlight:[UIImage imageNamed:[buttonHightlightImageName objectAtIndex:i]] bottomTitle:[titles objectAtIndex:i]];
        btn.tag = 200+i;
        [buttons addObject:btn];
        size = btn.frame.size;
        [btn addTarget:self action:@selector(navItemPressed:) forControlEvents:UIControlEventTouchUpInside];
    }
    [self.dmpNavigationBar setDMPNaviBarItemsWithArray:buttons isLeft:NO];
    
    naviItemsDict = dict[@"LeftItemsForNavi"];
    UILabel *appLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth - 41 * kNumberOfButton - 2, 40)];
    NSArray * leftitems = naviItemsDict[@"Title"];
    appLabel.text = leftitems[0];
    appLabel.textColor = [UIColor whiteColor];
    appLabel.font = [UIFont systemFontOfSize:13];
    appLabel.backgroundColor = [UIColor clearColor];
    
    [self.dmpNavigationBar setDMPNaviBarItemsWithArray:@[appLabel] isLeft:YES];
}

/** 页码指示器布局 */
- (void)pageControlConfig {
    _pageControl = [[LLCPageControl alloc] initWithFrame:CGRectMake(10, kScreenHeight-44-20-5, 198.5, 30)
                                              pointCount:16
                                       pointCornerRadius:2.5];
    _pageControl.pageCount = 8;
    [self.view addSubview:_pageControl];
}

/** 日期控件布局 */
- (void)dateIntroduceConfig {
    _dateIntroduce = [[[NSBundle mainBundle] loadNibNamed:@"LLCDateIntroduceView"
                                                    owner:self
                                                  options:nil] lastObject];
    _dateIntroduce.center = CGPointMake(_dateIntroduce.frame.size.width/2+20, _dateIntroduce.frame.size.height/2+44);
    [self.view addSubview:_dateIntroduce];
}

- (BOOL)shouldAutorotate {
    return NO;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return interfaceOrientation == UIInterfaceOrientationLandscapeLeft;
}

- (NSUInteger)supportedInterfaceOrientations {
    return UIInterfaceOrientationLandscapeLeft;
}

@end
