//
//  EEPhotoBrowserVC.m
//  VKPhotoViewer
//
//  Created by admin on 8/11/15.
//  Copyright (c) 2015 Admin. All rights reserved.
//

#import "EEPhotoBrowserVC.h"
#import "EEAppManager.h"
@interface EEPhotoBrowserVC ()

@end

@implementation EEPhotoBrowserVC

- (void)viewDidLoad {
    [_spinner startAnimating];
    [_spinner setHidesWhenStopped:YES];
    [super viewDidLoad];
    //[self.navigationController setNavigationBarHidden:YES animated:YES];
    _index = [EEAppManager sharedAppManager].currentPhotoIndex;
    _allPhotos = [EEAppManager sharedAppManager].allPhotos;
    [self setPhotoAtIndex:_index];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
 }

#pragma mark - Private methods

- (void)setPhotoAtIndex:(NSInteger)index {
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
            _imageView.image = image;
        }else{
            _imageView.image = [UIImage imageNamed:@"placeholder.png"];
        }
        [_spinner stopAnimating];
        
    }];
    self.navigationItem.title = [NSString stringWithFormat:@"%ld of %ld",_index+1,[_allPhotos count]];
}


- (IBAction)tapHandle:(UITapGestureRecognizer *)sender {
    if (!self.navigationController.navigationBarHidden){
        [self.navigationController setNavigationBarHidden:YES animated:YES];
    }else{
        [self.navigationController setNavigationBarHidden:NO animated:YES];
    }

}

- (IBAction)leftSwipeHandle:(UISwipeGestureRecognizer *)sender {
    
    _imageView.image = nil;
    [_spinner startAnimating];
    _index++;
    if (_index > [_allPhotos count]-1){
        _index = 0;
    }
    [self setPhotoAtIndex:_index];
}

- (IBAction)rightSwipeHandle:(UISwipeGestureRecognizer *)sender {
   
    _imageView.image = nil;
    [_spinner startAnimating];
    _index--;
    if (_index < 0){
        _index = [_allPhotos count]-1;
    }
    [self setPhotoAtIndex:_index];
}

@end
