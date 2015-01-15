//
//  LLCGodFoodCell.h
//  只能选材
//
//  Created by yxx on 14-2-19.
//  Copyright (c) 2014年 yxx. All rights reserved.
//

#import <UIKit/UIKit.h>

/** 智能选菜tableView的cell */
@interface LLCGodFoodCell : UITableViewCell

/** 左侧图片 */
@property (weak, nonatomic) IBOutlet UIImageView *pictureLeft;
/** 右侧图片 */
@property (weak, nonatomic) IBOutlet UIImageView *pictureRight;
/** 左侧标题 */
@property (weak, nonatomic) IBOutlet UILabel *titleLeft;
/** 右侧标题 */
@property (weak, nonatomic) IBOutlet UILabel *titleRight;
/** 左侧背景 */
@property (weak, nonatomic) IBOutlet UIImageView *backgroundImageViewLeft;
/** 右侧背景 */
@property (weak, nonatomic) IBOutlet UIImageView *backgroundImageViewRight;

@end
