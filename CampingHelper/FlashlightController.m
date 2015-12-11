//
//  Style1.m
//  Flashlight
//
//  Created by Han Sohn on 12-1-1.
//  Copyright (c) 2012年 Han.zh. All rights reserved.
//

#import "FlashlightController.h"

@implementation FlashlightController
@synthesize pFlashlight;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization

    }
    return self;
}

-(void)dealloc
{
    NSLog(@"FlashlightInterface dealloc");
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

-(void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    if ([pFlashlight isCheckingAutoOpen]) {
        [self setCkbImage:YES];
    }
    else{
        [self setCkbImage:NO];
    }
    
    if (pFlashlight.bLightStatus) {
        [self resetLightStatus:YES];
    }
    else
    {
        [self resetLightStatus:NO];
    }
    
    m_timer = [NSTimer scheduledTimerWithTimeInterval: 0.01
                                             target: self
                                           selector: @selector(handleTimer:)
                                           userInfo: nil
                                            repeats: YES];
}

-(void) viewDidDisappear:(BOOL)animated
{
    [m_timer invalidate];
    m_timer = nil;
    [super viewDidDisappear:animated];
}

- (void) handleTimer: (NSTimer *) timer
{
    static short i=0;
    if (m_bStatus) {
        btnSwitch.transform=CGAffineTransformMakeRotation(2*M_PI*i/360);
        i-=3;
        if (i<=0) {
            i=360;
        }
    }
}

-(void) FlashlightStatusChange:(boolean_t)status
{
    [self resetLightStatus:status];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
    
    btnSwitch=nil;
    ckbAutoOpen=nil;
    m_timer = nil;
    imgBulb=nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

-(BOOL)shouldAutorotate{
    return NO;
}

-(void) resetLightStatus:(boolean_t) status
{
    //btnSwitch
    //调整灯光效果
    if (status) 
    {
        m_bStatus=true;
        [imgBulb setImage:[UIImage imageNamed:@"flashlight_bulb_open.png"]];
    }
    else
    {
        m_bStatus=false;
        [imgBulb setImage:[UIImage imageNamed:@"flashlight_bulb_close.png"]];
    }
}

-(IBAction) btnSwitch_click:(id)sender
{
    if ([pFlashlight checkDev]) {
        if (pFlashlight.bLightStatus) {
            [pFlashlight turnOff];
        }
        else
        {
            [pFlashlight turnOn];
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

-(void) setCkbImage:(boolean_t)b
{
    m_bAutoOpen=b;
    if (b) {
        ckbAutoOpen.selected=true;
    }
    else
    {
        ckbAutoOpen.selected=false;
    }
}

-(IBAction) ckbAutoOpen_click:(id)sender
{
    if ([pFlashlight checkDev]){
        m_bAutoOpen=!m_bAutoOpen;
        [pFlashlight setInitAutoOpen:m_bAutoOpen];
        
        [self setCkbImage:m_bAutoOpen];
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

-(IBAction) btnBack_click:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void) addGestureRecognizers:(UIView *)piece
{
    //下面四个是判断上下左右的.
    UISwipeGestureRecognizer*r4 ;
    
    r4 = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipe:)];
    [r4 setDelegate:self];
    r4.direction=UISwipeGestureRecognizerDirectionUp;
    [piece addGestureRecognizer:r4];
    [r4 release];
    
    r4 = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipe:)];
    [r4 setDelegate:self];
    r4.direction=UISwipeGestureRecognizerDirectionDown;
    [piece addGestureRecognizer:r4];
    [r4 release];
    
}

- (void) handleSwipe:(UISwipeGestureRecognizer *)sender 
{
    NSLog(@"handleSwipe %d",sender.direction);
    switch ((int)sender.direction) {
        case UISwipeGestureRecognizerDirectionUp:
  
            break;
            
        case UISwipeGestureRecognizerDirectionDown:
 
            break;
    }
}

@end
