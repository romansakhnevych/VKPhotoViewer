//
//  EEAddPhotoVC.m
//  VKPhotoViewer
//
//  Created by admin on 9/14/15.
//  Copyright (c) 2015 Admin. All rights reserved.
//

#import "EEAddPhotoVC.h"
#import "AppDelegate.h"
#import "MainViewController.h"

@interface EEAddPhotoVC ()

@end

@implementation EEAddPhotoVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navItem.title = @"Add photo";
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

- (IBAction)menuBtnTap:(id)sender {
    [((MainViewController *)kMainViewController) showLeftViewAnimated:YES completionHandler:nil];
}
@end
