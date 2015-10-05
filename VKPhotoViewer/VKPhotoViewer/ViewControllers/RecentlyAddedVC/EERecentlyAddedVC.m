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
#import "EENews.h"
#import "EERecentlyAddedCell.h"
#import "UIImageView+Haneke.h"
#import "EEPhoto.h"
#import "Constants.h"
#import "EEPhotoGalleryVC.h"

@interface EERecentlyAddedVC (){
    NSArray *_newsList;
    
}

@end

@implementation EERecentlyAddedVC


- (void)viewDidLoad {
    [super viewDidLoad];
[_tableView registerNib:[UINib nibWithNibName:NSStringFromClass([EERecentlyAddedCell class]) bundle:[NSBundle mainBundle]] forCellReuseIdentifier:NSStringFromClass([EERecentlyAddedCell class])];
    [[EEAppManager sharedAppManager] getNewsfeedStartFrom:@"" CompletionSuccess:^(id responseObject) {
        _newsList = [[NSArray alloc] initWithArray:responseObject];
        [_tableView reloadData];
    } completionFailure:^(NSError *error) {
        
    }];
    _tableView.contentInset = UIEdgeInsetsMake(0, 0, 64, 0);
}

#pragma mark - UITableViewDataSource methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _newsList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

    EERecentlyAddedCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([EERecentlyAddedCell class])];
    EENews *lNew = [_newsList objectAtIndex:indexPath.row];
    EEPhoto *lPhoto = [lNew.photos objectAtIndex:0];
    
   [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    cell.nameLable.text = [NSString stringWithFormat:@"%@ %@", lNew.firstName, lNew.lastName];
    cell.dateLable.text = [lNew getDate];
    cell.userPhotoImgView.image = [UIImage imageNamed:@"Placeholder"];
    cell.mainPhotoImgView.image = [UIImage imageNamed:@"Placeholder"];
    [cell.userPhotoImgView hnk_setImageFromURL:[NSURL URLWithString:lNew.userPhotoLink]];
    [cell.mainPhotoImgView hnk_setImageFromURL:[NSURL URLWithString:lPhoto.mPhotoLink]];
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
   
    EENews *lNews = [_newsList objectAtIndex:indexPath.row];
    EEPhoto *lPhoto = [lNews.photos objectAtIndex:0];
    EEPhotoGalleryVC *lViewController = [[EEPhotoGalleryVC alloc] initWithPhoto:lPhoto index:0];
    //[EEAppManager sharedAppManager].allPhotos = [NSMutableArray arrayWithObjects:lPhoto, nil];
    
   
    [self.navigationController pushViewController:lViewController animated:YES];
    
    }

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
