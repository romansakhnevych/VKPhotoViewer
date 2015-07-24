//
//  EEFriendsListVC.m
//  VKPhotoViewer
//
//  Created by admin on 7/13/15.
//  Copyright (c) 2015 Admin. All rights reserved.
//

#import "EEFriendsListVC.h"
#import "Constants.h"
#import "EEFriends.h"
#import "EEResponseBilder.h"
#import "EERequests.h"
#import "EELoadingCellTableViewCell.h"
#import "EEFriendsListCell.h"
#import "AFHTTPRequestOperation.h"



@interface EEFriendsListVC ()

@end

@implementation EEFriendsListVC

- (void)viewDidLoad {
    [super viewDidLoad];
    _friendsList = [[NSMutableArray alloc] init];
    _count = 30;
    _offset = 0;
    [self updateDataWithCount:_count Offset:_offset];
    [self.navigationController setNavigationBarHidden:NO];
    self.navigationItem.title = @"Friends";

    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"Logout" style:UIBarButtonItemStylePlain target:self action:@selector(Logout)];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    
    return [_friendsList count];
}



-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSArray *lNib;
    if ([indexPath row] == [tableView numberOfRowsInSection:0]-1 && _loadedFriendsCount == _count) {
       
        [self updateDataWithCount:_count Offset:_offset];
        
        static NSString * CellId = @"LoadingCell";
        EELoadingCellTableViewCell *lLastCell = (EELoadingCellTableViewCell *)[tableView dequeueReusableCellWithIdentifier:CellId];
        
        if(lLastCell == nil){
            lNib = [[NSBundle mainBundle] loadNibNamed:@"LoadingCell" owner:self options:nil];
            lLastCell = [lNib objectAtIndex:0];
        }
        
        [lLastCell.spinner startAnimating];
    
        return lLastCell;
    }
    
    static NSString *CellIdentifier=@"Cell1";
    EEFriendsListCell *lCell = (EEFriendsListCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if(lCell==nil){
        lNib = [[NSBundle mainBundle] loadNibNamed:@"FriendsListCell" owner:self options:nil];
        lCell = [lNib objectAtIndex:0];
    }
    
    EEFriends *lUser = [_friendsList objectAtIndex:indexPath.row];
    lCell.fullName.text = [lUser getFullName];
    
    lCell.photo.image = [UIImage imageNamed:@"placeholder.png"];
    [[EEAppManager sharedAppManager] getPhotoByLink:lUser.smallPhotoLink withCompletion:^(UIImage *image, BOOL animated) {
        if (animated){
            [UIView transitionWithView:lCell.photo duration:0.5f options:UIViewAnimationOptionTransitionCrossDissolve animations:^{
            lCell.photo.image = image;
            } completion:nil];

        }
        else{
            lCell.photo.image = image;
        }
    }];
    
    return lCell;
}

- (void)tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath {
    
    [[EEAppManager sharedAppManager] setCurrentFriend:[_friendsList objectAtIndex:indexPath.row]];
    
    UIStoryboard * lStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    UIViewController *lViewController = [lStoryboard instantiateViewControllerWithIdentifier:@"userDetail"];
    [[self navigationController] pushViewController:lViewController animated:YES];
}

#pragma mark - Private methods

- (void)Logout{
    
    UIStoryboard * lStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    UIViewController *lViewController = [lStoryboard instantiateViewControllerWithIdentifier:@"login"];
    
    [self.navigationController pushViewController:lViewController animated:YES];
    NSHTTPCookieStorage *lStorage = [NSHTTPCookieStorage sharedHTTPCookieStorage];
    
    for (NSHTTPCookie *cookie in [lStorage cookies]) {
        [lStorage deleteCookie:cookie];
    }
    
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:ACCESS_TOKEN_KEY ];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:USER_ID_KEY];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:TOKEN_LIFE_TIME_KEY];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (void)updateDataWithCount:(NSInteger)count Offset:(NSInteger)offset{
    
    [[EEAppManager sharedAppManager] getFriendsWithCount:count offset:offset completionSuccess:^(id responseObject) {
        if ([responseObject isKindOfClass:[NSMutableArray class]]) {
            [_friendsList addObjectsFromArray:responseObject];
            _loadedFriendsCount = [responseObject count];
            _offset+=30;
        } else {
            NSLog(@"error");
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.tableView reloadData];
        });
    } completionFailure:^(NSError *error) {
        NSLog(@"error - %@",error);
    }];

}



@end
