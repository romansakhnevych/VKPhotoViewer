//
//  EEMainVC.m
//  VKPhotoViewer
//
//  Created by admin on 7/13/15.
//  Copyright (c) 2015 Admin. All rights reserved.
//

#import "EEMainVC.h"
#import "AppDelegate.h"
#import "Constants.h"
#import "MainViewController.h"

@interface EEMainVC ()

@end

@implementation EEMainVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navigationController setNavigationBarHidden:YES];
    [self.navigationItem setHidesBackButton:YES];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(popToTableView) name:@"successfulLogin" object:nil];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)popToTableView{
    UIViewController *lViewController = VIEW_CONTROLLER_WITH_ID(@"EEFriendsListVC");
    [self.navigationController pushViewController:lViewController animated:YES];
    
}


@end
