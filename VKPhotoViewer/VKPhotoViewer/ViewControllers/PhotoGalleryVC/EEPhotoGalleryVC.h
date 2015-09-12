//
//  EEPhotoGalleryVC.h
//  VKPhotoViewer
//
//  Created by admin on 8/12/15.
//  Copyright (c) 2015 Admin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EEAlbum.h"
#import "EEPhoto.h"

@protocol BaseAlbumDelegate <NSObject>

@required
-(void)BaseAlbumDelegateUploadPhotos:(void (^)())updateData;

@end

@interface EEPhotoGalleryVC : UIViewController <UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, UIScrollViewDelegate>
@property (nonatomic, retain) NSMutableArray *allPhotos;
@property (nonatomic) NSInteger currentIndex;
@property (nonatomic) NSInteger newIndex;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (nonatomic,retain) EEAlbum *album;
@property (weak, nonatomic) IBOutlet UILabel *likesCountLbl;
@property (weak, nonatomic) IBOutlet UIButton *likeBtn;
@property (nonatomic, retain)UIImage *image;

@property (nonatomic,weak) id <BaseAlbumDelegate> baseAlbumDelegate;

- (IBAction)likeBtnTaped:(id)sender;
- (IBAction)shareBtnTaped:(id)sender;


@end
