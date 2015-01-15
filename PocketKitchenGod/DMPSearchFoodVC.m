//
//  DMPSearchFoodVC.m
//  PocketKitchenGod
//
//  Created by Damon's on 14-2-18.
//  Copyright (c) 2014年 yxx. All rights reserved.
//

#import "DMPSearchFoodVC.h"
#import "DMPSearchTypeScrollView.h"
#import "DMPSearchDisPlayView.h"
#import "DMPMetrialModel.h"
#import "LLCUserInfoManager.h"
#import "LLCMainModel.h"
#import "LLCFacilityHUD.h"
#import "DMPUniversalSearchResultVC.h"
@interface DMPSearchFoodVC () {
    UIView *_roomView;
    UITableView *_tableView;
    NSDictionary * _dataDict;
    NSMutableArray * _modelArray;
    DMPMetrialView * _areaView;
    NSMutableArray * _dataArray;
    NSMutableArray * _keyArray;
    NSInteger _currentSelectedSection;
}

@end

@implementation DMPSearchFoodVC
const float kYpointOffForKeyBoardAppear = 240;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    if (_dataArray) {
        [_dataArray removeAllObjects];
    }
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self dataInit];
    [self uiConfig];
    [self naviInit];
    
}
- (void)dataInit {
    NSArray * imageNameA = @[@"菜系-川菜",@"菜系-湘菜",@"菜系-粤菜",@"菜系-鲁菜",@"菜系-徽菜",@"菜系-闽菜",@"菜系-浙菜",@"菜系-苏菜",@"菜系-其它菜系"];
    NSArray * imageNameB = @[@"口味-苦",@"口味-辣",@"口味-酸",@"口味-甜",@"口味-咸",@"口味-鲜",@"口味-淡"];
    NSArray * imageNameC = @[@"人群-婴幼儿",@"人群-儿童",@"人群-女性",@"人群-孕妇",@"人群-产妇",@"人群-男性",@"人群-老年人",@"人群-糖尿病者",@"人群-高血压病者",@"人群-高血脂病者",@"人群-肠胃病者",@"人群-一般人群"];
    NSArray * imageNameD = @[@"烹饪-拌",@"烹饪-腌",@"烹饪-卤",@"烹饪-炒",@"烹饪-焖",@"烹饪-蒸",@"烹饪-煎",@"烹饪-炸",@"烹饪-炖",@"烹饪-煮",@"烹饪-烤",@"烹饪-冻",@"烹饪-泡",@"烹饪-榨汁"];
    NSArray * imageNameE = @[@"功效-增强免疫",@"功效-提神健脑",@"功效-瘦身排毒",@"功效-美容养颜",@"功效-养心润肺",@"功效-保肝护肾",@"功效-开胃消食",@"功效-益气补血",@"功效-安神助眠",@"功效-降低血压",@"功效-降低血糖",@"功效-降低血脂",@"功效-清热解毒",@"功效-补铁",@"功效-补锌",@"功效-补钙",@"功效-增高助长",@"功效-增长记忆力",@"功效-益智健脑",@"功效-保护视力",@"功效-健脾止泻",@"功效-防癌抗癌"];
    NSArray * titles = @[@"中华菜系",@"口味分类",@"人群分类",@"烹饪分类",@"功效分类"];
    
    _dataDict = @{@"A": imageNameA,
                            @"B":imageNameB,
                            @"C":imageNameC,
                            @"D":imageNameD,
                            @"E":imageNameE,
                            @"titles":titles};
    
    _modelArray = [[NSMutableArray alloc] init];
    _dataArray = [[NSMutableArray alloc] init];
    _keyArray = [[NSMutableArray alloc] init];
    //当前选择  一开始设置为0,即第一个
    _currentSelectedSection = 0;
    
}
- (void) uiConfig {
    self.automaticallyAdjustsScrollViewInsets = NO;
    NSInteger height = 0;
    if (kIsIOS7) {
        height = 64;
    }
    
    UIImageView * bgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, height, self.view.bounds.size.width, kScreenHeight - 64)];
    bgView.image = [UIImage imageNamed:@"背景图"];
    [self.view addSubview:bgView];
    //初始化一个装组件的View
    _roomView = [[UIView alloc] initWithFrame:CGRectMake(0, height, kScreenWidth, kScreenHeight - 64)];
    [self.view addSubview:_roomView];
    [self createSelectComponent];
    [self createSearchPart];
    
 
    [self.view sendSubviewToBack:_roomView];
    [self.view sendSubviewToBack:bgView];
    
    UIView * statusView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 20)];
    statusView.backgroundColor = [UIColor blackColor];
    [self.view addSubview:statusView];
}
- (void) naviInit {
    [self.dmpNavigationBar setDMPNaviBarTitleViewSignImageViewSize:CGSizeMake(30, 30)];
    [self.dmpNavigationBar setDMPNaviBarTitleViewWithTitle:@"搜索" signImageName:@"搜索"];
}
#pragma mark- 创建上半部分 选择模块
- (void) createSelectComponent {
    
    _areaView = [[DMPMetrialView alloc] initWithFrame:CGRectMake(20, 12, 281, 71) distanceToVerticalSide:7 distanceToHorizontalSide:5 displayerSize:CGSizeMake(84, 24) placeHolder:nil backgroundImageName:@"搜索-选择背景"];
    _areaView.delegate = self;
    [_roomView addSubview:_areaView];
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(20, 91, _areaView.bounds.size.width, 285) style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.bounces = NO;
    _tableView.showsVerticalScrollIndicator = NO;
    [_tableView setContentInset:UIEdgeInsetsMake(10, 0, 0, 0)];
    
    UIImageView * tableViewBgView = [[UIImageView alloc] initWithFrame:_tableView.bounds];
    tableViewBgView.backgroundColor = [UIColor colorWithRed:253/255.0 green:240/255.0 blue:229/255.0 alpha:1];
    tableViewBgView.alpha = 0.5;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.backgroundView = tableViewBgView;
    _tableView.backgroundColor = [UIColor clearColor];
    [_roomView addSubview:_tableView];
}
#pragma mark- 创建下班部分 搜索模块
- (void) createSearchPart {
    UIImageView * searchView = [[UIImageView alloc] initWithFrame:CGRectMake(14, kScreenHeight - 10 - 38 - 64, 203, 38)];
    searchView.image = [UIImage imageNamed:@"搜索-搜索框.png"];
    [_roomView addSubview:searchView];
    searchView.userInteractionEnabled = YES;
    UITextField * searchKeyWordTextField = [[UITextField alloc] initWithFrame:CGRectMake(38,7, 150, 24)];
    searchKeyWordTextField.placeholder = @"请输入关键字";
    searchKeyWordTextField.font = [UIFont systemFontOfSize:15];
    searchKeyWordTextField.backgroundColor = [UIColor clearColor];
    searchKeyWordTextField.delegate = self;
    searchKeyWordTextField.tag = 191;
    [searchView addSubview:searchKeyWordTextField];
    
    UIButton * btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setFrame:CGRectMake(225,searchView.frame.origin.y, 83, 38)];
    [btn setTitle:@"搜索" forState:UIControlStateNormal];
    [btn setBackgroundImage:[UIImage imageNamed:@"搜索-搜索框按钮"] forState:UIControlStateNormal];
    [btn setBackgroundImage:[UIImage imageNamed:@"搜索-搜索框按钮-选"] forState:UIControlStateHighlighted];
    [btn addTarget:self action:@selector(btnPress:) forControlEvents:UIControlEventTouchUpInside];
    btn.titleLabel.font = [UIFont systemFontOfSize:17];
    [_roomView addSubview:btn];
}

- (NSString *)getDataKeyInDictWithIndexPath:(NSIndexPath *)indexPath {
    return [self getDataKeyInDictWithSection:indexPath.section];
}
- (NSString *)getDataKeyInDictWithSection:(NSInteger)section {
    switch (section) {
        case 0:
            return @"A";
            break;
        case 1:
            return @"B";
            break;
        case 2:
            return @"C";
            break;
        case 3:
            return @"D";
            break;
        default:
            return @"E";
            break;
    }
}
- (NSString *) getTextFieldText {
    UITextField * textField = ((UITextField *)[self.view viewWithTag:191]);
    return textField.text;
}

#pragma mark - 网络请求
- (void) requestWithAllInfos {
    [LLCFacilityHUD hudLoadingAppearOnView:self.view];
    for (int i = 0; i < 5; i ++) {
        if(!i) {
            NSString * name = [self translateHan:[self getTextFieldText]];
            [_keyArray addObject:name];
        }
        NSString * key = [self translateHan:[self getCurrentNameOfSelectedModelInSection:i]];
        [_keyArray addObject:key];
    }
//    NSString * name = [self translateHan:[self getTextFieldText]];
//    NSString * child_catalog_name = [self translateHan:[self getCurrentNameOfSelectedModelInSection:0]];
//    NSString * taste = [self translateHan:[self getCurrentNameOfSelectedModelInSection:1]];
//    NSString * fitting_crowd = [self translateHan:[self getCurrentNameOfSelectedModelInSection:2]];
//    NSString * cooking_method = [self translateHan:[self getCurrentNameOfSelectedModelInSection:3]];
//    NSString * effect = [self translateHan:[self getCurrentNameOfSelectedModelInSection:4]];

    [DMPHttpRequest requestWithUrlString: [NSString stringWithFormat:kSearch,((NSString *)_keyArray[0]),_keyArray[1],_keyArray[2],_keyArray[3],_keyArray[4],_keyArray[5],1,@""] isRefresh:YES delegate:self tag:1];
   }
#pragma mark- 获取数组中对应section的model的name
- (NSString *)getCurrentNameOfSelectedModelInSection:(NSInteger)section {
    for (DMPMetrialModel * model in _modelArray) {
        if (model.tag == section) {
            return model.name;
            break;
        }
    }
    return @"";
}
#pragma mark- 转汉字为网络格式
- (NSString *) translateHan:(NSString *)han {
    
    
    NSString * trans = @"";
    const  char *b = [han cStringUsingEncoding:NSUTF8StringEncoding];
    
    for(int i = 0; i < strlen(b); i++) {
    
        if ((b[i] >= 'A'&& b[i] <='Z')||( b[i] >= 'a' && b[i] <= 'z')||(b[i] >= '0'&&b[i] <= '9')) {
            trans = [NSString stringWithFormat:@"%@%c",trans,b[i]];
        }
        else
        trans = [NSString stringWithFormat:@"%@%%%02X",trans, (unsigned char)b[i]];
    }
    return trans;
}
#pragma mark-
#pragma mark- 点击响应
//搜索button点击
- (void) btnPress:(UIButton *)btn {
   
    [self requestWithAllInfos];

}
//各种类别点击
static NSInteger lastIndex = 99;
static NSInteger lastSection = 99;
- (void) scrollViewPressed:(DMPSearchTypeScrollView *)scroll {
//记录上一次点击
    
    
    if (!(lastIndex == scroll.currentSelectedIndex && lastSection ==_currentSelectedSection)) {
//点击不同于上一次
        lastIndex = scroll.currentSelectedIndex;
        lastSection = _currentSelectedSection;
        //得到title
        NSArray * array = _dataDict[[self getDataKeyInDictWithSection:_currentSelectedSection]];
        NSString * title = array[scroll.currentSelectedIndex];
        NSArray * subString = [title componentsSeparatedByString:@"-"];
        
//查找数组,看看是否已存在这个model
        BOOL isFind = NO;
        for (DMPMetrialModel * model in _modelArray) {
            if (model.tag == _currentSelectedSection) {
                __strong DMPMetrialModel * fitModel = model;
                fitModel.name = [subString lastObject];;
                [_modelArray removeObject:model];
                [_modelArray addObject:fitModel];
                //存在,替换值,换到最后一个,停止搜索
                isFind = YES;
                break;
            }
        }
        
        if (!isFind) {
//没找到,创建一个
            DMPMetrialModel * model = [[DMPMetrialModel alloc] init];
            model.name = [subString lastObject];
            model.tag = _currentSelectedSection;
            [_modelArray addObject:model];
        }
        //设置model完成
        //metrialView重置  
        [_areaView reloadData];
    }
    
}
- (void) headerViewTap:(UIGestureRecognizer *)recognizer {
    UIView * view = recognizer.view;
    NSInteger section = view.tag;
    _currentSelectedSection = section;
    //  [_tableView reloadSections:[NSIndexSet indexSetWithIndex:_currentSelectedSection] withRowAnimation:UITableViewRowAnimationNone];
    [_tableView reloadData];
}
#pragma mark- TextFieldDelegate 
- (void)textFieldDidBeginEditing:(UITextField *)textField {
    [UIView animateWithDuration:0.25f delay:0 options:UIViewAnimationOptionCurveEaseIn animations:^{
        _roomView.frame = CGRectOffset(_roomView.frame, 0, -kYpointOffForKeyBoardAppear);
    } completion:nil];
    NSInteger height = 0;
    if (kIsIOS7) {
        height = 64;
    }
    UIView * temporaryView = [[UIView alloc] initWithFrame:CGRectMake(0,height, kScreenWidth, kScreenHeight - 64 - 216)];
    temporaryView.tag = 992;
    temporaryView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:temporaryView];
}
#pragma mark- touch
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    if(_roomView.frame.origin.y < 0) {
    UIView * textField = [_roomView viewWithTag:191];
    [textField resignFirstResponder];
    UIView * tempView = [self.view viewWithTag:992];
    [tempView removeFromSuperview];
    
    [UIView animateWithDuration:0.25f delay:0 options:UIViewAnimationOptionCurveEaseIn animations:^{
        _roomView.frame = CGRectOffset(_roomView.frame, 0, kYpointOffForKeyBoardAppear);
    } completion:nil];
    }
}
#pragma mark- HttpRequestDelegate
- (void)dmpHttpRequest:(DMPHttpRequest *)request DidFailWithError:(NSError *)error {
    [LLCFacilityHUD hudFailAppearOnView:self.view];
}
- (void)dmpHttpRequestDidFinished:(DMPHttpRequest *)request {
    if (request.downloadData) {
        id result = [NSJSONSerialization JSONObjectWithData:request.downloadData options:NSJSONReadingMutableContainers error:nil];
      //  NSLog(@"%@",[[NSString alloc] initWithData:request.downloadData encoding:NSUTF8StringEncoding]);
        if ([result isKindOfClass:[NSDictionary class]]) {
            NSDictionary * dataDict = result;
            NSString * status = dataDict[@"status"];
            if ([status isEqualToString:@"1"]) {
                //服务器返回搜索无结果
                [self displayAlertWithMessage:dataDict[@"message"]];
                [LLCFacilityHUD hudDismissedOnView:self.view];
                return;
            }else {
                NSArray * dataArray = dataDict[@"data"];
                for (NSDictionary * modelDict in dataArray) {
                    LLCMainModel * model = [[LLCMainModel alloc] init];
                    [model setValuesForKeysWithDictionary:modelDict];
                    [_dataArray addObject:model];
                }
                
            }
        }else {
            //服务器返回搜索无结果
            [self displayAlertWithMessage:@"没有该条件组成的菜"];
            [LLCFacilityHUD hudDismissedOnView:self.view];
            return;
        }
    }
    //若有结果,传递
    [self sentDataToSearchResultVCWithArray:_dataArray];
}
#pragma mark- 传递model数组到搜索结果页面
- (void) sentDataToSearchResultVCWithArray:(NSArray *)dataArray {
    
    DMPUniversalSearchResultVC * resultVC = [[DMPUniversalSearchResultVC alloc] initWithTitle:@"搜索结果" abstract:nil initDataArray:_dataArray searchType:DMPSearchTypeNormalSearch key:_keyArray];
    [self.navigationController pushViewController:resultVC animated:YES];
    [LLCFacilityHUD hudSuccessAppearOnView:self.view];
}

#pragma mark - 弹出警告框
- (void) displayAlertWithMessage:(NSString *)message {
    
    UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"温馨提示" message:message delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
    [alert show];
}

#pragma mark- tableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 5;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == _currentSelectedSection) {
          return 1;
    }else
        return 0;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:[self getDataKeyInDictWithIndexPath:indexPath]];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:[self getDataKeyInDictWithIndexPath:indexPath]];
        cell.backgroundColor = [UIColor clearColor];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        NSString * dicKey = [self getDataKeyInDictWithIndexPath:indexPath];
        BOOL isHidden;
        if ([dicKey isEqualToString:@"A"] || [dicKey isEqualToString:@"B"]) {
            isHidden = YES;
        }else
            isHidden = NO;
        DMPSearchTypeScrollView * scrollView = [[DMPSearchTypeScrollView alloc] initWithFrame:CGRectMake(0, 0, cell.bounds.size.width, 65) WithImageNames:_dataDict[dicKey] isTitleHidden:isHidden target:self action:@selector(scrollViewPressed:)];
        scrollView.tag = indexPath.section + 100;
        [cell addSubview:scrollView];
        }
//当删除了areaView中displayer时,对应scrollView中button被选择状态也要取消
    BOOL isFind = NO;
    for (DMPMetrialModel * model in _modelArray) {
        if (model.tag != indexPath.section) {
        }else {
            isFind = YES;
            break;
        }
    }
    if (isFind == NO) {
        DMPSearchTypeScrollView * scrollView =(DMPSearchTypeScrollView *)[cell viewWithTag:indexPath.section + 100];
        [scrollView resetBtnState];
    }
   

    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 40;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
   // if (indexPath.section == _currentSelectedSection) {
        return 75;
   // }
   // return 0;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    BOOL isSelected;
    if (section == _currentSelectedSection) {
        isSelected = YES;
    }else
        isSelected = NO;
    return [self createFoodHeaderViewForTableView:tableView WithTitle:@"test" isSelected:isSelected section:section];
}
- (UIView *)createFoodHeaderViewForTableView:(UITableView *)tableView
                                   WithTitle:(NSString *)title
                                  isSelected:(BOOL)isSelected
                                     section:(NSInteger)section {
    UIImageView * headerView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, tableView.bounds.size.width, 20)];
    headerView.tag = section;
    if (!isSelected) {
         headerView.image = [UIImage imageNamed:@"搜索-类别筛选"];
    }else
        headerView.image = [UIImage imageNamed:@"搜索-类别筛选-选"];
    UILabel * titleLabel = [[UILabel alloc] init];
    titleLabel.text = ((NSArray *)_dataDict[@"titles"])[section];
    titleLabel.font = [UIFont systemFontOfSize:16];
    if (section == _currentSelectedSection) {
        titleLabel.textColor = [UIColor brownColor];
    }
    [titleLabel sizeToFit];
    titleLabel.frame = CGRectMake(headerView.bounds.size.width/2 - titleLabel.frame.size.width/2, 10, titleLabel.bounds.size.width, titleLabel.bounds.size.height);
    [headerView addSubview:titleLabel];
    
    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(headerViewTap:)];
    [headerView addGestureRecognizer:tap];
    headerView.userInteractionEnabled = YES;
    return headerView;
}
#pragma mark- MetrialViewDelegate
- (NSInteger)numberOfDisplayerForDmpMetrialView:(DMPMetrialView *)metrialView {
    return _modelArray.count;
}
- (DMPSearchDisPlayView *)dmpMetrialView:(DMPMetrialView *)metrialView displayerAtIndex:(NSInteger)index {
    static NSString * displayerIde = @"displayer";
    DMPSearchDisPlayView * displayer = [metrialView dequeueDisplayerWithidentifier:displayerIde];
    if (!displayer) {
        displayer = [[[NSBundle mainBundle] loadNibNamed:@"DMPSearchDisPlayView" owner:self options:nil] lastObject];
        displayer.searchNameLabel.adjustsFontSizeToFitWidth = YES;
    }
    DMPMetrialModel * model = _modelArray[index];
    displayer.searchNameLabel.text = model.name;
    return displayer;
}

- (void)dmpMetrialView:(DMPMetrialView *)metrialView DeleteDisplayerAtIndex:(NSInteger)index {
    lastIndex = 99;
    lastSection = 99;
    [_modelArray removeObjectAtIndex:index];
    [metrialView reloadData];
    [_tableView reloadData];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
