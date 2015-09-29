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
{
    NSIndexPath *selectedIndexPath;
}
@property (strong, nonatomic) NSArray *titlesArray;


@end

@implementation LeftViewController
- (void) viewDidLoad {
    [super viewDidLoad];
//    
//    UIButton* logOutBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, self.tableView.frame.size.height - 50, self.tableView.frame.size.width, 50)];
//    logOutBtn.titleLabel.text = @"LogOut";
//    [logOutBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//    //[logOutBtn setTitleColor: forState:<#(UIControlState)#>]
//    [logOutBtn addTarget:self action:@selector(logOut) forControlEvents:UIControlEventTouchUpInside];
//    //[[[UIApplication sharedApplication] windows] objectsAtIndexes:0]
//    [self.view addSubview:logOutBtn];
    
    selectedIndexPath = [NSIndexPath indexPathForRow:0 inSection:0];
   
    
    NSString *localizedFriendsString = NSLocalizedString(@"FriendsKey", @"");
    NSString *localizedAlbumsString = NSLocalizedString(@"AlbumsKey", @"");
    NSString *localizedRecentlyAddedString = NSLocalizedString(@"RecentlyAddedKey", @"");
    //NSString *localizedSettingsString = NSLocalizedString(@"SettingsKey", @"");
    //NSString *localizedAddPhotoString = NSLocalizedString(@"AddPhotoKey", @"");
    
    _titlesArray = @[localizedFriendsString,
                     localizedAlbumsString,
                     localizedRecentlyAddedString,];
    [self.tableView setTableFooterView:[[UIView alloc] initWithFrame:CGRectZero]];
    self.tableView.contentInset = UIEdgeInsetsMake(20.f, 0.f, 20.f, 0.f);
    self.tableView.showsVerticalScrollIndicator = NO;
    EECustomTableHeaderView *view = [EECustomTableHeaderView createView];
    view.delegate = self;
    self.tableView.tableHeaderView = view;
    
    NSString *lLoggedUserId = [[NSUserDefaults standardUserDefaults] objectForKey:USER_ID_KEY];
    [[EEAppManager sharedAppManager] getDetailByUserId:lLoggedUserId completionSuccess:^(BOOL successLoad, EEFriends *friendModel) {
        [EEAppManager sharedAppManager].loggedUser = friendModel;
        view.nameLable.text = friendModel.firstName;
        view.lastNameLabel.text = friendModel.lastName;
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

    [cell.textLabel setTextColor:[UIColor whiteColor]];
    cell.backgroundColor = NAVIGATION_BAR_TINT_COLOR;
    if(indexPath.row == selectedIndexPath.row) {
        [cell setHighlighted:YES];
    }
//            }
//    NSString *localizedFriendsString = NSLocalizedString(@"FriendsKey", @"");
//    NSString *localizedAlbumsString = NSLocalizedString(@"AlbumsKey", @"");
//    NSString *localizedRecentlyAddedString = NSLocalizedString(@"RecentlyAddedKey", @"");
//    NSString *localizedSettingsString = NSLocalizedString(@"SettingsKey", @"");
//    NSString *localizedAddPhotoString = NSLocalizedString(@"AddPhotoKey", @"");
    
    switch (indexPath.row) {
        case Friends:{
            cell.imageView.image = [UIImage imageNamed:@"FriendsWhite"];
//            cell.selected = YES;
            [tableView selectRowAtIndexPath:indexPath animated:NO scrollPosition:UITableViewScrollPositionNone];
            //[self tableView:tableView didSelectRowAtIndexPath:indexPath];
            [cell setBackgroundColor:[UIColor whiteColor]];
            [cell.textLabel setTextColor:CUSTOM_YELLOW_COLOR];
        }
            break;
        case Albums:{
            cell.imageView.image = [UIImage imageNamed:@"albumsWhite"];
        }
            break;
        case RecentlyAdded:{
            cell.imageView.image = [UIImage imageNamed:@"recentlyAddedWhite"];
        }
            break;
//        case Settings:{
//            cell.imageView.image = [UIImage imageNamed:@"settingsWhite"];
//        }
            break;
           }

        return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 44.0f;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    LeftViewCell* cell = (LeftViewCell*)[tableView cellForRowAtIndexPath:indexPath];
    [cell setBackgroundColor:[UIColor whiteColor]];
    [cell.textLabel setTextColor:CUSTOM_YELLOW_COLOR];
    
        
    NSString *localizedFriendsString = NSLocalizedString(@"FriendsKey", @"");
    NSString *localizedAlbumsString = NSLocalizedString(@"AlbumsKey", @"");
    NSString *localizedRecentlyAddedString = NSLocalizedString(@"RecentlyAddedKey", @"");
    //NSString *localizedSettingsString = NSLocalizedString(@"SettingsKey", @"");
    //NSString *localizedAddPhotoString = NSLocalizedString(@"AddPhotoKey", @"");
    
    [kMainViewController hideLeftViewAnimated:YES completionHandler:nil];
    EEContainerVC *lContainer = [[[kMainViewController rootViewController] childViewControllers] objectAtIndex:0];
    CGRect lViewRect = lContainer.view.frame;
    lViewRect.size.height = lViewRect.size.height - 64;
    lViewRect.origin.y = lViewRect.origin.y + 64;
    NSLog(@"lContainer frame - %@", NSStringFromCGRect(lContainer.view.frame));
    switch (indexPath.row) {
        case Friends:{
            UIViewController *lViewController;
            [lContainer removeChildVC];
            lViewController = VIEW_CONTROLLER_WITH_ID(@"EEFriendsListVC");
            [lContainer addSubviewAsChildVC:lViewController];
            lContainer.navigationItem.title = localizedFriendsString;
            cell.imageView.image = [UIImage imageNamed:@"FriendsYellow"];

        }
            break;
        case Albums:{
            UIViewController *lViewController;
            [lContainer removeChildVC];
            [EEAppManager sharedAppManager].currentFriend = [EEAppManager sharedAppManager].loggedUser;
            lViewController = VIEW_CONTROLLER_WITH_ID(@"EEAlbumsVC");
            lViewController.view.frame = lViewRect;
            [lContainer addSubviewAsChildVC:lViewController];
            lContainer.navigationItem.title = localizedAlbumsString;
            cell.imageView.image = [UIImage imageNamed:@"albumsYellow"];
        }
            break;
        case RecentlyAdded:{
            UIViewController *lViewController;
            [lContainer removeChildVC];
            lViewController = VIEW_CONTROLLER_WITH_ID(@"EERecentlyAddedVC");
            lViewController.view.frame = lViewRect;
            [lContainer addSubviewAsChildVC:lViewController];
            lContainer.navigationItem.title = localizedRecentlyAddedString;
            cell.imageView.image = [UIImage imageNamed:@"recentlyAddedYellow"];
        }
            break;
//        case Settings:{
//            lViewController = VIEW_CONTROLLER_WITH_ID(@"EESettingsVC");
//            lViewController.view.frame = lViewRect;
//            [lContainer addSubviewAsChildVC:lViewController];
//            lContainer.navigationItem.title = localizedSettingsString;
//            cell.imageView.image = [UIImage imageNamed:@"settingsYellow"];
//        }
//            break;
//        case AddPhoto:{
//            lViewController = VIEW_CONTROLLER_WITH_ID(@"EEAddPhotoVC");
//            lViewController.view.frame = lViewRect;
//            [lContainer addSubviewAsChildVC:lViewController];
//            lContainer.navigationItem.title = localizedAddPhotoString;
//        }
    }
   
}

-(void) tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath {
    LeftViewCell* cell = (LeftViewCell*)[tableView cellForRowAtIndexPath:indexPath];
    [cell.textLabel setTextColor:[UIColor whiteColor]];
    cell.backgroundColor = NAVIGATION_BAR_TINT_COLOR;
    switch (indexPath.row) {
        case Friends:{
            
            cell.imageView.image = [UIImage imageNamed:@"FriendsWhite"];
            
        }
            break;
        case Albums:{
            cell.imageView.image = [UIImage imageNamed:@"albumsWhite"];
        }
            break;
        case RecentlyAdded:{
            cell.imageView.image = [UIImage imageNamed:@"recentlyAddedWhite"];
        }
            break;
//        case Settings:{
//            cell.imageView.image = [UIImage imageNamed:@"settingsWhite"];
//        }
//            break;
    }


}

-(void)logOut {
    NSHTTPCookieStorage *lStorage = [NSHTTPCookieStorage sharedHTTPCookieStorage];
    
    for (NSHTTPCookie *cookie in [lStorage cookies]) {
        [lStorage deleteCookie:cookie];
    }
    //[EEAppManager sharedAppManager].loggedUser = nil;
    
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:ACCESS_TOKEN_KEY];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:USER_ID_KEY];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:TOKEN_LIFE_TIME_KEY];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:CREATED];
    [[NSUserDefaults standardUserDefaults] synchronize];
//    [self ]
    [kMainViewController hideLeftViewAnimated:YES completionHandler:nil];
    UIStoryboard * lStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    UIViewController *lViewController = [lStoryboard instantiateViewControllerWithIdentifier:@"login"];
    [kNavigationController popToRootViewControllerAnimated:YES];
    //[kMainViewController pushViewController:lViewController animated:YES];
    //[kMainViewController rootViewController]
    //[kMainViewController po
    //[kMainViewController popToViewController:lViewController animated:YES];
    //[self.navigationController pushViewController:lViewController  animated:YES];
//    [self.navigationController performSegueWithIdentifier:@"logOutSegueIdentifier" sender:self];
    //[kMainViewController]
}
@end
