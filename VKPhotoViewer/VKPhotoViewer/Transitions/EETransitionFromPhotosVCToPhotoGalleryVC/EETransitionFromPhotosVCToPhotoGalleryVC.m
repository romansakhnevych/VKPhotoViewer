////
////  EETransitionFromPhotosVCToPhotoGalleryVC.m
////  VKPhotoViewer
////
////  Created by админ on 9/12/15.
////  Copyright (c) 2015 Admin. All rights reserved.
////
//
//#import "EETransitionFromPhotosVCToPhotoGalleryVC.h"
//#import "EEPhotoGalleryVC.h"
//#import "EEPhotosVC.h"
//#import "EEGalleryCell.h"
//#import "EEPhotoCell.h"
//#import "EEGalleryCell.h"
//
//
//
//@implementation EETransitionFromPhotosVCToPhotoGalleryVC
//- (NSTimeInterval)transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext {
//    return 0.5;
//}
//-(void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext {
//    
//    EEPhotosVC* fromViewController = (EEPhotosVC*)[transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
//    EEPhotoGalleryVC* toViewController = (EEPhotoGalleryVC*)[transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
//    UIView* containerView = [transitionContext containerView];
//    NSTimeInterval duration = [self transitionDuration:transitionContext];
//    
//    EEPhotoCell* cell = (EEPhotoCell*)[fromViewController.collectionView cellForItemAtIndexPath:[[fromViewController.collectionView indexPathsForSelectedItems] firstObject]];
//    
//    toViewController.cellImageSnapshot = [cell.imageView snapshotViewAfterScreenUpdates:NO];
//    UIView* cellImageSnapshot = [cell.imageView snapshotViewAfterScreenUpdates:NO];
//    cellImageSnapshot.frame = [containerView convertRect:cell.imageView.frame fromView:cell.imageView.superview];
//    
//    cell.imageView.hidden = YES;
//    double toMakePhotoBigger = (toViewController.collectionView.frame.size.width/cell.imageView.image.size.width > toViewController.collectionView.frame.size.height/cell.imageView.image.size.height) ? toViewController.collectionView.frame.size.height/cell.imageView.image.size.height : toViewController.collectionView.frame.size.width/cell.imageView.image.size.width;
//    
//    toViewController.view.alpha = 0;
//    [toViewController.view setBackgroundColor:[UIColor blackColor]];
//    toViewController.collectionView.hidden = YES;
//    [containerView addSubview:toViewController.view];
//    [containerView addSubview:cellImageSnapshot];
//    [fromViewController.navigationController setNavigationBarHidden:YES];
//    toViewController.view.frame = [UIScreen mainScreen].bounds;
//    
//    [UIView animateWithDuration:duration animations:^{
//        
//        toViewController.view.alpha = 1.0;
//        
//        CGRect frame = CGRectMake((fromViewController.view.frame.size.width - cell.imageView.image.size.width*toMakePhotoBigger)/2, (fromViewController.view.frame.size.height - cell.imageView.image.size.height*toMakePhotoBigger)/2, cell.imageView.image.size.width*toMakePhotoBigger, cell.imageView.image.size.height*toMakePhotoBigger);
//        cellImageSnapshot.frame = frame;
//        
//    } completion:^(BOOL finished) {
//        
//        [toViewController.uperView setHidden:NO];
//        
//        toViewController.cellImageSnapshot = [[UIView alloc]init];
//        toViewController.cellImageSnapshot = [NSKeyedUnarchiver unarchiveObjectWithData:[NSKeyedArchiver archivedDataWithRootObject:cellImageSnapshot]];
//        
//        [toViewController.view addSubview:toViewController.cellImageSnapshot];
//        toViewController.collectionView.pagingEnabled = YES;
//        toViewController.collectionView.hidden = NO;
//        cell.imageView.hidden = NO;
//        [cellImageSnapshot removeFromSuperview];
//        if(toViewController.isImageLoaded) {
//            [toViewController.cellImageSnapshot removeFromSuperview];
//        }
//        
//        [transitionContext completeTransition:!transitionContext.transitionWasCancelled];
//    }];
//}
//
//
//
//
//
//@end

////
//  EETransitionFromPhotosVCToPhotoGalleryVC.m
//  VKPhotoViewer
//
//  Created by админ on 9/12/15.
//  Copyright (c) 2015 Admin. All rights reserved.



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
#import "EEAppManager.h"


@implementation EETransitionFromPhotosVCToPhotoGalleryVC
- (NSTimeInterval)transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext {
    return 0.5;
}
-(void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext {
    
    EEPhotosVC* fromViewController = (EEPhotosVC*)[transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    EEPhotoGalleryVC* toViewController = (EEPhotoGalleryVC*)[transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    
    toViewController.isDetailed = NO;
    UIView* containerView = [transitionContext containerView];
    NSTimeInterval duration = [self transitionDuration:transitionContext];
    
    EEPhotoCell* cell = (EEPhotoCell*)[fromViewController.collectionView cellForItemAtIndexPath:[[fromViewController.collectionView indexPathsForSelectedItems] firstObject]];
    
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
    [fromViewController.navigationController setNavigationBarHidden:YES];
    toViewController.view.frame = [UIScreen mainScreen].bounds;
    
    
    
    
    CGFloat lImageViewHeight = [UIScreen mainScreen].bounds.size.height;
    CGFloat lImageViewWidth = [UIScreen mainScreen].bounds.size.width;
    
    CGFloat lImageHeight = [photo.photoHeight floatValue];
    CGFloat lImageWidth = [photo.photoWidth floatValue];
    
    CGFloat lScaleFactor = MIN(lImageViewWidth / lImageWidth, lImageViewHeight / lImageHeight);
    
    CGFloat lNewWidth = [photo.photoWidth floatValue] * lScaleFactor;
    CGFloat lNewHeight = [photo.photoHeight floatValue] * lScaleFactor;

    
    
    
    
    
    
    [UIView animateWithDuration:5.0 animations:^{
        
        toViewController.view.alpha = 1.0;
        CGRect frame = CGRectMake(([UIScreen mainScreen].bounds.size.width - cell.frame.size.width)/2, ([UIScreen mainScreen].bounds.size.height - cell.frame.size.height)/2, cell.frame.size.width, cell.frame.size.height);
        //CGRect frame = CGRectMake((fromViewController.view.frame.size.width - cell.imageView.image.size.width*toMakePhotoBigger)/2, (fromViewController.view.frame.size.height - cell.imageView.image.size.height*toMakePhotoBigger)/2, cell.imageView.image.size.width*toMakePhotoBigger, cell.imageView.image.size.height*toMakePhotoBigger);
        cellImageSnapshot.frame = frame;
        
    } completion:^(BOOL finished) {
            UIImageView* copy = [[UIImageView alloc] initWithImage:cell.imageView.image];
        [copy setBackgroundColor:[UIColor greenColor]];
        copy.frame = cellImageSnapshot.frame;
        copy.contentMode = UIViewContentModeCenter;
        [cellImageSnapshot removeFromSuperview];

        [containerView addSubview:copy];
        
        
        
        
        

        
        
        
        //copy.contentMode = UIViewContentModeCenter;
        [UIView animateWithDuration:3.0 animations:^{
            copy.frame = CGRectMake(([UIScreen mainScreen].bounds.size.width - lNewWidth)/2, ([UIScreen mainScreen].bounds.size.height - lNewHeight)/2, lNewWidth, lNewHeight);
            
        //    copy.contentMode = UIViewContentModeScaleAspectFit;
        } completion:^(BOOL finished) {
            [toViewController.uperView setHidden:NO];
            
                    toViewController.cellImageSnapshot = [[UIView alloc]init];
                    toViewController.cellImageSnapshot = [NSKeyedUnarchiver unarchiveObjectWithData:[NSKeyedArchiver archivedDataWithRootObject:copy]];
            
                    [toViewController.view addSubview:toViewController.cellImageSnapshot];
                    toViewController.collectionView.pagingEnabled = YES;
                    toViewController.collectionView.hidden = NO;
                    cell.imageView.hidden = NO;
                    [copy removeFromSuperview];
                    if(toViewController.isImageLoaded) {
                        [toViewController.cellImageSnapshot removeFromSuperview];
                    }

            [transitionContext completeTransition:!transitionContext.transitionWasCancelled];
        }];
        
//        
//        [toViewController.uperView setHidden:NO];
//        
//        toViewController.cellImageSnapshot = [[UIView alloc]init];
//        toViewController.cellImageSnapshot = [NSKeyedUnarchiver unarchiveObjectWithData:[NSKeyedArchiver archivedDataWithRootObject:cellImageSnapshot]];
//        
//        [toViewController.view addSubview:toViewController.cellImageSnapshot];
//        toViewController.collectionView.pagingEnabled = YES;
//        toViewController.collectionView.hidden = NO;
//        cell.imageView.hidden = NO;
//        [cellImageSnapshot removeFromSuperview];
//        if(toViewController.isImageLoaded) {
//            [toViewController.cellImageSnapshot removeFromSuperview];
//        }
        
//        [transitionContext completeTransition:!transitionContext.transitionWasCancelled];
    }];
}





@end
