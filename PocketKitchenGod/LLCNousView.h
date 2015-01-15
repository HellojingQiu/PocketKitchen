//
//  LLCNousView.h
//  PocketKitchenGod
//
//  Created by yxx on 14-2-17.
//  Copyright (c) 2014年 yxx. All rights reserved.
//

#import <UIKit/UIKit.h>

/** 相关常识 */
@interface LLCNousView : UIView

/** 展示图片 */
@property (weak, nonatomic) IBOutlet UIImageView *pictureView;
/** 除单独字外其他的字 */
@property (weak, nonatomic) IBOutlet UILabel *moveLabel;
/** 单独大字 */
@property (weak, nonatomic) IBOutlet UILabel *bigSingleLabel;
/** "制作过程"标签 */
@property (weak, nonatomic) IBOutlet UILabel *cookGuideLabel;
/** 制作过程内容 */
@property (weak, nonatomic) IBOutlet UILabel *guideContentLabel;
/** 分隔线 */
@property (weak, nonatomic) IBOutlet UIImageView *lineImageView;

@end
