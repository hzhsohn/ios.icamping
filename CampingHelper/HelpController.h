//
//  HelpController.h
//  CampingHelper
//
//  Created by Han Sohn on 12-2-12.
//  Copyright (c) 2012年 Han.zh. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Flashlight.h"

@interface HelpController : UIViewController<FlashlightDelegate>{
    NSTimer *m_timer;
    int m_nTimeProc;
    BOOL m_isOpenFlash;
    boolean_t m_bSOS_On;
    IBOutlet UIButton* m_ckbRun;
    IBOutlet UIImageView* m_imgScreen;
    IBOutlet UIImageView* m_imgScreen_0;
    IBOutlet UIImageView* m_imgScreen_1;
    
    ////////////
    IBOutlet UIImageView* m_imgViwPeople3;
    unsigned long m_people3_time;
    BOOL m_people3_ani;
}
@property (nonatomic,retain) Flashlight* pFlashlight;

-(IBAction) btnBack_click:(id)sender;
-(IBAction) ckbSOS_click:(id)sender;

- (void) handleTimer: (NSTimer *) timer;

/////// SOS信号处理 //////
-(void) TimeProcAdd;
-(void) closeFlash;
-(void) dealayFlash:(BOOL)isLong;
-(void) resetTimeProcDone;
-(void) resetTimeProc;
-(void) SOSFlashlight;

@end
