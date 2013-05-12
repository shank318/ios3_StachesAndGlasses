//
//  EditViewController.h
//  Staches and Glasses
//
//  Created by cheonhyang on 13-5-10.
//  Copyright (c) 2013年 Tianxiang Zhang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIImageFiltrrCompositions.h"
#import <QuartzCore/QuartzCore.h>
#import <Social/Social.h>
#import <Parse/Parse.h>
#import "PaintView.h"
#import "Reachability.h"

@interface EditViewController : UIViewController <PaintViewDelegate>{
    NSMutableArray *arrEffects;
    NSMutableArray *arrFilterImg;
}
@property (nonatomic, strong) UIActivityIndicatorView * activityIn;
@property (weak, nonatomic) IBOutlet UIImageView *photo;
- (IBAction)saveImage:(id)sender;
- (IBAction)tweetImage:(id)sender;
- (IBAction)eraseDrawing:(id)sender;
@property (nonatomic, strong) UIImage *originalImage;
@property (weak, nonatomic) IBOutlet UIScrollView *filters;
@property (nonatomic, strong) UIImage *thumbnailImage;
@end
