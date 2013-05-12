//
//  EditViewController.m
//  Staches and Glasses
//
//  Created by cheonhyang on 13-5-10.
//  Copyright (c) 2013年 Tianxiang Zhang. All rights reserved.
//

#import "EditViewController.h"
#import "UIImageFiltrrCompositions.h"

@interface EditViewController ()

@property BOOL shouldMerge;
@property (strong, nonatomic) PaintView *paintView;
@end

@implementation EditViewController

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
	// Do any additional setup after loading the view.
    
    self.photo.image = self.originalImage;
    
    //generate the thumbnail images
    CGSize tinySize = CGSizeMake(70.0f, 70.0f);
    UIGraphicsBeginImageContext(tinySize);
    [self.originalImage drawInRect:CGRectMake(0, 0, tinySize.width, tinySize.height)];
    self.thumbnailImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    
    self.filters.contentSize = CGSizeMake(800, 100);
    
    
    //init all the filters' information
    arrEffects = [[NSMutableArray alloc] initWithObjects:[NSDictionary dictionaryWithObjectsAndKeys:@"Original",@"title",@"",@"method", nil],
                  [NSDictionary dictionaryWithObjectsAndKeys:@"e1",@"title",@"e1",@"method", nil],                  
                  [NSDictionary dictionaryWithObjectsAndKeys:@"e2",@"title",@"e2",@"method", nil],
                  [NSDictionary dictionaryWithObjectsAndKeys:@"e3",@"title",@"e3",@"method", nil],
                  [NSDictionary dictionaryWithObjectsAndKeys:@"e4",@"title",@"e4",@"method", nil],
                  [NSDictionary dictionaryWithObjectsAndKeys:@"e5",@"title",@"e5",@"method", nil],
                  [NSDictionary dictionaryWithObjectsAndKeys:@"e6",@"title",@"e6",@"method", nil],
                  [NSDictionary dictionaryWithObjectsAndKeys:@"e7",@"title",@"e7",@"method", nil],
                  [NSDictionary dictionaryWithObjectsAndKeys:@"e8",@"title",@"e10",@"method", nil],
                  [NSDictionary dictionaryWithObjectsAndKeys:@"e9",@"title",@"e11",@"method", nil],
                  nil];
    
    [self addImageFilers];
    
    //set up UIActivityIndicatorView inforamtion
    self.activityIn = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    CGPoint newCenter = self.view.center;
    newCenter.y -= 100;
    self.activityIn.center = newCenter;
    [self.view addSubview:self.activityIn];
    
    
    //Paint part
    _paintView = [[PaintView alloc] initWithFrame:CGRectMake(10, 10, 300, 300)];
    self.paintView.lineColor = [UIColor grayColor];
    self.paintView.delegate = self;
    [self.view addSubview:self.paintView];
    
    self.shouldMerge = YES;
}
// check if internet is available
-(void) checkInternet{
    Reachability *network = [Reachability reachabilityForInternetConnection];
    NetworkStatus newtworkStatus = [network currentReachabilityStatus];
    if (newtworkStatus == NotReachable){
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Oops" message:@"It seems you have no connection to the internet" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [self.activityIn stopAnimating];
        [alert show];
    }
    
}

//perform all the filters to the thumbnail images
-(void) addImageFilers{
    arrFilterImg = [[NSMutableArray alloc] init];
    for (int i = 0; i < [arrEffects count] ; i++){
        UIImage *tmpImage;
        UIButton *button;
        if(((NSString *)[[arrEffects objectAtIndex:i] valueForKey:@"method"]).length > 0) {
            SEL _selector = NSSelectorFromString([[arrEffects objectAtIndex:i] valueForKey:@"method"]);                @try{
                    tmpImage = [self.thumbnailImage performSelector:_selector];
                }
                @catch (NSException *e) {
                    NSLog(@"Can't find selector");
                    tmpImage = self.thumbnailImage;    
                }
        } else
        {
            tmpImage = self.thumbnailImage;
        }
        
        //generate the button
        //here use button to show the filtered images
        button = [[UIButton alloc] init];
        [button setImage:tmpImage forState:UIControlStateNormal];
        [button setFrame:CGRectMake(5+i*80, 5, 70, 70)];
        [button setTag:(200 + i)];
        [button addTarget:self action:@selector(filterButtonPressed:) forControlEvents:UIControlEventTouchDown];
        
        //generate label to show the name of the corresponding filters
        UILabel *tmpLabel = [[UILabel alloc] init];
        tmpLabel.text = [[arrEffects objectAtIndex:i] valueForKey:@"title"];
        tmpLabel.textAlignment = NSTextAlignmentCenter;
        [tmpLabel setFrame:CGRectMake(5+i*80, 80, 70, 20)];
        UIColor *myPurple = [UIColor colorWithRed:49.0/255.0f green:45.0/255.0f blue:196.0/255.0f alpha:1];
        [tmpLabel setBackgroundColor:myPurple];
        [tmpLabel setTextColor:[UIColor whiteColor]];
        [self.filters addSubview:tmpLabel];
        [self.filters addSubview:button];
    }
}


- (void)paintView:(PaintView*)paintView finishedTrackingPath:(CGPathRef)path inRect:(CGRect)painted
{
    
}

//merge the drawing part to the image
- (void)mergePaintToBackgroundView:(CGRect)painted
{
    // Create a new offscreen buffer that will be the UIImageView's image
    CGRect bounds = self.photo.bounds;
    UIGraphicsBeginImageContextWithOptions(bounds.size, NO, self.photo.contentScaleFactor);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    // Copy the previous background into that buffer.  Calling CALayer's renderInContext: will redraw the view if necessary
    CGContextSetBlendMode(context, kCGBlendModeCopy);
    [self.photo.layer renderInContext:context];
    
    // Now copy the painted contect from the paint view into our background image
    // and clear the paint view.  as an optimization we set the clip area so that we only copy the area of paint view
    // that was actually painted
    CGContextClipToRect(context, painted);
    CGContextSetBlendMode(context, kCGBlendModeNormal);
    [self.paintView.layer renderInContext:context];
    [self.paintView erase];
    
    // Create UIImage from the context
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    self.photo.image = image;
    UIGraphicsEndImageContext();
    
#ifdef PERFORMANCE3
    // Save the image to the photolibrary
    NSData *data = UIImagePNGRepresentation(image);
    UIImageWriteToSavedPhotosAlbum([UIImage imageWithData:data], nil, nil, nil);
    
    // Save the image to the photolibrary in the background
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSData *data = UIImagePNGRepresentation(image);
        UIImageWriteToSavedPhotosAlbum([UIImage imageWithData:data], nil, nil, nil);
        
        dispatch_async(dispatch_get_main_queue(), ^{
            NSLog(@"\n>>>>> Done saving in background...");//update UI here
        });
    });
#endif
    
}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - onScreen buttons actions


//actions taken then user tap on the thumbnail images
-(void)filterButtonPressed:(UIButton *)sender{
    int index = sender.tag - 200;
    
    //perform corresponding filter effect to the bigger image in the center
    if(((NSString *)[[arrEffects objectAtIndex:index] valueForKey:@"method"]).length > 0) {
        @try{
            SEL _selector = NSSelectorFromString([[arrEffects objectAtIndex:index] valueForKey:@"method"]);
            
            UIImage * filteredImage = [self.originalImage performSelector:_selector];
            self.photo.image = filteredImage;
        }
        @catch (NSException *e) {
            NSLog(@"The filter is not found");
            
        }
    }
    else{
        self.photo.image = self.originalImage;
        
    }
}



//save the current image in the center 
- (IBAction)saveImage:(id)sender {
    //merge the image with drawing
    if (self.shouldMerge) {
        [self mergePaintToBackgroundView:self.paintView.frame];
    }
    if (self.photo.image == nil){
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"No image" message:@"No image has been taken" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
    }
    else{
        //save it to local photo library
        UIImageWriteToSavedPhotosAlbum(self.photo.image, nil, nil, nil);
        
        //save it to parse
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

//send tweet with current image
- (IBAction)tweetImage:(id)sender {
    
    if (self.shouldMerge) {
        [self mergePaintToBackgroundView:self.paintView.frame];
    }
    
    if ([SLComposeViewController isAvailableForServiceType:SLServiceTypeTwitter]){
        SLComposeViewController *tweetSheet = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeTwitter];
        [tweetSheet setInitialText:@""];
        [tweetSheet addImage:self.photo.image];
        [self presentViewController: tweetSheet animated:YES completion:nil];
    }
}

//erase drawing part when user clicked on the erase button
- (IBAction)eraseDrawing:(id)sender {
    [self.paintView erase];
}
@end
