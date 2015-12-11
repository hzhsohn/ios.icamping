//
//  MosquitoController.m
//  CampingHelper
//
//  Created by Han Sohn on 12-2-21.
//  Copyright (c) 2012年 Han.zh. All rights reserved.
//

#import "MosquitoController.h"
#include "function.h"

@implementation MosquitoController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        m_bRun=false;
        
        m_timer = [NSTimer scheduledTimerWithTimeInterval: 0.01
                                                   target: self
                                                 selector: @selector(handleTimer:)
                                                 userInfo: nil
                                                  repeats: YES];
        m_bUseTiming=false;
    }
    return self;
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
    [m_timer invalidate];
    m_timer = nil;
    [super viewDidDisappear:animated];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [m_lbTiming1 setHidden:YES];
    [m_lbTiming2 setHidden:YES];
    [m_lbTiming3 setHidden:YES];
    [self phoneAnimation:NO];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
    m_ckbRun=nil;
    
    m_imgBBB1=nil;
    m_imgBBB2=nil;
    m_imgBBB3=nil;
    
    m_lbTiming1=nil;
    m_lbTiming2=nil;
    m_lbTiming3=nil;
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

-(IBAction) btnRun_click:(id)sender
{
    m_bUseTiming=false;
    m_nTimingMilliSec=0;
    [self setStart:!m_bRun];
}

-(void) setStart:(boolean_t)b
{
    m_dwPhoneAniTime=Sys_GetTime();
    m_bRun=b;
    m_rBBBstate=0;
    [self setRunState:m_bRun];
    //重新启动
    [m_lbTiming1 setHidden:YES];
    [m_lbTiming2 setHidden:YES];
    [m_lbTiming3 setHidden:YES];
    
}

-(void) setRunState:(boolean_t)b
{
    if (b) {
        m_ckbRun.selected=true;
    }
    else{
        m_ckbRun.selected=false;
    }
    [self phoneAnimation:b];
}

-(IBAction) btnTiming1_click:(id)sender
{
    NSLog(@"1");
    m_bUseTiming=true;
    m_rTimingType=1;
    m_dwTime1=Sys_GetTime();
    m_nTimingMilliSec=30*60*1000+1000;
    [self setStart:true];
    [m_lbTiming1 setHidden:NO];
    [m_lbTiming2 setHidden:YES];
    [m_lbTiming3 setHidden:YES];
}
-(IBAction) btnTiming2_click:(id)sender
{
    NSLog(@"2");
    m_bUseTiming=true;
    m_rTimingType=2;
    m_dwTime1=Sys_GetTime();
    m_nTimingMilliSec=90*60*1000+1000;
    [self setStart:true];
    [m_lbTiming1 setHidden:YES];
    [m_lbTiming2 setHidden:NO];
    [m_lbTiming3 setHidden:YES];
}
-(IBAction) btnTiming3_click:(id)sender
{
    NSLog(@"3");
    m_bUseTiming=true;
    m_rTimingType=3;
    m_dwTime1=Sys_GetTime();
    m_nTimingMilliSec=150*60*1000+1000;
    [self setStart:true];
    [m_lbTiming1 setHidden:YES];
    [m_lbTiming2 setHidden:YES];
    [m_lbTiming3 setHidden:NO];
}

//将毫秒转时时间格式20:00这样
-(NSString*)transTime:(int)ms
{
    int t_sce=ms/1000;
    int minte=t_sce/60;
    int sce=t_sce%60;
    return [NSString stringWithFormat:@"%d:%02d",minte,sce];
}

- (void) handleTimer: (NSTimer *) timer
{
    if (m_bRun) {
        /////////////////////////
        //启动动画
        [self phoneAnimation:true];
        /////////////////////////
        if (m_bUseTiming) {
            //定时器
            m_dwTime2=Sys_GetTime();
            m_dwTimeTmp=m_dwTime2-m_dwTime1;
            if (m_dwTimeTmp<m_nTimingMilliSec) {
                //刷新剩余时间
                switch (m_rTimingType) {
                    case 1:
                        NSLog(@"1->%@,%@",[self transTime:m_dwTimeTmp],[self transTime:m_nTimingMilliSec]);
                        m_lbTiming1.text=[self transTime:m_nTimingMilliSec-m_dwTimeTmp];
                        break;
                    case 2:
                        NSLog(@"2->%@,%@",[self transTime:m_dwTimeTmp],[self transTime:m_nTimingMilliSec]);
                        m_lbTiming2.text=[self transTime:m_nTimingMilliSec-m_dwTimeTmp];
                        break;
                    case 3:
                        NSLog(@"3->%@,%@",[self transTime:m_dwTimeTmp],[self transTime:m_nTimingMilliSec]);
                        m_lbTiming3.text=[self transTime:m_nTimingMilliSec-m_dwTimeTmp];
                        break;
                }
            }
            else{
                //定时已经完成
                //时间到了
                [self setStart:false];
            }
        }
        else{
            //不使用定时器
        }
    }
}

//手机电波动画
-(void) phoneAnimation:(boolean_t) b
{
    if (b) {
        static short i=0;
        unsigned long tt=Sys_GetTime();
        if (tt-m_dwPhoneAniTime>200) {
            m_dwPhoneAniTime=Sys_GetTime();
            switch (i) {
                case 0:
                    [m_imgBBB1 setHidden:YES];
                    [m_imgBBB2 setHidden:YES];
                    [m_imgBBB3 setHidden:YES];
                    break;
                case 1:
                    [m_imgBBB1 setHidden:NO];
                    [m_imgBBB2 setHidden:YES];
                    [m_imgBBB3 setHidden:YES];
                    break;
                case 2:
                    [m_imgBBB1 setHidden:NO];
                    [m_imgBBB2 setHidden:NO];
                    [m_imgBBB3 setHidden:YES];
                    break;
                case 3:
                    [m_imgBBB1 setHidden:NO];
                    [m_imgBBB2 setHidden:NO];
                    [m_imgBBB3 setHidden:NO];
                    break;
                case 4:
                    [m_imgBBB1 setHidden:NO];
                    [m_imgBBB2 setHidden:YES];
                    [m_imgBBB3 setHidden:YES];
                    break;
            }
            i++;
            i%=5;
        }
    }
    else{
        [m_imgBBB1 setHidden:YES];
        [m_imgBBB2 setHidden:YES];
        [m_imgBBB3 setHidden:YES];
    }
}
@end
