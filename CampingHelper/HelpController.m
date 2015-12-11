//
//  HelpController.m
//  CampingHelper
//
//  Created by Han Sohn on 12-2-12.
//  Copyright (c) 2012年 Han.zh. All rights reserved.
//

#import "HelpController.h"
#import "function.h"

@implementation HelpController
@synthesize pFlashlight;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        m_nTimeProc=0;
        m_bSOS_On=false;
        m_timer = [NSTimer scheduledTimerWithTimeInterval: 0.001
                                                 target: self
                                               selector: @selector(handleTimer:)
                                               userInfo: nil
                                                repeats: YES];
    }
    return self;
}

-(void) dealloc
{
    if ([pFlashlight checkDev]){[pFlashlight turnOff];}
    
    NSLog(@"HelpController dealloc");
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

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
    m_ckbRun=nil;
    m_imgScreen=nil;
    m_imgScreen_0=nil;
    m_imgScreen_1=nil;
    
    /////////
    m_imgViwPeople3=nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return Y  ES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

-(BOOL)shouldAutorotate{
    return NO;
}

//闪光灯事件回调delegate
-(void) FlashlightStatusChange:(boolean_t)status
{
    //NSLog(@"求救闪光灯回调");
}

-(IBAction) btnBack_click:(id)sender
{
    [m_timer invalidate];
    m_timer = nil;
    [self.navigationController popViewControllerAnimated:YES];
}

-(IBAction) ckbSOS_click:(id)sender
{
    if ([pFlashlight checkDev])
    {
        m_bSOS_On=!m_bSOS_On;
        if (m_bSOS_On) {
            m_nTimeProc=0;
            m_ckbRun.selected=true;
        }
        else{
            m_ckbRun.selected=false;
            if ([pFlashlight checkDev]){[pFlashlight turnOff];}
            [m_imgScreen setImage:m_imgScreen_0.image];
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

- (void) handleTimer: (NSTimer *) timer
{
    if (m_bSOS_On) {
        [self SOSFlashlight];
    }
    
    //男猪脚动画
    if (Sys_GetTime()-m_people3_time>500) {
        
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationDuration:0.5f];
       
        if (m_people3_ani) {
            [m_imgViwPeople3 setCenter:CGPointMake(m_imgViwPeople3.center.x,
                                                   m_imgViwPeople3.center.y+5)];
        }
        else {
            [m_imgViwPeople3 setCenter:CGPointMake(m_imgViwPeople3.center.x,
                                                   m_imgViwPeople3.center.y-5)];
        }
        
        [UIView setAnimationTransition:UIViewAnimationTransitionNone forView:m_imgViwPeople3 cache:YES];	
        [UIView commitAnimations];
        
        m_people3_time=Sys_GetTime();
        m_people3_ani=!m_people3_ani;
    }
    
    
}

//////////////////////////// SOS 信号处理 ////////////////////
-(void) TimeProcAdd
{
    m_isOpenFlash=FALSE;
    m_nTimeProc++;
}
-(void) closeFlash
{
    if ([pFlashlight checkDev]){[pFlashlight turnOff];}
    [m_imgScreen setImage:m_imgScreen_0.image];
    [self performSelector:@selector(TimeProcAdd) withObject:nil afterDelay:0.16f];
}
-(void) dealayFlash:(BOOL)isLong
{
    m_isOpenFlash=TRUE;
    if ([pFlashlight checkDev]){[pFlashlight turnOn];}
    [m_imgScreen setImage:m_imgScreen_1.image];
    
    if (isLong) {
        [self performSelector:@selector(closeFlash) withObject:nil afterDelay:0.5f];
        NSLog(@"-");
    }
    else {
        [self performSelector:@selector(closeFlash) withObject:nil afterDelay:0.16f];
        NSLog(@".");
    }
}

-(void) resetTimeProcDone
{
    m_isOpenFlash=FALSE;
    m_nTimeProc=0;
    NSLog(@"************");
}
-(void) resetTimeProc
{
    m_isOpenFlash=TRUE;
    [self performSelector:@selector(resetTimeProcDone) 
               withObject:nil 
               afterDelay:1];
}

-(void) SOSFlashlight
{
    if (m_isOpenFlash) {
        return;
    }
   
    switch (m_nTimeProc) {
        case 0:
            [self dealayFlash:NO];
            break;
        case 1:
            [self dealayFlash:NO];
            break;
        case 2:
            [self dealayFlash:NO];
            break;
        case 3:
            [self dealayFlash:YES];
            break;
        case 4:
            [self dealayFlash:YES];
            break;
        case 5:
            [self dealayFlash:YES];
            break;
        case 6:
            [self dealayFlash:NO];
            break;
        case 7:
            [self dealayFlash:NO];
            break;
        case 8:
            [self dealayFlash:NO];
            break;
            //休止时间
        case 9:
            [self resetTimeProc];
            break;
    }
    
}

@end
