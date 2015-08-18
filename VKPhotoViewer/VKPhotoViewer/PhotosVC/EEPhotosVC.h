//
//  EEPhotosVC.h
//  VKPhotoViewer
//
//  Created by admin on 8/7/15.
//  Copyright (c) 2015 Admin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EEFriends.h"
#import "EEAlbum.h"


@interface EEPhotosVC : UICollectionViewController <UICollectionViewDataSource,UICollectionViewDelegate>

@property (nonatomic,retain)NSMutableArray *photosList;
@property (nonatomic)NSInteger count;
@property (nonatomic)NSInteger offset;
@property (nonatomic)NSInteger loadedPhotosCount;
@property (nonatomic,retain)EEFriends *user;
@property (nonatomic,retain)EEAlbum *album;

@end
