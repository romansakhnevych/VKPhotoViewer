//
//  EETransitionFromPhotosVCToPhotoGalleryVC.m
//  VKPhotoViewer
//
//  Created by админ on 9/12/15.
//  Copyright (c) 2015 Admin. All rights reserved.
//

#import "EETransitionFromPhotosVCToPhotoGalleryVC.h"
#import "EEPhotoGalleryVC.h"
#import "EEPhotosVC.h"
#import "EEGalleryCell.h"
#import "EEPhotoCell.h"
#import "EEGalleryCell.h"



@implementation EETransitionFromPhotosVCToPhotoGalleryVC
- (NSTimeInterval)transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext {
    return 0.5;
}
-(void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext {
    
    EEPhotosVC* fromViewController = (EEPhotosVC*)[transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    EEPhotoGalleryVC* toViewController = (EEPhotoGalleryVC*)[transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    UIView* containerView = [transitionContext containerView];
    NSTimeInterval duration = [self transitionDuration:transitionContext];
    
    EEPhotoCell* cell = (EEPhotoCell*)[fromViewController.collectionView cellForItemAtIndexPath:[[fromViewController.collectionView indexPathsForSelectedItems] firstObject]];
    //toViewController.cellImageSnapshot = [UIView new];
    toViewController.cellImageSnapshot = [cell.imageView snapshotViewAfterScreenUpdates:NO];
    UIView* cellImageSnapshot = [cell.imageView snapshotViewAfterScreenUpdates:NO];
    cellImageSnapshot.frame = [containerView convertRect:cell.imageView.frame fromView:cell.imageView.superview];
    
    cell.imageView.hidden = YES;
        double toMakePhotoBigger = (toViewController.collectionView.frame.size.width/cell.imageView.image.size.width > toViewController.collectionView.frame.size.height/cell.imageView.image.size.height) ? toViewController.collectionView.frame.size.height/cell.imageView.image.size.height : toViewController.collectionView.frame.size.width/cell.imageView.image.size.width;
    
    toViewController.view.alpha = 0;
    [toViewController.view setBackgroundColor:[UIColor blackColor]];
    toViewController.collectionView.hidden = YES;
    [containerView addSubview:toViewController.view];
    [containerView addSubview:cellImageSnapshot];
    
    [UIView animateWithDuration:duration animations:^{
        
        toViewController.view.alpha = 1.0;
        
        CGRect frame = CGRectMake((fromViewController.view.frame.size.width - cell.imageView.image.size.width*toMakePhotoBigger)/2, (fromViewController.view.frame.size.height - cell.imageView.image.size.height*toMakePhotoBigger)/2, cell.imageView.image.size.width*toMakePhotoBigger, cell.imageView.image.size.height*toMakePhotoBigger);
        cellImageSnapshot.frame = frame;
        //toViewController.cellImageSnapshot.frame = frame;

    } completion:^(BOOL finished) {
        //[toViewController.view addSubview:toViewController.cellImageSnapshot];
        toViewController.cellImageSnapshot = [NSKeyedUnarchiver unarchiveObjectWithData:[NSKeyedArchiver archivedDataWithRootObject:cellImageSnapshot]];
        [toViewController.view addSubview:toViewController.cellImageSnapshot];

        toViewController.collectionView.hidden = NO;
        cell.imageView.hidden = NO;
        [cellImageSnapshot removeFromSuperview];
        
        [transitionContext completeTransition:!transitionContext.transitionWasCancelled];
    }];
}





@end
