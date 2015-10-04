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
#import "EEUserDetailVC.h"
#import "EEAppManager.h"
#import "UIImage+StackBlur.h"
#import "EEPhotoGalleryVC.h"
#import "MBProgressHUD.h"
#import "Constants.h"
#import "Haneke.h"
#import "UIImageView+Haneke.h"
#import "MBProgressHUD.h"
#import "EEContainerVC.h"
#import "HNKCache.h"
#import "RFRateMe.h"

@interface EESettingsVC ()

@end

@implementation EESettingsVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.delegate = [EEAppManager sharedAppManager];
    
    NSString *localizedDetailString = NSLocalizedString(@"LogOutKey", @"");
    NSString *localizedChangeQualityString = NSLocalizedString(@"ChangeQualityKey", @"");
    
    _label_imageQuality.text = localizedChangeQualityString;
    [_ChangeImageQuality addTarget:self action:@selector(changeSwitch:) forControlEvents:UIControlEventValueChanged];
    
    [_LogOutButton setTitle:localizedDetailString forState:UIControlStateNormal];
    
    [_userPhoto.layer setCornerRadius:_userPhoto.frame.size.width / 2];
    _userPhoto.layer.masksToBounds = YES;
    
    [self.navigationController setNavigationBarHidden:NO];
    
    NSString *lLoggedUserId = [[NSUserDefaults standardUserDefaults] objectForKey:USER_ID_KEY];
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_LOW, 0), ^{
        
        [[EEAppManager sharedAppManager] getDetailByUserId:lLoggedUserId completionSuccess:^(BOOL successLoad, EEFriends *friendModel) {
            [EEAppManager sharedAppManager].loggedUser = friendModel;
            EEFriends *lUser = [EEAppManager sharedAppManager].loggedUser;
            
            [[EEAppManager sharedAppManager] getDetailByUserId:lLoggedUserId
                                             completionSuccess:^(BOOL successLoad, EEFriends *friendModel) {
                                                 dispatch_async(dispatch_get_main_queue(), ^{
                                                     
                                                     _city.text = [friendModel getLocation];
                                                     _albumsCountLabel.text = [friendModel getAlbumsCount];
                                                     _photosCountLabel.text = [friendModel getPhotosCount];
                                                     _fullName.text = [friendModel getFullName];
                                                     
                                                 });
                                                 
                                             } completionFailure:^(NSError *error) {
                                                 NSLog(@"%@",error);
                                             }];
            
            [[EEAppManager sharedAppManager] getPhotoByLink:lUser.bigPhotoLink withCompletion:^(UIImage *image, BOOL animated) {
                _userPhoto.image = image;
                _backgroundPhoto.image = [image stackBlur:6];
            }];
            
        } completionFailure:^(NSError *error) {
            
        }];
        dispatch_async(dispatch_get_main_queue(), ^{
            [MBProgressHUD hideHUDForView:self.view animated:YES];
        });
    });
    
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapDetected)];
    singleTap.numberOfTapsRequired = 1;
    [_userPhoto setUserInteractionEnabled:YES];
    [_userPhoto addGestureRecognizer:singleTap];
    
    NSString *changeStr = GET_DEFAULT_VALUE(QUALITY_VALUE);
    if (self)
    {
        if ([changeStr  isEqual: @"1"]) {
            [_ChangeImageQuality setOn:YES animated:YES];
        }
        else if ([changeStr  isEqual: @"0"]) {
            [_ChangeImageQuality setOn:NO animated:YES];
        }
    }
    
    [RFRateMe showRateAlertAfterTimesOpened:3];
}

- (void) tapDetected {
    NSLog(@"tapp!!");
    
    NSString *localizedAlbumsString = NSLocalizedString(@"AlbumsKey", @"");
    UIViewController *lViewController;
    EEContainerVC *lContainer = [[[kMainViewController rootViewController] childViewControllers] objectAtIndex:0];
    CGRect lViewRect = lContainer.view.frame;
    lViewRect.size.height = lViewRect.size.height - 64;
    lViewRect.origin.y = lViewRect.origin.y + 64;
    
    [EEAppManager sharedAppManager].currentFriend = [EEAppManager sharedAppManager].loggedUser;
    lViewController = VIEW_CONTROLLER_WITH_ID(@"EEAlbumsVC");
    lViewController.view.frame = lViewRect;
    [lContainer addSubviewAsChildVC:lViewController];
    lContainer.navigationItem.title = localizedAlbumsString;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)changeSwitch:(id)sender {
    if ([sender isOn]) {
        NSLog(@"On");
        _strSwitcher = @"1";
        SAVE_DEFAULT_VALUE(self.strSwitcher, QUALITY_VALUE);
    } else
    {
        NSLog(@"Off");
        _strSwitcher = @"0";
        SAVE_DEFAULT_VALUE(self.strSwitcher, QUALITY_VALUE);
    }
}

- (IBAction)logOutAction:(id)sender {
    [self logout];
}
- (void)logout {
    
    NSHTTPCookieStorage *lStorage = [NSHTTPCookieStorage sharedHTTPCookieStorage];
    
    for (NSHTTPCookie *cookie in [lStorage cookies]) {
        [lStorage deleteCookie:cookie];
    }
    
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:ACCESS_TOKEN_KEY];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:USER_ID_KEY];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:TOKEN_LIFE_TIME_KEY];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:CREATED];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    UIStoryboard *lStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    UIViewController *lViewController = [lStoryboard instantiateViewControllerWithIdentifier:@"login"];
    [[self navigationController] pushViewController:lViewController animated:YES];
}


- (IBAction)deleteCashAction:(id)sender {
    
    [[NSURLCache sharedURLCache] removeAllCachedResponses];
    
    NSHTTPCookieStorage *lStorage = [NSHTTPCookieStorage sharedHTTPCookieStorage];
    
    for (NSHTTPCookie *cookie in [lStorage cookies]) {
        [lStorage deleteCookie:cookie];
    }
}
@end
