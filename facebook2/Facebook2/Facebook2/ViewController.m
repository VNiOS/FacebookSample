//
//  ViewController.m
//  Facebook2
//
//  Created by Nghia on 10/4/12.
//  Copyright (c) 2012 Nghia. All rights reserved.
//

#import "ViewController.h"
#import <FacebookSDK/FacebookSDK.h>
@interface ViewController ()
@property(nonatomic,retain) IBOutlet UILabel *usernamelb;
@property(nonatomic,retain) IBOutlet FBProfilePictureView *profilepic;
@property(nonatomic,strong) id<FBGraphUser> userLogged;

@property(nonatomic,retain) IBOutlet UITextField *textField;
@property(nonatomic,retain) IBOutlet UIButton *sendMsg;


-(IBAction)sendMsg:(id)sender;
-(void)showAlert:(NSError *)error;

@end

@implementation ViewController
@synthesize usernamelb,profilepic,userLogged,textField,sendMsg;
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title=@"Facebook";
    //[self.navigationController.toolbar setHidden:NO];
    
    
    self.profilepic=[[FBProfilePictureView alloc]initWithFrame:CGRectMake(12, 12, 96, 96)];
    self.profilepic.profileID=@"";
    [self.view addSubview:self.profilepic];
    
    
    FBLoginView *loginview =
    [[FBLoginView alloc] initWithPermissions:[NSArray arrayWithObject:@"publish_actions"]];
    
    
    loginview.frame = CGRectMake(110, 360, 100, 40);
    for (id obj in loginview.subviews)
    {
        if ([obj isKindOfClass:[UIButton class]])
        {
            UIButton * loginButton =  obj;
            UIImage *loginImage = [UIImage imageNamed:@"fblogin.png"];
            
            [loginButton setBackgroundImage:loginImage forState:UIControlStateNormal];
            [loginButton setBackgroundImage:nil forState:UIControlStateSelected];
            [loginButton setBackgroundImage:nil forState:UIControlStateHighlighted];
            
            [loginButton sizeToFit];
        }
        if ([obj isKindOfClass:[UILabel class]])
        {
            UILabel * loginLabel =  obj;
            loginLabel.textAlignment = UITextAlignmentCenter;
            loginLabel.frame = CGRectMake(0, 10, 100, 20);
        }
    }
    
    loginview.delegate = self;
    
    [self.view addSubview:loginview];

    
	// Do any additional setup after loading the view, typically from a nib.
}
-(void)viewDidUnload{
    [super viewDidUnload];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - loginview delegate
- (void)loginViewShowingLoggedInUser:(FBLoginView *)loginView {
    // first get the buttons set for login mode
   
}

- (void)loginViewFetchedUserInfo:(FBLoginView *)loginView
                            user:(id<FBGraphUser>)user {
    // here we use helper properties of FBGraphUser to dot-through to first_name and
    // id properties of the json response from the server; alternatively we could use
    // NSDictionary methods such as objectForKey to get values from the my json object
    self.usernamelb.text = [NSString stringWithFormat:@"%@", user.name];
   
    self.profilepic.profileID = user.id;
    self.userLogged = user;
}

- (void)loginViewShowingLoggedOutUser:(FBLoginView *)loginView {
    self.profilepic.profileID=nil;
    self.usernamelb.text=@"name";
}
#pragma mark - button action
-(IBAction)sendMsg:(id)sender{
    [textField resignFirstResponder];
    [FBRequestConnection startForPostStatusUpdate:textField.text completionHandler:^(FBRequestConnection *connection, id result, NSError *error) {
        [self showAlert:error];
    }];
}
#pragma mark - alertview
-(void)showAlert:(NSError *)error{
    if (error) {
        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"Error" message:@"Not succes !" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
        [alert show];
    }
    else{
        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"Succes" message:@" Succes !" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
        [alert show];
    }
}
@end
