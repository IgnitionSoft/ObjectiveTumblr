//
//  IGMasterViewController.m
//  ObjectiveTumblr
//
//  Created by Chong Francis on 12年4月25日.
//  Copyright (c) 2012年 Ignition Soft Limited. All rights reserved.
//

#import "IGMasterViewController.h"

#import "IGDetailViewController.h"
#import "IGObjectiveTumblr.h"
#import "Constants.h"

@interface IGMasterViewController () {
    NSMutableArray *_objects;
}
@end

@implementation IGMasterViewController

@synthesize detailViewController = _detailViewController;
@synthesize tumblr = _tumblr;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = NSLocalizedString(@"Master", @"Master");
    }
    return self;
}
							
- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    self.navigationItem.leftBarButtonItem = self.editButtonItem;
    
    self.tumblr = [[IGObjectiveTumblr alloc] initWithConsumerKey:kTumblrConsumerKey secret:kTumblrConsumerSecret];
    self.tumblr.delegate = self;
    [self.tumblr authenticateWithUsername:kTumblrUsername password:kTumblrPassword];

    UIBarButtonItem *addButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(insertNewObject:)];
    self.navigationItem.rightBarButtonItem = addButton;
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}

- (void)insertNewObject:(id)sender
{
    if (!_objects) {
        _objects = [[NSMutableArray alloc] init];
    }
    [_objects insertObject:[NSDate date] atIndex:0];
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    [self.tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
}

#pragma mark - Table View

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _objects.count;
}

// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }


    NSDate *object = [_objects objectAtIndex:indexPath.row];
    cell.textLabel.text = [object description];
    return cell;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        [_objects removeObjectAtIndex:indexPath.row];
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view.
    }
}

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

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (!self.detailViewController) {
        self.detailViewController = [[IGDetailViewController alloc] initWithNibName:@"IGDetailViewController" bundle:nil];
    }
    NSDate *object = [_objects objectAtIndex:indexPath.row];
    self.detailViewController.detailItem = object;
    [self.navigationController pushViewController:self.detailViewController animated:YES];
}

#pragma mark - 

-(void) tumblr:(IGObjectiveTumblr*)tumblr didFinishAuthenticationWithToken:(NSString *)token secret:(NSString *)secret{
    NSLog(@"auth ok: %@", token);
    [tumblr userInfo];
}

-(void) tumblr:(IGObjectiveTumblr*)tumblr didFinishUserInfo:(IGUser*)user {
    NSLog(@"did finish user info: %@", user);
    
//    IGPhotoPost* post = [[IGPhotoPost alloc] init];
//    post.source = @"http://desmond.yfrog.com/Himg863/scaled.php?tn=0&server=863&filename=l74hd.jpg&xsize=640&ysize=640";
//    post.link = @"http://yfrog.com/nzl74hdj";
//    [tumblr createPostWithHostName:@"siuying-testing.tumblr.com" post:post];
    
    IGTextPost* post = [[IGTextPost alloc] init];
    post.markdown = YES;
    post.title = @"Hello World Test";
    post.body  = @"## Header\nFoo **Bar** \n_World_!!\n\n- 1\n- 2\n- 3";
    [tumblr createPostWithHostName:@"siuying-testing.tumblr.com" post:post];
}

-(void) tumblr:(IGObjectiveTumblr*)tumblr didFailUserInfoWithError:(NSError*)error {
    NSLog(@"did finish error: %@", error);
}

@end
