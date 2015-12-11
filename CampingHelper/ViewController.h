//
//  ViewController.h
//  Flashlight
//
//  Created by Han Sohn on 11-12-23.
//  Copyright (c) 2011年 Han.zh. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Flashlight.h"
#import <QuartzCore/QuartzCore.h>
#import <CoreLocation/CoreLocation.h>

#import <GoogleMobileAds/GoogleMobileAds.h>

@interface ViewController : UIViewController<GADBannerViewDelegate>
{
    IBOutlet UIButton* btnRating;
    IBOutlet UIButton* btnADClose;
    
    Flashlight* m_flashlight;
    CLLocationManager *m_locManager;
    
    //限制不再显示广告
    BOOL m_isNotShowAD;
    GADBannerView *bannerView_;
}

- (void)applicationWillResignActive:(UIApplication *)application;
- (void)applicationDidBecomeActive:(UIApplication *)application;

- (IBAction) title_click:(id)sender;

- (IBAction) btnUserReview_click:(id)sender;
-(IBAction)btnADClose_click:(id)sender;
@end