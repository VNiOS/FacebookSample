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
@property(nonatomic,retain) IBOutlet UILabel *genrelb;
@property(nonatomic,retain) IBOutlet FBProfilePictureView *profilepic;
@property(nonatomic,strong) id<FBGraphUser> userLogged;

@property(nonatomic,retain) IBOutlet UITextField *textField;
@property(nonatomic,retain) IBOutlet UIButton *sendMsg;
@property(nonatomic,retain) IBOutlet UIImageView *imgUpload;

-(IBAction)sendMsg:(id)sender;
-(IBAction)takePhoto:(id)sender;
-(IBAction)dongTextField:(id)sender;

-(void)getHomeTimeline;
-(void)getUserInfo;
-(void)showAlert:(NSError *)error;
@end

@implementation ViewController
@synthesize usernamelb,genrelb,profilepic,userLogged,textField,sendMsg;
@synthesize dataUpload,imgUpload;
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title=@"Facebook";
    
    
    
    self.profilepic=[[FBProfilePictureView alloc]initWithFrame:CGRectMake(12, 12, 60, 60)];
    self.profilepic.profileID=@"";
    [self.view addSubview:self.profilepic];
    [self.sendMsg setEnabled:NO];
    
    FBLoginView *loginview =
    [[FBLoginView alloc] initWithPermissions:[NSArray arrayWithObjects:@"user_about_me", @"user_activities",@"friends_activities",@"friends_status",@"publish_actions",nil]];
    
    
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
    
    [self.sendMsg setEnabled:YES];
    [self getUserInfo];
}

- (void)loginViewShowingLoggedOutUser:(FBLoginView *)loginView {
    self.profilepic.profileID=nil;
    self.usernamelb.text=@"name";
    [self.sendMsg setEnabled:NO];
}
-(void)getHomeTimeline{
  
}
-(void)getUserInfo{
    NSLog(@"get User info");

    [FBRequestConnection startWithGraphPath:@"/me" parameters:nil HTTPMethod:@"GET" completionHandler:^(FBRequestConnection *connection, id<FBGraphObject> result, NSError *error) {
        NSLog(@"userinfo %@",result);
        if ([[result objectForKey:@"gender"] isEqualToString:@"male"]) {
            [self.genrelb setText:@"Male"];
        }
        else{
            [self.genrelb setText:@"Female"];
        }
      
        
    }];
    

    
    
//    [FBRequestConnection startWithGraphPath:@"me/friends" parameters:nil HTTPMethod:@"GET" completionHandler:^(FBRequestConnection *connection, id<FBGraphObject> result, NSError *error) {
//        NSLog(@"friends data :%@",[[result objectForKey:@"data"] objectAtIndex:1]);
//        }];
}
#pragma mark - button action
-(IBAction)sendMsg:(id)sender{
    [textField resignFirstResponder];
    if (![textField.text isEqualToString:@""]) {

        
        NSMutableDictionary *param=[NSMutableDictionary dictionaryWithObjectsAndKeys:self.imgUpload.image,@"source",textField.text,@"message", nil];
        
        [FBRequestConnection startWithGraphPath:@"/me/photos" parameters:param HTTPMethod:@"POST" completionHandler:^(FBRequestConnection *connection, id result, NSError *error) {
            [self showAlert:error];
        }];
        
    }
  
}
-(IBAction)dongTextField:(id)sender{
    [sender resignFirstResponder];
}
-(IBAction)takePhoto:(id)sender{
    UIActionSheet *action=[[UIActionSheet alloc]initWithTitle:@"Select" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Select on library",@"Select camera", nil];
    [action showInView:self.view];
}

#pragma mark - alertview
-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    NSLog(@" click %d",buttonIndex);
    UIImagePickerController *select=[[UIImagePickerController alloc]init];
    select.delegate=self;
    switch (buttonIndex) {
        case 0:
        {
            select.sourceType=UIImagePickerControllerSourceTypePhotoLibrary;
            [self presentModalViewController:select animated:YES];
        }
            break;
        case 1:
        {
          if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
              select.sourceType=UIImagePickerControllerSourceTypeCamera;
              [self presentModalViewController:select animated:YES];
          }
          else{
              UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"Alert" message:@"No camera" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
              [alert show];
              
          }
        }
            break;
            
        default:
            break;
    }
}
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
    //UIImage *img=[info objectForKey:UIImagePickerControllerEditedImage];
    UIImage *img1=[info objectForKey:UIImagePickerControllerOriginalImage];
    
    if (img1==nil) {
        NSLog(@"ko lay dc anh");
    }
    else{
        [imgUpload setImage:img1];
        
    }
    [self dismissModalViewControllerAnimated:YES];
}
-(void)showAlert:(NSError *)error{
    if (error) {
        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"Error" message:@"Not succes !" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
        [alert show];
    }
    else{
        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"Succes" message:@" Succes !" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
        [alert show];
        [self.textField setText:@""];
    }
}
@end
