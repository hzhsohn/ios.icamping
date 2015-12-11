//
//  AppDelegate.h
//  Flashlight
//
//  Created by Han Sohn on 11-12-23.
//  Copyright (c) 2011年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Flashlight.h"

@class ViewController;

@interface AppDelegate : UIResponder <UIApplicationDelegate>{
    
}

@property (strong, nonatomic) UIWindow *window;

@property (strong, nonatomic) ViewController *viewController;

@end
