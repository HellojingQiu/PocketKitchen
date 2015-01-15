//
//  DMPRootViewController.h
//  PocketKitchenGod
//
//  Created by Damon's on 14-2-16.
//  Copyright (c) 2014年 yxx. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DMPNavigationBar.h"


@interface DMPRootViewController : UIViewController
//带有导航条的父类
@property (nonatomic, strong) DMPNavigationBar * dmpNavigationBar;  //导航栏

@end
