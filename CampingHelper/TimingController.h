//
//  TimingController.h
//  CampingHelper
//
//  Created by Han Sohn on 12-2-20.
//  Copyright (c) 2012年 Han.zh. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Flashlight.h"

@interface TimingController : UIViewController<FlashlightDelegate>
{
    short m_rChangeAttr;
    boolean_t m_bKeybDisplay;
    boolean_t m_bIsRun;
    boolean_t m_bIsCycle;
    
    //是否已经闪过一次,在点击闪光开始时复位
    boolean_t m_bCycleRepeat;
    
    IBOutlet UIButton* m_ckbRun;
    IBOutlet UIButton* m_ckbCycle;
    
    //时间
    float m_fDisplaySec;
    float m_fIntervalSec;
    float m_fDelaySec;
    IBOutlet UILabel* m_lbDisplaySec;
    IBOutlet UILabel* m_lbIntervalSec;
    IBOutlet UILabel* m_lbDelaySec;
    
    //进度
    IBOutlet UIImageView* m_imgDisplayProcess;
    CGRect m_rcDisplayProcess;
    
    //键盘
    IBOutlet UIView* m_keyb;
    IBOutlet UILabel* m_lbKeybValue;
    NSMutableString* m_sKeybValue;
    
    NSTimer* m_timer;
    //计时器
    unsigned long m_dwTime1,m_dwTime2;
}

@property (nonatomic,retain) Flashlight* pFlashlight;

-(IBAction) btnBack_click:(id)sender;
-(IBAction) btnBeybDisplay_click:(id)sender;
-(IBAction) ckbRun_click:(id)sender;
-(IBAction) ckbCycle_click:(id)sender;
-(void) setRunState:(boolean_t)b;
-(void) setCycleState:(boolean_t)b;


-(void) keyb_display:(boolean_t)b;
-(IBAction) btnKeyB_click:(id)sender;

//计算显示值
-(void) caculDisplayValue;

-(void)performTransitionUp:(UIView *)viw;
-(void)performTransitionDown:(UIView *)viw;

- (void) handleTimer: (NSTimer *) timer;
@end
