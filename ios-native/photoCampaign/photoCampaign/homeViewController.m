//
//  homeViewController.m
//  photoCampaign
//
//  Created by Dan Mindru on 10/05/14.
//  Copyright (c) 2014 Dan Mindru. All rights reserved.
//

#import "homeViewController.h"
#import "AFNetworking.h"
#import "statics.h"

@interface homeViewController (){
	NSMutableArray *loadedUserObject;
	NSMutableArray *loadedPostObjects;
}
@property (weak, nonatomic) IBOutlet UIBarButtonItem *accountButton;
@property (weak, nonatomic) IBOutlet UITableView *feedTableView;

@end

@implementation homeViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated{
	//read the user and change the text of the top left account button
	NSString *userPlistURL = [user getPlistURL];
	loadedUserObject = [user readFromPlist:userPlistURL];
	NSArray *allUserData = [loadedUserObject objectAtIndex:0];
	
	[self.accountButton setTitle:[[NSString alloc] initWithFormat:@"%@ %@", [allUserData valueForKey:@"firstName"], [allUserData valueForKey:@"lastName"]]];
	
	//load post data
		NSString *loginString = [[NSString alloc] initWithFormat:@"%@%@", REQUEST_URL, POST_FEED];
		
		AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
		NSDictionary *params = @{@"campaignObject":[allUserData valueForKey:@"campaign"]};
		
		[manager GET:loginString parameters:params
			  success:^(AFHTTPRequestOperation *operation, id responseObject) {
				 //save post data and then trigger child table view population method
				  for(NSArray* onePost in responseObject){
					  //instantiate post object
					  post* postToSave = [[post alloc] initWithId:[onePost valueForKey:@"_id"] andCampaignIdentifier:[[onePost valueForKey:@"campaignObject" ] valueForKey:@"identifier"] andTitle:[onePost valueForKey:@"title"] andDescription:[onePost valueForKey:@"description"]  andPhotoURL:[onePost valueForKey:@"photoURL"] andCreated:[onePost valueForKey:@"created"]];
					  
					  //get post url
					  NSString* postPlistURL = [post getPlistURL];
					  [postToSave saveToPlist:postPlistURL];
				  }
				  
				  [self reloadPostFeed];
				  
				  //log JSON response
				  NSLog(@"Campaign success JSON: %@", responseObject);
			  }
			  failure:^(AFHTTPRequestOperation *operation, NSError *error) {
				  UIAlertView *accountAlert = [[UIAlertView alloc] initWithTitle:@"Problem reading feed" message:@"Cannot read the campaign post feed. Please make sure there is an active internet connection" delegate:self cancelButtonTitle:@"Okay" otherButtonTitles:nil, nil];
				  
				  [accountAlert show];
				  
				  NSLog(@"Campaign feed Error: %@", error);
			  }
		 ];

}

#pragma mark - Table View methods
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
	return [loadedPostObjects count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
	static NSString *CellIdentifier = @"defaultPostCell";
	UITableViewCell *oneCell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
	
	post *currentPost = [loadedPostObjects objectAtIndex:indexPath.row];
	oneCell.textLabel.text = [currentPost title];
	
	return oneCell;
}

- (void) reloadPostFeed{
	//initialize the loaded posts array
	loadedPostObjects = [[NSMutableArray alloc] init];
	NSString *postURL = [post getPlistURL];
	loadedPostObjects = [post readFromPlist:postURL];
	
	//populate table view
	[self.feedTableView reloadData];
}

#pragma mark - Button actions

- (IBAction)touchAccountName:(id)sender {
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
