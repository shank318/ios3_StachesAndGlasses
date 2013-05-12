//
//  SettingsViewController.m
//  Staches and Glasses
//
//  Created by cheonhyang on 13-5-12.
//  Copyright (c) 2013年 Tianxiang Zhang. All rights reserved.
//

#import "SettingsViewController.h"

@interface SettingsViewController ()

@end

@implementation SettingsViewController

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
    //get current user name
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *username = [defaults objectForKey:@"stachesUser"];
    self.usernameText.text = username;
    
    //init path style menu
    self.homemenu = [[ALRadialMenu alloc] init];
    [self.homemenu setButtonSize:50.0f];
    self.homemenu.delegate = self;
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

//click on the log out button 
- (IBAction)logout:(id)sender {
    //clear the username in userdefaults and go to the log in page -- WelcomeViewController     
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:@"" forKey:@"stachesUser"];
    
    WelcomeViewController *wvc = [[self storyboard] instantiateViewControllerWithIdentifier:@"welcome"];
    [self presentViewController:wvc animated:YES completion:^{
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
    if (index == 1){
        [self.homemenu buttonsWillAnimateFromButton:self.homeButton withFrame:self.homeButton.frame inView:self.view];
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
        HomeNavViewController * hvc = [[self storyboard] instantiateViewControllerWithIdentifier:@"homenav"];
        
        
        [self presentViewController:hvc animated:YES completion:^(void){
        }];
        
    }
}





@end
