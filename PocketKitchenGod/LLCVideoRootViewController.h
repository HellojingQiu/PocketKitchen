//
//  LLCVideoRootViewController.h
//  PocketKitchenGod
//
//  Created by yxx on 14-2-17.
//  Copyright (c) 2014年 yxx. All rights reserved.
//

#import "DMPSubIIRootViewController.h"
#import "QFTableView.h"

/** 视频界面父类 */
@interface LLCVideoRootViewController :DMPSubRootViewController
<QFTableViewDataSource,
QFTableViewDelegate>
{
   QFTableView       *_tableView;
}
@end
