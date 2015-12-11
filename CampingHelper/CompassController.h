//
//  CompassController.h
//  CampingHelper
//
//  Created by Han Sohn on 12-2-1.
//  Copyright (c) 2012年 Han.zh. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import <MessageUI/MessageUI.h>

@interface CompassController : UIViewController<CLLocationManagerDelegate,MFMessageComposeViewControllerDelegate>{
    IBOutlet UIImageView* imgPointerMagnetic;
    IBOutlet UIImageView* imgPointerTrue;
    IBOutlet UILabel* txtAngle;
    IBOutlet UILabel* txtCoodrX;
    IBOutlet UILabel* txtCoodrY;
    CLLocationCoordinate2D m_curLocation;
}

@property (nonatomic,retain) CLLocationManager *pLocManager;

-(IBAction) btnBack_click:(id)sender;

-(void) setPointer:(boolean_t)animated :(CLHeading *)newHeading;
-(void) setLocation:(CLLocation *)newLocation :(CLLocation *)oldLocation;

-(IBAction)showSMSPicker:(id)sender;
-(void)displaySMSComposerSheet;
-(void)messageComposeViewController:(MFMessageComposeViewController *)controller
                 didFinishWithResult:(MessageComposeResult)result ;
@end
