//
//  DMPSearchDisPlayView.h
//  PocketKitchenGod
//
//  Created by Damon's on 14-2-19.
//  Copyright (c) 2014年 yxx. All rights reserved.
//

#import <UIKit/UIKit.h>
//displayer类
@interface DMPSearchDisPlayView : UIView
@property (weak, nonatomic) IBOutlet UIImageView *searchBgView;
@property (weak, nonatomic) IBOutlet UILabel *searchNameLabel;
@property (weak, nonatomic) IBOutlet UIButton *searchCloseBtn;
@property (nonatomic, assign) NSInteger tag;

@end
