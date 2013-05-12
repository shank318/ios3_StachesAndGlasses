//
//  HomeViewController.m
//  Staches and Glasses
//
//  Created by cheonhyang on 13-5-9.
//  Copyright (c) 2013年 Tianxiang Zhang. All rights reserved.
//

#import "HomeViewController.h"

@interface HomeViewController ()

@end

@implementation HomeViewController

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
    [self checkInternet];
    
    //path style menu
    self.homemenu = [[ALRadialMenu alloc] init];
    [self.homemenu setButtonSize:50.0f];
    self.homemenu.delegate = self;
    
    //init the operating cell
    self.opCell = -1;
    
    //set up activityIndicator
    self.activityIn = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    CGPoint newCenter = self.view.center;
    newCenter.y -= 100;
    self.activityIn.center = newCenter;
    [self.view addSubview:self.activityIn];
    
    //get current logged in user name
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    self.username = [defaults objectForKey:@"stachesUser"];
    NSString *usernameTitle = [NSString stringWithFormat:@"%@'s photos", self.username];
    self.title = usernameTitle;
    
     [self updateTableData];
    
}
//check if internet is available
-(void) checkInternet{
    Reachability *network = [Reachability reachabilityForInternetConnection];
    NetworkStatus newtworkStatus = [network currentReachabilityStatus];
    if (newtworkStatus == NotReachable){
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Oops" message:@"It seems you have no connection to the internet" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [self.activityIn stopAnimating];
        [alert show];
    }

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - table view delegate method
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [self.pictures count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    PicCell *cell = [tableView dequeueReusableCellWithIdentifier:@"PicCell"forIndexPath:indexPath];
//    NSLog(@"Fill the cell with %@ and cell id is %@",indexPath, cell);
    PFFile *imagefile = [[self.pictures objectAtIndex:indexPath.row] objectForKey:@"pic"];
    NSData *data = [imagefile getData];
    UIImage *image = [UIImage imageWithData:data];
    cell.pic.image = image;
    cell.tag = indexPath.row + 200;
    
    UISwipeGestureRecognizer *sges = [[UISwipeGestureRecognizer alloc] initWithTarget:self action: @selector(SwipeCell:)];
    [sges setDirection:UISwipeGestureRecognizerDirectionRight];
    [cell addGestureRecognizer:sges];
    
//    NSLog(@"now the tag is %d and opCell is %d", cell.tag, self.opCell);
    
    if (cell.tag == self.opCell + 200){
        cell.pic.hidden = YES;
        cell.pic.alpha = 0;
    }
    else{
        cell.pic.hidden = NO;
        cell.pic.alpha = 1;
    }
//    NSLog(@"The pic is : %@", cell.pic);
    
    return cell;
}
//when user swipe the cell
//show or hide the two buttons 
-(void)SwipeCell: (UISwipeGestureRecognizer *) swipeG{
    PicCell *cell = swipeG.view;
    if (self.opCell>=0){
        if (self.opCell == cell.tag - 200){
            //Undo the hide
            self.opCell = -1;
            cell.pic.hidden = NO;
            cell.pic.alpha = 0;
            [UIView animateWithDuration:0.3f animations:^(void){
                cell.pic.alpha = 1;
            }completion:^(BOOL completed){
                
            }];
            
        }
        else{
            //got a new cell
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:self.opCell inSection:0];
            PicCell *oldCell = (PicCell *)[self.tableview cellForRowAtIndexPath:indexPath];
            
            oldCell.pic.hidden = NO;
            oldCell.pic.alpha = 0;
            [UIView animateWithDuration:0.3f animations:^(void){
                oldCell.pic.alpha = 1;
            }completion:^(BOOL completed){
                
            }];
            
            
            cell.pic.alpha = 1;
            [UIView animateWithDuration:0.3f animations:^(void){
                cell.pic.alpha = 0;
            }completion:^(BOOL completed){
                cell.pic.hidden = YES;
            }];          
            
            self.opCell = cell.tag - 200;
            
        }
    }
    else{
        cell.pic.alpha = 1;
        [UIView animateWithDuration:0.3f animations:^(void){
            cell.pic.alpha = 0;
        }completion:^(BOOL completed){
            cell.pic.hidden = YES;
        }];
        
        
        self.opCell = cell.tag - 200;
    }
}


-(void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
  
}

#pragma mark -update data for data of tableview
- (void)updateTableData{
    PFQuery *query = [PFQuery queryWithClassName:@"Picture"];
    [query whereKey:@"user" equalTo:self.username];
    [query orderByAscending:@"createdAt"];
    [self.activityIn startAnimating];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error){
        self.pictures = objects;
        [self.tableview reloadData];
        [self.activityIn stopAnimating];
    }];
}

#pragma mark - path menu delegate 
- (IBAction)buttonPressed:(id)sender {
	[self.homemenu buttonsWillAnimateFromButton:sender withFrame:self.homeButton.frame inView:self.view];

}



#pragma mark - radial menu delegate methods
- (NSInteger) numberOfItemsInRadialMenu:(ALRadialMenu *)radialMenu {
		return 4;
}


- (NSInteger) arcSizeForRadialMenu:(ALRadialMenu *)radialMenu {
		return -180;
	
}


- (NSInteger) arcRadiusForRadialMenu:(ALRadialMenu *)radialMenu {
		return 60;

}


- (UIImage *) radialMenu:(ALRadialMenu *)radialMenu imageForIndex:(NSInteger) index {
        if(index == 1){
            return [UIImage imageNamed:@"buttonSettingsBorder"];
        }
		else if (index == 2) {
			return [UIImage imageNamed:@"buttonPictureBorder"];
		} else if (index == 3) {
            
			return [UIImage imageNamed:@"buttonCameraBorder"];
            
		} else if (index == 4) {
			return [UIImage imageNamed:@"buttonHomeBorder"];
		}
	
	
	return nil;
}


- (void) radialMenu:(ALRadialMenu *)radialMenu didSelectItemAtIndex:(NSInteger)index {
	
		//[self.homemenu itemsWillDisapearIntoButton:self.homeButton];
        if (index == 1){
            SettingsViewController *svc = [[self storyboard] instantiateViewControllerWithIdentifier:@"settings"];
            [self presentViewController:svc animated:YES completion:^{
                
            }];
        }
		else if (index == 2) {
			NSLog(@"picture clicked");
            PictureNavViewController *pvc = [[self storyboard] instantiateViewControllerWithIdentifier:@"picnav"];
            [self presentViewController:pvc animated:YES completion:^(void){}];
		} else if (index == 3) {
            NSLog(@"camera clicked");

            CameraNavViewController * cvc = [[self storyboard] instantiateViewControllerWithIdentifier:@"cameranav"];
            [self presentViewController:cvc animated:YES completion:^(void){
            }];
		} else if (index == 4) {
			NSLog(@"home clicked");
            
            [self.homemenu buttonsWillAnimateFromButton:self.homeButton withFrame:self.homeButton.frame inView:self.view];
		}

    
}

#pragma mark - on Screen Buttons 
- (IBAction)tweetImage:(id)sender {
    if ([SLComposeViewController isAvailableForServiceType:SLServiceTypeTwitter]){
        SLComposeViewController *tweetSheet = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeTwitter];
        [tweetSheet setInitialText:@""];
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:self.opCell inSection:0];
        PicCell *cell = (PicCell *)[self.tableview cellForRowAtIndexPath:indexPath];
        [tweetSheet addImage:cell.pic.image];
        [self presentViewController: tweetSheet animated:YES completion:nil];
    }
    
    
}

- (IBAction)deleteImage:(id)sender{
    PFObject *object = [self.pictures objectAtIndex:self.opCell];
    [self.activityIn startAnimating];
    [object deleteInBackgroundWithBlock:^(BOOL succeeded, NSError * error){
        
        [self.activityIn stopAnimating];
        [self.pictures removeObjectAtIndex:self.opCell];
        self.opCell = -1;
        [self.tableview reloadData];
        
    }];
}
@end
