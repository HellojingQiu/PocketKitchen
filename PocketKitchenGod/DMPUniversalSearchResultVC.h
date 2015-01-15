//
//  DMPUniversalSearchResultVC.h
//  PocketKitchenGod
//
//  Created by Damon's on 14-2-21.
//  Copyright (c) 2014年 yxx. All rights reserved.
//

#import "DMPSubRootViewController.h"
#import "DMPHttpRequest.h"
#import "DMPTwoTwoView.h"

typedef enum{
    DMPSearchTypeAutoSearch,
    DMPSearchTypeNormalSearch
}DMPSearchType;
//为智能搜索和搜索封装通用的搜索VC类
@interface DMPUniversalSearchResultVC : DMPSubRootViewController<DMPTwoTwoViewDelegate,DMPHttpRequestDelegate>
/**
 初始化搜索VC的方法
 @param title 导航栏的标题
 @param abstrct 导航Label的text
 @param modelArray 第一次展现的数据模型数组
 @param type 搜索类型
 @param key 关键实例
 */
- (id)initWithTitle:(NSString *)title
           abstract:(NSString *)abstrct
      initDataArray:(NSArray *)modelArray
         searchType:(DMPSearchType)type
                key:(id)key;

@end
