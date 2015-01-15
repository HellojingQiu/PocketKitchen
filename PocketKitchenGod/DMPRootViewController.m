//
//  DMPRootViewController.m
//  PocketKitchenGod
//
//  Created by Damon's on 14-2-16.
//  Copyright (c) 2014年 yxx. All rights reserved.
//

#import "DMPRootViewController.h"
#import "DMPToolsManager.h"

#define NaviBarHeight 44
@interface DMPRootViewController ()

@end

@implementation DMPRootViewController

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
  self.navigationController.navigationBarHidden = YES;
}
- (void)viewDidLoad
{
  [super viewDidLoad];
  self.view.backgroundColor = [UIColor blackColor];
  self.automaticallyAdjustsScrollViewInsets = NO;
  
  [self createNaviBar];
}
- (void) createNaviBar {
  NSInteger height = 0;
  if (kIsIOS7) {
    height = 20;
  }
  self.dmpNavigationBar = [[DMPNavigationBar alloc] initWithFrame:CGRectMake(0, height, kScreenWidth, NaviBarHeight)];
  [self.view addSubview:self.dmpNavigationBar];
  NSDictionary * dict = [[DMPToolsManager shareToolsManager] getRespondingDictionaryWithControllerClass:[DMPRootViewController class]];
  [self.dmpNavigationBar setDmpBackgroundImage:[UIImage imageNamed:dict[@"bgImageNameForNavi"]]];
  [self.dmpNavigationBar setDmpDivisionImage:[UIImage imageNamed:dict[@"ImageNameForDivision"]]];
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
