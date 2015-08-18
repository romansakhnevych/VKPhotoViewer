//
//  EEPhotoGalleryVC.h
//  VKPhotoViewer
//
//  Created by admin on 8/12/15.
//  Copyright (c) 2015 Admin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EEAlbum.h"

@interface EEPhotoGalleryVC : UIViewController <UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, UIScrollViewDelegate>
@property (nonatomic, retain) NSMutableArray *allPhotos;
@property (nonatomic)NSInteger index;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (nonatomic,retain) EEAlbum *album;

@end
