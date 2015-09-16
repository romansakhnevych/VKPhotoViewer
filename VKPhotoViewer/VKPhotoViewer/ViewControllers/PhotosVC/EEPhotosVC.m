//
//  EEPhotosVC.m
//  VKPhotoViewer
//
//  Created by admin on 8/7/15.
//  Copyright (c) 2015 Admin. All rights reserved.
//

#import "EEPhotosVC.h"
#import "EEPhotoCell.h"
#import "EEAppManager.h"
#import "EEPhoto.h"
#import "UIImageView+Haneke.h"
#import "EEPhotoGalleryVC.h"
#import "EETransitionFromPhotosVCToPhotoGalleryVC.h"
#import "EETransitionFromPhotoGalleryVCToPhotosVC.h"
#import "MBProgressHUD.h"


@interface EEPhotosVC ()

@end

@implementation EEPhotosVC

static NSString * const reuseIdentifier = @"PhotoCell";

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _photosList = [[NSMutableArray alloc] init];
    _count = 60;
    _offset = 0;
    _user = [[EEAppManager sharedAppManager] currentFriend];
    _album = [[EEAppManager sharedAppManager] currentAlbum];
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_LOW, 0), ^{
        self.navigationItem.title = _album.albumTitle;
        [self updateDataWithCount:_count Offset:_offset AlbumId:_album.albumID UserId:_user.userId completion:nil];
        dispatch_async(dispatch_get_main_queue(), ^{
            [MBProgressHUD hideHUDForView:self.view animated:YES];
        });
    });
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    // Set outself as the navigation controller's delegate so we're asked for a transitioning object
    self.navigationController.delegate = self;
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    // Stop being the navigation controller's delegate
    if (self.navigationController.delegate == self) {
        self.navigationController.delegate = nil;
    }
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


#pragma mark <UICollectionViewDataSource>

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return [_photosList count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == [collectionView numberOfItemsInSection:0] - 1 && _loadedPhotosCount == _count){
        [self updateDataWithCount:_count Offset:_offset AlbumId:_album.albumID UserId:_user.userId completion:nil];
    }
    EEPhotoCell *lCell = (EEPhotoCell *)[collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
    EEPhoto *lPhoto = [_photosList objectAtIndex:indexPath.row];
    lCell.imageView.image = [UIImage imageNamed:@"PlaceholderIcon"];
    [lCell.imageView hnk_setImageFromURL:[NSURL URLWithString:lPhoto.mPhotoLink ] placeholder:[UIImage imageNamed:@"PlaceholderIcon"] success:^(UIImage *image) {
        lCell.imageView.image = image;
    } failure:^(NSError *error) {
        
    }];
    return lCell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    UIStoryboard * lStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    EEPhotoGalleryVC *lViewController = [lStoryboard instantiateViewControllerWithIdentifier:@"PhotoView"];
    [[self navigationController] pushViewController:lViewController animated:YES];
    [EEAppManager sharedAppManager].currentPhotoIndex = indexPath.row;
    [EEAppManager sharedAppManager].allPhotos = _photosList;
    [EEAppManager sharedAppManager].currentPhoto = [_photosList objectAtIndex:indexPath.row];
}

- (UIEdgeInsets)collectionView:
(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(15, 5, 20, 5); /*top, left, bottom, right*/
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    NSInteger cellWidth = (self.view.bounds.size.width - 20) / 3 ;
    CGSize retval = CGSizeMake(cellWidth, cellWidth);
    return retval;
}

#pragma mark - Private Methods

- (void)updateDataWithCount:(NSInteger)count
                     Offset:(NSInteger)offset
                    AlbumId:(NSString *)albumId
                     UserId:(NSString *)userId
                 completion:(void (^)())updateData{
    
    [[EEAppManager sharedAppManager] getPhotosWithCount:count offset:offset fromAlbum:albumId forUser:userId completionSuccess:^(id responseObject) {
        if ([responseObject isKindOfClass:[NSMutableArray class]]){
            [_photosList addObjectsFromArray:responseObject];
            _loadedPhotosCount = [responseObject count];
            _offset+=60;
        }else{
            NSLog(@"error");
        }
        if (updateData) {
            updateData();
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.collectionView reloadData];
        });
    } completionFailure:^(NSError *error) {
        NSLog(@"error - %@",error);
    }];
}

- (EEPhotoCell*)cellWithIndex: (NSInteger) index {
    return (EEPhotoCell*)[self.collectionView cellForItemAtIndexPath:[NSIndexPath indexPathForRow:index inSection:0]];
}

#pragma mark - UIViewControllerAnimatedTransitioning implementation

- (id<UIViewControllerAnimatedTransitioning>)navigationController:(UINavigationController *)navigationController
                                  animationControllerForOperation:(UINavigationControllerOperation)operation
                                               fromViewController:(UIViewController *)fromVC
                                                 toViewController:(UIViewController *)toVC {
    // Check if we're transitioning from this view controller to a DSLSecondViewController
    if (fromVC == self && [toVC isKindOfClass:[EEPhotoGalleryVC class]]) {
        return [[EETransitionFromPhotosVCToPhotoGalleryVC alloc] init];
    }
    else {
        return nil;
    }
}
@end
