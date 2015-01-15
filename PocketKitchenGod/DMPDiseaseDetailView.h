//
//  DMPDiseaseDetailView.h
//  PocketKitchenGod
//
//  Created by Damon's on 14-2-18.
//  Copyright (c) 2014年 yxx. All rights reserved.
//

#import <UIKit/UIKit.h>
//展示疾病详情的View
@interface DMPDiseaseDetailView : UIView
@property (weak, nonatomic) IBOutlet UIButton *DiseaseCloseBtn;
@property (weak, nonatomic) IBOutlet UILabel *DiseaseTitleLabel;
@property (weak, nonatomic) IBOutlet UIScrollView *DiseaseScrollView;
@property (weak, nonatomic) IBOutlet UILabel *diseaseIntroLabel;
@property (weak, nonatomic) IBOutlet UILabel *diseaseFitEatLabel;
@property (weak, nonatomic) IBOutlet UILabel *diseaseLifeSuitLabel;
@property (weak, nonatomic) IBOutlet UILabel *diseaseTopTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *diseaseMidTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *diseaseBottomTitleLabel;

- (void) resizeViewWithTextWithTitleText:(NSString *)titleText
                                                  introText:(NSString *)introText
                                                 fitEatText:(NSString *)fitEatText
                                              lifeSuitText:(NSString *)lifeSuitText;
@end
