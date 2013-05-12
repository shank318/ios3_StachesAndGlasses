//
//  WelcomeViewController.m
//  Staches and Glasses
//
//  Created by cheonhyang on 13-5-11.
//  Copyright (c) 2013年 Tianxiang Zhang. All rights reserved.
//

#import "WelcomeViewController.h"

@interface WelcomeViewController ()

@end

@implementation WelcomeViewController

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
    
    //set up the UIActivityIndicatorView
    self.activityIn = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    CGPoint newCenter = self.view.center;
    newCenter.y -= 100;
    self.activityIn.center = newCenter;
    [self.view addSubview:self.activityIn];
    
    //set the textfields' delegate to this controller
    self.usernameField.delegate = self;
    self.passwordField.delegate = self;
    
    //add tap gesture on the background image
    //so user tap on it and dismiss the keyboard
    UITapGestureRecognizer *tges = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapBackground)];
    [self.backImage addGestureRecognizer:tges];
    self.backImage.userInteractionEnabled = YES;    
   
    
    //check for userdefault
    //if user has already logged in  just go to the HomePage of the app
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *username = [defaults objectForKey:@"stachesUser"];
    NSLog(@"Got username is :%@", username);
    if ([username length]>0){
        NSLog(@"present home");
        self.usernameField.hidden = YES;
        self.passwordField.hidden = YES;
        [self performSelector:@selector(gotoHomeNavController) withObject:nil afterDelay:0.5f];
    }
    else{
        
    }
    
    
}

-(void) gotoHomeNavController{
    //here we go to HomeNavViewController instead of just HomeViewController
    //this is to ensure the navigation bar in that view controller
    HomeNavViewController * hvc = [[self storyboard] instantiateViewControllerWithIdentifier:@"homenav"];
    [self presentViewController:hvc animated:YES completion:^(void){}];
    
}

//when user tap on background dismiss the keyboard
-(void) tapBackground{
    [self.usernameField resignFirstResponder];
    [self.passwordField resignFirstResponder];
}

//actions when user hit return button on keyboard
-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    if (textField == self.usernameField){
        //if we are in username field we need to go to next field
        [self.usernameField resignFirstResponder];
        [self.passwordField becomeFirstResponder];
    }
    else{
        [self.passwordField resignFirstResponder];
    }
    return YES;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//action taken when user clicked on the go button in the center
- (IBAction)goToHome:(id)sender {
    //if any of the username or password is blank  show the alert
    if ([self.usernameField.text length] == 0 || [self.passwordField.text length] == 0){
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Need more information" message:@"Both username and password can't be blank" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
    }
    
    
    else{
        NSString *username = self.usernameField.text;
        NSString *password = self.passwordField.text;
        [PFUser logInWithUsernameInBackground:username password:password block:
            ^(PFUser *user, NSError *error) {
            //if user information corrected
            if (user){
                NSLog(@"Log in");
                NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
                [defaults setObject:user.username forKey:@"stachesUser"];
                HomeNavViewController *hnvc = [[self storyboard] instantiateViewControllerWithIdentifier:@"homenav"];
                [self presentViewController:hnvc animated:YES completion:^{}];
                
            }
            //if not correct or just want to register a new user account
            else{
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"What do you mean" message:@"Username or password not correct, or you want to register a new account with those information?" delegate:self cancelButtonTitle:@"Retry" otherButtonTitles:@"Register", nil];
                [alert show];
                NSLog(@"Error is : %@", error);
            }
        }];
    }
}

//when user clicked on register button
//we should create new account using the information in the textfield
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex == 1){
//        NSLog(@"Clicked on register");
        PFUser *user = [PFUser user];
        user.username = self.usernameField.text;
        user.password = self.passwordField.text;
        [user signUpInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
            if (!error){
                NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
                [defaults setObject:user.username forKey:@"stachesUser"];
//                NSLog(@"THe default is :%@", [defaults dictionaryRepresentation]);
                HomeNavViewController *hnvc = [[self storyboard] instantiateViewControllerWithIdentifier:@"homenav"];
                [self presentViewController:hnvc animated:YES completion:^{
                   
                }];
                // new user has registered
                
            }
            else{
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"An error occured" message:@"User register failed, please try again." delegate:self cancelButtonTitle:@"Retry" otherButtonTitles:nil, nil];
                [alert show];
            }
        }];
    }
}

@end
