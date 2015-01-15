//
//  LLCCookMethodCell.h
//  PocketKitchenGod
//
//  Created by yxx on 14-2-17.
//  Copyright (c) 2014年 yxx. All rights reserved.
//

#import <UIKit/UIKit.h>

/** 做法cell */
@interface LLCCookMethodCell : UITableViewCell

/** 图片 */
@property (weak, nonatomic) IBOutlet UIImageView *pictureView;
/** 步骤 */
@property (weak, nonatomic) IBOutlet UILabel *stepLabel;
/** 内容 */
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;

@end
