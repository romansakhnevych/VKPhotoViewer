//
//  EESettingsVC.h
//  VKPhotoViewer
//
//  Created by admin on 9/14/15.
//  Copyright (c) 2015 Admin. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol EESettingsVCDelegate <NSObject>

-(void)EESettingsVCDelegateLogOutButtonTapped;

@end

@interface EESettingsVC : UIViewController
@property (weak, nonatomic) IBOutlet UIButton *logOutButton;
@property (weak, nonatomic) IBOutlet UILabel *fullName;
@property (weak, nonatomic) IBOutlet UILabel *city;

@property (weak, nonatomic) IBOutlet UIImageView *backgroundPhoto;
@property (weak, nonatomic) IBOutlet UIImageView *userPhoto;

@property (weak, nonatomic) IBOutlet UILabel *albumsCountLabel;
@property (weak, nonatomic) IBOutlet UILabel *photosCountLabel;
@property (weak, nonatomic) IBOutlet UIButton *LogOutButton;
- (IBAction)logOutAction:(id)sender;
@property (weak, nonatomic) IBOutlet UILabel *label_imageQuality;
@property (weak, nonatomic) IBOutlet UISwitch *ChangeImageQuality;
@property (nonatomic, retain)NSString *strSwitcher;
@property (weak, nonatomic) IBOutlet UIButton *deleteCashBtn;
- (IBAction)deleteCashAction:(id)sender;
@property (weak, nonatomic) id <EESettingsVCDelegate> delegate;

@end
