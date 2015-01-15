//
//  DMPDiseaseDetailView.m
//  PocketKitchenGod
//
//  Created by Damon's on 14-2-18.
//  Copyright (c) 2014年 yxx. All rights reserved.
//

#import "DMPDiseaseDetailView.h"
#define distanceV 8
@implementation DMPDiseaseDetailView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void) resizeViewWithTextWithTitleText:(NSString *)titleText
                               introText:(NSString *)introText
                              fitEatText:(NSString *)fitEatText
                            lifeSuitText:(NSString *)lifeSuitText {
    
    self.DiseaseTitleLabel.text = titleText;
    self.diseaseIntroLabel.text = introText;
    self.diseaseFitEatLabel.text = fitEatText;
    self.diseaseLifeSuitLabel.text = lifeSuitText;
    
    for (int i = 1; i < 4; i ++) {
        UILabel * titleLabel = (UILabel *)[self viewWithTag:i + 100];
        UILabel * contentLabel = (UILabel *)[self viewWithTag:i + 200];
        [contentLabel sizeToFit];
        if (i != 1) {
            //2,3小标题
            UIView * contentLabel = [self viewWithTag:i + 200 - 1];
            CGRect frame = titleLabel.frame;
            frame.origin.x = 12;
            frame.origin.y = contentLabel.frame.origin.y + contentLabel.frame.size.height + distanceV;
            titleLabel.frame = frame;
        }else {
            //第一个小标题
            CGRect frame = titleLabel.frame;
            frame.origin.x = 12;
            frame.origin.y = distanceV;
            titleLabel.frame = frame;
        }
        CGRect frame = contentLabel.frame;
        frame.origin.x = 41;
        frame.origin.y = titleLabel.frame.origin.y + titleLabel.frame.size.height + distanceV;
        contentLabel.frame = frame;
        if (i == 3) {
            //根据最后一个contentLabel来调整scrollview的size
            CGSize size = self.DiseaseScrollView.contentSize;
            size.width = self.DiseaseScrollView.frame.size.width;
            size.height = contentLabel.frame.origin.y + contentLabel.frame.size.height + distanceV;
            self.DiseaseScrollView.contentSize = size;
        }
    }
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
