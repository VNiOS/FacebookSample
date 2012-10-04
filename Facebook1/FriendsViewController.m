//
//  FriendsViewController.m
//  Facebook1
//
//  Created by Nghia on 10/4/12.
//  Copyright (c) 2012 Nghia. All rights reserved.
//

#import "FriendsViewController.h"
#import "AppDelegate.h"
#import <FacebookSDK/FacebookSDK.h>
#import "FriendViewCell.h"

@interface FriendsViewController ()

-(void)getdata;

@end

@implementation FriendsViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self getData];
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - Get data

-(void)getData{
        if (frienddata) {
            [frienddata release];
        }
        frienddata=[[NSMutableData alloc]init];
        AppDelegate *appdelegate=[[UIApplication sharedApplication]delegate];
        NSURL *url=[NSURL URLWithString:[NSString stringWithFormat:@"https://graph.facebook.com/me/friends?access_token=%@",appdelegate.session.accessToken]];
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
        
        [frienddata setLength:0];
    }
-(void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data{
        
        [frienddata appendData:data];
    }
-(void)connectionDidFinishLoading:(NSURLConnection *)connection{
        
        NSString *data=[[NSString alloc]initWithData:frienddata encoding:NSUTF8StringEncoding];
        NSLog(@"data receive : %@",data);
     
        NSDictionary *dic=[[[NSDictionary alloc]init]retain];
        
        NSError *jsonParsingErr;
        dic=[[NSJSONSerialization JSONObjectWithData:frienddata options:0 error:&jsonParsingErr]retain];
        NSLog(@" so phan tu cua dic  la %d",[dic count]);
    if (friendlist) {
        [friendlist release];
    }
    friendlist=[[NSArray alloc]initWithArray:(NSArray *)[dic objectForKey:@"data"] ];
    NSLog(@"so friends : %d",[friendlist count]);
    [self.tableView reloadData];
        //NSJSONSerialization
    }




#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{

    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{

    // Return the number of rows in the section.
    return [friendlist count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    FriendViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[FriendViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
    }
    NSDictionary *dic=(NSDictionary *)[friendlist objectAtIndex:indexPath.row];
    cell.profilepic.profileID=[dic objectForKey:@"id"];
    cell.fname.text=[dic objectForKey:@"name"];
    
    // Configure the cell...
    
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 50;
}
/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Navigation logic may go here. Create and push another view controller.
    /*
     <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
     // ...
     // Pass the selected object to the new view controller.
     [self.navigationController pushViewController:detailViewController animated:YES];
     [detailViewController release];
     */
}

@end
