//
//  TouchShow.m
//  CampingHelper
//
//  Created by Han Sohn on 12-7-1.
//  Copyright (c) 2012年 Han.zh. All rights reserved.
//

#import "TouchShow.h"

@implementation TouchShowScreen

-(void) setFlashlight:(Flashlight*) p
{
    pFlashlight=p;
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    if ([pFlashlight checkDev]) {
        [pFlashlight turnOn];
    }
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    if ([pFlashlight checkDev]) {
        [pFlashlight turnOff];
    }
}
@end

@implementation TouchShow
@synthesize pFlashlight;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(void) dealloc
{
    NSLog(@"TouchShow dealloc");

    if (pFlashlight) {
        pFlashlight.delegate=nil;
        [pFlashlight release];
        pFlashlight=nil;
    }
    [super dealloc];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [m_tss setFlashlight:pFlashlight];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
    
    m_tss=nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}


-(BOOL)shouldAutorotate{
    return NO;
}

-(IBAction) btnBack_click:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}



//闪光灯事件回调delegate
-(void) FlashlightStatusChange:(boolean_t)status
{
    NSLog(@"flash...");
}

@end
