//
//  MapController.h
//  CampingHelper
//
//  Created by Han Sohn on 12-2-8.
//  Copyright (c) 2012年 Han.zh. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import <MessageUI/MessageUI.h>
#import <MapKit/MapKit.h>

@interface MapController : UIViewController<CLLocationManagerDelegate,MFMessageComposeViewControllerDelegate,MKMapViewDelegate>
{
    IBOutlet MKMapView* map;
    IBOutlet UILabel* lbInfo;
    CLLocationCoordinate2D m_curLocation;
    float m_curAngle;
}

@property (nonatomic,retain) CLLocationManager *pLocManager;

-(IBAction) btnBack_click:(id)sender;
-(IBAction) btnCurCoodr_click:(id)sender;

-(void) setInfoLabel;

-(IBAction)showSMSPicker:(id)sender;
-(void)displaySMSComposerSheet;
-(void)messageComposeViewController:(MFMessageComposeViewController *)controller
                didFinishWithResult:(MessageComposeResult)result ;

@end
