//
//  AppDelegate.h
//  Facebook1
//
//  Created by Nghia on 10/1/12.
//  Copyright (c) 2012 Nghia. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <FacebookSDK/FacebookSDK.h>
@class ViewController;

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (strong, nonatomic) ViewController *viewController;

@property (strong ,nonatomic) FBSession *session;
@end
