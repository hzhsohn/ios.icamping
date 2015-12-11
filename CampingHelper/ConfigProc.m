//
//  ConfigProc.m
//  CampingHelper
//
//  Created by Han Sohn on 12-2-1.
//  Copyright (c) 2012年 Han.zh. All rights reserved.
//

#import "ConfigProc.h"

@implementation ConfigProc

#define CONFIG_FILE     @"config.plist"

+(NSString*) documentPath:(NSString*)str
{
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	NSString *documentsDirectory = [paths objectAtIndex:0];
	
	if (nil!=str) {
		return [NSString stringWithFormat:@"%@/%@",documentsDirectory,str];
	}
	return [NSString stringWithFormat:@"%@",documentsDirectory];
}

+(void) initialize
{
    ////////////////////////////////
    //第一:读取documents路径的方法：
    NSString *configFile = [self documentPath:CONFIG_FILE]; 
    NSMutableDictionary *configList =[[NSMutableDictionary alloc] initWithContentsOfFile:configFile];  //初始化字典，读取配置文件的信息
    
    //第二:写入文件
    if (!configList) {
        //第一次，文件没有创建，因此要创建文件，并写入相应的初始值。
        configList = [[NSMutableDictionary alloc] initWithObjectsAndKeys: 
                      @"true",  @"flashlight_help1",
                      @"true",  @"flashlight_help2",
                      @"true",  @"flashlight_help3",
                      @"true",  @"compass_help1",
                      @"true",  @"mosi_help1",
                      @"true",  @"timeflash_help1",
                      @"true",  @"repellent_help1",
                      @"false",  @"flashlight_automation",
                      @"true",  @"timeflash_cycle",
                      @"0.2",@"timeing_interval",
                      @"0.3",@"timeing_delay",
                      nil];
        [configList writeToFile:configFile atomically:YES];
        [configList release];
    }
}

//是否显示帮助内容
+(Boolean) isShowFlashlight_help1
{
    NSString *configFile = [self documentPath:CONFIG_FILE]; 
    NSMutableDictionary *configList =[[NSMutableDictionary alloc] 
                                      initWithContentsOfFile:configFile];
    if (configList) {
        NSString *v  = [configList objectForKey:@"flashlight_help1"];
        if ([v isEqualToString:@"true"]) {
            return YES;
        }
    }
    return NO;
}
+(Boolean) isShowFlashlight_help2
{
    NSString *configFile = [self documentPath:CONFIG_FILE]; 
    NSMutableDictionary *configList =[[NSMutableDictionary alloc] 
                                      initWithContentsOfFile:configFile];
    if (configList) {
        NSString *v  = [configList objectForKey:@"flashlight_help2"];
        if ([v isEqualToString:@"true"]) {
            return YES;
        }
    }
    return NO;
}
+(Boolean) isShowFlashlight_help3
{
    NSString *configFile = [self documentPath:CONFIG_FILE]; 
    NSMutableDictionary *configList =[[NSMutableDictionary alloc] 
                                      initWithContentsOfFile:configFile];
    if (configList) {
        NSString *v  = [configList objectForKey:@"flashlight_help3"];
        if ([v isEqualToString:@"true"]) {
            return YES;
        }
    }
    return NO;
}
+(Boolean) isShowCompass_help1
{
    NSString *configFile = [self documentPath:CONFIG_FILE]; 
    NSMutableDictionary *configList =[[NSMutableDictionary alloc] 
                                      initWithContentsOfFile:configFile];
    if (configList) {
        NSString *v  = [configList objectForKey:@"compass_help1"];
        if ([v isEqualToString:@"true"]) {
            return YES;
        }
    }
    return NO;
}
+(Boolean) isShowMosi_help1
{
    NSString *configFile = [self documentPath:CONFIG_FILE]; 
    NSMutableDictionary *configList =[[NSMutableDictionary alloc] 
                                      initWithContentsOfFile:configFile];
    if (configList) {
        NSString *v  = [configList objectForKey:@"mosi_help1"];
        if ([v isEqualToString:@"true"]) {
            return YES;
        }
    }
    return NO;
}
+(Boolean) isShowTimeflash_help1
{
    NSString *configFile = [self documentPath:CONFIG_FILE]; 
    NSMutableDictionary *configList =[[NSMutableDictionary alloc] 
                                      initWithContentsOfFile:configFile];
    if (configList) {
        NSString *v  = [configList objectForKey:@"timeflash_help1"];
        if ([v isEqualToString:@"true"]) {
            return YES;
        }
    }
    return NO;
}
+(Boolean) isShowRepellent_help1
{
    NSString *configFile = [self documentPath:CONFIG_FILE]; 
    NSMutableDictionary *configList =[[NSMutableDictionary alloc] 
                                      initWithContentsOfFile:configFile];
    if (configList) {
        NSString *v  = [configList objectForKey:@"repellent_help1"];
        if ([v isEqualToString:@"true"]) {
            return YES;
        }
    }
    return NO;
}

//功能保存
+(Boolean) isFlashlight_automation
{
    NSString *configFile = [self documentPath:CONFIG_FILE]; 
    NSMutableDictionary *configList =[[NSMutableDictionary alloc] 
                                      initWithContentsOfFile:configFile];
    if (configList) {
        NSString *v  = [configList objectForKey:@"flashlight_automation"];
        if ([v isEqualToString:@"true"]) {
            return YES;
        }
    }
    return NO;
}
+(Boolean) isTimeflash_cycle
{
    NSString *configFile = [self documentPath:CONFIG_FILE]; 
    NSMutableDictionary *configList =[[NSMutableDictionary alloc] 
                                      initWithContentsOfFile:configFile];
    if (configList) {
        NSString *v  = [configList objectForKey:@"timeflash_cycle"];
        if ([v isEqualToString:@"true"]) {
            return YES;
        }
    }
    return NO;
}

//设定功能保存参数
+(void) setFlashlightAutomation:(Boolean)b
{
    NSString *configFile = [self documentPath:CONFIG_FILE]; 
    NSMutableDictionary *configList =[[NSMutableDictionary alloc] 
                                      initWithContentsOfFile:configFile];

    if (configList) {
        if (b) {
            [configList setValue:@"true" forKey:@"flashlight_automation"];
        }
        else
        {
            [configList setValue:@"false" forKey:@"flashlight_automation"];
        }
        [configList writeToFile:configFile atomically:YES];
        [configList release];
    }
}
+(void) setTimeflashCycle:(Boolean)b
{
    NSString *configFile = [self documentPath:CONFIG_FILE]; 
    NSMutableDictionary *configList =[[NSMutableDictionary alloc] 
                                      initWithContentsOfFile:configFile];  

    if (configList) {
        if (b) {
            [configList setValue:@"true" forKey:@"timeflash_cycle"];
        }
        else
        {
            [configList setValue:@"false" forKey:@"timeflash_cycle"];
        }
        [configList writeToFile:configFile atomically:YES];
        [configList release];
    }
}

//设定参数
+(void) setTimingInterval:(float)f
{
    NSString *configFile = [self documentPath:CONFIG_FILE]; 
    NSMutableDictionary *configList =[[NSMutableDictionary alloc] 
                                      initWithContentsOfFile:configFile];  
    
    if (configList) {
            [configList setValue:[NSString stringWithFormat:@"%f",f] forKey:@"timeing_interval"];
        [configList writeToFile:configFile atomically:YES];
        [configList release];
    }
}

+(void) setTimingDelay:(float)f
{
    NSString *configFile = [self documentPath:CONFIG_FILE]; 
    NSMutableDictionary *configList =[[NSMutableDictionary alloc] 
                                      initWithContentsOfFile:configFile];  
    
    if (configList) {
        [configList setValue:[NSString stringWithFormat:@"%f",f] forKey:@"timeing_delay"];
        [configList writeToFile:configFile atomically:YES];
        [configList release];
    }
}

//获取参数
+(float) getTimingInterval
{
    float f;
    NSString *configFile = [self documentPath:CONFIG_FILE]; 
    NSMutableDictionary *configList =[[NSMutableDictionary alloc] 
                                      initWithContentsOfFile:configFile];
    if (configList) {
        NSString *v  = [configList objectForKey:@"timeing_interval"];
        f=[v floatValue];
        return f;
    }
    return 0;
}

+(float) getTimingDelay
{
    float f;
    NSString *configFile = [self documentPath:CONFIG_FILE]; 
    NSMutableDictionary *configList =[[NSMutableDictionary alloc] 
                                      initWithContentsOfFile:configFile];
    if (configList) {
        NSString *v  = [configList objectForKey:@"timeing_delay"];
        f=[v floatValue];
        return f;
    }
    return 0;
}

@end
