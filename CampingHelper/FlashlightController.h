//
//  Style1.h
//  Flashlight
//
//  Created by Han Sohn on 12-1-1.
//  Copyright (c) 2012年 Han.zh. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Flashlight.h"

@interface FlashlightController : UIViewController<UIGestureRecognizerDelegate,FlashlightDelegate>{
    
    IBOutlet UIImageView* imgBulb;
    IBOutlet UIButton* btnSwitch;
    IBOutlet UIButton* ckbAutoOpen;
    BOOL m_bStatus;
    BOOL m_bAutoOpen;

    NSTimer* m_timer;
}

@property (nonatomic,retain) Flashlight* pFlashlight;

-(void) resetLightStatus:(boolean_t) status;
-(void) setCkbImage:(boolean_t)b;

-(IBAction) btnSwitch_click:(id)sender;
-(IBAction) ckbAutoOpen_click:(id)sender;
-(IBAction) btnBack_click:(id)sender;

- (void) addGestureRecognizers:(UIView *)piece;
- (void) handleSwipe:(UISwipeGestureRecognizer *)sender;
@end
