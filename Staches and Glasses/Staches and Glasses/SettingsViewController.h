//
//  SettingsViewController.h
//  Staches and Glasses
//
//  Created by cheonhyang on 13-5-12.
//  Copyright (c) 2013年 Tianxiang Zhang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ALRadialMenu.h"
#import "HomeNavViewController.h"
#import "CameraNavViewController.h"
#import "PictureNavViewController.h"
#import "WelcomeViewController.h"

@interface SettingsViewController : UIViewController<ALRadialMenuDelegate>
- (IBAction)logout:(id)sender;

@property (weak, nonatomic) IBOutlet UILabel *usernameText;
@property (strong, nonatomic) ALRadialMenu *homemenu;
@property (weak, nonatomic) IBOutlet UIButton *homeButton;
- (IBAction)buttonPressed:(id)sender;

@end
