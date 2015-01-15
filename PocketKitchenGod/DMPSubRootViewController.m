    //
//  DMPSubRootViewController.m
//  PocketKitchenGod
//
//  Created by Damon's on 14-2-18.
//  Copyright (c) 2014年 yxx. All rights reserved.
//

#import "DMPSubRootViewController.h"
#import "DMPToolsManager.h"
#import "UIButton+KitButton.h"
@interface DMPSubRootViewController ()

@end

@implementation DMPSubRootViewController

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
    [self subRootNaviBarInit];
}
- (void) subRootNaviBarInit {
    NSDictionary * dict = [[DMPToolsManager shareToolsManager] getRespondingDictionaryWithControllerClass:[DMPSubRootViewController class]];
    dict = dict[@"LeftItemsForNavi"];
    NSArray * imageName = dict[@"ImageName"];
    NSArray * imageNameH = dict[@"ImageNameH"];
    _backBtn = [UIButton createKitButtonWithBackgroundImageNameForNormal:imageName[0] highlight:imageNameH[0] bottomTitle:nil];
    [_backBtn addTarget:self action:@selector(backBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [self.dmpNavigationBar setDMPNaviBarItemsWithArray:@[_backBtn] isLeft:YES];
}

- (void) backBtnClick {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
