//
//  DMPAutoSeletedFoodVC.m
//  PocketKitchenGod
//
//  Created by Damon's on 14-2-20.
//  Copyright (c) 2014年 yxx. All rights reserved.
//

#import "DMPAutoSeletedFoodVC.h"
#import "LLCGodFoodView.h"
#import "GDataXMLNode.h"

#import "LLCGodFoodModel.h"
#import "LLCSubFoodModel.h"
#import "LLCUserInfoManager.h"
#import "LLCMainModel.h"

#import "DMPToolsManager.h"
#import "DMPSearchDisPlayView.h"
#import "DMPUniversalSearchResultVC.h"

#import "LLCFacilityHUD.h"
#define kColorWithRGBA(r,g,b,a) [UIColor colorWithRed:r/255. green:g/255. blue:b/255. alpha:a]
#define kSingleNumber_Color kColorWithRGBA(226,222,208,1)
#define kDoubleNumber_Color kColorWithRGBA(226,216,202,1)

@interface DMPAutoSeletedFoodVC () {
    NSMutableArray * _modelArray;           //存放subFoodModel
    DMPMetrialView * _areaView;               //展示搜索条件的View
    NSMutableArray * _dataArray;              //存放LLCMainModel
    UIView * _bannerView;                            //阻止用户交互的view
}

@end

@implementation DMPAutoSeletedFoodVC

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
    [self createSelectedPart];


    
#pragma mark 读取数据
    NSString *content = [NSString stringWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"material.xml" ofType:nil] encoding:NSUTF8StringEncoding error:nil];
    
    NSMutableArray *categoryModels = [[NSMutableArray alloc] init];
    
    GDataXMLDocument *document = [[GDataXMLDocument alloc] initWithXMLString:content options:0 error:nil];
    
    NSArray *arr = [document nodesForXPath:@"//entity" error:nil];
    GDataXMLElement *element = [arr lastObject];
    
    NSArray *firstElement = [element elementsForName:@"tblMmaterialType"];
    
    for (GDataXMLElement *aCategoryNode in firstElement) {
        
        LLCGodFoodModel *categoryModel = [[LLCGodFoodModel alloc] init];
        categoryModel.categoryName = [[[aCategoryNode elementsForName:@"name"] lastObject] stringValue];
        NSArray *foodNodes = [aCategoryNode elementsForName:@"tblMaterial"];
        for (GDataXMLElement *aFoodNode in foodNodes) {
            
            LLCSubFoodModel *subFoodModel = [[LLCSubFoodModel alloc] init];
            subFoodModel.foodName = [self getStringValueWithElement:aFoodNode forChildName:@"name"];
            subFoodModel.foodImagName = [self getStringValueWithElement:aFoodNode forChildName:@"imageFilename"];
            subFoodModel.materialId = [self getStringValueWithElement:aFoodNode forChildName:@"materialId"];
            [categoryModel.subFoodModels addObject:subFoodModel];
        }
        
        [categoryModels addObject:categoryModel];
    }
    
//    self.view.backgroundColor = [UIColor purpleColor];
    self.automaticallyAdjustsScrollViewInsets = NO;
    NSInteger height = [[DMPToolsManager shareToolsManager] getFitHeightForOS];
    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, height + 92 + 50, 320, kScreenHeight - 92 - 50 - 64)];
    scrollView.showsHorizontalScrollIndicator = NO;
    scrollView.showsVerticalScrollIndicator = NO;
    scrollView.contentSize = CGSizeMake((141+5)*15+5, scrollView.frame.size.height);
    [self.view addSubview:scrollView];
    
    for (int i = 0; i < 15; i++) {
        LLCGodFoodView *food = [[LLCGodFoodView alloc] initWithFrame:CGRectMake(i*(5+141), 0, 141, scrollView.frame.size.height) andTableBackgroungColor:i % 2 == 0 ? kSingleNumber_Color : kDoubleNumber_Color];
        food.target = self;
        food.action = @selector(foodMetrialSelected:);
        LLCGodFoodModel *amodel = [categoryModels objectAtIndex:i];
        food.titleLabel.text = amodel.categoryName;
        food.dataArray = amodel.subFoodModels;
        [scrollView addSubview:food];
    }
    
#pragma mark- bannerView
    //bannerView
    _bannerView = [[UIView alloc] initWithFrame:CGRectMake(0,[[DMPToolsManager shareToolsManager] getFitHeightForOS], kScreenWidth, kScreenHeight - 64)];
    _bannerView.hidden = YES;
    [self.view addSubview:_bannerView];
}

- getStringValueWithElement:(GDataXMLElement *)element forChildName:(NSString *)childName {
    return [[[element elementsForName:childName] lastObject] stringValue];
}

#pragma mark- 数据初始化
- (void) dataInit {
    _modelArray = [[NSMutableArray alloc] init];
    _dataArray = [[NSMutableArray alloc] init];
}

#pragma mark- 响应点击
//食材tableView响应点击事件,穿出来对应的LLCSubFoodModel
- (void) foodMetrialSelected:(LLCSubFoodModel * )model {
    if (_modelArray.count != 6 && ![_modelArray containsObject:model]) {
        [_modelArray addObject:model];
        [_areaView reloadData];
    }else if(_modelArray.count == 6) {
        [self displayAlertWithMessage:@"最多可以选择6种材料,请删除部分材料再添加"];
    }
}

//touchDown
- (void) btnPressIn:(UIButton *)btn {
//button 触摸反馈,与btnPressOn方法相呼应
    btn.alpha = 0.3;
    
}
//touchUpInside
- (void) btnPressOn:(UIButton *)btn {
    [UIView animateWithDuration:0.25f animations:^{
        btn.alpha = 1.0;
    }];
//判断数组是否有model
    if (_modelArray.count) {
        //数组中有
        //请求数据
        [self requestForResultModelArrayWithKeyWord:[self getAppendedMetrialID]];
        
    }else {
        //数组中没有
        [self displayAlertWithMessage:@"没有材料"];
    }
}
#pragma mark- 获取当前被选择的model中的拼接id
- (NSString *) getAppendedMetrialID {
    //创建要搜索材料的id拼接起来的一个字符串
    NSMutableString * idString = [[NSMutableString alloc] init];
    for (int i = 0; i < _modelArray.count; i++) {
        LLCSubFoodModel * model = _modelArray[i];
        [idString appendFormat:@"%@",model.materialId];
        if (i < _modelArray.count - 1) {
            [idString appendString:@","];
        }
    }
    return idString;
}
#pragma mark - 获取当前被选择的model中的拼接名
- (NSString *) getAppendedMetrialName {
    NSString * firstName = ((LLCSubFoodModel *)_modelArray[0]).foodName;
    NSMutableString * abstract = [[NSMutableString alloc] initWithString:firstName];
    for (int i = 0; i < _modelArray.count; i ++) {
        if(i == 0)
            continue;
        
        LLCSubFoodModel * model = _modelArray[i];
        [abstract appendFormat:@"+%@",model.foodName];
    }
    return abstract;
}
#pragma mark- 发出请求获取搜索结果model的数组
- (void) requestForResultModelArrayWithKeyWord:(NSString *)keyStr {
    [LLCFacilityHUD hudLoadingAppearOnView:self.view];
    _bannerView.hidden = NO;
                      
    [DMPHttpRequest requestWithUrlString:[NSString stringWithFormat:kBrainpower_Search,keyStr,1,[[LLCUserInfoManager sharedUserInfo] userID]] isRefresh:NO delegate:self tag:1];
}
#pragma mark- HttpRequestDelegate
- (void)dmpHttpRequest:(DMPHttpRequest *)request
            DidFailWithError:(NSError *)error {
    [LLCFacilityHUD hudFailAppearOnView:self.view];
    
    _bannerView.hidden = YES;
}

- (void)dmpHttpRequestDidFinished:(DMPHttpRequest *)request {
    if (request.downloadData) {
        id result = [NSJSONSerialization JSONObjectWithData:request.downloadData options:NSJSONReadingMutableContainers error:nil];
        if ([result isKindOfClass:[NSDictionary class]]) {
            NSDictionary * dataDict = result;
            NSString * status = dataDict[@"status"];
            if ([status isEqualToString:@"1"]) {
                //服务器返回搜索无结果
                [self displayAlertWithMessage:dataDict[@"message"]];
                return;
            }else {
                NSArray * dataArray = dataDict[@"data"];
                for (NSDictionary * modelDict in dataArray) {
                    LLCMainModel * model = [[LLCMainModel alloc] init];
                    [model setValuesForKeysWithDictionary:modelDict];
                    [_dataArray addObject:model];
                }
                
            }
        }
    }
//若有结果,传递
    [self sentDataToSearchResultVCWithArray:_dataArray];
}
#pragma mark- 传递model数组到搜索结果页面
- (void) sentDataToSearchResultVCWithArray:(NSArray *)dataArray {
     DMPUniversalSearchResultVC * resultVC = [[DMPUniversalSearchResultVC alloc] initWithTitle:@"智能选菜结果" abstract:[self getAppendedMetrialName]  initDataArray:_dataArray searchType:DMPSearchTypeAutoSearch key:nil];
    [self.navigationController pushViewController:resultVC animated:YES];
    [LLCFacilityHUD hudSuccessAppearOnView:self.view];
}

#pragma mark - 弹出警告框
- (void) displayAlertWithMessage:(NSString *)message {

    UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"温馨提示" message:message delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
    [alert show];
}

#pragma mark- 创建选择部分
- (void) createSelectedPart {
//导航栏设置
    [self.dmpNavigationBar setDMPNaviBarTitleViewWithTitle:@"智能选菜" signImageName:@"智能选菜"];
    [self.dmpNavigationBar setDMPNaviBarTitleViewSignImageViewSize:CGSizeMake(35, 30)];
//创建背景
    NSInteger height = [[DMPToolsManager shareToolsManager] getFitHeightForOS];
    UIImageView * bgView = [[UIImageView alloc] initWithFrame:CGRectMake(0,height, kScreenWidth,kScreenHeight - 64)];
    bgView.image = [UIImage imageNamed:@"背景图"];
    [self.view addSubview:bgView];
//DMPMetrialView
    _areaView = [[DMPMetrialView alloc] initWithFrame:CGRectMake(3,height, 314, 92) distanceToVerticalSide:15 distanceToHorizontalSide:30 displayerSize:CGSizeMake(80, 22) placeHolder:@"看看厨房都有哪些食材, 搜一搜, 就会有惊喜!" backgroundImageName:@"智能选菜-背景上"];
    _areaView.delegate = self;
    [self.view addSubview:_areaView];
//搜索按钮
    UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setBackgroundImage:[UIImage imageNamed:@"智能选菜-搜索"] forState:UIControlStateNormal];
     [button setBackgroundImage:[UIImage imageNamed:@"智能选菜-搜索"] forState:UIControlStateHighlighted];
    [button setTitle:@"搜索" forState:UIControlStateNormal];
   
    [button addTarget:self action:@selector(btnPressIn:) forControlEvents:UIControlEventTouchDown];
    [button addTarget:self action:@selector(btnPressOn:) forControlEvents:UIControlEventTouchUpInside];
    button.titleLabel.font = [UIFont systemFontOfSize:14];
    button.frame = CGRectMake(215, 92 + 10 + height, 73, 24);
    [self.view addSubview:button];

}

#pragma mark- MetrialViewDelegate
//MetralView中展示单位 为Displayer,此代理需要通过返回值确定displayer的个数
- (NSInteger)numberOfDisplayerForDmpMetrialView:(DMPMetrialView *)metrialView {
    return _modelArray.count;
}
//调用此代理来设置displayer
- (DMPSearchDisPlayView *)dmpMetrialView:(DMPMetrialView *)metrialView displayerAtIndex:(NSInteger)index {
    static NSString * displayerIde = @"displayer";
    DMPSearchDisPlayView * displayer = [metrialView dequeueDisplayerWithidentifier:displayerIde];
    if (!displayer) {
        displayer = [[[NSBundle mainBundle] loadNibNamed:@"DMPSearchDisPlayView" owner:self options:nil] lastObject];
       
        //智能选菜-材料背景
        displayer.searchBgView.image = [UIImage imageNamed:@"智能选菜-材料背景"];
        displayer.searchNameLabel.adjustsFontSizeToFitWidth = YES;
    }
    LLCSubFoodModel * model = _modelArray[index];
    displayer.searchNameLabel.text = model.foodName;
    return displayer;
}
//当点击到displayer的取消键时,调用此代理
- (void)dmpMetrialView:(DMPMetrialView *)metrialView DeleteDisplayerAtIndex:(NSInteger)index {
//点击删除键后的操作
    [_modelArray removeObjectAtIndex:index];
    [metrialView reloadData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
