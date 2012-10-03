//
//  ViewController.m
//  Facebook1
//
//  Created by Nghia on 10/1/12.
//  Copyright (c) 2012 Nghia. All rights reserved.
//

#import "ViewController.h"
#import "AppDelegate.h"
@interface ViewController ()
@property(strong,nonatomic) IBOutlet UIButton *buttonLoginLogout;

@property(strong, nonatomic) IBOutlet UILabel *username;
@property(strong, nonatomic) IBOutlet UILabel *genre;
@property(strong ,nonatomic) IBOutlet FBProfilePictureView *profilePic;
-(IBAction)buttonclick:(id)sender;
-(IBAction)homeclick:(id)sender;
-(void)updateView;
-(void)getData;
-(void)showAlert:(NSString *)msg;
@end

@implementation ViewController
@synthesize buttonLoginLogout,username,genre,profilePic,userdata,aboutMe;
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title=@"Facebook";
    
    self.profilePic=[[FBProfilePictureView alloc]initWithFrame:CGRectMake(12, 12, 96, 96)];
    self.profilePic.profileID=@"";
    [self.view addSubview:self.profilePic];
    [self updateView];
    
    
    AppDelegate *appdelegate=[UIApplication sharedApplication].delegate;
    if (!appdelegate.session.isOpen) {
        appdelegate.session=[[FBSession alloc]init];
        if (appdelegate.session.state==FBSessionStateCreatedTokenLoaded) {
            [appdelegate.session openWithCompletionHandler:^(FBSession *session, FBSessionState status, NSError *error) {
                [self updateView];
            }];
        }
    }

	// Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(IBAction)buttonclick:(id)sender{
    NSLog(@"button click");
    AppDelegate *appdelegate=[UIApplication sharedApplication].delegate;
    if (appdelegate.session.isOpen) {
        NSLog(@"session is opened");
        [appdelegate.session closeAndClearTokenInformation ];
        self.profilePic.profileID=@"";
        self.username.text=@"Name";
        self.genre.text=@"Genre";
    }
    else{
        NSLog(@"session is not open");
        AppDelegate *appdelegate=[UIApplication sharedApplication].delegate;
        if (appdelegate.session.state!=FBSessionStateCreated) {
            NSLog(@"if session is not created ,create");
            appdelegate.session = [[FBSession alloc] init];
        }
        [appdelegate.session openWithCompletionHandler:^(FBSession *session, FBSessionState status, NSError *error) {
            [self updateView];
            
        }];
    }
}
-(void)updateView{
    NSLog(@"updateView");
    AppDelegate *appdelegate=[[UIApplication sharedApplication]delegate];
    if (appdelegate.session.isOpen) {
        NSLog(@"da login voi access token la %@",appdelegate.session.accessToken);
        [self.buttonLoginLogout setTitle:@"Log out" forState:UIControlStateNormal];
        [self getData];
       
    }
    else{
        NSLog(@"Chua login");
        [self.buttonLoginLogout setTitle:@"Log in" forState:UIControlStateNormal];
       
        self.username.text=@"";
    }
}
-(IBAction)homeclick:(id)sender{
    NSLog(@"Show home");
}
-(void)getData{
    if (userdata) {
        [userdata release];
    }
    userdata=[[NSMutableData alloc]init];
    AppDelegate *appdelegate=[[UIApplication sharedApplication]delegate];
    NSURL *url=[NSURL URLWithString:[NSString stringWithFormat:@"https://graph.facebook.com/me?access_token=%@",appdelegate.session.accessToken]];
    NSMutableURLRequest *request=[[NSMutableURLRequest alloc]init];
    [request setURL:url];
    [request setHTTPMethod:@"GET"];
    NSURLConnection *conn=[[NSURLConnection alloc]initWithRequest:request delegate:self];
    if (conn) {
        NSLog(@"connect succes");
    }
    else{
        NSLog(@"connect error");
    }

}
#pragma mark  - nsurlconnection delegate
-(void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response{
    
    [userdata setLength:0];
}
-(void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data{

    [userdata appendData:data];
}
-(void)connectionDidFinishLoading:(NSURLConnection *)connection{
    
    NSString *data=[[NSString alloc]initWithData:userdata encoding:NSUTF8StringEncoding];
    NSLog(@"data receive : %@",data);
    if (aboutMe) {
        [aboutMe release];
    }
    aboutMe=[[[NSDictionary alloc]init]retain];
    
    NSError *jsonParsingErr;
    aboutMe=[[NSJSONSerialization JSONObjectWithData:userdata options:0 error:&jsonParsingErr]retain];
    NSLog(@" so phan tu  la %d",[aboutMe count]);
    
    NSString *userid=[aboutMe objectForKey:@"id"];
    NSString *name=[aboutMe objectForKey:@"name"];
    NSString *sex=[aboutMe objectForKey:@"gender"];
    //NSLog(@" UserID : %@",userid);
    //NSLog(@" Username : %@",name);
    if ([sex isEqualToString:@"male"]) {
        [self.genre setText:[NSString stringWithFormat:@"Male"]];
    }
    else{
        [self.genre setText:[NSString stringWithFormat:@"Female"]];
    }
    [self.username setText:[NSString stringWithFormat:@"%@",name ]];
    
     self.profilePic.profileID=userid;
    //NSJSONSerialization
}
-(void)showAlert:(NSString *)msg{
    UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"Alert" message:msg delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
    [alert show];
}
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    
}
-(void)dealloc{
    [super dealloc];
  
}
@end
