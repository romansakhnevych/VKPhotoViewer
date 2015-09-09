//
//  EEFriendsListVC.h
//  VKPhotoViewer
//
//  Created by admin on 7/13/15.
//  Copyright (c) 2015 Admin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EEAppManager.h"
#import "EGOCache.h"

@interface EEFriendsListVC : UIViewController <UITableViewDelegate,UITableViewDataSource, UIScrollViewDelegate, UISearchControllerDelegate, UISearchResultsUpdating>

@property (nonatomic,retain) NSMutableArray *friendsList;
@property (strong, nonatomic)NSMutableArray *searchResult;

@property (nonatomic) NSInteger offset;
@property (nonatomic) NSInteger count;
@property (nonatomic) NSInteger loadedFriendsCount;

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;
@property (weak, nonatomic) IBOutlet UINavigationBar *navigationBar;
@property (strong, nonatomic)UISearchController *searchController;

- (IBAction)logoutTap:(id)sender;

@end
