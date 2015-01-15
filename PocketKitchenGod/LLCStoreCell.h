//
//  LLCStoreCell.h
//  PocketKitchenGod
//
//  Created by yxx on 14-2-21.
//  Copyright (c) 2014年 yxx. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LLCMainModel.h"

/** "我的收藏"cell */
@interface LLCStoreCell : UITableViewCell

/** 左侧图片 */
@property (weak, nonatomic) IBOutlet UIImageView *pictureImageViewLeft;
/** 右侧图片 */
@property (weak, nonatomic) IBOutlet UIImageView *pictureImageViewRight;

/** 食材名 */
@property (weak, nonatomic) IBOutlet UILabel *nameLabelLeft;
@property (weak, nonatomic) IBOutlet UILabel *nameLabelRight;
/** 收藏日期 */
@property (weak, nonatomic) IBOutlet UILabel *dateLabelLeft;
@property (weak, nonatomic) IBOutlet UILabel *dateLabelRight;
/** 免费标签 */
@property (weak, nonatomic) IBOutlet UILabel *freeLabelLeft;
@property (weak, nonatomic) IBOutlet UILabel *freeLabelRight;
/** 红条 */
@property (weak, nonatomic) IBOutlet UIImageView *redViewLeft;

/** 删除层 */
@property (weak, nonatomic) IBOutlet UIImageView *shadowViewLeft;
@property (weak, nonatomic) IBOutlet UIImageView *shadowViewRight;
@property (weak, nonatomic) IBOutlet UIImageView *redViewRight;

@end
