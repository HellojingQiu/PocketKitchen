//
//  LLCDateIntroduceView.h
//  PocketKitchenGod
//
//  Created by yxx on 14-2-17.
//  Copyright (c) 2014年 yxx. All rights reserved.
//

#import <UIKit/UIKit.h>

/** 主界面的日期介绍View */
@interface LLCDateIntroduceView : UIView

/** 状态 */
@property (weak, nonatomic) IBOutlet UIImageView *statusLabel;
/** 日 */
@property (weak, nonatomic) IBOutlet UILabel *ddLabel;
/** 年月 */
@property (weak, nonatomic) IBOutlet UILabel *yyMMLabel;
/** 农历 */
@property (weak, nonatomic) IBOutlet UILabel *oldDateLabel;
/** 展示本日宜、忌内容 */
@property (weak, nonatomic) IBOutlet UIScrollView *moveScrollView
;
/** 食物名 */
@property (weak, nonatomic) IBOutlet UILabel *foodNameLabel;
/** 食物名拼音 */
@property (weak, nonatomic) IBOutlet UILabel *foodPinYinName;

/** 忌的内容 */
@property (nonatomic, copy) NSString *avoidContent;
/** 宜的内容 */
@property (nonatomic, copy) NSString *fittingContent;

/** 宜、忌内容开始滚动 */
- (void)lanuchContent;
/** 重置内容 */
- (void)resetContent;

@end
