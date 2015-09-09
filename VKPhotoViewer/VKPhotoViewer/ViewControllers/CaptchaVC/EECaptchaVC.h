//
//  CaptchaVC.h
//  VKPhotoViewer
//
//  Created by admin on 9/9/15.
//  Copyright (c) 2015 Admin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EECaptchaVC : UIViewController
- (IBAction)btnPressed:(id)sender;
@property (weak, nonatomic) IBOutlet UIImageView *captchaImageView;
@property (weak, nonatomic) IBOutlet UITextField *textField;

@end
