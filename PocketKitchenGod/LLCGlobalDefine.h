//
//  LLCGlobalDefine.h
//  LLCUtility
//
//  Created by yxx on 14-1-5.
//  Copyright (c) 2014年 yxx. All rights reserved.
//

/** 常用宏 **/
#ifndef LLCUtility_LLCGlobalDefine_h
#define LLCUtility_LLCGlobalDefine_h

/** 判断设备系统是否是iOS7 */
#define kIsIOS7 [[[UIDevice currentDevice] systemVersion] hasPrefix:@"7"] ? YES : NO
/** 获取设备系统版本号 */
#define kDeviceVersion [[UIDevice currentDevice] systemVersion]

/** 获取 appDelegate */
#define kAppDelegate  [[UIApplication sharedApplication] delegate]
/** 获取 application */
#define kApplication [UIApplication sharedApplication]
#define kColorWithRGBA(r,g,b,a) [UIColor colorWithRed:r/255. green:g/255. blue:b/255. alpha:a]
/** 获取设备model */
#define kDevice_Model [[UIDevice currentDevice] model]
#define kColorWithRGBA(r,g,b,a) [UIColor colorWithRed:r/255. green:g/255. blue:b/255. alpha:a]
/** Debug Log */
#define kObjDebugLog(__Variable__, __Value__) \
NSLog(@"\n----------------------\n%s:[line: %d]\n%@ = %@\n----------------------",\
__func__, __LINE__, __Variable__, __Value__);
#define kIntDebugLog(__Variable__, __Value__) \
NSLog(@"\n----------------------\n%s:[line: %d]\n%@ = %d\n----------------------",\
__func__, __LINE__, __Variable__, __Value__);
#define kFloatDebugLog(__Variable__, __Value__) \
NSLog(@"\n----------------------\n%s:[line: %d]\n%@ = %f\n----------------------",\
__func__, __LINE__, __Variable__, __Value__);

#define kDeallocDebugLog(__ClassName__) \
NSLog(@"\n----------------------\n%@: dealloc\n----------------------",\
__ClassName__);

/** 屏幕尺寸 */
#define kScreenHeight [UIScreen mainScreen].bounds.size.height
#define kScreenWidth [UIScreen mainScreen].bounds.size.width

/** 内存管理 */
#if ! __has_feature(objc_arc) // Non-ARC
  #define LLCAutorelease(__v) ([__v autorelease]);
  #define LLCReturnAutoreleased LLCAutorelease

  #define LLCRetain(__v) ([__v retain]);
  #define LLCReturnRetained FMDBRetain

  #define LLCRelease(__v) if (__v != nil) {\
                              [__v release];\
                              __v = nil;\
                          } else {\
                              __v = nil;\
                          }

  #define LLCDispatchQueueRelease(__v) (dispatch_release(__v));
#else // ARC
  #define LLCAutorelease(__v)
  #define LLCReturnAutoreleased(__v) (__v)

  #define LLCRetain(__v)
  #define LLCReturnRetained(__v) (__v)

  #define LLCRelease(__v)
#endif

#endif
