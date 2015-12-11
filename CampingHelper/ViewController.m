//
//  ViewController.m
//  Flashlight
//
//  Created by Han Sohn on 11-12-23.
//  Copyright (c) 2011年 Han.zh All rights reserved.
//

#import "ViewController.h"
#import "ConfigProc.h"
#import "FlashlightController.h"
#import "CompassController.h"
#import "MapController.h"
#import "HelpController.h"
#import "TimingController.h"
#import "MosquitoController.h"
#import "TouchShow.h"



@implementation ViewController

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

-(NSString *) TransitionForm
{
    UIInterfaceOrientation orientation = [UIApplication sharedApplication].statusBarOrientation;
    if (orientation == UIInterfaceOrientationLandscapeLeft) {
        return kCATransitionFromRight;
    } else  {
        return kCATransitionFromLeft;
    }
}
//移出来
-(void)performTransitionUp:(UIView *)viw
{
    
    CATransition *transition = [CATransition animation];
    transition.duration = 0.25;
    transition.type = @"moveIn";
    transition.subtype = kCATransitionFromTop;
    [viw.layer addAnimation:transition forKey:nil];
}
//缩回去
-(void)performTransitionDown:(UIView *)viw
{
    
    CATransition *transition = [CATransition animation];
    transition.duration = 0.25;
    transition.type = @"reveal";
    transition.subtype = kCATransitionFromBottom;
    [viw.layer addAnimation:transition forKey:nil];
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    /////////// 加入广告  //////////////////////
    
    
    
    // Create a view of the standard size at the top of the screen.
    // Available AdSize constants are explained in GADAdSize.h.
    bannerView_ = [[GADBannerView alloc] initWithAdSize:kGADAdSizeBanner];
    
    // Specify the ad's "unit identifier." This is your AdMob Publisher ID.
    bannerView_.adUnitID = @"ca-app-pub-8018207524434638/2067182504";
    
    // Let the runtime know which UIViewController to restore after taking
    // the user wherever the ad goes and add it to the view hierarchy.
    bannerView_.rootViewController = self;
    [bannerView_ setAlpha:0];
    [btnADClose setAlpha:0];
    
    int sv=[[[[UIDevice currentDevice] systemVersion] substringWithRange:NSMakeRange(0, 1)] intValue];
    CGRect rx;
    
    if (sv>=7) {
        rx= [ UIScreen mainScreen ].bounds;
    }else
    {
        rx= [ UIScreen mainScreen ].applicationFrame;
    }
    
    
    CGRect rc=bannerView_.frame;
    rc.origin.y=rx.size.height-rc.size.height;
    [bannerView_ setFrame:rc];
    CGRect rd=btnADClose.frame;
    rd.origin.x=0;
    rd.origin.y=rc.origin.y-rd.size.height;
    [btnADClose setFrame:rd];
    [self.view addSubview:bannerView_];
    bannerView_.delegate=self;
    
    // Initiate a generic request to load it with an ad.
    [bannerView_ loadRequest:[GADRequest request]];
    
    
    /////// 加入广告 END ////////////////////////

    //初始化配置文件的默认参数
    [ConfigProc initialize];
    
    
    //闪光灯初始化
    m_flashlight=[[Flashlight alloc] init];
    
    if ([m_flashlight checkDev]) {
        NSLog(@"可以使用闪光灯");
    }
    else{
        NSLog(@"设备不支持闪光灯");
    }
          m_locManager = [[CLLocationManager alloc] init];
    ///测试设备是否支持heading
    if ([m_locManager headingAvailable])
    {
        NSLog(@"指南针可用");
        m_locManager.headingFilter=1;
        [m_locManager startUpdatingHeading];
    }
    else
    {
        NSLog(@"不支持指南针");
    }
    
    //开始探测自己的位置     
    if ([CLLocationManager locationServicesEnabled])   
    {  
        m_locManager.desiredAccuracy=kCLLocationAccuracyBest;  
        m_locManager.distanceFilter=5.0f;  
        [m_locManager startUpdatingLocation];
        NSLog(@"获取当前坐标可用");
    }
    else
    {
        NSLog(@"不能获取当前坐标");
    }
}

//广告回调
- (void)adViewDidReceiveAd:(GADBannerView *)view
{
    if (FALSE==m_isNotShowAD) {
        [btnADClose setAlpha:1];
        [view setAlpha:1];
        [self performTransitionUp:btnADClose];
        [self performTransitionUp:view];
    }
}

-(IBAction)btnADClose_click:(id)sender
{
    [btnADClose setAlpha:0];
    [bannerView_ setAlpha:0];
    [self performTransitionDown:btnADClose];
    [self performTransitionDown:bannerView_];
    m_isNotShowAD=TRUE;
}

- (void)dealloc {
    
    [m_flashlight release];
    m_flashlight=nil;
    
    [m_locManager release];
    m_locManager=nil;
    
    // Don't release the bannerView_ if you are using ARC in your project
    [bannerView_ release];
    [super dealloc];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
    
    btnRating=nil;
    btnADClose=nil;
}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        return (interfaceOrientation == UIDeviceOrientationPortrait);
    } else {
        return YES;
    }
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    NSLog(@"退出程序");
    if (m_flashlight.bLightStatus) {
        [m_flashlight turnOff];
    }
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    NSLog(@"打开程序");
    if ([m_flashlight isCheckingAutoOpen]) {
        [m_flashlight performSelector:@selector(turnOn) withObject:nil afterDelay:0.5f];
    }
}

- (IBAction) title_click:(id)sender
{
    UIButton*btn=(UIButton*)sender;
    switch (btn.tag) {
        case 1:
        {
            FlashlightController* coller;
            if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
                coller = [[FlashlightController alloc] 
                          initWithNibName:@"FlashlightController_iPhone" bundle:nil];
            } else {
                coller = [[FlashlightController alloc] 
                          initWithNibName:@"FlashlightController_iPad" bundle:nil];
            }
            
            m_flashlight.delegate=coller;
            coller.pFlashlight=m_flashlight;
            
            [self.navigationController pushViewController:coller animated:YES];
            [coller release];
        }
            break;
        case 2:
        {
            TouchShow*frm=[[TouchShow alloc] initWithNibName:@"TouchShow_iPhone" bundle:nil];
            
            m_flashlight.delegate=frm;
            frm.pFlashlight=m_flashlight;
            
            [self.navigationController pushViewController:frm animated:YES];
            [frm release];
        }
            break;
        case 3:
        {
            CompassController* coller;
            if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
                coller = [[CompassController alloc] 
                          initWithNibName:@"CompassController_iPhone" bundle:nil];
            } else {
                coller = [[CompassController alloc] 
                          initWithNibName:@"CompassController_iPad" bundle:nil];
            }
            
            m_locManager.delegate=coller;
            coller.pLocManager=m_locManager;
            
            [self.navigationController pushViewController:coller animated:YES];
            [coller release];
        }
            break;
        case 4:
        {
            MapController* coller;
            if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
                coller = [[MapController alloc] 
                          initWithNibName:@"MapController_iPhone" bundle:nil];
            } else {
                coller = [[MapController alloc] 
                          initWithNibName:@"MapController_iPad" bundle:nil];
            }
            
            m_locManager.delegate=coller;
            coller.pLocManager=m_locManager;
            
            [self.navigationController pushViewController:coller animated:YES];
            [coller release];
        }
            break;
        case 5:
        {
            HelpController* coller;
            if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
                coller = [[HelpController alloc] 
                          initWithNibName:@"HelpController_iPhone" bundle:nil];
            } else {
                coller = [[HelpController alloc] 
                          initWithNibName:@"HelpController_iPad" bundle:nil];
            }
            
            m_flashlight.delegate=coller;
            coller.pFlashlight=m_flashlight;
            
            [self.navigationController pushViewController:coller animated:YES];
            [coller release];
        }
            break;
        case 6:
        {
            TimingController* coller;
            if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
                coller = [[TimingController alloc] 
                          initWithNibName:@"TimingController_iPhone" bundle:nil];
            } else {
                coller = [[TimingController alloc] 
                          initWithNibName:@"TimingController_iPad" bundle:nil];
            }
            
            m_flashlight.delegate=coller;
            coller.pFlashlight=m_flashlight;
            
            [self.navigationController pushViewController:coller animated:YES];
            [coller release];
        }
            break;
        case 7:
        {
            MosquitoController* coller;
            if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
                coller = [[MosquitoController alloc] 
                          initWithNibName:@"MosquitoController_iPhone" bundle:nil];
            } else {
                coller = [[MosquitoController alloc] 
                          initWithNibName:@"MosquitoController_iPad" bundle:nil];
            }
            
            [self.navigationController pushViewController:coller animated:YES];
            [coller release];
        }
            break;
    }
    
  
}

- (IBAction) btnUserReview_click:(id)sender
{
    NSString* RateURL = [NSString stringWithFormat:@"http://itunes.apple.com/us/app/id%d?mt=8", 541406412];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:RateURL]];
    
    //541406412
    NSLog(@"Review Click");
}

@end
