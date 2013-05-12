//
//  PicCell.h
//  Staches and Glasses
//
//  Created by cheonhyang on 13-5-9.
//  Copyright (c) 2013年 Tianxiang Zhang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PicCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *pic;
@property (weak, nonatomic) IBOutlet UIImageView *twitterButton;
@property (weak, nonatomic) IBOutlet UIButton *deleteButton;

@end
