//
//  EEAlbumsVC.h
//  VKPhotoViewer
//
//  Created by admin on 8/7/15.
//  Copyright (c) 2015 Admin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EEFriends.h"

@interface EEAlbumsVC : UITableViewController <UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,retain)NSMutableArray *albumsList;
@property (nonatomic)NSInteger offset;
@property (nonatomic)NSInteger count;
@property (nonatomic)NSInteger loadedAlbumsCount;
@property (nonatomic,retain)EEFriends *user;

@end
