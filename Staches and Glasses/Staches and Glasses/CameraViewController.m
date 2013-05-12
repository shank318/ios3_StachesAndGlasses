//
//  CameraViewController.m
//  Staches and Glasses
//
//  Created by cheonhyang on 13-5-9.
//  Copyright (c) 2013年 Tianxiang Zhang. All rights reserved.
//

#import "CameraViewController.h"

@interface CameraViewController ()

@end

@implementation CameraViewController

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
    
    //set up UIActivityIndicatorView
    self.activityIn = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    CGPoint newCenter = self.view.center;
    newCenter.y -= 100;
    self.activityIn.center = newCenter;
    [self.view addSubview:self.activityIn];
    //path Style menu
    self.homemenu = [[ALRadialMenu alloc] init];
    [self.homemenu setButtonSize:50.0f];
    self.homemenu.delegate = self;
    
    //if no camera is available  do not show the takePicButton
    if (![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]){
        self.takePicButton.hidden = YES;
    }
    
    
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



#pragma mark - on screen buttons
//send tweet with current image
- (IBAction)tweetImage:(id)sender {
    
    if (self.photo.image == nil){
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"No image" message:@"No image has been taken" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
    }
    else{
    
        if ([SLComposeViewController isAvailableForServiceType:SLServiceTypeTwitter]){
            SLComposeViewController *tweetSheet = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeTwitter];
            [tweetSheet setInitialText:@""];
            [tweetSheet addImage:self.photo.image];
            [self presentViewController: tweetSheet animated:YES completion:nil];
        }
    }
}
//go to the edit page
- (IBAction)editImage:(id)sender {
    
    if (self.photo.image == nil){
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"No image" message:@"No image has been taken" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
    }
    else{
        EditViewController *evc = [[self storyboard] instantiateViewControllerWithIdentifier:@"edit"];
        evc.originalImage = self.photo.image;
        [self.navigationController pushViewController:evc animated:YES];
    }
}
//save the current image
- (IBAction)saveImage:(id)sender {
    if (self.photo.image == nil){
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"No image" message:@"No image has been taken" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
    }
    else{
        UIImageWriteToSavedPhotosAlbum(self.photo.image, nil, nil, nil);
  
        PFObject *pictures = [PFObject objectWithClassName:@"Picture"];
        PFFile *imageFile = [PFFile fileWithData: UIImagePNGRepresentation(self.photo.image)];
        [pictures setObject: imageFile forKey:@"pic" ];
        [pictures setObject: @"" forKey:@"tag" ];
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        NSString *tmpStr = [defaults objectForKey:@"stachesUser"];
        [pictures setObject: tmpStr forKey:@"user"];

        [self.activityIn startAnimating];
        [pictures saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error){
            
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Save image" message:@"Your image has been saved" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            [self.activityIn stopAnimating];
            [alert show];
        }
         ];
    }
}
//actions taken when user clicked on the Camera button
- (IBAction)getCameraPicture:(id)sender{
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.delegate = self;
    picker.allowsEditing = YES;
    picker.sourceType = (sender == self.takePicButton) ?
    UIImagePickerControllerSourceTypeCamera: UIImagePickerControllerSourceTypeSavedPhotosAlbum;
    [self presentViewController:picker animated:YES completion:^(void){}];
    
}

#pragma mark - camera delegate
- (void) imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
//    NSLog(@"The result is %@",info);
    self.photo.image = [info objectForKey:@"UIImagePickerControllerEditedImage"];
    [self dismissViewControllerAnimated:YES completion:^{}];
}


#pragma mark - path menu delegate
- (IBAction)buttonPressed:(id)sender {
    NSLog(@"Home button clicked");
	[self.homemenu buttonsWillAnimateFromButton:sender withFrame:self.homeButton.frame inView:self.view];
    NSLog(@"After the call");
    
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
        
        [self.homemenu buttonsWillAnimateFromButton:self.homeButton withFrame:self.homeButton.frame inView:self.view];
    } else if (index == 4) {
        NSLog(@"home clicked");
        HomeNavViewController * hvc = [[self storyboard] instantiateViewControllerWithIdentifier:@"homenav"];
        
        
        [self presentViewController:hvc animated:YES completion:^(void){
        }];
        
    }
    
    
}




@end
