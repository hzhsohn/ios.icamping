//
//  MosquitoController.h
//  CampingHelper
//
//  Created by Han Sohn on 12-2-21.
//  Copyright (c) 2012年 Han.zh. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MosquitoController : UIViewController
{
    IBOutlet UIButton* m_ckbRun;

    IBOutlet UIImageView* m_imgBBB1;
    IBOutlet UIImageView* m_imgBBB2;
    IBOutlet UIImageView* m_imgBBB3;
    short m_rBBBstate;
    
    IBOutlet UILabel* m_lbTiming1;
    IBOutlet UILabel* m_lbTiming2;
    IBOutlet UILabel* m_lbTiming3;
    
    NSTimer* m_timer;
    boolean_t m_bRun;
    
    //计时器
    //是否取用定时停止
    boolean_t m_bUseTiming;
    unsigned long m_dwTime1,m_dwTime2,m_dwTimeTmp;
    //当这个数为0的时候就会关闭驱蚊器
    int m_nTimingMilliSec;
    short m_rTimingType;
    
    //动画时间效果初始变量;
    unsigned long m_dwPhoneAniTime;
}

-(IBAction) btnBack_click:(id)sender;
-(IBAction) btnRun_click:(id)sender;
-(void) setStart:(boolean_t)b;
-(void) setRunState:(boolean_t)b;

-(IBAction) btnTiming1_click:(id)sender;
-(IBAction) btnTiming2_click:(id)sender;
-(IBAction) btnTiming3_click:(id)sender;

//将毫秒转时时间格式20:00这样
-(NSString*)transTime:(int)ms;

-(void) handleTimer: (NSTimer *) timer;

//手机电波动画
-(void) phoneAnimation:(boolean_t) b;
@end
