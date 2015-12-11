//
//  Flashlight.m
//  Flashlight
//
//  Created by Han Sohn on 11-12-23.
//  Copyright (c) 2011年 Han.zh. All rights reserved.
//

#import "Flashlight.h"
#import "ConfigProc.h"

@implementation Flashlight
@synthesize delegate;
@synthesize torchSession;
@synthesize bLightStatus;

- (void)dealloc {
    NSLog(@"Flashlight dealloc");
    [torchSession release];
    [super dealloc];
}

- (id) init {
    if ((self = [super init])) {
        
        // initialize flashlight
        // test if this class even exists to ensure flashlight is turned on ONLY for iOS 4 and above
        Class captureDeviceClass = NSClassFromString(@"AVCaptureDevice");
        if (captureDeviceClass != nil) {
            
            AVCaptureDevice *device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
            
            if ([device hasTorch] && [device hasFlash]){
                
                if (device.torchMode == AVCaptureTorchModeOff) {
                    
                    NSLog(@"Setting up flashlight for later use...");
                    
                    AVCaptureDeviceInput *flashInput = [AVCaptureDeviceInput deviceInputWithDevice:device error: nil];
                    AVCaptureVideoDataOutput *output = [[AVCaptureVideoDataOutput alloc] init];
                    
                    AVCaptureSession *session = [[AVCaptureSession alloc] init];
                    
                    [session beginConfiguration];
                    [device lockForConfiguration:nil];
                    
                    if (flashInput) {
                        [session addInput:flashInput];
                    }
                    
                    if (output) {
                        [session addOutput:output];
                    }
                    
                    [device unlockForConfiguration];
                    
                    [output release];
                    
                    [session commitConfiguration];
                    [session startRunning];
                    
                    [self setTorchSession:session];
                    [session release];
                }
            }
        }
    } return self;
    
}

- (NSString*) documentPath:(NSString*)str
{
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	NSString *documentsDirectory = [paths objectAtIndex:0];
	
	if (nil!=str) {
		return [NSString stringWithFormat:@"%@/%@",documentsDirectory,str];
	}
	return [NSString stringWithFormat:@"%@",documentsDirectory];
}

-(void) setInitAutoOpen:(boolean_t)isOpen
{
    if (isOpen) {
        [ConfigProc setFlashlightAutomation:YES];
        NSLog(@"set flashlight auto open yes...");
    }
    else{
        [ConfigProc setFlashlightAutomation:NO];
        NSLog(@"set flashlight auto open no...");
    }
}

-(Boolean) isCheckingAutoOpen
{
    return [ConfigProc isFlashlight_automation];
}

-(void) turnOn
{
    // test if this class even exists to ensure flashlight is turned on ONLY for iOS 4 and above
    Class captureDeviceClass = NSClassFromString(@"AVCaptureDevice");
    if (captureDeviceClass != nil) {
        
        AVCaptureDevice *device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
        
        [device lockForConfiguration:nil];
        
        [device setTorchMode:AVCaptureTorchModeOn];
        [device setFlashMode:AVCaptureFlashModeOn];
        
        [device unlockForConfiguration];
        
        bLightStatus=YES;
        [delegate FlashlightStatusChange:YES];
    }
    
    [UIApplication sharedApplication].idleTimerDisabled=YES;
}

-(void) turnOff
{
    // test if this class even exists to ensure flashlight is turned on ONLY for iOS 4 and above
    Class captureDeviceClass = NSClassFromString(@"AVCaptureDevice");
    if (captureDeviceClass != nil) {
        
        AVCaptureDevice *device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
        
        [device lockForConfiguration:nil];
        
        [device setTorchMode:AVCaptureTorchModeOff];
        [device setFlashMode:AVCaptureFlashModeOff];
        
        [device unlockForConfiguration];
        
        bLightStatus=NO;
        [delegate FlashlightStatusChange:NO];
    }
    
    [UIApplication sharedApplication].idleTimerDisabled=NO;
}

-(Boolean) checkDev
{
    AVCaptureDevice *device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    return [device hasTorch] && [device hasFlash];
}

@end