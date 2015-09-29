//
//  EEContainerVC.m
//  VKPhotoViewer
//
//  Created by admin on 9/16/15.
//  Copyright (c) 2015 Admin. All rights reserved.
//

#import "EEContainerVC.h"
#import "Constants.h"
#import "AppDelegate.h"
#import "MainViewController.h"

@interface EEContainerVC ()

@end

@implementation EEContainerVC

- (void)viewDidLoad {
    [super viewDidLoad];
    UIViewController *lViewController = VIEW_CONTROLLER_WITH_ID(@"EEFriendsListVC");
    [self addSubviewAsChildVC:lViewController];
    [self setupNavigationBar];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)addSubviewAsChildVC:(UIViewController *)viewController {
    [viewController willMoveToParentViewController:self];
    [self addChildViewController:viewController];
    [self.view addSubview:viewController.view];
    [viewController didMoveToParentViewController:self];
}

- (void)removeChildVC{
    [[self.childViewControllers lastObject] willMoveToParentViewController:nil];
    //[[self.childViewControllers lastObject].view removeFromSuperview];
    [[self.childViewControllers lastObject] removeFromParentViewController];
    
}

- (void)menuBtnTap: (id)btn{
    
    [kMainViewController showLeftViewAnimated:YES completionHandler:nil];
    
}

- (void)logout{
    NSHTTPCookieStorage *lStorage = [NSHTTPCookieStorage sharedHTTPCookieStorage];
    
    for (NSHTTPCookie *cookie in [lStorage cookies]) {
        [lStorage deleteCookie:cookie];
    }
    
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:ACCESS_TOKEN_KEY];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:USER_ID_KEY];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:TOKEN_LIFE_TIME_KEY];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:CREATED];
    [[NSUserDefaults standardUserDefaults] synchronize];
//    
//    UIStoryboard * lStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
//    UIViewController *lViewController = [lStoryboard instantiateViewControllerWithIdentifier:@"login"];
//    [self.navigationController popToViewController: lViewController  animated:YES];
}

- (void)setupNavigationBar{
    [self.navigationController setNavigationBarHidden:NO];
    
    //NSString *localizedMenuString = NSLocalizedString(@"MenuKey", @"");
    //NSString *localizedLogOutString = NSLocalizedString(@"LogOutKey", @"");
    UIButton* customBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    customBtn.frame = CGRectMake(0, 0, 40, 40);
    [customBtn setImage:[UIImage imageNamed: @"menuButtonWhite"] forState:UIControlStateNormal];
    [customBtn setImage:[UIImage imageNamed:@"menuButtonYellow"] forState:UIControlStateSelected];
    [customBtn addTarget:self action:@selector(menuBtnTap:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *lMenuBtn = [[UIBarButtonItem alloc] initWithCustomView:customBtn];
    
//    //UIBarButtonItem *lMenuBtn = [[UIBarButtonItem alloc] initWithTitle:localizedMenuString
//                                                                 style:UIBarButtonItemStylePlain
//                                                                target:self
//                                                                action:@selector(menuBtnTap)];
//    //UIBarButtonItem *LogoutBtn = [[UIBarButtonItem alloc] initWithTitle:localizedLogOutString
//                                                                  style:UIBarButtonItemStylePlain
//                                                                 target:self
//                                                                 action:@selector(logout)];
//    [//self.navigationItem setRightBarButtonItem:LogoutBtn];
    
    [self.navigationItem setLeftBarButtonItem:lMenuBtn];
}
@end
