//
//  LLCHeaderButton.h
//  标签栏
//
//  Created by yxx on 14-2-17.
//  Copyright (c) 2014年 yxx. All rights reserved.
//

#import <UIKit/UIKit.h>

/** 视频界面的tabBar上的按钮 */
@interface LLCHeaderButton : UIView

/** 按钮 */
@property (weak, nonatomic) IBOutlet UIButton *headerButton;
/** 标题 */
@property (weak, nonatomic) IBOutlet UILabel *headerLabel;

@end
