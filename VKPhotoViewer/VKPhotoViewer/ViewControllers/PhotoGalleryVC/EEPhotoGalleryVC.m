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
#import "UIImageView+Haneke.h"
#import "EETransitionFromPhotoGalleryVCToPhotosVC.h"
#import "EETransitionFromPhotosVCToPhotoGalleryVC.h"
#import "EEPhotosVC.h"
#import "EEFiltredVC.h"

@interface EEPhotoGalleryVC ()

@end
NSInteger spacing = 0;
static NSString *CelID = @"GalleryCell";

@implementation EEPhotoGalleryVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navigationController setNavigationBarHidden:YES];
    [_uperView setBackgroundColor:[UIColor colorWithRed:89.0/255.0f green:179.0/255.0f blue:209.0/255.0f alpha:0.5f]];
    [ _bottomView setBackgroundColor:[UIColor colorWithRed:89.0/255.0f green:179.0/255.0f blue:209.0/255.0f alpha:0.5f]];
   // _currentIndex = [EEAppManager sharedAppManager].currentPhotoIndex;
   // _allPhotos = nil;
  //  _allPhotos = [NSMutableArray arrayWithArray:[EEAppManager sharedAppManager].allPhotos];
  //  _album = [EEAppManager sharedAppManager].currentAlbum;
    _image = [UIImage new];
    [self setupCollectionView];
   
    if ([[_allPhotos objectAtIndex:_currentIndex] isLiked]) {
        _likeBtn.imageView.image = [UIImage imageNamed:@"LikeFilled"];
    } else {
        _likeBtn.imageView.image = [UIImage imageNamed:@"Like"];
    }
    _likesCountLbl.text = [[_allPhotos objectAtIndex:_currentIndex] getLikesCount];
}

- (instancetype)initWithStoryboard{
    self = (EEPhotoGalleryVC *)VIEW_CONTROLLER_WITH_ID(@"PhotoView");
    if (self) {
         _topLabel.text = [NSString stringWithFormat:@"%ld of %@",_currentIndex + 1,[EEAppManager sharedAppManager].currentAlbum.size];
    }
    return self;
}

- (instancetype)initWithPhoto:(EEPhoto *)photo
                               index:(NSInteger)index{
    self = [self initWithStoryboard];
    if (self) {
    _allPhotos = [NSMutableArray arrayWithObjects:photo, nil];
    _currentIndex = index;
    self.navigationItem.title = @"rec";
    }
    return self;
}

- (instancetype)initWithAllPhotos:(NSMutableArray *)allPhotos currentIndex:(NSInteger)index{
    self = [self initWithStoryboard];
    if (self) {
        _allPhotos = allPhotos;
        _currentIndex = index;
    }
    return self;
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    self.uperView.hidden  = NO;
    // Set outself as the navigation controller's delegate so we're asked for a transitioning object
    self.navigationController.delegate = self;
    
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:NO];
    // Stop being the navigation controller's delegate
    if (self.navigationController.delegate == self) {
        self.navigationController.delegate = nil;
    }
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    
    NSIndexPath *lIndexPath = [NSIndexPath indexPathForItem:_currentIndex inSection:0];
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

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    NSString* albumSizeToString = [NSString stringWithFormat:@"%lu",(unsigned long)[EEAppManager sharedAppManager].allPhotos.count];
    if (indexPath.row == [EEAppManager sharedAppManager].allPhotos.count - 1
        && ![albumSizeToString isEqualToString:[[EEAppManager sharedAppManager].currentAlbum getAlbumSize]]) {
        [[EEAppManager sharedAppManager] UploadPhotos: ^{
            [_collectionView reloadData];
        }];
    }
    EEGalleryCell *lCell = (EEGalleryCell *)[collectionView dequeueReusableCellWithReuseIdentifier:CelID forIndexPath:indexPath];
    lCell.imageView.image = nil;
    [lCell.spinner startAnimating];
    [lCell.spinner setHidesWhenStopped:YES];
    _newIndex = indexPath.row;
    UIImage* placeholderImg = [[UIImage alloc] init];
    UITapGestureRecognizer* tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapped)];
    [lCell.imageView addGestureRecognizer:tap];
    
    _isImageLoaded = NO;
    NSString *lPhotoLink = [self setPhotoAtIndex:indexPath.row];
    [lCell.imageView hnk_setImageFromURL:[NSURL URLWithString:lPhotoLink] placeholder:placeholderImg success:^(UIImage *image) {
        
        _isImageLoaded = YES;
        [self.cellImageSnapshot removeFromSuperview];
        [lCell.spinner stopAnimating];
        lCell.imageView.image = image;
        _image = image;
    } failure:^(NSError *error) {
        
    }];
    return lCell;
}

-(void)collectionView:(UICollectionView *)collectionView didEndDisplayingCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath {
    //for case, when cell changes
    if (indexPath.row != _newIndex) {
        if (_newIndex > _currentIndex) {
            _currentIndex++;
        } else {
            _currentIndex--;
        }
        EEPhoto *lPhoto = [_allPhotos objectAtIndex:_currentIndex];
        [EEAppManager sharedAppManager].currentPhoto = lPhoto;
        ((EEGalleryCell*)cell).photo = lPhoto;
        _topLabel.text = [NSString stringWithFormat:@"%ld of %@",_currentIndex + 1,[EEAppManager sharedAppManager].currentAlbum.size];
        if ([[_allPhotos objectAtIndex:_currentIndex] isLiked]) {
            _likeBtn.imageView.image = [UIImage imageNamed:@"LikeFilled"];
        } else {
            _likeBtn.imageView.image = [UIImage imageNamed:@"Like"];
        }
        
        _likesCountLbl.text = [lPhoto getLikesCount];
    }
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    return CGSizeMake(self.view.frame.size.width, self.view.frame.size.height);
}

- (void)setupCollectionView {
    [self.collectionView registerClass:[EEGalleryCell class] forCellWithReuseIdentifier:CelID];
    UICollectionViewFlowLayout *lFlowLayout = [[UICollectionViewFlowLayout alloc] init];
    [lFlowLayout setScrollDirection:UICollectionViewScrollDirectionHorizontal];
    lFlowLayout.minimumInteritemSpacing = 0;
    lFlowLayout.minimumLineSpacing = 0;
    [self.collectionView setPagingEnabled:YES];
    [self.collectionView setCollectionViewLayout:lFlowLayout];
}

- (NSString *)setPhotoAtIndex:(NSInteger)index {
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
    //change image quality
    NSString *imageQuality = GET_DEFAULT_VALUE(QUALITY_VALUE);
    if ([imageQuality  isEqual: @"0"]) {
        lLink = lPhoto.lPhotoLink;
        NSLog(@"middle image quality!!!");
    }
    else {
        NSLog(@"best quality!!!");
    }
    
    return lLink;
}

#pragma mark - button realization

- (IBAction)shareBtnTaped:(id)sender {
    
    NSArray *sharedItems = [[NSArray alloc] initWithObjects:_image, nil];
    UIActivityViewController *lActivityViewController = [[UIActivityViewController alloc] initWithActivityItems:sharedItems applicationActivities:nil];
    
    lActivityViewController.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
    
    [self presentViewController:lActivityViewController animated:YES completion:nil];
    
    
}
- (IBAction)closeBtnTapped:(id)sender {
    if(self.isDetailed) {
        [self dismissViewControllerAnimated:YES completion:nil];
    }
    else {
    [self.navigationController popViewControllerAnimated:YES];
    }
}
- (IBAction)likeBtnTaped:(id)sender {
    if ([[EEAppManager sharedAppManager].currentPhoto isLiked]) {
        [[EEAppManager sharedAppManager] deleteLikeForCurrentFriendPhotoWithCaptcha:nil
         CompletionSuccess:^(id responseObject) {
            NSInteger lLikesCount = [(NSNumber *)[[responseObject objectForKey:@"response"] objectForKey:@"likes"] integerValue];
            _likesCountLbl.text = [NSString stringWithFormat:@"%li",(long)lLikesCount];
            _likeBtn.imageView.image = [UIImage imageNamed:@"Like"];
            [EEAppManager sharedAppManager].currentPhoto.Liked = [NSNumber numberWithInt:0];
            [EEAppManager sharedAppManager].currentPhoto.likesCount = [NSNumber numberWithInteger:lLikesCount];
        } completionFailure:^(NSError *error) {
            
        }];
    } else {
 
        [[EEAppManager sharedAppManager] addLikeForCurrentFriendPhotoWithCaptha:nil CompletionSuccess:^(id responseObject) {
                    NSInteger lLikesCount = [(NSNumber *)[[responseObject objectForKey:@"response"] objectForKey:@"likes"] integerValue];
                    _likesCountLbl.text = [NSString stringWithFormat:@"%li",(long)lLikesCount];
                    _likeBtn.imageView.image = [UIImage imageNamed:@"LikeFilled"];
                    [EEAppManager sharedAppManager].currentPhoto.Liked = [NSNumber numberWithInt:1];
                    [EEAppManager sharedAppManager].currentPhoto.likesCount = [NSNumber numberWithInteger:lLikesCount];
        } completionFailure:^(NSError *error) {
            
        }];
    }
}

-(void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if([segue.identifier isEqualToString:@"pushFiltredVCSegueIdentfier"]) {
        ((EEFiltredVC*)segue.destinationViewController).linkForPhoto = [self setPhotoAtIndex:self.currentIndex];
        
    }
}
- (id<UIViewControllerAnimatedTransitioning>)navigationController:(UINavigationController *)navigationController
                                  animationControllerForOperation:(UINavigationControllerOperation)operation
                                               fromViewController:(UIViewController *)fromVC
                                                 toViewController:(UIViewController *)toVC {
    // Check if we're transitioning from this view controller to a DSLFirstViewController
    if (fromVC == self && [toVC isKindOfClass:[EEPhotosVC class]]) {
        return [[EETransitionFromPhotoGalleryVCToPhotosVC alloc] init];
    }
    else {
        return nil;
    }
}
-(EEGalleryCell*) visableCell {
    return (EEGalleryCell*)[self.collectionView cellForItemAtIndexPath:[NSIndexPath indexPathForRow:self.currentIndex inSection:0]];
}

-(void)tapped {
    [UIView animateWithDuration:0.3 animations:^{
        if(self.uperView.hidden == YES) {
            self.uperView.hidden = NO;
            self.bottomView.hidden = NO;
        }
        else {
            self.uperView.hidden = YES;
            self.bottomView.hidden = YES;
        }
    }];
    
}
@end
