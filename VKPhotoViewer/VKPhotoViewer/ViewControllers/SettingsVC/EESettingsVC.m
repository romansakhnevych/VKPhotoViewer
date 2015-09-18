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

@interface EESettingsVC ()

@end

@implementation EESettingsVC

- (void)viewDidLoad {
    [super viewDidLoad];
     NSString *localizedDetailString = NSLocalizedString(@"LogOutKey", @"");
    [_LogOutButton setTitle:localizedDetailString forState:UIControlStateNormal];
    
    [_buttonWithAvatar.imageView.layer setCornerRadius:_buttonWithAvatar.frame.size.width/2];
    _buttonWithAvatar.imageView.layer.masksToBounds = YES;
    _buttonWithAvatar.imageView.layer.borderColor = [UIColor whiteColor].CGColor;
    _buttonWithAvatar.imageView.layer.borderWidth = 2;
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
            _buttonWithAvatar.contentMode = UIViewContentModeScaleAspectFill;
            _buttonWithAvatar.imageView.contentMode = UIViewContentModeScaleAspectFill;
            _buttonWithAvatar.contentHorizontalAlignment = UIControlContentHorizontalAlignmentFill;
            _buttonWithAvatar.contentVerticalAlignment = UIControlContentVerticalAlignmentFill;
            [_buttonWithAvatar setImage:image forState:UIControlStateNormal];
            [_buttonWithAvatar setImage:image forState:UIControlStateHighlighted];
            [_buttonWithAvatar setImage:image forState:UIControlStateDisabled];
            _backgroundPhoto.image = [image stackBlur:6];
        }];
        
        
        //[_backgroundPhoto.image hnk_setImageFromURL:[NSURL URLWithString:friendModel.bigPhotoLink]];
    } completionFailure:^(NSError *error) {
        
    }];
        dispatch_async(dispatch_get_main_queue(), ^{
            [MBProgressHUD hideHUDForView:self.view animated:YES];
        });
    });
    
    
    }

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)avatarCkicked:(id)sender {
   /* [[EEAppManager sharedAppManager] getAlbumWithId:ALBUM_WITH_AVATARS_ID completionSuccess:^(id responseObject){
        [EEAppManager sharedAppManager].currentAlbum = responseObject[0];
        [[EEAppManager sharedAppManager] getPhotosWithCount:60 offset:0 fromAlbum:ALBUM_WITH_AVATARS_ID forUser:[EEAppManager sharedAppManager].currentFriend.userId completionSuccess:^(id responseObject) {
            if ([responseObject isKindOfClass:[NSMutableArray class]]){
                UIStoryboard * lStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
                EEPhotoGalleryVC *lViewController = [lStoryboard instantiateViewControllerWithIdentifier:@"PhotoView"];
                NSMutableArray *lArray = [NSMutableArray array];
                [lArray addObjectsFromArray:responseObject];
                [EEAppManager sharedAppManager].allPhotos = lArray;
                [EEAppManager sharedAppManager].currentPhotoIndex = 0;
                [EEAppManager sharedAppManager].currentPhoto = [[EEAppManager sharedAppManager].allPhotos objectAtIndex:0];
                [[self navigationController] pushViewController:lViewController animated:YES];
            }else{
                NSLog(@"error");
            }
        } completionFailure:^(NSError *error) {
            NSLog(@"error - %@",error);
        }];
    } completionFailure:^(NSError *error){
        
        NSLog(@"error - %@",error);
    }];*/
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
@end
