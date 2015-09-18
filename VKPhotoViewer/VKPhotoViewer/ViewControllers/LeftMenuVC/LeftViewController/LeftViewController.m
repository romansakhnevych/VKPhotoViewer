//
//  LeftViewController.m
//  LGSideMenuControllerDemo
//
//  Created by Grigory Lutkov on 18.02.15.
//  Copyright (c) 2015 Grigory Lutkov. All rights reserved.
//

#import "LeftViewController.h"
#import "MainViewController.h"
#import "AppDelegate.h"
#import "LeftViewCell.h"
#import "EECustomTableHeaderView.h"
#import "UIView+EEViewCreator.h"
#import "Constants.h"
#import "EEAppManager.h"
#import "Haneke.h"
#import "EEContainerVC.h"

typedef NS_ENUM(NSInteger, EEMenuItems) {
    Friends,
    Albums,
    RecentlyAdded,
    Settings,
    AddPhoto
};


@interface LeftViewController ()

@property (strong, nonatomic) NSArray *titlesArray;

@end

@implementation LeftViewController

- (void)awakeFromNib
{
    [super awakeFromNib];
    NSString *localizedFriendsString = NSLocalizedString(@"FriendsKey", @"");
    NSString *localizedAlbumsString = NSLocalizedString(@"AlbumsKey", @"");
    NSString *localizedRecentlyAddedString = NSLocalizedString(@"RecentlyAddedKey", @"");
    NSString *localizedSettingsString = NSLocalizedString(@"SettingsKey", @"");
    NSString *localizedAddPhotoString = NSLocalizedString(@"AddPhotoKey", @"");

    _titlesArray = @[localizedFriendsString,
                     localizedAlbumsString,
                     localizedRecentlyAddedString,
                     localizedSettingsString,
                     localizedAddPhotoString];
    
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.contentInset = UIEdgeInsetsMake(20.f, 0.f, 20.f, 0.f);
    self.tableView.showsVerticalScrollIndicator = NO;
    EECustomTableHeaderView *view = [EECustomTableHeaderView createView];
    self.tableView.tableHeaderView = view;
    
    NSString *lLoggedUserId = [[NSUserDefaults standardUserDefaults] objectForKey:USER_ID_KEY];
    [[EEAppManager sharedAppManager] getDetailByUserId:lLoggedUserId completionSuccess:^(BOOL successLoad, EEFriends *friendModel) {
        [EEAppManager sharedAppManager].loggedUser = friendModel;
        view.nameLable.text = friendModel.firstName;
        [view.imageView hnk_setImageFromURL:[NSURL URLWithString:friendModel.bigPhotoLink]];
    } completionFailure:^(NSError *error) {
        
    }];
    
    

}

#pragma mark -

- (void)openLeftView
{
    [kMainViewController showLeftViewAnimated:YES completionHandler:nil];
}

- (void)openRightView
{
    [kMainViewController showRightViewAnimated:YES completionHandler:nil];
}

#pragma mark - UITableView DataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _titlesArray.count;
}

#pragma mark - UITableView Delegate

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    LeftViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    
    cell.textLabel.text = _titlesArray[indexPath.row];

    cell.tintColor = _tintColor;
    cell.backgroundColor = [UIColor whiteColor];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 44.0f;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *localizedFriendsString = NSLocalizedString(@"FriendsKey", @"");
    NSString *localizedAlbumsString = NSLocalizedString(@"AlbumsKey", @"");
    NSString *localizedRecentlyAddedString = NSLocalizedString(@"RecentlyAddedKey", @"");
    NSString *localizedSettingsString = NSLocalizedString(@"SettingsKey", @"");
    NSString *localizedAddPhotoString = NSLocalizedString(@"AddPhotoKey", @"");
    
    [kMainViewController hideLeftViewAnimated:YES completionHandler:nil];
    UIViewController *lViewController;
    EEContainerVC *lContainer = [[[kMainViewController rootViewController] childViewControllers] objectAtIndex:0];
    CGRect lViewRect = lContainer.view.frame;
    lViewRect.size.height = lViewRect.size.height - 64;
    lViewRect.origin.y = lViewRect.origin.y + 64;
    NSLog(@"lContainer frame - %@", NSStringFromCGRect(lContainer.view.frame));
    switch (indexPath.row) {
        case Friends:{
            lViewController = VIEW_CONTROLLER_WITH_ID(@"EEFriendsListVC");
            lViewController.view.frame = lViewRect;
            [lContainer addSubviewAsChildVC:lViewController];
            lContainer.navigationItem.title = localizedFriendsString;
        }
            break;
        case Albums:{
            [EEAppManager sharedAppManager].currentFriend = [EEAppManager sharedAppManager].loggedUser;
            lViewController = VIEW_CONTROLLER_WITH_ID(@"EEAlbumsVC");
            lViewController.view.frame = lViewRect;
            [lContainer addSubviewAsChildVC:lViewController];
            lContainer.navigationItem.title = localizedAlbumsString;
        }
            break;
        case RecentlyAdded:{
            lViewController = VIEW_CONTROLLER_WITH_ID(@"EERecentlyAddedVC");
            lViewController.view.frame = lViewRect;
            [lContainer addSubviewAsChildVC:lViewController];
            lContainer.navigationItem.title = localizedRecentlyAddedString;
        }
            break;
        case Settings:{
            lViewController = VIEW_CONTROLLER_WITH_ID(@"EESettingsVC");
            lViewController.view.frame = lViewRect;
            [lContainer addSubviewAsChildVC:lViewController];
            lContainer.navigationItem.title = localizedSettingsString;
        }
            break;
        case AddPhoto:{
            lViewController = VIEW_CONTROLLER_WITH_ID(@"EEAddPhotoVC");
            lViewController.view.frame = lViewRect;
            [lContainer addSubviewAsChildVC:lViewController];
            lContainer.navigationItem.title = localizedAddPhotoString;
        }
    }
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

@end
