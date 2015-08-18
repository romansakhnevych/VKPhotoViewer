//
//  EEPhotoGalleryVC.m
//  VKPhotoViewer
//
//  Created by admin on 8/12/15.
//  Copyright (c) 2015 Admin. All rights reserved.
//

#import "EEPhotoGalleryVC.h"
#import "Constants.h"
#import "EEAppManager.h"
#import "EEGalleryCell.h"


@interface EEPhotoGalleryVC ()

@end
NSInteger spacing = 0;
static NSString *CelID = @"GalleryCell";

@implementation EEPhotoGalleryVC

- (void)viewDidLoad {
    [super viewDidLoad];
    _index = [EEAppManager sharedAppManager].currentPhotoIndex;
    _allPhotos = [EEAppManager sharedAppManager].allPhotos;
    _album = [EEAppManager sharedAppManager].currentAlbum;
    [self setupCollectionView];
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    
    NSIndexPath *lIndexPath = [NSIndexPath indexPathForItem:_index inSection:0];
    [_collectionView scrollToItemAtIndexPath:lIndexPath atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:NO];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return [_allPhotos count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    
    EEGalleryCell *lCell = (EEGalleryCell *)[collectionView dequeueReusableCellWithReuseIdentifier:CelID forIndexPath:indexPath];
    
    lCell.imageView.image = nil;
    [lCell.spinner startAnimating];
    [lCell.spinner setHidesWhenStopped:YES];
   
    
    
   dispatch_async(dispatch_get_main_queue(), ^{
        [self setPhotoAtIndex:indexPath.row withCompletion:^(UIImage *image) {
            lCell.imageView.image = image;
            [lCell.spinner stopAnimating];
        }];
   });
    
    
    self.navigationItem.title = [NSString stringWithFormat:@"%ld of %@",indexPath.row+1,[_album getAlbumSize]];
    return lCell;
}
//
//- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset {
//    *targetContentOffset = scrollView.contentOffset;
//    float pageWidth = (float)self.collectionView.bounds.size.width;
//    int minSpace = 20;
//    
//    int cellToSwipe = (scrollView.contentOffset.x)/(pageWidth + minSpace) + 0.5;
//    if (cellToSwipe < 0) {
//        cellToSwipe = 0;
//    } else if (cellToSwipe >= self.allPhotos.count) {
//        cellToSwipe = (int)self.allPhotos.count - 1;
//    }
//    [self.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForRow:cellToSwipe inSection:0] atScrollPosition:UICollectionViewScrollPositionLeft animated:YES];
//}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{

    return CGSizeMake(self.view.frame.size.width, self.view.frame.size.height);
}



- (void)setupCollectionView{
    
    [self.collectionView registerClass:[EEGalleryCell class] forCellWithReuseIdentifier:CelID];
    
    UICollectionViewFlowLayout *lFlowLayout = [[UICollectionViewFlowLayout alloc] init];
    [lFlowLayout setScrollDirection:UICollectionViewScrollDirectionHorizontal];
    lFlowLayout.minimumInteritemSpacing = 0;
    lFlowLayout.minimumLineSpacing = 0;
    [self.collectionView setPagingEnabled:YES];
    [self.collectionView setCollectionViewLayout:lFlowLayout];
}

- (void)setPhotoAtIndex:(NSInteger)index withCompletion:(void (^)(UIImage *image))succsess{
    NSString *lLink;
    EEPhoto *lPhoto = [[EEPhoto alloc] init];
    lPhoto = [_allPhotos objectAtIndex:index];
    BOOL lNoPhoto = NO;
    
    if (lPhoto.xxlPhotoLink){
        lLink = lPhoto.xxlPhotoLink;
    }else if (lPhoto.xlPhotoLink){
        lLink = lPhoto.xlPhotoLink;
        
    }else if (lPhoto.lPhotoLink){
        lLink = lPhoto.lPhotoLink;
        
    }else if (lPhoto.mPhotoLink){
        lLink = lPhoto.mPhotoLink;
        
    }else if (lPhoto.sPhotoLink){
        lLink = lPhoto.sPhotoLink;
        
    }else if (lPhoto.xsPhotoLink){
        lLink = lPhoto.xsPhotoLink;
        
    }else{
        lNoPhoto = YES;
    }
    
    [[EEAppManager sharedAppManager] getPhotoByLink:lLink withCompletion:^(UIImage *image, BOOL animated) {
        if (!lNoPhoto){
           succsess(image);
        }else{
            succsess([UIImage imageNamed:@"placeholder.png"]);
        }
        
        
    }];
    
}



@end
