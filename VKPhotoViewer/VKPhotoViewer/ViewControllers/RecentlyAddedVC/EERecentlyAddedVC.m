//
//  EERecentlyAddedVC.m
//  VKPhotoViewer
//
//  Created by admin on 9/14/15.
//  Copyright (c) 2015 Admin. All rights reserved.
//

#import "EERecentlyAddedVC.h"
#import "AppDelegate.h"
#import "MainViewController.h"
#import "EEAppManager.h"
@interface EERecentlyAddedVC ()

@end

@implementation EERecentlyAddedVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [[EEAppManager sharedAppManager] getNewsfeedStartFrom:@"" CompletionSuccess:^(id responseObject) {
        
    } completionFailure:^(NSError *error) {
        
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
