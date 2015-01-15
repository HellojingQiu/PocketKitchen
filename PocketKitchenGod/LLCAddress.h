//
//  LLCAddress.h
//  PocketKitchenGod
//
//  Created by yxx on 14-2-16.
//  Copyright (c) 2014年 yxx. All rights reserved.
//

#ifndef PocketKitchenGod_LLCAddress_h
#define PocketKitchenGod_LLCAddress_h

#define kHost_And_Port @"http://112.124.32.151:8080"

// 主界面
#define kMain_Url kHost_And_Port@"/HandheldKitchen/api/more/tblcalendaralertinfo!getHomePage.do?phonetype=2&page=%d&pageRecord=8&user_id=%@&is_traditional=0"

//// 主界面日期 (传值: year/month/day)
#define kMainDate_Url kHost_And_Port@"/HandheldKitchen/api/more/tblcalendaralertinfo!get.do?year=%@&month=%@&day=%@&page=1&pageRecord=10&is_traditional=0"

#pragma mark - 对症食疗
// 对症食疗第一层
#define kTblo_First_Url kHost_And_Port@"/HandheldKitchen/api/vegetable/tbloffice!getOffice.do?is_traditional=0"
// 对症食疗第二层 (传值: oficeid)
#define kTblo_Second_Url kHost_And_Port@"/HandheldKitchen/api/vegetable/tbldisease!getDisease.do?officeId=%@&is_traditional=0"
// 对症食疗第三层 (传值: diseaseId)
#define kTblo_Third_Url kHost_And_Port@"/HandheldKitchen/api/vegetable/tbldisease!getVegetable.do?diseaseId=%@&page=%d&pageRecord=8&phonetype=0&is_traditional=0"
#pragma mark - 视频
// 视频首页 (传值: vegetable_id/user_id)
#define kTblo_Video kHost_And_Port@"/HandheldKitchen/api/vegetable/tblvegetable!getTblVegetables.do?vegetable_id=%@&phonetype=2&user_id=%@&is_traditional=0"
// 视频->材料 (传值: vegetable_id/type)
#define kTblo_Video_Material kHost_And_Port@"/HandheldKitchen/api/vegetable/tblvegetable!getIntelligentChoice.do?vegetable_id=%@&type=%d&phonetype=0&is_traditional=0"
// 视频->材料准备 (传值: 菜名+A)
#define kTblo_Video_Prepare_MP4 @"http://121.40.31.5:280/upload/mp4/caixinshaobaiheA.mp4"
// 视频->制作过程 (传值: 菜名+B)
#define kTblo_Video_CookMethod_MP4 @"http://121.40.31.5:280/upload/mp4/caixinshaobaiheB.mp4"

#pragma mark - 智能选材/搜索
// 智能选材->搜索 (传值: material_id 字符串拼接如256,555,475,263,512,264/page/user_id)
#define kBrainpower_Search kHost_And_Port@"/HandheldKitchen/api/vegetable/tblvegetable!getChooseFood.do?material_id=%@&page=%d&pageRecord=90000&phonetype=0&user_id=%@&is_traditional=0"
// 搜索 (传值: child_catalog_name需UTF8编码/page/user_id)
#define kSearch kHost_And_Port@"/HandheldKitchen/api/vegetable/tblvegetable!getVegetableInfo.do?name=%@&child_catalog_name=%@&taste=%@&fitting_crowd=%@&cooking_method=%@&effect=%@&page=%d&pageRecord=10&phonetype=0&user_id=%@&is_traditional=0"

#pragma mark - 热门推荐
// 最新推出 (传值: page/user_id)
#define kNewTblVegetable kHost_And_Port@"/HandheldKitchen/api/vegetable/tblvegetable!getNewTblVegetable.do?page=%d&pageRecord=8&phonetype=0&user_id=%@&is_traditional=0"
// 最受欢迎 (传值: page/user_id)
#define kHotTblVegetable kHost_And_Port@"/HandheldKitchen/api/vegetable/tblvegetable!getHotTblVegetable.do?page=%d&pageRecord=8&phonetype=0&user_id=%@&is_traditional=0"

#pragma mark - 二月菜单
// 二月菜单 (传值: year/month/page/user_id)
#define kMonthMenu kHost_And_Port@"/HandheldKitchen/api/more/tblmonthlypopinfo!get.do?year=%@&month=%@&page=%d&phonetype=0&pageRecord=8&user_id=%@&is_traditional=0"

#pragma mark - 注册/登陆
// 注册 (传值: username/password/email)
#define kRegister kHost_And_Port@"/HandheldKitchen/api/users/tbluser!register.do?username=%@&password=%@&email=%@&is_traditional=0"
// 登陆 (传值: email/password)
#define kLogin kHost_And_Port"/HandheldKitchen/api/users/tbluser!login.do?email=%@&password=%@&is_traditional=0"

#pragma mark - 万道美食任你选

// tabBar参数
#define kCategories_Url kHost_And_Port@"/HandheldKitchen/api/vegetable/tblvegetablecatalog!get.do?page=1&pageRecord=8&phonetype=2&is_traditional=0"
// 万道美食任你选 (传值: page/user_id)
#define kDelicious_Food kHost_And_Port@"/HandheldKitchen/api/vegetable/tblvegetable!getInfo.do?catalog_id=&page=%d&pageRecord=8&phonetype=0&user_id=%@&is_traditional=0"

// 万道美食任你选tabBar点选 (传值: catalog_id/page/user_id)
#define kKeepHealthy kHost_And_Port@"/HandheldKitchen/api/vegetable/tblvegetable!getInfo.do?catalog_id=%@&page=%d&pageRecord=8&phonetype=0&user_id=%@&is_traditional=0"

#define kRecord_Plist_Path [NSHomeDirectory() stringByAppendingFormat:@"/Documents/RecordList.plist"]
#define kStorePlist_Path [NSHomeDirectory() stringByAppendingFormat:@"/Documents/StorePlist.plist"]
#pragma mark - 摇一摇
// 摇一摇 (传值: user_id)
#define kShake @"http://42.121.13.106:8080/HandheldKitchen/api/vegetable/tblrandomvegetable!get.do?count=1&user_id=%@&phonetype=2&is_traditional=0"

#endif
