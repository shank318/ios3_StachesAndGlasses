//
//  HomeViewController.h
//  Staches and Glasses
//
//  Created by cheonhyang on 13-5-9.
//  Copyright (c) 2013年 Tianxiang Zhang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ALRadialMenu.h"
#import <Parse/Parse.h>
#import "PicCell.h"
#import "CameraNavViewController.h"
#import "PictureNavViewController.h"
#import "SettingsViewController.h"
#import <Social/Social.h>
#import "Reachability.h"


@interface HomeViewController : UIViewController
<ALRadialMenuDelegate, UITableViewDataSource, UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableview;
@property (weak, nonatomic) IBOutlet UIButton *homeButton;
@property (strong, nonatomic) ALRadialMenu *homemenu;
@property (nonatomic) int opCell;
@property (nonatomic) NSString *username;
- (IBAction)tweetImage:(id)sender;
- (IBAction)deleteImage:(id)sender;

@property (nonatomic, strong) UIActivityIndicatorView *activityIn;
@property (strong,nonatomic) NSMutableArray * pictures;

- (IBAction)buttonPressed:(id)sender;
@end
