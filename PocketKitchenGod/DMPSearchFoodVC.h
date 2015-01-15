//
//  DMPSearchFoodVC.h
//  PocketKitchenGod
//
//  Created by Damon's on 14-2-18.
//  Copyright (c) 2014年 yxx. All rights reserved.
//

#import "DMPSubRootViewController.h"
#import "DMPMetrialView.h"
#import "DMPHttpRequest.h"
//搜索VC类
@interface DMPSearchFoodVC : DMPSubRootViewController<UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate,DMPMetrialViewDelegate,DMPHttpRequestDelegate>

@end
