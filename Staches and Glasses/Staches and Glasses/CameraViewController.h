//
//  CameraViewController.h
//  Staches and Glasses
//
//  Created by cheonhyang on 13-5-9.
//  Copyright (c) 2013年 Tianxiang Zhang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ALRadialMenu.h"
#import "PictureNavViewController.h"
#import "HomeNavViewController.h"
#import <Parse/Parse.h>
#import <Social/Social.h>
#import "EditViewController.h"
#import "SettingsViewController.h"
#import "Reachability.h"

@interface CameraViewController : UIViewController <ALRadialMenuDelegate, UIImagePickerControllerDelegate>


@property (weak, nonatomic) IBOutlet UIButton *takePicButton;
@property (weak, nonatomic) IBOutlet UIButton *homeButton;
@property (weak, nonatomic) IBOutlet UIImageView *photo;

@property (strong, nonatomic) ALRadialMenu *homemenu;
- (IBAction)buttonPressed:(id)sender;
@property (weak, nonatomic) IBOutlet UIView *photoView;
@property (nonatomic, strong) UIActivityIndicatorView *activityIn;
- (IBAction)editImage:(id)sender;
- (IBAction)saveImage:(id)sender;
- (IBAction)tweetImage:(id)sender;

- (IBAction)getCameraPicture:(id)sender;
 

@end
