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
@property (weak, nonatomic) id <EESettingsVCDelegate> delegate;

@end
