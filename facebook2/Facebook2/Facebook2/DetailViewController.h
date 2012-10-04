//
//  DetailViewController.h
//  Facebook2
//
//  Created by Nghia on 10/4/12.
//  Copyright (c) 2012 Nghia. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DetailViewController : UIViewController

@property (strong, nonatomic) id detailItem;

@property (strong, nonatomic) IBOutlet UILabel *detailDescriptionLabel;

@end
