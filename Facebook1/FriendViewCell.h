//
//  FriendViewCell.h
//  Facebook1
//
//  Created by Nghia on 10/4/12.
//  Copyright (c) 2012 Nghia. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <FacebookSDK/FacebookSDK.h>
@interface FriendViewCell : UITableViewCell{
    FBProfilePictureView *profilepic;
    UILabel *fname;
}
@property(nonatomic,retain) FBProfilePictureView *profilepic;
@property(nonatomic,retain) UILabel *fname;
@end
