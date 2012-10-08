//
//  ViewController.m
//  Facebook2
//
//  Created by Nghia on 10/4/12.
//  Copyright (c) 2012 Nghia. All rights reserved.
//

#import "ViewController.h"
#import <FacebookSDK/FacebookSDK.h>
#import <CoreLocation/CoreLocation.h>


@interface ViewController ()

@property(nonatomic,strong) id<FBGraphUser> userLogged;
@property(nonatomic,strong) id<FBGraphPlace> userLocation;

@property(nonatomic,retain) IBOutlet UILabel *usernamelb;
@property(nonatomic,retain) IBOutlet UILabel *genrelb;
@property(nonatomic,retain) IBOutlet FBProfilePictureView *profilepic;


@property(nonatomic,retain) IBOutlet UITextField *textField;
@property(nonatomic,retain) IBOutlet UIButton *sendMsg;
@property(nonatomic,retain) IBOutlet UIButton *photobt;
@property(nonatomic,retain) IBOutlet UIButton *locationbt;
@property(nonatomic,retain) IBOutlet UIImageView *imgUpload;

-(IBAction)sendMsg:(id)sender;
-(IBAction)takePhoto:(id)sender;
-(IBAction)dongTextField:(id)sender;
-(IBAction)hienMenu:(id)sender;
-(IBAction)getLocation:(id)sender;



-(void)getHomeTimeline;
-(void)getUserInfo;
-(void)showAlert:(NSError *)error;
@end

@implementation ViewController
@synthesize usernamelb,genrelb,profilepic,userLogged,textField,userLocation,sendMsg,photobt,locationbt;
@synthesize dataUpload,imgUpload;
bool LocateEnable;
CGSize toado;
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title=@"Facebook";
    
    
    
    self.profilepic=[[FBProfilePictureView alloc]initWithFrame:CGRectMake(12, 12, 45, 45)];
    self.profilepic.profileID=@"";
    [self.view addSubview:self.profilepic];
    [self.sendMsg setEnabled:NO];
    [self.photobt setEnabled:NO];
    [self.locationbt setEnabled:NO];
    LocateEnable=NO;
    
    UIBarButtonItem *menu=[[UIBarButtonItem alloc]initWithTitle:@"Menu" style:UIBarButtonItemStyleBordered target:self action:@selector(hienMenu:)];
    self.navigationItem.leftBarButtonItem=menu;
    
    
    FBLoginView *loginview =
    [[FBLoginView alloc] initWithPermissions:[NSArray arrayWithObjects:@"user_about_me", @"user_activities",@"friends_activities",@"friends_status",@"publish_actions",@"read_stream",@"access_token",nil]];
    
    
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

    [self getLocation];
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
    [self.photobt setEnabled:YES];
    [self.locationbt setEnabled:YES];
   
    [self getUserInfo];
}

- (void)loginViewShowingLoggedOutUser:(FBLoginView *)loginView {
    self.profilepic.profileID=nil;
    self.usernamelb.text=@"name";
    [self.sendMsg setEnabled:NO];
}
-(void)getHomeTimeline{
    [FBRequestConnection startWithGraphPath:@"/me/home" completionHandler:^(FBRequestConnection *connection, id result, NSError *error) {
        NSLog(@"%@",result);
    }];
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
-(IBAction)hienMenu:(id)sender{
    NSLog(@"Hien menu");
    UIActionSheet *menu=[[UIActionSheet alloc]initWithTitle:@"Menu" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Friends",@"Wall",@"Home", nil];
    menu.tag=2;
    [menu showInView:self.view];
    
}
-(IBAction)getLocation:(id)sender{
    
    if (LocateEnable==YES) {
        FBPlacePickerViewController *placepick=[[FBPlacePickerViewController alloc]init];
        placepick.title=@"Where are you ? ";
        placepick.locationCoordinate=CLLocationCoordinate2DMake(toado.width, toado.height);
        [placepick loadData];
        placepick.radiusInMeters=1000;
        placepick.resultsLimit=30;
        placepick.searchText=@"restaurant";
        placepick.modalTransitionStyle=UIModalTransitionStyleCoverVertical;
        [placepick presentModallyFromViewController:self animated:YES handler:^(FBViewController *sender, BOOL donePressed) {
            if (donePressed) {
                self.userLocation=placepick.selection;
                NSLog(@"location name : %@",placepick.selection.name);
                NSLog(@"location ID %@",placepick.selection.id);
            }
            
        }];
    }
    else{
        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"Error" message:@"Can' t get location " delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
        [alert show];
    }
    
    

 
}
-(void)getLocation{
    
        CLLocationManager *location=[[CLLocationManager alloc]init];
        [location setDelegate:self];
        [location setDistanceFilter:kCLLocationAccuracyThreeKilometers];
        [location setDesiredAccuracy:kCLLocationAccuracyBest];
        
        [location startUpdatingLocation];
        
    
}
-(void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation{
    
    NSLog(@"toa do moi la  : %f %f",newLocation.coordinate.latitude,newLocation.coordinate.longitude);
    toado.width=(float)newLocation.coordinate.latitude;
    toado.height=(float)newLocation.coordinate.longitude;
    
    LocateEnable=YES;

}
-(void)checkin{
    [FBRequestConnection startForPostStatusUpdate:textField.text place:self.userLocation tags:nil completionHandler:^(FBRequestConnection *connection, id result, NSError *error) {
        [self showAlert:error];
    }];
}
-(IBAction)sendMsg:(id)sender{
    [textField resignFirstResponder];
    if (![textField.text isEqualToString:@""]) {
        
//        [FBRequestConnection startForPostStatusUpdate:textField.text place:self.userLocation tags:nil completionHandler:^(FBRequestConnection *connection, id result, NSError *error) {
//            [self showAlert:error];
//        }];
       
        
        
        NSString *url=[NSString stringWithFormat:@"/me/feed"];
        
        NSMutableDictionary *params=[[NSMutableDictionary alloc]init];
        [params setObject:[NSString stringWithFormat:@"%@",textField.text] forKey:@"message"];
        [params setObject:self.userLocation.id forKey:@"place"];
        
        
        
        //NSString *img=[NSString stringWithFormat:@"https://fbcdn-profile-a.akamaihd.net/hprofile-ak-prn1/41373_1204072167_477_n.jpg"];
        [params setObject:imgUpload.image forKey:@"source"];
//        if (imgUpload.image!=nil) {
//            [params setObject:imgUpload.image forKey:@"source"];
//            [url release];
//            url=[NSString stringWithFormat:@"/me/photos"];
//        }
//        else{
//            
//        }
        
        NSLog(@"params count :%d",[params count]);
        NSLog(@"url : %@",url);
            
            [FBRequestConnection startWithGraphPath:url parameters:params HTTPMethod:@"POST" completionHandler:^(FBRequestConnection *connection, id result, NSError *error) {
                [self showAlert:error];
            }];
   
    
  
    }
    else{
        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"Error" message:@"Message is empty" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
        [alert show];
    }
}
-(IBAction)dongTextField:(id)sender{
    [sender resignFirstResponder];
}
-(IBAction)takePhoto:(id)sender{
    UIActionSheet *action=[[UIActionSheet alloc]initWithTitle:@"Select" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Select on library",@"Select camera", nil];
    action.tag=1;
    [action showInView:self.view];
}

#pragma mark - alert
-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    NSLog(@" click %d",buttonIndex);
    
    if (actionSheet.tag==1) {
        
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
    else if(actionSheet.tag==2){
    
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
        [self.imgUpload setImage:nil];
        [self.textField setText:@""];
    }
}
@end
