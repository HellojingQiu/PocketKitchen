//
//  DMPDietTherapyVC.m
//  PocketKitchenGod
//
//  Created by Damon on 14-2-17.
//  Copyright (c) 2014年 yxx. All rights reserved.
//

#import "DMPDietTherapyVC.h"
#import "DMPDiseaseDetailIIVC.h"
#import "DMPSubjectModel.h"
#import "DMPDiseaseModel.h"
#import "DMPMenuViewCell.h"
#import "DMPToolsManager.h"
#import "UIButton+KitButton.h"
#import "UIImageView+WebCache.h"
#import "LLCFacilityHUD.h"

#define dMainMenuRequest 101
#define dSubMenuRequest 102
#define dMenuCellHeight 66

#define kBanView_Tag 412
@interface DMPDietTherapyVC ()
{
    DMPNetMenuView * _menu;             //两级菜单
    NSMutableArray * _subjectsArray;    //主科数组
    NSInteger _currentRowInMain;         //当前row在主菜单
    NSUInteger _currentRowInSub;        //当前row在子菜单
    BOOL _isDoubleFirstInit;                    //是否为两级菜单第一次
    BOOL _isDoubleWorkingState;          //是否两级菜单处于展开状态
    BOOL _isMainDataInitOK;                 //是否主菜单数据初始化完成,若子菜单提前获取,主菜单无数据,则用主科类添加疾病类造成数组越界
}

@end

@implementation DMPDietTherapyVC
const int oficeid = 3; // url关键字

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
    [self naviInit];
   
    [self menuInit];
    [self dataInit];
	// Do any additional setup after loading the view.
}
- (void) dataInit {
    _currentRowInMain = -1;
    _currentRowInSub = -1;
    _subjectsArray = [[NSMutableArray alloc] init];
    _isDoubleFirstInit = NO;
    _isDoubleWorkingState = NO;
    _isMainDataInitOK = NO;
    
    [self getMainData];
}
//导航栏初始化
- (void) naviInit {
    NSDictionary * dict = [[DMPToolsManager shareToolsManager] getRespondingDictionaryWithController:self];
    [self naviTitleViewInit];
   NSDictionary * subDict = dict[@"LeftItemsForNavi"];
    NSArray * imagesName = subDict[@"ImageName"];
    NSArray * imagesNameH = subDict[@"ImageNameH"];
    _backBtn = [UIButton createKitButtonWithBackgroundImageNameForNormal:imagesName[0] highlight:imagesNameH[0] bottomTitle:nil];
    [_backBtn addTarget:self action:@selector(backPressed) forControlEvents:UIControlEventTouchUpInside];
    [self.dmpNavigationBar setDMPNaviBarItemsWithArray:@[_backBtn] isLeft:YES];
}
//导航栏titleVIew初始化
- (void) naviTitleViewInit {
    NSDictionary * dict = [[DMPToolsManager shareToolsManager] getRespondingDictionaryWithController:self];
    NSDictionary * subDict = dict[@"TitleView"];
    [self.dmpNavigationBar setDMPNaviBarTitleViewWithTitle:subDict[@"title"] signImageName:subDict[@"signImageName"]];
}
#pragma mark-  菜单初始化
- (void) menuInit {
    NSInteger height = 0;
    if (kIsIOS7) {
        height = 64;
    }
    _menu = [[DMPNetMenuView alloc] initWithFrame:CGRectMake(0,height,self.view.bounds.size.width,kScreenHeight - 64)];
    _menu.dmpDelegate = self;
    [self.view addSubview:_menu];
    
}
#pragma mark- 响应事件
- (void) backPressed {
    [self.navigationController popViewControllerAnimated:YES];
}
- (void) backPressedWhenDouble {
    [self naviTitleViewInit];
    _isDoubleWorkingState = NO;
    [_menu menuFold];
    [_menu mainMenuReload];
  //  [self performSelector:@selector(turnOffDoubleWorkingState) withObject:nil afterDelay:0.2];
    [_backBtn removeTarget:self action:@selector(backPressedWhenDouble) forControlEvents:UIControlEventTouchUpInside];
    [_backBtn addTarget:self action:@selector(backPressed) forControlEvents:UIControlEventTouchUpInside];
}
#pragma push疾病详情页面
- (void) pushToDetaiViewControllerWithModel:(DMPDiseaseModel *)model {
    DMPDiseaseDetailIIVC * detailVC = [[DMPDiseaseDetailIIVC alloc] init];
    detailVC.model = model;
    [self.navigationController pushViewController:detailVC animated:YES];
}
#pragma mark- MenuDelegate
//此代理通过
- (NSInteger)numberOfRowsForMenuTableView:(DMPMenuTableView *)menu menuView:(DMPNetMenuView *)menuView {
    if (!_subjectsArray.count)
        return 0;
    if (menu.tag == DMPMenuMainTableView) {
        return _subjectsArray.count;
    }else if(_currentRowInMain >= 0){
        DMPSubjectModel * subject = _subjectsArray[_currentRowInMain];
        return subject.diseaseArray.count;
    }
    return 0;
}
- (UITableViewCell *)dmpMenuTableView:(DMPMenuTableView *)mainMenu cellForRowAtIndexPath:(NSIndexPath *)indexPath menuView:menuView {
    
    static NSString * cellIde = @"cell";
    DMPMenuViewCell * cell = [mainMenu dequeueReusableCellWithIdentifier:cellIde];
    if (!cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"DMPMenuViewCell"
                                              owner:self
                                            options:nil] lastObject];
        UIImageView * sbgImageView = [[UIImageView alloc] initWithFrame:cell.bounds];
        NSString * ImageName;
        if(mainMenu.tag == DMPMenuMainTableView)
            ImageName = @"科室选中";
        else
            ImageName = @"疾病选中";
        
        sbgImageView.image = [UIImage imageNamed:ImageName];
        cell.selectedBackgroundView = sbgImageView;
    }
        cell.imgView.alpha = 1;
        cell.lineImgView.alpha = 1;
        cell.mainLabel.textColor = [UIColor blackColor];
    
        if (mainMenu.tag == DMPMenuMainTableView) {
            DMPSubjectModel * subject = _subjectsArray[indexPath.row];
            cell.mainLabel.text = subject.officeName;
            cell.subLabel.text = [NSString stringWithFormat:@"%@...",subject.diseaseNames];
            [cell.imgView setImageWithURL:[NSURL URLWithString:subject.imagePath]];
            //默认 subLabel,mainLabel alpha为1 imgView,lineImgView 为0
            
            if (_isDoubleWorkingState) {
                if (_currentRowInMain != indexPath.row) {
                     cell.mainLabel.textColor = [UIColor grayColor];
                }else
                    cell.mainLabel.textColor = [UIColor brownColor];
               
                //是在菜单二级层工作状态
                if (_isDoubleFirstInit) {
                    //是在第一次的变换过程
                    [UIView animateWithDuration:0.2f animations:^{
                        cell.subLabel.alpha = 0;
                        cell.lineImgView.alpha = 0;
                        cell.imgView.alpha = 0;
                    }];
                }else {
                    //变换后,cell内的设置,不加动画直接为0
                    cell.subLabel.alpha = 0;
                    cell.lineImgView.alpha = 0;
                    cell.imgView.alpha = 0;
                }
            }
        }else {
            //子菜单
            if (_currentRowInSub != indexPath.row) {
                cell.mainLabel.textColor = [UIColor grayColor];
            }else
                cell.mainLabel.textColor = [UIColor brownColor];
            
            DMPSubjectModel * subject = _subjectsArray[_currentRowInMain];
            DMPDiseaseModel * model = subject.diseaseArray[indexPath.row];
            cell.mainLabel.text = model.diseaseName;
            cell.mainLabel.frame = CGRectMake(84,18,216,21);
            cell.imgView.bounds = CGRectMake(0, 0, 40, 40);
            [cell.imgView setImageWithURL:[NSURL URLWithString:model.imageName] placeholderImage:[UIImage imageNamed:@"缺省背景图"]];
        }
    return cell;
}
- (CGFloat)dmpMenuTableView:(DMPMenuTableView *)menu heightForRowAtIndexPath:(NSIndexPath *)indexPath menuView:(DMPNetMenuView *)menuView {
    //一样高
    return dMenuCellHeight;
}
-(void)dmpMenuView:(DMPNetMenuView *)menuView dmpMenuTableView:(DMPMenuTableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
     [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (tableView.tag == DMPMenuMainTableView ) {
        //主菜单点击响应
        //展开第一次
       
        
        if (!_isDoubleWorkingState) {
            [_backBtn removeTarget:self action:@selector(backPressed) forControlEvents:UIControlEventTouchUpInside];
            [_backBtn addTarget:self action:@selector(backPressedWhenDouble) forControlEvents:UIControlEventTouchUpInside];
            _isDoubleWorkingState = YES;
            _isDoubleFirstInit = YES;
            [self performSelector:@selector(doubleInitOver) withObject:nil afterDelay:0.5];
            [menuView mainMenuReload];
        }
      
        if (_currentRowInMain != indexPath.row) {
            _currentRowInMain = indexPath.row;
            [menuView mainMenuReload];
             [self getSubMenuDataWithRow:_currentRowInMain];
        }
        //替换导航栏标题
        DMPSubjectModel * subject = _subjectsArray[_currentRowInMain];
        [self.dmpNavigationBar setDMPNaviBarTitleViewWithTitle:subject.officeName signImageName:nil];
        
    }else if(tableView.tag == DMPMenuSubTableView){
        //子菜单点击响应
        _currentRowInSub = indexPath.row;
        [menuView subMenuReload];
        DMPSubjectModel * subject = _subjectsArray[_currentRowInMain];
        if (subject.diseaseArray.count) {
            DMPDiseaseModel * model = subject.diseaseArray[_currentRowInSub];
            [self pushToDetaiViewControllerWithModel:model];
        }
    }
}
- (void) doubleInitOver {
    _isDoubleFirstInit = NO;
}
- (void) turnOffDoubleWorkingState {
    _isDoubleWorkingState = NO;
}
#pragma mark- DMPHttpRequestDelegate
- (void)dmpHttpRequestDidFinished:(DMPHttpRequest *)request {
    if(request.downloadData) {
        id result = [NSJSONSerialization JSONObjectWithData:request.downloadData options:NSJSONReadingMutableContainers error:nil];
        if ([result isKindOfClass:[NSDictionary class]]) {
            NSDictionary * dic = result;
            NSArray * array = dic[@"data"];
            for (NSDictionary * dataDict in array) {
                
                if (request.tag == dMainMenuRequest) {
                    DMPSubjectModel * subject = [[DMPSubjectModel alloc] init];
                    [subject setValuesForKeysWithDictionary:dataDict];
                    [_subjectsArray addObject:subject];
//                    if (!_isMainDataInitOK) {
//                        [self performSelector:@selector(subMenuRequestInit) withObject:nil];
//                        _isMainDataInitOK = YES;
//                    }
                }else if(request.tag == dSubMenuRequest) {
                    DMPDiseaseModel * disease = [[DMPDiseaseModel alloc] init];
                    [disease setValuesForKeysWithDictionary:dataDict];
                    DMPSubjectModel * subject = _subjectsArray[_currentRowInMain];
                    [subject addDiseaseModel:disease];
                }
            }
            [LLCFacilityHUD hudSuccessAppearOnView:self.view];
        }
    
    }
    if (request.tag == dMainMenuRequest) {
        [_menu mainMenuReload];
    }else
        [_menu subMenuReload];
  
}

- (void)dmpHttpRequest:(DMPHttpRequest *)request DidFailWithError:(NSError *)error {
    [LLCFacilityHUD hudFailAppearOnView:self.view];
}

#pragma mark 获取数据
- (void) getMainData {
    [LLCFacilityHUD hudLoadingAppearOnView:self.view];
    [DMPHttpRequest requestWithUrlString:kTblo_First_Url isRefresh:NO delegate:self tag:dMainMenuRequest];
}
- (void) getSubMenuDataWithRow:(NSUInteger)row {
    [LLCFacilityHUD hudLoadingAppearOnView:self.view];
    NSString * key = [NSString stringWithFormat:@"%d",row + oficeid];
    [DMPHttpRequest requestWithUrlString:[NSString stringWithFormat:kTblo_Second_Url,key] isRefresh:YES delegate:self tag:dSubMenuRequest];
    _currentRowInSub = -1;
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
