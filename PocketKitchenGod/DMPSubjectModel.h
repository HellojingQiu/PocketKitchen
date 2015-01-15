//
//  DMPSubjectModel.h
//  PocketKitchenGod
//
//  Created by Damon's on 14-2-17.
//  Copyright (c) 2014年 yxx. All rights reserved.
//

#import <Foundation/Foundation.h>
@class DMPDiseaseModel;
@interface DMPSubjectModel : NSObject
@property (nonatomic, copy) NSString * officeName;
@property (nonatomic, copy) NSString * officeId;
@property (nonatomic, copy) NSString * imageSelPath;
@property (nonatomic, copy) NSString * imagePath;
@property (nonatomic, copy) NSString * diseaseNames;
@property (nonatomic, strong) NSMutableArray * diseaseArray;

- (void) addDiseaseModel:(DMPDiseaseModel *)model;
@end
