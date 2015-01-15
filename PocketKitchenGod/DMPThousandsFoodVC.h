//
//  DMPThousandsFoodVC.h
//  PocketKitchenGod
//
//  Created by Damon's on 14-2-20.
//  Copyright (c) 2014年 yxx. All rights reserved.
//

#import "DMPSubRootViewController.h"
#import "DMPTwoTwoView.h"
#import "DMPHttpRequest.h"
@interface DMPThousandsFoodVC : DMPSubRootViewController<DMPTwoTwoViewDelegate,DMPHttpRequestDelegate>

@property (nonatomic, strong) UILabel *bigLabel;
@property (nonatomic, strong) UILabel *smallLabel;

@end
