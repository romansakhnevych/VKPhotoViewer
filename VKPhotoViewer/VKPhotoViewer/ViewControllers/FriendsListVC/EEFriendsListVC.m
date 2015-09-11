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
#import "UIImageView+Haneke.h"

@interface EEFriendsListVC ()
@property (nonatomic)CGFloat lastOffset;
@end

@implementation EEFriendsListVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _friendsList = [[NSMutableArray alloc] init];
    _searchResult = [[NSMutableArray alloc] init];
    _count = 30;
    _offset = 0;
    [self updateDataWithCount:_count Offset:_offset];
    [_tableView setContentInset:UIEdgeInsetsMake(-20, 0, 0, 0)];
    _searchController = [[UISearchController alloc] initWithSearchResultsController:nil];
    _searchController.searchResultsUpdater = self;
    _searchController.dimsBackgroundDuringPresentation = NO;
    [_searchController.searchBar sizeToFit];
    
    _tableView.tableHeaderView = _searchController.searchBar;
}

- (void)viewWillAppear:(BOOL)animated{
    [self.navigationController setNavigationBarHidden:YES];
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
    if (_searchController.active && ![_searchController.searchBar.text isEqualToString:@""]) {
        return [_searchResult count];
    } else {
         return [_friendsList count];
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
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
    
    static NSString *CellIdentifier = @"FriendsCell";
    EEFriendsListCell *lCell = (EEFriendsListCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if(lCell==nil){
        lNib = [[NSBundle mainBundle] loadNibNamed:@"FriendsListCell" owner:self options:nil];
        lCell = [lNib objectAtIndex:0];
    }
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

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (_searchController.active && ![_searchController.searchBar.text isEqualToString:@""]) {
        [[EEAppManager sharedAppManager] setCurrentFriend:[_searchResult objectAtIndex:indexPath.row]];
    } else {
    [[EEAppManager sharedAppManager] setCurrentFriend:[_friendsList objectAtIndex:indexPath.row]];
    }
    [_searchController setActive:NO];
    UIStoryboard * lStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    UIViewController *lViewController = [lStoryboard instantiateViewControllerWithIdentifier:@"albumsTableView"];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    [[self navigationController] pushViewController:lViewController animated:YES];
}

#pragma mark - UIScrollView delegat
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
//    
//    if (isBeginning) {
//        
//       if (self.lastOffset > scrollView.contentOffset.y){
//        _searchBar.frame = CGRectMake(0, _searchBar.frame.origin.y + 8, _searchBar.frame.size.width, _searchBar.frame.size.height);
//        if (_searchBar.frame.origin.y > _navigationBar.frame.size.height) {
//            _searchBar.frame = CGRectMake(_searchBar.frame.origin.x, _navigationBar.frame.size.height, _searchBar.frame.size.width, _searchBar.frame.size.height);
//        }
//    } else if(self.lastOffset < scrollView.contentOffset.y){
//        _searchBar.frame = CGRectMake(0, _searchBar.frame.origin.y - 8, _searchBar.frame.size.width, _searchBar.frame.size.height);
//        if (_searchBar.frame.origin.y < _navigationBar.frame.origin.y) {
//            _searchBar.frame = CGRectMake(_searchBar.frame.origin.x, _navigationBar.frame.origin.y, _searchBar.frame.size.width, _searchBar.frame.size.height);
//        }
//        
//    }
//     self.lastOffset = scrollView.contentOffset.y;
//    }
}


- (void)updateSearchResultsForSearchController:(UISearchController *)searchController {
    [self filterFriendsForTerm:_searchController.searchBar.text];
}


#pragma mark - Private methods

- (void)Logout {
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



- (void)filterFriendsForTerm:(NSString *)term{
    [_searchResult removeAllObjects];
    NSPredicate *lFirstNamePredicate = [NSPredicate predicateWithFormat:@"self.firstName beginswith[cd]%@",term];
    NSPredicate *lLastNamePredicate = [NSPredicate predicateWithFormat:@"self.lastName beginswith[cd]%@",term];
    NSPredicate *lFullNamePredicate = [NSCompoundPredicate orPredicateWithSubpredicates:@[lFirstNamePredicate,lLastNamePredicate]];
   [_searchResult addObjectsFromArray:[_friendsList filteredArrayUsingPredicate:lFullNamePredicate]];
    
    [_tableView reloadData];
}

#pragma mark - IBActions

- (IBAction)logoutTap:(id)sender {
    [self Logout];
}
@end
