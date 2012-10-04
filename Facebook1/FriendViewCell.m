//
//  FriendViewCell.m
//  Facebook1
//
//  Created by Nghia on 10/4/12.
//  Copyright (c) 2012 Nghia. All rights reserved.
//

#import "FriendViewCell.h"

@implementation FriendViewCell
@synthesize profilepic,fname;
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        self.profilepic =[[FBProfilePictureView alloc]initWithFrame:CGRectMake(0, 0, 50, 50)];
        [self addSubview:self.profilepic];
        self.fname=[[UILabel alloc]initWithFrame:CGRectMake(60, 5, 200, 25)];
        [self addSubview:self.fname];
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
