//
//  LLCFoodIntroduceView.h
//  PocketKitchenGod
//
//  Created by yxx on 14-2-17.
//  Copyright (c) 2014年 yxx. All rights reserved.
//

#import <UIKit/UIKit.h>

/** 视频界面上面对食物介绍的View */
@interface LLCFoodIntroduceView : UIView

/** 食物名字 */
@property (weak, nonatomic) IBOutlet UILabel *foodNameLabel;
/** 食物名字的拼音 */
@property (weak, nonatomic) IBOutlet UILabel *foodPinYinNameLabel;
/** 烹饪时长 */
@property (weak, nonatomic) IBOutlet UILabel *cookTimeLength;
/** 口味 */
@property (weak, nonatomic) IBOutlet UILabel *tastLabel;
/** 烹饪方法 */
@property (weak, nonatomic) IBOutlet UILabel *cookMethodLabel;
/** 功效 */
@property (weak, nonatomic) IBOutlet UILabel *effectLabel;
/** 适合人群 */
@property (weak, nonatomic) IBOutlet UILabel *fittingPeopleLabel;
/** 红色标签 */
@property (weak, nonatomic) IBOutlet UIImageView *redLabelView;
/** 免费 */
@property (weak, nonatomic) IBOutlet UILabel *freeLabel;
/** 购买 */
@property (weak, nonatomic) IBOutlet UILabel *purchaseLabel;

@end
