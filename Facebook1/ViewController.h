//
//  ViewController.h
//  Facebook1
//
//  Created by Nghia on 10/1/12.
//  Copyright (c) 2012 Nghia. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <FacebookSDK/FacebookSDK.h>
@interface ViewController : UIViewController{
    NSMutableData *userdata;
    NSDictionary *aboutMe;
}
@property(nonatomic,retain) NSMutableData *userdata;
@property(nonatomic,retain) NSDictionary *aboutMe;
@end
