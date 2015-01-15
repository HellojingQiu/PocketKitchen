//
//  LLCMateMaterialCell.h
//  PocketKitchenGod
//
//  Created by yxx on 14-2-17.
//  Copyright (c) 2014年 yxx. All rights reserved.
//

#import <UIKit/UIKit.h>

/** 配料cell */
@interface LLCMateMaterialCell : UITableViewCell

/** 图片 */
@property (weak, nonatomic) IBOutlet UIImageView *pictureView;
/** 标题 */
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@end
