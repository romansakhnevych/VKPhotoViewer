//
//  EETransitionFromPhotoGalleryVCToPhotosVC.m
//  VKPhotoViewer
//
//  Created by админ on 9/12/15.
//  Copyright (c) 2015 Admin. All rights reserved.
//

#import "EETransitionFromPhotoGalleryVCToPhotosVC.h"
#import "EEPhotoCell.h"
#import "EEGalleryCell.h"
#import "EEPhotosVC.h"
#import "EEPhotoGalleryVC.h"

@implementation EETransitionFromPhotoGalleryVCToPhotosVC
- (NSTimeInterval)transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext {
    return 0.3;
}

- (void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext {
    
    EEPhotoGalleryVC* fromViewController = (EEPhotoGalleryVC*)[transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    EEPhotosVC* toViewController = (EEPhotosVC*)[transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    
    UIView* containerView = [transitionContext containerView];
    NSTimeInterval duration = [self transitionDuration:transitionContext];
    
    
    EEGalleryCell* cellGallery = [fromViewController visableCell];
    EEPhotoCell* cellSmallPhoto = [toViewController cellWithIndex:fromViewController.currentIndex];
    toViewController.collectionView.alpha = 0.0;
    [toViewController.view setBackgroundColor:[UIColor blackColor]];
    
    UIView *imageSnapshot = [cellGallery.imageView snapshotViewAfterScreenUpdates:NO];
    imageSnapshot.frame = [containerView convertRect:cellGallery.imageView.frame fromView:cellGallery.imageView.superview];
    cellSmallPhoto.hidden = YES;
    
    
    UICollectionViewLayoutAttributes *attributes = [toViewController.collectionView layoutAttributesForItemAtIndexPath:[toViewController.collectionView indexPathForCell:cellSmallPhoto]];
    CGRect cellRect = attributes.frame;
    CGRect frameInSuperView = [toViewController.collectionView convertRect:cellRect toView:[toViewController.collectionView superview]];
    toViewController.view.frame = [transitionContext finalFrameForViewController:toViewController];
    [containerView insertSubview:toViewController.view belowSubview:fromViewController.view];
    [containerView addSubview:imageSnapshot];
    
    
    double toMakePhotoBiggerWidth = cellGallery.imageView.image.size.width/frameInSuperView.size.width;
    double toMakePhotoBiggerHeight = cellGallery.imageView.image.size.height/frameInSuperView.size.height;
    
    
    CGRect finalFrame = CGRectMake(frameInSuperView.origin.x - (([UIScreen mainScreen].bounds.size.width - cellGallery.imageView.image.size.width)/2)/toMakePhotoBiggerWidth, frameInSuperView.origin.y - (([UIScreen mainScreen].bounds.size.height - cellGallery.imageView.image.size.height)/2)/toMakePhotoBiggerHeight, ([UIScreen mainScreen].bounds.size.width/cellGallery.imageView.image.size.width)*frameInSuperView.size.width, ([UIScreen mainScreen].bounds.size.height/cellGallery.imageView.image.size.height)*frameInSuperView.size.height);
    fromViewController.view.alpha = 0.0;
    [UIView animateWithDuration:duration animations:^{
        
        toViewController.collectionView.alpha = 1;
        
        
        if (!cellSmallPhoto) {
            [imageSnapshot removeFromSuperview];
        }
        else {
            imageSnapshot.frame = finalFrame;
        }
        
        
    } completion:^(BOOL finished) {
        
        [imageSnapshot removeFromSuperview];
        cellGallery.imageView.hidden = NO;
        cellSmallPhoto.hidden = NO;
        

        [transitionContext completeTransition:!transitionContext.transitionWasCancelled];
    }];
    
}
@end
