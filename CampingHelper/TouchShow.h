//
//  TouchShow.h
//  CampingHelper
//
//  Created by Han Sohn on 12-7-1.
//  Copyright (c) 2012年 Han.zh. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Flashlight.h"


@interface TouchShowScreen:UIImageView
{
    Flashlight *pFlashlight;
}
-(void) setFlashlight:(Flashlight*) pFlashlight;
@end

@interface TouchShow : UIViewController<FlashlightDelegate>
{
    IBOutlet TouchShowScreen *m_tss;
}

@property (nonatomic,retain) Flashlight* pFlashlight;

-(IBAction) btnBack_click:(id)sender;

@end
