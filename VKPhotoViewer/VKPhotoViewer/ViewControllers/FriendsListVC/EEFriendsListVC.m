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
#import "UIImageView+Haneke.h"
#import "EELoadingTVCell.h"
#import "EEFriendsListTVCell.h"
#import "EEFriendsCountTVCell.h"
#import "MainViewController.h"
#import "AppDelegate.h"
#import "MBProgressHUD.h"



@interface EEFriendsListVC ()
@property (nonatomic)CGFloat lastOffset;
@end

@implementation EEFriendsListVC

#pragma mark - EEFriendsListVC lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _friendsList = [NSMutableArray new];
    _searchResult = [NSMutableArray new];
    [self configureSearchController];
    [self setUpTableView];
    //[EEAppManager sharedAppManager].delegate = self;
    CGRect lViewRect = self.view.frame;
    lViewRect.size.height = lViewRect.size.height - 64;
    lViewRect.origin.y = lViewRect.origin.y + 64;
    self.view.frame = lViewRect;

}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    //[self.navigationController setNavigationBarHidden:NO];
    if(!_friendsList ||! _friendsList.count) {
        [MBProgressHUD showHUDAddedTo:self.view animated:YES]; //load indicator
        [self updateTableView];
    }

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - TableView data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSInteger count;
    

    if (_searchController.active && ![_searchController.searchBar.text isEqualToString:@""]){
        count = (_searchResult.count>0) ? _searchResult.count+1 : _searchResult.count;
    } else {
        count = (_friendsList.count>0) ? _friendsList.count+1 : _friendsList.count;
    }
    
    return count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if ([indexPath row] == [tableView numberOfRowsInSection:0] - 1 && _loadedFriendsCount == _count) {
        
        [self updateDataWithCount:_count offset:_offset];
        
        EELoadingTVCell *lLastCell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([EELoadingTVCell class])];
        [lLastCell.spinner startAnimating];
        
        return lLastCell;
    } else if ([indexPath row] == [tableView numberOfRowsInSection:0] - 1) {
        EEFriendsCountTVCell *lLastCell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([EEFriendsCountTVCell class])];
        if (_searchController.active) {
            [lLastCell setCount:_searchResult.count];
        } else {
            [lLastCell setCount:_friendsList.count];
        }
        [lLastCell setSelectionStyle:UITableViewCellSelectionStyleNone];
        return lLastCell;
    }
    
    EEFriendsListTVCell *lCell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([EEFriendsListTVCell class])];
    lCell.photo.image = [UIImage imageNamed:@"Placeholder"];
    
    EEFriends *lUser;
    if (_searchController.active && ![_searchController.searchBar.text isEqualToString:@""]) {
        lUser = [_searchResult objectAtIndex:indexPath.row];
    } else {
        lUser = [_friendsList objectAtIndex:indexPath.row];
    }
    
    lCell.fullName.text = [lUser getFullName];
    [lCell.photo hnk_setImageFromURL:[NSURL URLWithString:lUser.smallPhotoLink]];
    
    return lCell;
}

#pragma mark - UITableView delegate

- (void)tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath {
    
    if (_searchController.active && ![_searchController.searchBar.text isEqualToString:@""]) {
        [[EEAppManager sharedAppManager] setCurrentFriend:[_searchResult objectAtIndex:indexPath.row]];
    } else {
        [[EEAppManager sharedAppManager] setCurrentFriend:[_friendsList objectAtIndex:indexPath.row]];
    }
    
    [_searchController setActive:NO];
    
    UIStoryboard * lStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    UIViewController *lViewController = [lStoryboard instantiateViewControllerWithIdentifier:@"userDetail"];
    [[self navigationController] pushViewController:lViewController animated:YES];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([indexPath row] == [tableView numberOfRowsInSection:0] - 1){
        [tableView deselectRowAtIndexPath:indexPath animated:NO];
    } else {
    if (_searchController.active && ![_searchController.searchBar.text isEqualToString:@""]) {
        [[EEAppManager sharedAppManager] setCurrentFriend:[_searchResult objectAtIndex:indexPath.row]];
    } else {
        [[EEAppManager sharedAppManager] setCurrentFriend:[_friendsList objectAtIndex:indexPath.row]];
    }
    [_searchController setActive:NO];
    
    UIStoryboard *lStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    UIViewController *lViewController = [lStoryboard instantiateViewControllerWithIdentifier:@"EEAlbumsVC"];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    [[self navigationController] pushViewController:lViewController animated:YES];
    }
}

- (void)updateSearchResultsForSearchController:(UISearchController *)searchController {
    [self filterFriendsForTerm:_searchController.searchBar.text];
}

#pragma mark - Private methods

- (void)setUpTableView {
    [_tableView registerNib:[UINib nibWithNibName:NSStringFromClass([EEFriendsCountTVCell class]) bundle:[NSBundle mainBundle]] forCellReuseIdentifier:NSStringFromClass([EEFriendsCountTVCell class])];
    [_tableView registerNib:[UINib nibWithNibName:NSStringFromClass([EELoadingTVCell class]) bundle:[NSBundle mainBundle]] forCellReuseIdentifier:NSStringFromClass([EELoadingTVCell class])];
    [_tableView registerNib:[UINib nibWithNibName:NSStringFromClass([EEFriendsListTVCell class]) bundle:[NSBundle mainBundle]] forCellReuseIdentifier:NSStringFromClass([EEFriendsListTVCell class])];
    [_tableView setTableFooterView:[[UIView alloc] initWithFrame:CGRectZero]];
}

- (void)configureSearchController {
    _searchController = [[UISearchController alloc] initWithSearchResultsController:nil];
    _searchController.searchResultsUpdater = self;
    _searchController.dimsBackgroundDuringPresentation = NO;
    [_searchController.searchBar sizeToFit];

    _tableView.tableHeaderView = _searchController.searchBar;
}

- (void)updateTableView {
    _count = 30;
    _offset = 0;
    [self updateDataWithCount:_count offset:_offset];
}

- (void)logout {
//    if ([self.searchController isActive]) {
//        self.searchController.active = NO;
//    }
    [self.friendsList removeAllObjects];
    [self.searchResult removeAllObjects];
    [self.tableView reloadData];
    
    
    NSHTTPCookieStorage *lStorage = [NSHTTPCookieStorage sharedHTTPCookieStorage];
    
    for (NSHTTPCookie *cookie in [lStorage cookies]) {
        [lStorage deleteCookie:cookie];
    }
    
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:ACCESS_TOKEN_KEY];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:USER_ID_KEY];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:TOKEN_LIFE_TIME_KEY];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:CREATED];
    [[NSUserDefaults standardUserDefaults] synchronize];
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (void)updateDataWithCount:(NSInteger)count offset:(NSInteger)offset {
    
    [[EEAppManager sharedAppManager] getFriendsWithCount:count offset:offset completionSuccess:^(id responseObject) {
        if ([responseObject isKindOfClass:[NSMutableArray class]]) {
            [_friendsList addObjectsFromArray:responseObject];
            _loadedFriendsCount = ((NSArray*)responseObject).count;
            _offset += 30;
        } else {
            NSLog(@"error");
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.tableView reloadData];
            [MBProgressHUD hideHUDForView:self.view animated:YES];
        });
    } completionFailure:^(NSError *error) {
        [[EEAppManager sharedAppManager] showAlertWithError:error];
    }];
}

- (void)filterFriendsForTerm:(NSString *)term {
    [_searchResult removeAllObjects];
    
    NSPredicate *lFirstNamePredicate = [NSPredicate predicateWithFormat:@"self.firstName beginswith[cd]%@", term];
    NSPredicate *lLastNamePredicate = [NSPredicate predicateWithFormat:@"self.lastName beginswith[cd]%@", term];
    NSPredicate *lFullNamePredicate = [NSCompoundPredicate orPredicateWithSubpredicates:@[lFirstNamePredicate, lLastNamePredicate]];
    [_searchResult addObjectsFromArray:[_friendsList filteredArrayUsingPredicate:lFullNamePredicate]];
    
    [_tableView reloadData];
}

#pragma mark - IBActions methods

- (IBAction)logoutTap:(id)sender {
    [self logout];
}

- (IBAction)menuTap:(id)sender {
    [((MainViewController *)kMainViewController) showLeftViewAnimated:YES completionHandler:nil];
}

#pragma mark - EEAppManagerDelegateMethods

- (void)tokenDidExpired {
    [self logout];
    [[EEAppManager sharedAppManager] showAlertAboutTokenExpired];
}

-(void)EESettingsVCDelegateLogOutButtonTapped {
    [self logout];
}
@end
