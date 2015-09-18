//
//  EESettingsVC.m
//  VKPhotoViewer
//
//  Created by admin on 9/14/15.
//  Copyright (c) 2015 Admin. All rights reserved.
//

#import "EESettingsVC.h"
#import "AppDelegate.h"
#import "MainViewController.h"
#import "Constants.h"
#import "EEAppManager.h"

@interface EESettingsVC ()

@end

@implementation EESettingsVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.delegate = [EEAppManager sharedAppManager];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)logOutButtonTapped:(id)sender {
    //[self.delegate EESettingsVCDelegateLogOutButtonTapped];
    NSHTTPCookieStorage *lStorage = [NSHTTPCookieStorage sharedHTTPCookieStorage];
    
    for (NSHTTPCookie *cookie in [lStorage cookies]) {
        [lStorage deleteCookie:cookie];
    }
    [EEAppManager sharedAppManager].loggedUser = nil;
    
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:ACCESS_TOKEN_KEY];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:USER_ID_KEY];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:TOKEN_LIFE_TIME_KEY];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:CREATED];
    [[NSUserDefaults standardUserDefaults] synchronize];
}


@end
