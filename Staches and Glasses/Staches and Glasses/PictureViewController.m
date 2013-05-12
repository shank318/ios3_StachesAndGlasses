//
//  PictureViewController.m
//  Staches and Glasses
//
//  Created by cheonhyang on 13-5-10.
//  Copyright (c) 2013年 Tianxiang Zhang. All rights reserved.
//

#import "PictureViewController.h"

@interface PictureViewController ()

@end

@implementation PictureViewController

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
    
    //path style menu
    self.homemenu = [[ALRadialMenu alloc] init];
    [self.homemenu setButtonSize:50.0f];
    self.homemenu.delegate = self;
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - path menu delegate
- (IBAction)buttonPressed:(id)sender {
	[self.homemenu buttonsWillAnimateFromButton:sender withFrame:self.homeButton.frame inView:self.view];
}
#pragma mark - on screen buttons
//send tweet with current image
- (IBAction)tweetImage:(id)sender {
    if (self.photo.image == nil){
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"No image" message:@"No image has been selected" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
    }
    else{
        if ([SLComposeViewController isAvailableForServiceType:SLServiceTypeTwitter]){
            SLComposeViewController *tweetSheet = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeTwitter];
            [tweetSheet addImage:self.photo.image];
            [self presentViewController: tweetSheet animated:YES completion:nil];
        }
    }
}

- (IBAction)editImage:(id)sender {
    if (self.photo.image == nil){
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"No image" message:@"No image has been selected" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
    }
    else{
        EditViewController *evc = [[self storyboard] instantiateViewControllerWithIdentifier:@"edit"];
        evc.originalImage = self.photo.image;
        [self.navigationController pushViewController:evc animated:YES];
    }
}

//select image from local photo library
- (IBAction)selectPic:(id)sender {
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]){
        UIImagePickerController *picker = [[UIImagePickerController alloc]init];
        picker.delegate = self;
        picker.allowsEditing = YES;
        picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        [self presentViewController:picker animated:YES completion:^(void){}];
    }
    else{
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Device does not support photo library" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil , nil];
        [alert show];
    }
    
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
        
        [self.homemenu buttonsWillAnimateFromButton:self.homeButton withFrame:self.homeButton.frame inView:self.view];
        NSLog(@"picture");
    } else if (index == 3) {
        NSLog(@"camera clicked");
        CameraNavViewController * cvc = [[self storyboard] instantiateViewControllerWithIdentifier:@"cameranav"];
        
        
        [self presentViewController:cvc animated:YES completion:^(void){
        }];
    } else if (index == 4) {
        HomeNavViewController * hvc = [[self storyboard] instantiateViewControllerWithIdentifier:@"homenav"];
        
        
        [self presentViewController:hvc animated:YES completion:^(void){
        }];
        NSLog(@"Home clicked");
    }
       
}


#pragma mark - imagedelegate
- (void) imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
    //    NSLog(@"The result is %@",info);
    self.photo.image = [info objectForKey:@"UIImagePickerControllerEditedImage"];
    [self dismissViewControllerAnimated:YES completion:^{}];
}

@end
