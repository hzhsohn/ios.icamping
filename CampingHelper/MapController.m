//
//  MapController.m
//  CampingHelper
//
//  Created by Han Sohn on 12-2-8.
//  Copyright (c) 2012年 Han.zh. All rights reserved.
//

#import "MapController.h"

@implementation MapController
@synthesize pLocManager;

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
    NSLog(@"MapController dealloc");
    if (pLocManager) {
        pLocManager.delegate=nil;
        [pLocManager release];
        pLocManager=nil;
    }
    map.delegate=nil;
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
    [self btnCurCoodr_click:0];
    
    m_curLocation=pLocManager.location.coordinate;
    m_curAngle=pLocManager.heading.magneticHeading;
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
    map=nil;
    lbInfo=nil;
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

#pragma mark -使用Heading值跟踪北向
- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    NSLog(@"Location manager error: %@", [error description]);
}

- (void)locationManager:(CLLocationManager *)manager didUpdateHeading:(CLHeading *)newHeading
{
    // 回调方法返回一个 CLHeading 对象，CLHeading对象可以查询前进方向的两个属性：magneticHeading和trueHeading，
    // magneticHeading 返回磁北的相对位置，磁北对应于随时间变化的地球磁场极点；
    // trueHeading 返回正北的相对位置，真北始终指向地理北极点
	
    //磁北
   // CGFloat heading = -1.0f * M_PI * newHeading.magneticHeading / 180.0f;
    m_curAngle=newHeading.magneticHeading;
    [self setInfoLabel];
    //正北 
    //CGFloat heading2 = -1.0f * M_PI * newHeading.trueHeading / 180.0f;
}

- (BOOL)locationManagerShouldDisplayHeadingCalibration:(CLLocationManager *)manager
{
    return YES;
}

- (void) locationManager:(CLLocationManager *)manager 
     didUpdateToLocation:(CLLocation *)newLocation
            fromLocation:(CLLocation *)oldLocation
{
    NSLog(@"newLocation:%@",[newLocation description]);
}

-(void) setInfoLabel
{
    lbInfo.text=[NSString stringWithFormat:@"[%@:%0.6f,%@:%0.6f]      %@:%0.2f",
                 NSLocalizedString(@"map_txtLatitude", nil),m_curLocation.latitude ,
                 NSLocalizedString(@"map_txtLongitude", nil),m_curLocation.longitude ,
                 NSLocalizedString(@"map_txtAngle", nil),m_curAngle];
}

//////////////////////////////////////////////////////////////
//发短信
#pragma mark - #pragma mark SMS   
-(IBAction)showSMSPicker:(id)sender {       
    Class messageClass = (NSClassFromString(@"MFMessageComposeViewController"));    
    if (messageClass != nil) {         
        // Check whether the current device is configured for sending SMS messages         
        if ([messageClass canSendText]) {             
            [self displaySMSComposerSheet];        
        }
        else 
        {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"SMS_no_msg_func",nil) 
                                                            message:nil delegate: self 
                                                  cancelButtonTitle:NSLocalizedString(@"close",nil) 
                                                  otherButtonTitles:nil];
            [alert show];
            [alert release];
        }
    }
    else 
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"SMS_ios_version_old",nil)
                                                        message:nil delegate: self 
                                              cancelButtonTitle:NSLocalizedString(@"close",nil) 
                                              otherButtonTitles:nil];
        [alert show];
        [alert release];
    }
}

-(void)displaySMSComposerSheet {
    MFMessageComposeViewController *picker = [[MFMessageComposeViewController alloc] init];
    picker.messageComposeDelegate = self;
    picker.body=[NSString stringWithFormat:@"%@ [%@ %0.6f,%@ %0.6f] http://maps.google.com/?q=%0.6f,%0.6f ",
                 NSLocalizedString(@"send_SMS", nil),
                 NSLocalizedString(@"send_SMS_latitude", nil),
                 m_curLocation.latitude,
                 NSLocalizedString(@"send_SMS_longitude", nil),
                 m_curLocation.longitude,
                 m_curLocation.latitude,
                 m_curLocation.longitude];
    [self presentViewController:picker animated:YES completion:NULL];
    [picker release];
}

-(void)messageComposeViewController:(MFMessageComposeViewController *)controller
                didFinishWithResult:(MessageComposeResult)result 
{
    switch (result)
    {
        case MessageComposeResultCancelled:
        {
            NSLog(@"Result: SMS sending canceled");
        }
            break;
        case MessageComposeResultSent:
        {
            NSLog(@"Result: SMS sent");
        }
            break;
        case MessageComposeResultFailed:
        {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"SMS_send_fail",nil) 
                                                            message:nil delegate: self
                                                  cancelButtonTitle:NSLocalizedString(@"close",nil) 
                                                  otherButtonTitles:nil];
            [alert show];
            [alert release];
        }
            break;
        default:
        {
            NSLog(@"Result: SMS not sent");
        }
            break;
    }
    [self dismissModalViewControllerAnimated:YES]; 
}

-(IBAction) btnCurCoodr_click:(id)sender
{
    MKCoordinateRegion mapRegion;
    
    MKCoordinateSpan mapSpan;
    mapSpan.latitudeDelta = 0.002;
    mapSpan.longitudeDelta = 0.002;
    
    mapRegion.center=m_curLocation;
    mapRegion.span = mapSpan;
    
    [map setRegion:mapRegion];
    [map regionThatFits:mapRegion];
    map.userTrackingMode=MKUserTrackingModeFollowWithHeading ;
}
/////////////////////////////////////////////////////////
- (void)mapView:(MKMapView *)mapView regionDidChangeAnimated:(BOOL)animated
{
     NSLog(@"regionDidChangeAnimated");
};

- (void)mapViewWillStartLoadingMap:(MKMapView *)mapView
{
    NSLog(@"mapViewWillStartLoadingMap");
    
}

- (void)mapViewDidFinishLoadingMap:(MKMapView *)mapView
{
    NSLog(@"mapViewDidFinishLoadingMap");
}

- (void)mapView:(MKMapView *)mapView didChangeUserTrackingMode:(MKUserTrackingMode)mode animated:(BOOL)animated NS_AVAILABLE(NA, 5_0)
{
    NSLog(@"didChangeUserTrackingMode");
}

- (void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation
{
    NSLog(@"didUpdateUserLocation");
    m_curLocation=userLocation.location.coordinate;
    [self setInfoLabel];
}
@end
