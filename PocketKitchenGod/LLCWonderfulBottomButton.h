//
//  LLCWonderfulBottomButton.h
//  PocketKitchenGod
//
//  Created by yxx on 14-2-19.
//  Copyright (c) 2014年 yxx. All rights reserved.
//

#import <UIKit/UIKit.h>

/** 食材按钮 */
@interface LLCWonderfulBottomButton : UIView

/** 食材名 */
@property (weak, nonatomic) IBOutlet UILabel *bottomTitle;
/** 食材图片 */
@property (weak, nonatomic) IBOutlet UIImageView *bottomImage;
/** 食材真正的按钮! */
@property (weak, nonatomic) IBOutlet UIButton *bottonButton;

@end
