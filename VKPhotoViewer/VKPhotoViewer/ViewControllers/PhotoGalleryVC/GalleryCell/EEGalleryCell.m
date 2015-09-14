//
//  EEGalleryCell.m
//  VKPhotoViewer
//
//  Created by admin on 8/14/15.
//  Copyright (c) 2015 Admin. All rights reserved.
//

#import "EEGalleryCell.h"
#import "EEAppManager.h"

@implementation EEGalleryCell



- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self){
        NSArray *lArrayOfViews = [[NSBundle mainBundle] loadNibNamed:@"GalleryCell" owner:self options:nil];
        if ([lArrayOfViews count] < 1) {
            return nil;
        }
        if (![[lArrayOfViews objectAtIndex:0] isKindOfClass:[UICollectionViewCell class]]) {
            return nil;
        }
        self = [lArrayOfViews objectAtIndex:0];
        
    }
    isZooming = NO;
    _zoomScrollView.delegate = self;
    _zoomScrollView.minimumZoomScale = 1.0f;
    _zoomScrollView.maximumZoomScale = 10.0f;
    [_zoomScrollView setClipsToBounds:YES];
    return  self;
}

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView{
    return _imageView;
}


-(void)scrollViewWillBeginDecelerating:(UIScrollView *)scrollView{
    _photo = [EEAppManager sharedAppManager].currentPhoto;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    CGFloat minY = 0.0f;
    CGFloat maxY = 0.0f;
    
   if (!isZooming) {
    NSLog(@"===================================================================");
    CGPoint lScrollViewOffset =  _zoomScrollView.contentOffset;
    NSLog(@"lScrollViewOffset - %@", NSStringFromCGPoint(lScrollViewOffset));
    CGSize lContentSize = _zoomScrollView.contentSize;
    
    NSLog(@"lContentSize - %@", NSStringFromCGSize(lContentSize));
    
    NSLog(@"imageView - %@ ", NSStringFromCGRect(_imageView.frame));
    NSLog(@"scale - %f", _zoomScrollView.zoomScale);
    
    CGFloat lScale = _zoomScrollView.zoomScale;
    CGSize lPhotoSize = [self sizeOfPhoto:_photo inAspectFitImageView:_imageView];
    CGSize lScaledSize = CGSizeMake(lPhotoSize.width * lScale, lPhotoSize.height * lScale);
    NSLog(@"photo size ----%@",NSStringFromCGSize(lPhotoSize));
    NSLog(@"scaled size --- %@",NSStringFromCGSize(lScaledSize));
   
     minY = (lContentSize.height - lScaledSize.height) / 2;
     maxY = (_zoomScrollView.contentSize.height - _zoomScrollView.frame.size.height) - minY;
    CGFloat minX = (lContentSize.width - lScaledSize.width) / 2;
    CGFloat maxX = (_zoomScrollView.contentSize.width - _zoomScrollView.frame.size.width) - minX;

    NSLog(@"min y ----%f",minY);
    NSLog(@"max y -----%f",maxY);
    NSLog(@"===================================================================");
   
    if (_zoomScrollView.contentOffset.y <= minY && lScale > 1 && minY > 0) {
        _zoomScrollView.contentOffset = CGPointMake(_zoomScrollView.contentOffset.x, minY);
    }
    if (_zoomScrollView.contentOffset.y >= maxY && lScale > 1 && maxY > 0) {
        _zoomScrollView.contentOffset = CGPointMake(_zoomScrollView.contentOffset.x, maxY);
    }
    if (_zoomScrollView.contentOffset.x <= minX && lScale > 1 && minX > 0) {
           _zoomScrollView.contentOffset = CGPointMake(minX, _zoomScrollView.contentOffset.y);
    }
    if (_zoomScrollView.contentOffset.x >= maxX && lScale > 1 && maxX > 0) {
           _zoomScrollView.contentOffset = CGPointMake(maxX, _zoomScrollView.contentOffset.y);
       }
  }
}

- (void)scrollViewWillBeginZooming:(UIScrollView *)scrollView withView:(UIView *)view{
    isZooming = YES;
}

- (void)scrollViewDidEndZooming:(UIScrollView *)scrollView withView:(UIView *)view atScale:(CGFloat)scale{
    isZooming = NO;
    //    CGSize lPhotoSize = [self sizeOfPhoto:_photo inAspectFitImageView:_imageView];
    //    CGSize lScaledSize = CGSizeMake(lPhotoSize.width * scale, lPhotoSize.height * scale);
    //    _imageView.frame = CGRectMake(0, 100, lScaledSize.width, lScaledSize.height);
    // scrollView.contentSize = lScaledSize;
}




- (void)scrollViewDidZoom:(UIScrollView *)scrollView{
    //    UIView *subView = [scrollView.subviews objectAtIndex:0];
    //    CGFloat offsetX;
    //    CGFloat offsetY;
    //    if (scrollView.bounds.size.width > scrollView.contentSize.width) {
    //        offsetX = (scrollView.bounds.size.width - scrollView.contentSize.width) * 0.5;
    //    }
    //    else{
    //        offsetX = 0.0f;
    //    }
    //
    //    if (scrollView.bounds.size.height > scrollView.contentSize.height) {
    //        offsetY = (scrollView.bounds.size.height - scrollView.contentSize.height) * 0.5;
    //    }
    //    else{
    //        offsetY = 0.0f;
    //    }
    //        subView.center = CGPointMake(scrollView.contentSize.width * 0.5 + offsetX,
    //                                     scrollView.contentSize.height * 0.5 + offsetY);
}

- (CGSize) sizeOfPhoto:(EEPhoto *)photo inAspectFitImageView:(UIImageView *)imageView{
    CGFloat lImageViewHeight = imageView.bounds.size.height;
    CGFloat lImageViewWidth = imageView.bounds.size.width;
    
    CGFloat lImageHeight = [photo.photoHeight floatValue];
    CGFloat lImageWidth = [photo.photoWidth floatValue];
    
    CGFloat lScaleFactor = MIN(lImageViewWidth / lImageWidth, lImageViewHeight / lImageHeight);
    
    CGFloat lNewWidth = [photo.photoWidth floatValue] * lScaleFactor;
    CGFloat lNewHeight = [photo.photoHeight floatValue] * lScaleFactor;
    
    return CGSizeMake(lNewWidth, lNewHeight);
}

- (IBAction)doubleTapHandle:(UITapGestureRecognizer *)sender {
    
    UIScrollView *scrollView = (UIScrollView*)self.imageView.superview;
    float scale = scrollView.zoomScale;
    scale += 2.0;
    if(scale > 3.0){
        scale = 1.0;
    }
    [scrollView setZoomScale:scale animated:YES];
}

@end
