//
//  DMPFoodCell.h
//  PocketKitchenGod
//
//  Created by Damon's on 14-2-18.
//  Copyright (c) 2014年 yxx. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DMPFoodCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *foodImgView;
@property (weak, nonatomic) IBOutlet UIImageView *foodEdgeView;
@property (weak, nonatomic) IBOutlet UIImageView *foodTypeView;
@property (weak, nonatomic) IBOutlet UIImageView *ClickCountView;
@property (weak, nonatomic) IBOutlet UILabel *foodFavourteNumLabel;
@property (weak, nonatomic) IBOutlet UIImageView *foodCollectImgView;
@property (weak, nonatomic) IBOutlet UILabel *foodNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *freeLabel;


- (void)foodCellSetAllImgViewAppear;
@end
