//
//  Flashlight.h
//  Flashlight
//
//  Created by Han Sohn on 11-12-23.
//  Copyright (c) 2011年 Han.zh. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>

/*********** demo *************
 
 Flashlight* m_flashlight;
 m_flashlight=[[Flashlight alloc] init];
 //检测是是否能用闪光灯
 [m_flashlight checkDev];
 
 //打开闪光灯
 [m_flashlight turnOn];
 
 //关闭闪光灯
 [m_flashlight turnOff];
 [m_flashlight release];
 
 */
@protocol FlashlightDelegate <NSObject>
@optional
-(void) FlashlightStatusChange:(boolean_t)status;
@end

@interface Flashlight : NSObject<UIApplicationDelegate>{
    AVCaptureSession *torchSession;
}

@property (nonatomic, assign) id<FlashlightDelegate> delegate;
@property (nonatomic, retain) AVCaptureSession * torchSession;

//判断闪光灯是否已经打开
@property (nonatomic, assign) boolean_t bLightStatus;

-(NSString*) documentPath:(NSString*)str;
-(void) setInitAutoOpen:(boolean_t)isOpen;
-(Boolean) isCheckingAutoOpen;
-(void) turnOn;
-(void) turnOff;
-(Boolean) checkDev;
@end
