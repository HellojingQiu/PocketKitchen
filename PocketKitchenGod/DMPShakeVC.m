//
//  DMPShakeVC.m
//  PocketKitchenGod
//
//  Created by Damon on 14-2-21.
//  Copyright (c) 2014年 yxx. All rights reserved.
//

#import "DMPShakeVC.h"
#import "DMPToolsManager.h"
#import "LLCFacilityHUD.h"
#import "DMPShakeResultView.h"
#import "LLCUserInfoManager.h"
#import "LLCMainModel.h"
#import "UIImageView+WebCache.h"
#import "LLCVideoViewController.h"
#import <AVFoundation/AVFoundation.h>
#import <AudioToolbox/AudioToolbox.h>
@interface DMPShakeVC () {
    DMPShakeResultView * _resultView;
    BOOL _isLoading;
}
@property (nonatomic, strong) LLCMainModel * model;
@property (nonatomic, strong) AVAudioPlayer * player;
@end

@implementation DMPShakeVC

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
/*Returns NO by default. If a responder object returns YES from this method, it becomes the first responder and can receive touch events and action messages. Subclasses must override this method to be able to become first responder.*/
-(BOOL)canBecomeFirstResponder {
    return YES;
}
-(void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    //当前vc设定为第一响应者
    [self becomeFirstResponder];
}
- (void)viewWillDisappear:(BOOL)animated {
    [self resignFirstResponder];
    [super viewWillDisappear:animated];
}
//摇晃前
- (void)motionBegan:(UIEventSubtype)motion withEvent:(UIEvent *)event {
    AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
    [self.player play];

}
//摇晃后
- (void)motionEnded:(UIEventSubtype)motion withEvent:(UIEvent *)event
{
    if (motion == UIEventSubtypeMotionShake) {
        if (!_isLoading) {
        [self getShakeData];
        }
    }
}
- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    [self dataInit];
    [self createUI];
}
- (void) dataInit {
    _isLoading = NO;
    [self prepAudio];
    
}

- (BOOL) prepAudio {
    NSString * path = [[NSBundle mainBundle] pathForResource:@"shake_sound_male" ofType:@"wav"];
    if (![[NSFileManager defaultManager] fileExistsAtPath:path] || !path) {
        return NO;
    }
    self.player = [[AVAudioPlayer alloc] initWithContentsOfURL:[NSURL fileURLWithPath:path] error:nil];
    [self.player prepareToPlay];
    [self.player setNumberOfLoops:0];
    return YES;
}
- (void) createUI {
    UIImageView * bgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, [[DMPToolsManager shareToolsManager] getFitHeightForOS], kScreenWidth, kScreenHeight - 64)];
    bgView.image = [UIImage imageNamed:@"摇一摇-背景"];
    [self.view addSubview:bgView];
   
    
    [self.dmpNavigationBar setDMPNaviBarTitleViewWithTitle:@"摇一摇" signImageName:@"摇一摇"];
    [self.dmpNavigationBar setDMPNaviBarTitleViewSignImageViewSize:CGSizeMake(45, 40)];
    
    _resultView = [[[NSBundle mainBundle] loadNibNamed:@"DMPShakeResultView" owner:self options:nil] lastObject];
    _resultView.frame = bgView.frame;
    _resultView.hidden = YES;
    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(resultViewPress:)];
    [_resultView addGestureRecognizer:tap];
    [self.view addSubview:_resultView];
}
#pragma mark- 点击响应
- (void) resultViewPress:(UITapGestureRecognizer *)recognize {
    LLCVideoViewController *vVC = [[LLCVideoViewController alloc] init];
    vVC.currentIndex = 0;
    [vVC loadSingleFoodWithVegetableID:self.model.vegetable_id];
    [self.navigationController pushViewController:vVC animated:YES];
}
//获取一道菜的数据
- (void) getShakeData {
    [LLCFacilityHUD hudLoadingAppearOnView:self.view];
    _isLoading = YES;
    _resultView.hidden = YES;
   
    [DMPHttpRequest requestWithUrlString:[NSString stringWithFormat:kShake,@"16681"] isRefresh:YES delegate:self tag:1];
}

#pragma mark- HttpRequestDelegate
- (void)dmpHttpRequestDidFinished:(DMPHttpRequest *)request {
    if (request.downloadData) {
        id result = [NSJSONSerialization JSONObjectWithData:request.downloadData options:NSJSONReadingMutableContainers error:nil];
        
        if ([result isKindOfClass:[NSDictionary class]]) {
            NSDictionary * dic = result;
            NSArray * dataArray = dic[@"data"];
            for (NSDictionary * dict in dataArray) {
                LLCMainModel * model = [[LLCMainModel alloc] init];
                [model setValuesForKeysWithDictionary:dict];
                self.model = model;
            }
        }
    }
    [self resultDisplay];
    [LLCFacilityHUD hudSuccessAppearOnView:self.view];
}
- (void)dmpHttpRequest:(DMPHttpRequest *)request DidFailWithError:(NSError *)error {
    [LLCFacilityHUD hudFailAppearOnView:self.view];
}
- (void) resultDisplay {
    _isLoading = NO;
    [_resultView.imgView setImageWithURL:[NSURL URLWithString:self.model.imagePathLandscape] placeholderImage:[UIImage imageNamed:@"defaultImage"]];
    _resultView.titleLabel.text = self.model.name;
    _resultView.pingYinLabel.text = self.model.englishName;
    _resultView.hidden = NO;
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
