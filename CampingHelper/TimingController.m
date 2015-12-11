//
//  TimingController.m
//  CampingHelper
//
//  Created by Han Sohn on 12-2-20.
//  Copyright (c) 2012年 Han.zh. All rights reserved.
//

#import "TimingController.h"
#import "ConfigProc.h"
#include "function.h"

@implementation TimingController
@synthesize pFlashlight;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        m_bKeybDisplay=false;
        m_sKeybValue=[[NSMutableString alloc] init];
        m_bIsRun=false;
        m_bIsCycle=false;
        
        m_timer = [NSTimer scheduledTimerWithTimeInterval: 0.01
                                                   target: self
                                                 selector: @selector(handleTimer:)
                                                 userInfo: nil
                                                  repeats: YES];
    }
    return self;
}

-(void) dealloc
{
    NSLog(@"TimingController dealloc");
    [m_sKeybValue release];
    m_sKeybValue=nil;
    
    if (pFlashlight) {
        pFlashlight.delegate=nil;
        [pFlashlight release];
        pFlashlight=nil;
    }
    
    [super dealloc];
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle
-(void) viewDidDisappear:(BOOL)animated
{
    //关闭闪光灯
    if (pFlashlight.bLightStatus) {
        if ([pFlashlight checkDev]) {
            [pFlashlight turnOff];
        }
    }
    [m_timer invalidate];
    m_timer = nil;
    [super viewDidDisappear:animated];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    //读取配置文件
    m_fIntervalSec=[ConfigProc getTimingInterval];
    m_fDelaySec=[ConfigProc getTimingDelay];
    m_lbIntervalSec.text=[NSString stringWithFormat:@"%0.1fs",m_fIntervalSec];
    m_lbDelaySec.text=[NSString stringWithFormat:@"%0.1fs",m_fDelaySec];
    [self caculDisplayValue];
    
    //
    m_bIsCycle=[ConfigProc isTimeflash_cycle];
    [self setCycleState:m_bIsCycle];
    //
    [self.view addSubview: m_keyb];
    [self keyb_display:m_bKeybDisplay];
    [m_sKeybValue setString:@""];
    //
    m_rcDisplayProcess=m_imgDisplayProcess.frame;
    
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
    m_ckbRun=nil;
    m_ckbCycle=nil;

    m_lbDisplaySec=nil;
    m_lbIntervalSec=nil;
    m_lbDelaySec=nil;

    m_imgDisplayProcess=nil;
    m_lbKeybValue=nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

-(BOOL)shouldAutorotate{
    return NO;
}

-(IBAction) btnBack_click:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

-(IBAction) btnBeybDisplay_click:(id)sender
{
    UIButton*btn=(UIButton*)sender;
    switch (btn.tag) {
        case 1:
            m_rChangeAttr=1;
            break;
        case 2:
            m_rChangeAttr=2;
            break;
    }
    m_bKeybDisplay=!m_bKeybDisplay;
    [self keyb_display:m_bKeybDisplay];
}

-(IBAction) ckbRun_click:(id)sender
{
    if ([pFlashlight checkDev])
    {
        m_bCycleRepeat=false;
        m_bIsRun=!m_bIsRun;
        [self setRunState:m_bIsRun];
        //如果是启动话
        if (m_bIsRun) {
            m_dwTime1=Sys_GetTime();
        }
    }
    else
    {
        //设备没有灯光
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"no_flashlight_dev",nil) 
                                                        message:nil delegate: self 
                                              cancelButtonTitle:NSLocalizedString(@"close",nil) 
                                              otherButtonTitles:nil];
        [alert show];
        [alert release];
    }
}

-(IBAction) ckbCycle_click:(id)sender
{
    m_bIsCycle=!m_bIsCycle;
    [ConfigProc setTimeflashCycle:m_bIsCycle];
    [self setCycleState:m_bIsCycle];
}

-(void) setRunState:(boolean_t)b
{
    if (b) {
        m_ckbRun.selected=true;
    }
    else
    {
        //关闭闪光灯
        if (pFlashlight.bLightStatus) {
            if ([pFlashlight checkDev]) {
                [pFlashlight turnOff];
            }
        }
        m_ckbRun.selected=false;
    }
}

-(void) setCycleState:(boolean_t)b
{
    if (b) {
        NSLog(@"设置效果:循环闪");
        m_ckbCycle.selected=true;
    }
    else
    {
        NSLog(@"设置效果:闪一次");
        m_ckbCycle.selected=false;
    }
}

-(IBAction) btnKeyB_click:(id)sender
{
    UIButton*btn=(UIButton*)sender;
    switch (btn.tag) {
        case 1:
            if ([m_sKeybValue isEqualToString:@"0"]) {
                [m_sKeybValue setString:@""];
            }
            [m_sKeybValue appendString:@"1"];
            break;
        case 2:
            if ([m_sKeybValue isEqualToString:@"0"]) {
                [m_sKeybValue setString:@""];
            }
            [m_sKeybValue appendString:@"2"];
            break;
        case 3:
            if ([m_sKeybValue isEqualToString:@"0"]) {
                [m_sKeybValue setString:@""];
            }
            [m_sKeybValue appendString:@"3"];
            break;
        case 4:
            if ([m_sKeybValue isEqualToString:@"0"]) {
                [m_sKeybValue setString:@""];
            }
            [m_sKeybValue appendString:@"4"];
            break;
        case 5:
            if ([m_sKeybValue isEqualToString:@"0"]) {
                [m_sKeybValue setString:@""];
            }
            [m_sKeybValue appendString:@"5"];
            break;
        case 6:
            if ([m_sKeybValue isEqualToString:@"0"]) {
                [m_sKeybValue setString:@""];
            }
            [m_sKeybValue appendString:@"6"];
            break;
        case 7:
            if ([m_sKeybValue isEqualToString:@"0"]) {
                [m_sKeybValue setString:@""];
            }
            [m_sKeybValue appendString:@"7"];
            break;
        case 8:
            if ([m_sKeybValue isEqualToString:@"0"]) {
                [m_sKeybValue setString:@""];
            }
            [m_sKeybValue appendString:@"8"];
            break;
        case 9:
            if ([m_sKeybValue isEqualToString:@"0"]) {
                [m_sKeybValue setString:@""];
            }
            [m_sKeybValue appendString:@"9"];
            break;
        case 10:
        {
            int n=[m_sKeybValue length]-1;
            if (n<=0) {
                n=0;
                [m_sKeybValue setString:@"0"];
            }
            else
            {
                [m_sKeybValue setString:[m_sKeybValue substringToIndex:n]];
            }
        }
            break;
        case 11:
            [m_sKeybValue appendString:@"."];
            break;
        case 12:
            if ([m_sKeybValue isEqualToString:@"0"]) {
                [m_sKeybValue setString:@""];
            }
            [m_sKeybValue appendString:@"0"];
            break;
        case 13:
        {
            //检测是否非0秒状态
            if ([m_sKeybValue floatValue]==0) {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil
                                                                message:NSLocalizedString(@"timing_value_alert",nil)
                                                               delegate:self
                                                      cancelButtonTitle:NSLocalizedString(@"ok",nil)
                                                      otherButtonTitles: nil];
                
                [alert show];
                [alert release];
                return;
            }
            //确定按钮
            switch (m_rChangeAttr) {
                case 1:
                    m_fIntervalSec=[m_sKeybValue floatValue];
                    //四舍五入
                    m_fIntervalSec+=0.05f;
                    m_fIntervalSec*=10;
                    m_fIntervalSec=(int)m_fIntervalSec;
                    m_fIntervalSec/=10;
                    
                    m_lbIntervalSec.text=[NSString stringWithFormat:@"%0.1fs",m_fIntervalSec];
                    
                    break;
                case 2:
                    m_fDelaySec=[m_sKeybValue floatValue];
                    //四舍五入
                    m_fDelaySec+=0.05f;
                    m_fDelaySec*=10;
                    m_fDelaySec=(int)m_fDelaySec;
                    m_fDelaySec/=10;
                    m_lbDelaySec.text=[NSString stringWithFormat:@"%0.1fs",m_fDelaySec];
                    break;
            }
            m_bKeybDisplay=!m_bKeybDisplay;
            [self keyb_display:m_bKeybDisplay];
            //重新计算显示值
            [self caculDisplayValue];
            
            //保存到配置文件
            [ConfigProc setTimingInterval:m_fIntervalSec];
            [ConfigProc setTimingDelay:m_fDelaySec];
        } 
            break;
    }
    m_lbKeybValue.text=m_sKeybValue;
}

-(void) keyb_display:(boolean_t)b
{
    switch (m_rChangeAttr) {
        case 1:
            //键盘显示
            if (m_fIntervalSec==0) {
                [m_sKeybValue setString:[NSString stringWithFormat:@"0"]];
            }
            else{
                [m_sKeybValue setString:[NSString stringWithFormat:@"%0.1f",m_fIntervalSec]];
            }
            
            m_lbKeybValue.text=m_sKeybValue;
            break;
        case 2:
            //键盘显示
            if (m_fDelaySec==0) {
                [m_sKeybValue setString:[NSString stringWithFormat:@"0"]];
            }
            else{
                [m_sKeybValue setString:[NSString stringWithFormat:@"%0.1f",m_fDelaySec]];
            }
            m_lbKeybValue.text=m_sKeybValue;
            break;
    }

    CGRect rx = [ UIScreen mainScreen ].bounds;
    if (b) {
        [self performTransitionUp:m_keyb];
        [m_keyb setFrame:CGRectMake(0, rx.size.height-m_keyb.frame.size.height, 
                                    m_keyb.frame.size.width, m_keyb.frame.size.height)];
    }
    else{
        [self performTransitionDown:m_keyb];
        [m_keyb setFrame:CGRectMake(0, rx.size.height, 
                                    m_keyb.frame.size.width, m_keyb.frame.size.height)];
    }
}

-(void) caculDisplayValue
{
    m_fDisplaySec=m_fIntervalSec+m_fDelaySec;
    [m_lbDisplaySec setText:[NSString stringWithFormat:@"%0.1fs",m_fDisplaySec]];
}

-(void)performTransitionUp:(UIView *)viw
{
    
	CATransition *transition = [CATransition animation];
	transition.duration = 0.25;
	transition.type = @"moveIn";
    transition.subtype = kCATransitionFromTop;
	[viw.layer addAnimation:transition forKey:nil];	
}
-(void)performTransitionDown:(UIView *)viw
{
    
	CATransition *transition = [CATransition animation];
	transition.duration = 0.25;
	transition.type = @"reveal";
    transition.subtype = kCATransitionFromBottom;
	[viw.layer addAnimation:transition forKey:nil];	
}

-(void) FlashlightStatusChange:(boolean_t)status
{
    //闪光灯状态被修改
}

- (void) handleTimer: (NSTimer *) timer
{
    /////////////////////////////
    //闪光灯处理
    if (m_bIsRun) {
        m_dwTime2=Sys_GetTime();
        //开始打开闪光灯
        if (m_dwTime2-m_dwTime1>(m_fIntervalSec*1000)) {
            if (!pFlashlight.bLightStatus) {
                if ([pFlashlight checkDev]) {
                    [pFlashlight turnOn];
                }
            }
        }
        //时间段内只执行一次
        if (m_dwTime2-m_dwTime1>(m_fDisplaySec*1000)) {
            //循环闪
            if (m_bIsCycle || false==m_bCycleRepeat) 
            {
                NSLog(@"我闪啊闪啊闪闪闪..");
                if (m_bIsCycle) {
                    m_dwTime1=Sys_GetTime();
                }
            }
            //单次闪
            else if(!m_bIsCycle && true==m_bCycleRepeat)
            {
                NSLog(@"单次自动闪完了..");
                m_dwTime1=Sys_GetTime();
                m_bCycleRepeat=false;
                m_bIsRun=!m_bIsRun;
                [self setRunState:m_bIsRun];
            }
            //已经闪过一次
            m_bCycleRepeat=true;
            //关闭闪光灯
            if (pFlashlight.bLightStatus) {
                if ([pFlashlight checkDev]) {
                    [pFlashlight turnOff];
                }
            }
        }

        //显示时间留下的百分比
        if (m_dwTime2!=m_dwTime1) {
            float pce;
            if (m_dwTime2>m_dwTime1) {
                pce=(float)(m_dwTime2-m_dwTime1)/(float)(m_fDisplaySec*1000.0f);
                if (pce>1) {
                    pce=1;
                }
            }
            else
            {
                pce=1;
            }
            NSLog(@"pce=%0.2f",pce);
            CGRect rc=CGRectMake(m_rcDisplayProcess.origin.x,
                                 m_rcDisplayProcess.origin.y, 
                                 m_rcDisplayProcess.size.width*pce,
                                 m_rcDisplayProcess.size.height);
            [m_imgDisplayProcess setFrame:rc]; 
        }
    }
}
@end
