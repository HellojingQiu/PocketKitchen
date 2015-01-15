//
//  DMPDiseaseDetailIIVC.h
//  PocketKitchenGod
//
//  Created by Damon's on 14-2-18.
//  Copyright (c) 2014年 yxx. All rights reserved.
//


#import "DMPSubRootViewController.h"
#import "DMPTwoTwoView.h"
#import "DMPHttpRequest.h"
//疾病详情VC类
@class DMPDiseaseModel;
@interface DMPDiseaseDetailIIVC : DMPSubRootViewController<DMPTwoTwoViewDelegate,DMPHttpRequestDelegate>
@property (nonatomic, strong) DMPDiseaseModel * model;
@end
