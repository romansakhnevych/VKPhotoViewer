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

@interface EEFriendsListVC : UITableViewController <UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,retain) NSMutableArray *friendsList;
@property (nonatomic) NSInteger offset;
@property (nonatomic) NSInteger count;
@property (nonatomic) NSInteger loadedFriendsCount;

@end
