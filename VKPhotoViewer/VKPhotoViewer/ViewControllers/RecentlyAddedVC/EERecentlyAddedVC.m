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

#pragma mark - UITableViewDataSource methods
//
//- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
//    return 1;
//}
//
//- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
//    return 5;
//}
//
//- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
//    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
//    if (cell == nil) {
//        
//        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
//                                       reuseIdentifier:@"cell"];
//    }
//    cell.textLabel.text = @"ok";
//    return cell;
//}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
