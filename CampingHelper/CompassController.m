//
//  CompassController.m
//  CampingHelper
//
//  Created by Han Sohn on 12-2-1.
//  Copyright (c) 2012年 Han.zh. All rights reserved.
//

#import "CompassController.h"

@implementation CompassController
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
    NSLog(@"CompassController dealloc");
    if (pLocManager) {
        pLocManager.delegate=nil;
        [pLocManager release];
        pLocManager=nil;
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
    [self setPointer:NO :pLocManager.heading];
    [self setLocation:pLocManager.location :nil];
    
    
    // 2.GPS
    if([[[UIDevice currentDevice] systemVersion] doubleValue]>=8.0)
    {
        // 2.1 only for ios8
        [pLocManager requestWhenInUseAuthorization];// 前台定位
        [pLocManager requestAlwaysAuthorization];// 前后台同时定位
    }
    
    [pLocManager startUpdatingLocation];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
    
    imgPointerMagnetic=nil;
    imgPointerTrue=nil;
    txtAngle=nil;
    txtCoodrX=nil;
    txtCoodrY=nil;
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

-(void) setPointer:(boolean_t)animated :(CLHeading *)newHeading
{
    if (animated) {
        [UIView beginAnimations:@"compass" context:@"compass"];
        [UIView setAnimationDuration:0.5f];
        [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
        [UIView setAnimationRepeatAutoreverses:NO];
    }

    //磁北
    CGFloat heading = -1.0f * M_PI * newHeading.magneticHeading / 180.0f;
    imgPointerMagnetic.transform = CGAffineTransformMakeRotation(heading);
    txtAngle.text=[NSString stringWithFormat:@"%@:%0.2f",NSLocalizedString(@"compass_txtAngle", nil),newHeading.magneticHeading];
    
    //正北 
    //CGFloat heading2 = -1.0f * M_PI * newHeading.trueHeading / 180.0f;
    //imgPointerTrue.transform = CGAffineTransformMakeRotation(heading2);
    //txtAngle.text=[NSString stringWithFormat:@"%@:%0.2f",NSLocalizedString(@"compass_txtAngle", nil),newHeading.trueHeading];
 
    
    if (animated) {
        [UIView setAnimationTransition:UIViewAnimationTransitionNone 
                               forView:imgPointerMagnetic cache:YES];
        //[UIView setAnimationTransition:UIViewAnimationTransitionNone 
        //                       forView:imgPointerTrue cache:YES];
        [UIView commitAnimations];
    }
}

- (void)locationManager:(CLLocationManager *)manager didUpdateHeading:(CLHeading *)newHeading
{
    // 回调方法返回一个 CLHeading 对象，CLHeading对象可以查询前进方向的两个属性：magneticHeading和trueHeading，
    // magneticHeading 返回磁北的相对位置，磁北对应于随时间变化的地球磁场极点；
    // trueHeading 返回正北的相对位置，真北始终指向地理北极点
	
    [self setPointer:YES :newHeading];
}

- (BOOL)locationManagerShouldDisplayHeadingCalibration:(CLLocationManager *)manager
{
    return YES;
}

-(void) setLocation:(CLLocation *)newLocation :(CLLocation *)oldLocation
{
    //保存新位置
    if (newLocation) {
        m_curLocation=newLocation.coordinate;
        txtCoodrY.text=[NSString stringWithFormat:@"%@:%0.6f",NSLocalizedString(@"compass_txtLatitude", nil), m_curLocation.latitude];
        txtCoodrX.text=[NSString stringWithFormat:@"%@:%0.6f",NSLocalizedString(@"compass_txtLongitude", nil), m_curLocation.longitude];
    }

    if (oldLocation) {
        
    }
}

- (void) locationManager:(CLLocationManager *)manager 
     didUpdateToLocation:(CLLocation *)newLocation
            fromLocation:(CLLocation *)oldLocation
{
    NSLog(@"newLocation:%@",[newLocation description]);
    [self setLocation:newLocation :oldLocation];
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
    [self dismissViewControllerAnimated:YES completion:NULL];
}

@end
