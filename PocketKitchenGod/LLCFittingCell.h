//
//  LLCFittingCell.h
//  PocketKitchenGod
//
//  Created by yxx on 14-2-17.
//  Copyright (c) 2014年 yxx. All rights reserved.
//

#import <UIKit/UIKit.h>

/** "相宜相克"cell */
@interface LLCFittingCell : UITableViewCell

/** 标题 */
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
/** 图片 */
@property (weak, nonatomic) IBOutlet UIImageView *pictureView;
/** 拼音 */
@property (weak, nonatomic) IBOutlet UILabel *englishLabe;
/** 背景 */
@property (weak, nonatomic) IBOutlet UIView *labelBackgroundView;
/** 显示相宜或者相克 */
@property (weak, nonatomic) IBOutlet UILabel *isFittingLabel;


@end
