//
//  LLCMaterialCell.h
//  PocketKitchenGod
//
//  Created by yxx on 14-2-17.
//  Copyright (c) 2014年 yxx. All rights reserved.
//

#import <UIKit/UIKit.h>

/** "材料"cell */
@interface LLCMaterialCell : UITableViewCell

/** 材料 */
@property (weak, nonatomic) IBOutlet UILabel *materiaLabel;
/** 配料 */
@property (weak, nonatomic) IBOutlet UILabel *mateMateriaLabel;
/** 图片 */
@property (weak, nonatomic) IBOutlet UIImageView *pictureView;
/** 原料名 */
@property (weak, nonatomic) IBOutlet UILabel *subTitleLabel;
/** 背景 */
@property (weak, nonatomic) IBOutlet UIImageView *tempBackView;

@end
