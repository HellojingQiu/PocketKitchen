//
//  DMPQRViewController.m
//  PocketKitchenGod
//
//  Created by Damon on 14-2-23.
//  Copyright (c) 2014年 yxx. All rights reserved.
//

#import "DMPQRViewController.h"
#import "DMPNavigationBar.h"
#import "DMPToolsManager.h"
#import "DMPRootViewController.h"
#import "DMPSubRootViewController.h"
#import "UIButton+KitButton.h"



#define blackColor [UIColor blackColor]
#define bgAlpha 0.7
#define NaviBarHeight 44
@interface DMPQRViewController ()
{
    UIImageView * _scanLine;
    UIImageView * _kuangView;
}


@end

@implementation DMPQRViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self createKuang];
    [self createBgViews];
    [self createIntroLabel];
    [self createTorchBtn];
    [self createNaviBar];
    [self scanLineStartAnimation];
}
- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
}
//创建框图
- (void) createKuang {
    //AVCaptureVideoPreviewLayer
    // HAS_AVFF 在模拟器下,这宏为0,访问不了prevLayer属性,需要连接真机编译才能通过
//#if !TARGET_IPHONE_SIMULATOR
//#define HAS_AVFF 1
//#endif
    //若当前为模拟器,下面代码不编译
#if HAS_AVFF
    self.prevLayer.frame = CGRectMake(0, 20, kScreenWidth, kScreenHeight - 20);
#endif
    _kuangView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"scanKuang"]];
    _kuangView.bounds = CGRectMake(0, 0, 305, 305);
    _kuangView.center = CGPointMake(kScreenWidth/2, kScreenHeight/2);
    [self.view addSubview:_kuangView];
    
    _scanLine  =[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"scanLine"]];
    _scanLine.frame = CGRectMake(_kuangView.frame.origin.x , _kuangView.frame.origin.y + 5, _kuangView.bounds.size.width, 4);
    [self.view addSubview:_scanLine];
    
}
//创建背景
- (void)createBgViews {
    NSInteger height = [[DMPToolsManager shareToolsManager] getFitHeightForOS];
    UIView * bgViewA = [[UIView alloc] initWithFrame:CGRectMake(0, height, kScreenWidth, _kuangView.frame.origin.y - height)];
    bgViewA.backgroundColor = blackColor;
    bgViewA.alpha = bgAlpha;
    UIView * bgViewB = [[UIView alloc] initWithFrame:CGRectMake(0, height + bgViewA.frame.size.height, (kScreenWidth - _kuangView.frame.size.width)/2, _kuangView.frame.size.height)];
    bgViewB.backgroundColor = blackColor;
    bgViewB.alpha = bgAlpha;
    UIView * bgViewC = [[UIView alloc] initWithFrame:CGRectMake(_kuangView.frame.origin.x + _kuangView.frame.size.width, height + bgViewA.frame.size.height, bgViewB.bounds.size.width, bgViewB.bounds.size.height)];
    bgViewC.backgroundColor = blackColor;
    bgViewC.alpha = bgAlpha;
    UIView * bgViewD = [[UIView alloc] initWithFrame:CGRectMake(0, bgViewA.frame.size.height + bgViewB.frame.size.height + height, kScreenWidth, kScreenHeight - bgViewA.frame.size.height - bgViewB.frame.size.height - 64)];
    bgViewD.backgroundColor = blackColor;
    bgViewD.alpha = bgAlpha;
    [self.view addSubview:bgViewA];
    [self.view addSubview:bgViewB];
    [self.view addSubview:bgViewC];
    [self.view addSubview:bgViewD];
}
//创建Label
- (void) createIntroLabel {
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0,220, 40)];
    label.text = @"讲二维码图案放在取景框内即可自动扫描";
    label.font = [UIFont systemFontOfSize:15];
    label.textAlignment = NSTextAlignmentCenter;
    label.textColor = [UIColor colorWithWhite:0.95 alpha:1.0];
    label.numberOfLines = 2;
    label.center = CGPointMake(kScreenWidth/2, kScreenHeight/2 + _kuangView.bounds.size.height/2 + 20);
    [self.view addSubview:label];
}
//创建NaviBar
- (void) createNaviBar {
    NSInteger height = 0;
    if (kIsIOS7) {
        height = 20;
    }
    self.dmpNavigationBar = [[DMPNavigationBar alloc] initWithFrame:CGRectMake(0, height, kScreenWidth,NaviBarHeight)];
    [self.view addSubview:self.dmpNavigationBar];
    NSDictionary * dict = [[DMPToolsManager shareToolsManager] getRespondingDictionaryWithControllerClass:[DMPRootViewController class]];
    [self.dmpNavigationBar setDmpBackgroundImage:[UIImage imageNamed:dict[@"bgImageNameForNavi"]]];
    [self.dmpNavigationBar setDmpDivisionImage:[UIImage imageNamed:dict[@"ImageNameForDivision"]]];
    
    dict = [[DMPToolsManager shareToolsManager] getRespondingDictionaryWithControllerClass:[DMPSubRootViewController class]];
    dict = dict[@"LeftItemsForNavi"];
    NSArray * imageName = dict[@"ImageName"];
    NSArray * imageNameH = dict[@"ImageNameH"];
    UIButton * _backBtn = [UIButton createKitButtonWithBackgroundImageNameForNormal:imageName[0] highlight:imageNameH[0] bottomTitle:nil];
    [_backBtn addTarget:self action:@selector(backBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [self.dmpNavigationBar setDMPNaviBarItemsWithArray:@[_backBtn] isLeft:YES];
    
    [self.dmpNavigationBar setDMPNaviBarTitleViewWithTitle:@"二维码" signImageName:@"二维码"];
    [self.dmpNavigationBar setDMPNaviBarTitleViewSignImageViewSize:CGSizeMake(35, 30)];
    

    UIButton * moreButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [moreButton setTitle:@". . ." forState:UIControlStateNormal];
    [moreButton setTitleColor:[UIColor colorWithWhite:0.9 alpha:1] forState:UIControlStateNormal];
    moreButton.bounds = CGRectMake(0, 0, 41, 33);
    moreButton.titleLabel.font = [UIFont boldSystemFontOfSize:23];
    [moreButton addTarget:self action:@selector(moreBtnPress) forControlEvents:UIControlEventTouchUpInside];
    [self.dmpNavigationBar setDMPNaviBarItemsWithArray:@[moreButton] isLeft:NO];
}
- (void) createTorchBtn {
    UIButton * torchBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    torchBtn.bounds = CGRectMake(0, 0, 50, 30);
    NSInteger height = 0;
    if (kIsIOS7) {
        height = 20;
    }
    torchBtn.center = CGPointMake(kScreenWidth/2,height + 44 + 35);
    [torchBtn setBackgroundImage:[UIImage imageNamed:@"FlashOff1"] forState:UIControlStateNormal];
    [torchBtn setBackgroundImage:[UIImage imageNamed:@"FlashOn1"] forState:UIControlStateSelected];
    torchBtn.bounds = CGRectMake(0, 0,38,38);
    [torchBtn addTarget:self action:@selector(torchBtnPress:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:torchBtn];

}
//开始动画
- (void) scanLineStartAnimation {
    [UIView animateKeyframesWithDuration:2.0f delay:0 options:UIViewKeyframeAnimationOptionAutoreverse |UIViewKeyframeAnimationOptionRepeat animations:^{
        _scanLine.frame = CGRectOffset(_scanLine.frame, 0, _kuangView.bounds.size.height - 20);
    } completion:nil];

}
#pragma mark- 点击响应
- (void) backBtnClick {
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (void) moreBtnPress {

    UIActionSheet * actionSheet = [[UIActionSheet alloc] initWithTitle:@"" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:@"通过相册导入" otherButtonTitles:nil];
    [actionSheet showInView:self.view];
}
- (void) torchBtnPress:(UIButton *)btn {
    static BOOL torchState = NO;
    static BOOL btnState = NO;
    btnState = !btnState;
    torchState = !torchState;
    [self setTorch:torchState];
    [btn setSelected:btnState];
}
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (!buttonIndex) {
        UIImagePickerController * picker = [[UIImagePickerController alloc] init];
        picker.delegate = self;
        picker.allowsEditing = YES;
        picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        picker.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
        [self presentViewController:picker animated:YES completion:nil];
    }
}

#pragma mark- UIImagePickerDelegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    UIImage * image = info[UIImagePickerControllerEditedImage];
    [picker dismissViewControllerAnimated:NO completion:^{
        if ([self.dmpDelegate respondsToSelector:@selector(dmpQRViewController:didFinishPickingImage:)]) {
            [self.dmpDelegate dmpQRViewController:self didFinishPickingImage:image];
        }
    }];
}
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_7_0
- (UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleLightContent;
}

- (BOOL)prefersStatusBarHidden{
    return NO;
}
#endif
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
