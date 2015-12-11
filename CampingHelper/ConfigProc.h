//
//  ConfigProc.h
//  CampingHelper
//
//  Created by Han Sohn on 12-2-1.
//  Copyright (c) 2012年 Han.zh. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ConfigProc : NSObject

+(NSString*) documentPath:(NSString*)str;
+(void) initialize;

//是否显示帮助内容
+(Boolean) isShowFlashlight_help1;
+(Boolean) isShowFlashlight_help2;
+(Boolean) isShowFlashlight_help3;
+(Boolean) isShowCompass_help1;
+(Boolean) isShowMosi_help1;
+(Boolean) isShowTimeflash_help1;
+(Boolean) isShowRepellent_help1;

//功能保存
+(Boolean) isFlashlight_automation;
+(Boolean) isTimeflash_cycle;

//设定功能保存参数
+(void) setFlashlightAutomation:(Boolean)b;
+(void) setTimeflashCycle:(Boolean)b;

//设定参数
+(void) setTimingInterval:(float)f;
+(void) setTimingDelay:(float)f;

//获取参数
+(float) getTimingInterval;
+(float) getTimingDelay;
@end
