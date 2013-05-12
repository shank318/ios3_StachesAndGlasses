//
//  PictureViewController.h
//  Staches and Glasses
//
//  Created by cheonhyang on 13-5-10.
//  Copyright (c) 2013年 Tianxiang Zhang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ALRadialMenu.h"
#import "HomeNavViewController.h"
#import "CameraNavViewController.h"
#import "EditViewController.h"
#import "SettingsViewController.h"
#import <Parse/Parse.h>
#import <Social/Social.h>

@interface PictureViewController : UIViewController<ALRadialMenuDelegate>
- (IBAction)selectPic:(id)sender;
@property (strong, nonatomic) ALRadialMenu *homemenu;
@property (weak, nonatomic) IBOutlet UIButton *homeButton;
- (IBAction)buttonPressed:(id)sender;
- (IBAction)tweetImage:(id)sender;
- (IBAction)editImage:(id)sender;
@property (weak, nonatomic) IBOutlet UIImageView *photo;
@end
