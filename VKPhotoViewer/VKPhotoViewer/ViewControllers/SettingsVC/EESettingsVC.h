//
//  EESettingsVC.h
//  VKPhotoViewer
//
//  Created by admin on 9/14/15.
//  Copyright (c) 2015 Admin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MainViewController.h"

@interface EESettingsVC : UIViewController
@property (weak, nonatomic) IBOutlet UILabel *fullName;
@property (weak, nonatomic) IBOutlet UILabel *city;

@property (weak, nonatomic) IBOutlet UIImageView *backgroundPhoto;

@property (weak, nonatomic) IBOutlet UILabel *albumsCountLabel;
@property (weak, nonatomic) IBOutlet UILabel *photosCountLabel;
@property (weak, nonatomic) IBOutlet UIButton *LogOutButton;
- (IBAction)logOutAction:(id)sender;

@property (weak, nonatomic) IBOutlet UIButton *buttonWithAvatar;
-(IBAction)avatarCkicked:(id)sender;

@end
