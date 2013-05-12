//
//  WelcomeViewController.h
//  Staches and Glasses
//
//  Created by cheonhyang on 13-5-11.
//  Copyright (c) 2013年 Tianxiang Zhang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>
#import "HomeNavViewController.h"
@interface WelcomeViewController : UIViewController<UITextFieldDelegate,UIAlertViewDelegate>
@property (weak, nonatomic) IBOutlet UITextField *usernameField;
@property (weak, nonatomic) IBOutlet UITextField *passwordField;
- (IBAction)goToHome:(id)sender;
@property (weak, nonatomic) IBOutlet UIImageView *backImage;

@property (weak, nonatomic) IBOutlet UIButton *goButton;
@property (nonatomic, strong) UIActivityIndicatorView *activityIn;

@end
