//
//  CaptchaVC.m
//  VKPhotoViewer
//
//  Created by admin on 9/9/15.
//  Copyright (c) 2015 Admin. All rights reserved.
//

#import "EECaptchaVC.h"
#import "EEAppManager.h"
#import "Haneke.h"

@interface EECaptchaVC ()

@end

@implementation EECaptchaVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [_captchaImageView hnk_setImageFromURL:[NSURL URLWithString:[EEAppManager sharedAppManager].captchaImageLink]];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)btnPressed:(id)sender {
    NSString *captchaKey = _textField.text;
    NSDictionary *captcha = @{@"captcha_sid":[EEAppManager sharedAppManager].captchaSid, @"captcha_key":captchaKey};
    
    [[EEAppManager sharedAppManager] addLikeForCurrentFriendPhotoWithCompletionSuccess:^(id responseObject) {
        
    } completionFailure:^(NSError *error) {
        
    } captcha:captcha];
}
@end
